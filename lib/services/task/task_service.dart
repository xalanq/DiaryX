import 'dart:async';
import 'package:diaryx/utils/app_logger.dart';
import 'task_queue.dart';
import 'models/task_models.dart';

/// Universal task service for managing background tasks
/// This service is completely generic and can be used by any part of the application
class TaskService {
  static TaskService? _instance;
  TaskQueue? _taskQueue;

  // Private constructor
  TaskService._();

  /// Singleton access
  static TaskService get instance {
    _instance ??= TaskService._();
    return _instance!;
  }

  /// Initialize the task service with a task queue implementation
  Future<void> initialize({required TaskQueue taskQueue}) async {
    _taskQueue = taskQueue;
    await _taskQueue!.start();
    AppLogger.info('TaskService initialized');
  }

  /// Check if task service is initialized
  bool get isInitialized => _taskQueue != null;

  // ========== Task Submission ==========

  /// Submit a generic task to the queue
  Future<void> submitTask(Task task) async {
    if (_taskQueue == null) {
      throw Exception('TaskService not initialized');
    }
    await _taskQueue!.submitTask(task);
  }

  // ========== Task Callback Registration ==========

  /// Register a callback for handling specific task types
  void registerTaskHandler(String type, TaskCallback callback) {
    if (_taskQueue == null) {
      throw Exception('TaskService not initialized');
    }
    _taskQueue!.registerCallback(type, callback);
  }

  /// Register callback for task completion events
  void onTaskCompleted(TaskCompletionCallback callback) {
    if (_taskQueue == null) {
      throw Exception('TaskService not initialized');
    }
    _taskQueue!.registerCompletionCallback(callback);
  }

  /// Register callback for task progress updates
  void onTaskProgress(TaskProgressCallback callback) {
    if (_taskQueue == null) {
      throw Exception('TaskService not initialized');
    }
    _taskQueue!.registerProgressCallback(callback);
  }

  // ========== Task Management ==========

  /// Get current tasks with optional filtering
  Future<List<Task>> getTasks([TaskFilter? filter]) async {
    if (_taskQueue == null) {
      throw Exception('TaskService not initialized');
    }
    return await _taskQueue!.getTasks(filter);
  }

  /// Listen to task list changes
  Stream<List<Task>> get tasksStream {
    if (_taskQueue == null) {
      throw Exception('TaskService not initialized');
    }
    return _taskQueue!.tasksStream;
  }

  /// Get task statistics
  Future<TaskStats> getStats() async {
    if (_taskQueue == null) {
      throw Exception('TaskService not initialized');
    }
    return await _taskQueue!.getStats();
  }

  /// Cancel a specific task
  Future<void> cancelTask(String taskId) async {
    if (_taskQueue == null) {
      throw Exception('TaskService not initialized');
    }
    await _taskQueue!.cancelTask(taskId);
  }

  /// Retry a failed task
  Future<void> retryTask(String taskId) async {
    if (_taskQueue == null) {
      throw Exception('TaskService not initialized');
    }
    await _taskQueue!.retryTask(taskId);
  }

  /// Cancel all pending and running tasks
  Future<void> cancelAllTasks() async {
    if (_taskQueue == null) {
      throw Exception('TaskService not initialized');
    }
    await _taskQueue!.cancelAllTasks();
  }

  // ========== Lifecycle Management ==========

  /// Start task processing
  Future<void> start() async {
    if (_taskQueue == null) {
      throw Exception('TaskService not initialized');
    }
    await _taskQueue!.start();
  }

  /// Stop task processing
  Future<void> stop() async {
    if (_taskQueue == null) {
      throw Exception('TaskService not initialized');
    }
    await _taskQueue!.stop();
  }

  /// Dispose the task service and clean up resources
  Future<void> dispose() async {
    await _taskQueue?.dispose();
    _taskQueue = null;
    _instance = null;
    AppLogger.info('TaskService disposed');
  }
}
