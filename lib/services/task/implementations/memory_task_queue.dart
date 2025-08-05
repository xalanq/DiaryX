import 'dart:async';
import 'dart:collection';
import 'package:diaryx/consts/env_config.dart';
import 'package:diaryx/utils/app_logger.dart';
import '../models/task_models.dart';
import '../task_queue.dart';

/// In-memory implementation of TaskQueue
class MemoryTaskQueue implements TaskQueue {
  final Map<String, TaskCallback> _callbacks = {};
  final List<TaskCompletionCallback> _completionCallbacks = [];
  final List<TaskProgressCallback> _progressCallbacks = [];

  final Queue<Task> _pendingTasks = Queue<Task>();
  final Map<String, Task> _allTasks = {};
  final Set<String> _runningTasks = {};

  final StreamController<List<Task>> _tasksController =
      StreamController.broadcast();

  bool _isRunning = false;
  Timer? _processingTimer;
  Timer? _cleanupTimer;

  @override
  Future<void> submitTask(Task task) async {
    AppLogger.info('Submitting task: ${task.id} (${task.type})');

    _allTasks[task.id] = task;
    _pendingTasks.add(task);

    _notifyTasksChanged();

    if (_isRunning) {
      _processNextTask();
    }
  }

  @override
  void registerCallback(String type, TaskCallback callback) {
    _callbacks[type] = callback;
    AppLogger.info('Registered callback for task type: $type');
  }

  @override
  void registerCompletionCallback(TaskCompletionCallback callback) {
    _completionCallbacks.add(callback);
  }

  @override
  void registerProgressCallback(TaskProgressCallback callback) {
    _progressCallbacks.add(callback);
  }

  @override
  Future<List<Task>> getTasks([TaskFilter? filter]) async {
    var tasks = _allTasks.values.toList();

    if (filter != null) {
      if (filter.types != null) {
        tasks = tasks.where((t) => filter.types!.contains(t.type)).toList();
      }
      if (filter.statuses != null) {
        tasks = tasks
            .where((t) => filter.statuses!.contains(t.status))
            .toList();
      }
      if (filter.priorities != null) {
        tasks = tasks
            .where((t) => filter.priorities!.contains(t.priority))
            .toList();
      }
      if (filter.createdAfter != null) {
        tasks = tasks
            .where((t) => t.createdAt.isAfter(filter.createdAfter!))
            .toList();
      }
      if (filter.createdBefore != null) {
        tasks = tasks
            .where((t) => t.createdAt.isBefore(filter.createdBefore!))
            .toList();
      }
      if (filter.limit != null) {
        tasks = tasks.take(filter.limit!).toList();
      }
    }

    // Sort by priority, then by creation time
    tasks.sort((a, b) {
      final priorityComparison = a.priority.compareTo(b.priority);
      if (priorityComparison != 0) return priorityComparison;
      return a.createdAt.compareTo(b.createdAt);
    });

    return tasks;
  }

  @override
  Stream<List<Task>> get tasksStream => _tasksController.stream;

  @override
  Future<TaskStats> getStats() async {
    final allTasks = _allTasks.values.toList();
    final tasksByType = <String, int>{};
    final tasksByPriority = <int, int>{};

    var pending = 0, running = 0, completed = 0, failed = 0, cancelled = 0;

    for (final task in allTasks) {
      switch (task.status) {
        case TaskStatus.pending:
        case TaskStatus.retrying:
          pending++;
          break;
        case TaskStatus.running:
          running++;
          break;
        case TaskStatus.completed:
          completed++;
          break;
        case TaskStatus.failed:
          failed++;
          break;
        case TaskStatus.cancelled:
          cancelled++;
          break;
      }

      tasksByType[task.type] = (tasksByType[task.type] ?? 0) + 1;
      tasksByPriority[task.priority] =
          (tasksByPriority[task.priority] ?? 0) + 1;
    }

    return TaskStats(
      totalTasks: allTasks.length,
      pendingTasks: pending,
      runningTasks: running,
      completedTasks: completed,
      failedTasks: failed,
      cancelledTasks: cancelled,
      tasksByType: tasksByType,
      tasksByPriority: tasksByPriority,
    );
  }

  @override
  Future<void> cancelTask(String taskId) async {
    final task = _allTasks[taskId];
    if (task == null) return;

    if (task.status == TaskStatus.pending ||
        task.status == TaskStatus.retrying) {
      _pendingTasks.removeWhere((t) => t.id == taskId);
    }

    _runningTasks.remove(taskId);

    final cancelledTask = task.copyWith(
      status: TaskStatus.cancelled,
      completedAt: DateTime.now(),
    );

    _allTasks[taskId] = cancelledTask;
    _notifyTasksChanged();
    _notifyTaskCompleted(cancelledTask, false, null, 'Task cancelled');

    AppLogger.info('Task cancelled: $taskId');
  }

  @override
  Future<void> retryTask(String taskId) async {
    final task = _allTasks[taskId];
    if (task == null || task.status != TaskStatus.failed) return;

    if (task.retryCount >= EnvConfig.maxTaskRetries) {
      AppLogger.warn('Task $taskId has exceeded max retries');
      return;
    }

    final retryTask = task.copyWith(
      status: TaskStatus.retrying,
      retryCount: task.retryCount + 1,
      error: null,
    );

    _allTasks[taskId] = retryTask;
    _pendingTasks.add(retryTask);
    _notifyTasksChanged();

    AppLogger.info(
      'Task queued for retry: $taskId (attempt ${retryTask.retryCount})',
    );
  }

  @override
  Future<void> cancelAllTasks() async {
    final taskIds = _allTasks.keys.where((id) {
      final task = _allTasks[id]!;
      return task.status == TaskStatus.pending ||
          task.status == TaskStatus.retrying ||
          task.status == TaskStatus.running;
    }).toList();

    for (final taskId in taskIds) {
      await cancelTask(taskId);
    }
  }

  @override
  Future<void> start() async {
    if (_isRunning) return;

    _isRunning = true;
    AppLogger.info('TaskQueue started');

    // Start processing tasks
    _processingTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _processNextTask();
    });

    // Start cleanup timer
    _cleanupTimer = Timer.periodic(EnvConfig.taskCleanupInterval, (_) {
      _cleanupOldTasks();
    });
  }

  @override
  Future<void> stop() async {
    if (!_isRunning) return;

    _isRunning = false;
    _processingTimer?.cancel();
    _cleanupTimer?.cancel();

    AppLogger.info('TaskQueue stopped');
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _tasksController.close();
    _callbacks.clear();
    _completionCallbacks.clear();
    _progressCallbacks.clear();
    _allTasks.clear();
    _pendingTasks.clear();
    _runningTasks.clear();
  }

  // Private methods

  void _processNextTask() {
    if (_runningTasks.length >= EnvConfig.maxConcurrentTasks) return;
    if (_pendingTasks.isEmpty) return;

    final task = _pendingTasks.removeFirst();
    _executeTask(task);
  }

  Future<void> _executeTask(Task task) async {
    final callback = _callbacks[task.type];
    if (callback == null) {
      AppLogger.error('No callback registered for task type: ${task.type}');
      _handleTaskFailure(task, 'No callback registered');
      return;
    }

    _runningTasks.add(task.id);

    final runningTask = task.copyWith(
      status: TaskStatus.running,
      startedAt: DateTime.now(),
    );

    _allTasks[task.id] = runningTask;
    _notifyTasksChanged();

    try {
      AppLogger.info('Executing task: ${task.id}');

      final result = await callback(runningTask).timeout(
        EnvConfig.taskTimeout,
        onTimeout: () =>
            throw TimeoutException('Task timeout', EnvConfig.taskTimeout),
      );

      _handleTaskSuccess(task, result);
    } catch (e) {
      AppLogger.error('Task execution failed: ${task.id}', e);
      _handleTaskFailure(task, e.toString());
    } finally {
      _runningTasks.remove(task.id);
    }
  }

  void _handleTaskSuccess(Task task, Map<String, dynamic> result) {
    final completedTask = task.copyWith(
      status: TaskStatus.completed,
      completedAt: DateTime.now(),
      result: result,
    );

    _allTasks[task.id] = completedTask;
    _notifyTasksChanged();
    _notifyTaskCompleted(completedTask, true, result, null);

    AppLogger.info('Task completed: ${task.id}');
  }

  void _handleTaskFailure(Task task, String error) {
    final failedTask = task.copyWith(
      status: TaskStatus.failed,
      completedAt: DateTime.now(),
      error: error,
    );

    _allTasks[task.id] = failedTask;
    _notifyTasksChanged();
    _notifyTaskCompleted(failedTask, false, null, error);

    // Auto-retry if under retry limit
    if (task.retryCount < EnvConfig.maxTaskRetries) {
      Timer(EnvConfig.taskRetryDelay, () {
        retryTask(task.id);
      });
    }
  }

  void _notifyTasksChanged() {
    _tasksController.add(_allTasks.values.toList());
  }

  void _notifyTaskCompleted(
    Task task,
    bool success,
    Map<String, dynamic>? result,
    String? error,
  ) {
    for (final callback in _completionCallbacks) {
      try {
        callback(task, success, result, error);
      } catch (e) {
        AppLogger.error('Error in completion callback', e);
      }
    }
  }

  void _cleanupOldTasks() {
    final cutoff = DateTime.now().subtract(EnvConfig.completedTaskRetention);
    final toRemove = <String>[];

    for (final entry in _allTasks.entries) {
      final task = entry.value;
      if ((task.status == TaskStatus.completed ||
              task.status == TaskStatus.failed ||
              task.status == TaskStatus.cancelled) &&
          task.completedAt != null &&
          task.completedAt!.isBefore(cutoff)) {
        toRemove.add(entry.key);
      }
    }

    for (final taskId in toRemove) {
      _allTasks.remove(taskId);
    }

    if (toRemove.isNotEmpty) {
      _notifyTasksChanged();
      AppLogger.info('Cleaned up ${toRemove.length} old tasks');
    }
  }
}
