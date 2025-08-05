import 'dart:async';
import 'dart:convert';
import 'package:diaryx/consts/env_config.dart';
import 'package:diaryx/databases/app_database.dart';
import 'package:diaryx/utils/app_logger.dart';
import 'package:drift/drift.dart';
import '../models/task_models.dart';
import '../task_queue.dart';

/// Database-based implementation of TaskQueue
class DatabaseTaskQueue implements TaskQueue {
  final AppDatabase _database;
  final Map<String, TaskCallback> _callbacks = {};
  final List<TaskCompletionCallback> _completionCallbacks = [];
  final List<TaskProgressCallback> _progressCallbacks = [];

  final StreamController<List<Task>> _tasksController =
      StreamController.broadcast();

  bool _isRunning = false;
  Timer? _processingTimer;
  Timer? _cleanupTimer;
  final Set<String> _runningTasks = {};

  DatabaseTaskQueue(this._database);

  @override
  Future<void> submitTask(Task task) async {
    AppLogger.info('Submitting task to database: ${task.id} (${task.type})');

    try {
      await _database
          .into(_database.taskQueue)
          .insert(
            TaskQueueCompanion.insert(
              taskId: task.id,
              type: task.type,
              priority: Value(task.priority),
              label: task.label,
              status: task.status.name,
              createdAt: task.createdAt,
              data: jsonEncode(task.data),
              retryCount: Value(task.retryCount),
              startedAt: Value.absentIfNull(task.startedAt),
              completedAt: Value.absentIfNull(task.completedAt),
              error: Value.absentIfNull(task.error),
              result: Value.absentIfNull(
                task.result != null ? jsonEncode(task.result) : null,
              ),
            ),
          );

      _notifyTasksChanged();

      if (_isRunning) {
        _processNextTask();
      }
    } catch (e) {
      AppLogger.error('Failed to submit task to database', e);
      rethrow;
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
    try {
      var query = _database.select(_database.taskQueue);

      if (filter != null) {
        if (filter.types != null) {
          query.where((t) => t.type.isIn(filter.types!));
        }
        if (filter.statuses != null) {
          final statusNames = filter.statuses!.map((s) => s.name).toList();
          query.where((t) => t.status.isIn(statusNames));
        }
        if (filter.priorities != null) {
          query.where((t) => t.priority.isIn(filter.priorities!));
        }
        if (filter.createdAfter != null) {
          query.where(
            (t) => t.createdAt.isBiggerThanValue(filter.createdAfter!),
          );
        }
        if (filter.createdBefore != null) {
          query.where(
            (t) => t.createdAt.isSmallerThanValue(filter.createdBefore!),
          );
        }
        if (filter.limit != null) {
          query.limit(filter.limit!);
        }
      }

      // Order by priority (desc), then by creation time (asc)
      query.orderBy([
        (t) => OrderingTerm.desc(t.priority),
        (t) => OrderingTerm.asc(t.createdAt),
      ]);

      final rows = await query.get();
      return rows.map(_taskFromRow).toList();
    } catch (e) {
      AppLogger.error('Failed to get tasks from database', e);
      return [];
    }
  }

  @override
  Stream<List<Task>> get tasksStream => _tasksController.stream;

  @override
  Future<TaskStats> getStats() async {
    try {
      final allTasks = await getTasks();
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
    } catch (e) {
      AppLogger.error('Failed to get task stats from database', e);
      return TaskStats(
        totalTasks: 0,
        pendingTasks: 0,
        runningTasks: 0,
        completedTasks: 0,
        failedTasks: 0,
        cancelledTasks: 0,
        tasksByType: {},
        tasksByPriority: {},
      );
    }
  }

  @override
  Future<void> cancelTask(String taskId) async {
    try {
      final task = await _getTaskById(taskId);
      if (task == null) return;

      _runningTasks.remove(taskId);

      await (_database.update(
        _database.taskQueue,
      )..where((t) => t.taskId.equals(taskId))).write(
        TaskQueueCompanion(
          status: Value(TaskStatus.cancelled.name),
          completedAt: Value(DateTime.now()),
        ),
      );

      final cancelledTask = task.copyWith(
        status: TaskStatus.cancelled,
        completedAt: DateTime.now(),
      );

      _notifyTasksChanged();
      _notifyTaskCompleted(cancelledTask, false, null, 'Task cancelled');

      AppLogger.info('Task cancelled: $taskId');
    } catch (e) {
      AppLogger.error('Failed to cancel task', e);
    }
  }

  @override
  Future<void> retryTask(String taskId) async {
    try {
      final task = await _getTaskById(taskId);
      if (task == null || task.status != TaskStatus.failed) return;

      if (task.retryCount >= EnvConfig.maxTaskRetries) {
        AppLogger.warn('Task $taskId has exceeded max retries');
        return;
      }

      await (_database.update(
        _database.taskQueue,
      )..where((t) => t.taskId.equals(taskId))).write(
        TaskQueueCompanion(
          status: Value(TaskStatus.retrying.name),
          retryCount: Value(task.retryCount + 1),
          error: const Value.absent(),
        ),
      );

      _notifyTasksChanged();

      AppLogger.info(
        'Task queued for retry: $taskId (attempt ${task.retryCount + 1})',
      );
    } catch (e) {
      AppLogger.error('Failed to retry task', e);
    }
  }

  @override
  Future<void> cancelAllTasks() async {
    try {
      final runningStatuses = [
        TaskStatus.pending.name,
        TaskStatus.retrying.name,
        TaskStatus.running.name,
      ];

      await (_database.update(
        _database.taskQueue,
      )..where((t) => t.status.isIn(runningStatuses))).write(
        TaskQueueCompanion(
          status: Value(TaskStatus.cancelled.name),
          completedAt: Value(DateTime.now()),
        ),
      );

      _runningTasks.clear();
      _notifyTasksChanged();

      AppLogger.info('All tasks cancelled');
    } catch (e) {
      AppLogger.error('Failed to cancel all tasks', e);
    }
  }

  @override
  Future<void> start() async {
    if (_isRunning) return;

    _isRunning = true;
    AppLogger.info('DatabaseTaskQueue started');

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

    AppLogger.info('DatabaseTaskQueue stopped');
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _tasksController.close();
    _callbacks.clear();
    _completionCallbacks.clear();
    _progressCallbacks.clear();
    _runningTasks.clear();
  }

  // Private methods

  Task _taskFromRow(TaskQueueData row) {
    return Task(
      id: row.taskId,
      type: row.type,
      priority: row.priority,
      label: row.label,
      status: TaskStatus.values.firstWhere((s) => s.name == row.status),
      createdAt: row.createdAt,
      data: jsonDecode(row.data) as Map<String, dynamic>,
      retryCount: row.retryCount,
      startedAt: row.startedAt,
      completedAt: row.completedAt,
      error: row.error,
      result: row.result != null
          ? jsonDecode(row.result!) as Map<String, dynamic>
          : null,
    );
  }

  Future<Task?> _getTaskById(String taskId) async {
    try {
      final row = await (_database.select(
        _database.taskQueue,
      )..where((t) => t.taskId.equals(taskId))).getSingleOrNull();

      return row != null ? _taskFromRow(row) : null;
    } catch (e) {
      AppLogger.error('Failed to get task by ID', e);
      return null;
    }
  }

  void _processNextTask() async {
    if (_runningTasks.length >= EnvConfig.maxConcurrentTasks) return;

    try {
      final pendingStatuses = [
        TaskStatus.pending.name,
        TaskStatus.retrying.name,
      ];

      final pendingTasks =
          await (_database.select(_database.taskQueue)
                ..where((t) => t.status.isIn(pendingStatuses))
                ..orderBy([
                  (t) => OrderingTerm.desc(t.priority),
                  (t) => OrderingTerm.asc(t.createdAt),
                ])
                ..limit(1))
              .get();

      if (pendingTasks.isEmpty) return;

      final taskRow = pendingTasks.first;
      final task = _taskFromRow(taskRow);

      await _executeTask(task);
    } catch (e) {
      AppLogger.error('Error processing next task', e);
    }
  }

  Future<void> _executeTask(Task task) async {
    final callback = _callbacks[task.type];
    if (callback == null) {
      AppLogger.error('No callback registered for task type: ${task.type}');
      await _handleTaskFailure(task, 'No callback registered');
      return;
    }

    _runningTasks.add(task.id);

    try {
      // Update task status to running
      await (_database.update(
        _database.taskQueue,
      )..where((t) => t.taskId.equals(task.id))).write(
        TaskQueueCompanion(
          status: Value(TaskStatus.running.name),
          startedAt: Value(DateTime.now()),
        ),
      );

      final runningTask = task.copyWith(
        status: TaskStatus.running,
        startedAt: DateTime.now(),
      );

      _notifyTasksChanged();

      AppLogger.info('Executing task: ${task.id}');

      final result = await callback(runningTask).timeout(
        EnvConfig.taskTimeout,
        onTimeout: () =>
            throw TimeoutException('Task timeout', EnvConfig.taskTimeout),
      );

      await _handleTaskSuccess(task, result);
    } catch (e) {
      AppLogger.error('Task execution failed: ${task.id}', e);
      await _handleTaskFailure(task, e.toString());
    } finally {
      _runningTasks.remove(task.id);
    }
  }

  Future<void> _handleTaskSuccess(
    Task task,
    Map<String, dynamic> result,
  ) async {
    try {
      await (_database.update(
        _database.taskQueue,
      )..where((t) => t.taskId.equals(task.id))).write(
        TaskQueueCompanion(
          status: Value(TaskStatus.completed.name),
          completedAt: Value(DateTime.now()),
          result: Value(jsonEncode(result)),
        ),
      );

      final completedTask = task.copyWith(
        status: TaskStatus.completed,
        completedAt: DateTime.now(),
        result: result,
      );

      _notifyTasksChanged();
      _notifyTaskCompleted(completedTask, true, result, null);

      AppLogger.info('Task completed: ${task.id}');
    } catch (e) {
      AppLogger.error('Failed to handle task success', e);
    }
  }

  Future<void> _handleTaskFailure(Task task, String error) async {
    try {
      await (_database.update(
        _database.taskQueue,
      )..where((t) => t.taskId.equals(task.id))).write(
        TaskQueueCompanion(
          status: Value(TaskStatus.failed.name),
          completedAt: Value(DateTime.now()),
          error: Value(error),
        ),
      );

      final failedTask = task.copyWith(
        status: TaskStatus.failed,
        completedAt: DateTime.now(),
        error: error,
      );

      _notifyTasksChanged();
      _notifyTaskCompleted(failedTask, false, null, error);

      // Auto-retry if under retry limit
      if (task.retryCount < EnvConfig.maxTaskRetries) {
        Timer(EnvConfig.taskRetryDelay, () {
          retryTask(task.id);
        });
      }
    } catch (e) {
      AppLogger.error('Failed to handle task failure', e);
    }
  }

  void _notifyTasksChanged() async {
    try {
      final tasks = await getTasks();
      _tasksController.add(tasks);
    } catch (e) {
      AppLogger.error('Failed to notify tasks changed', e);
    }
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

  Future<void> _cleanupOldTasks() async {
    try {
      final cutoff = DateTime.now().subtract(EnvConfig.completedTaskRetention);

      final completedStatuses = [
        TaskStatus.completed.name,
        TaskStatus.failed.name,
        TaskStatus.cancelled.name,
      ];

      final deleted =
          await (_database.delete(_database.taskQueue)..where(
                (t) =>
                    t.status.isIn(completedStatuses) &
                    t.completedAt.isSmallerThanValue(cutoff),
              ))
              .go();

      if (deleted > 0) {
        _notifyTasksChanged();
        AppLogger.info('Cleaned up $deleted old tasks');
      }
    } catch (e) {
      AppLogger.error('Failed to cleanup old tasks', e);
    }
  }
}
