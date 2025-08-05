import 'dart:async';
import 'models/task_models.dart';

/// Task callback function type
typedef TaskCallback = Future<Map<String, dynamic>> Function(Task task);

/// Task completion callback function type
typedef TaskCompletionCallback =
    void Function(
      Task task,
      bool success,
      Map<String, dynamic>? result,
      String? error,
    );

/// Task progress callback function type
typedef TaskProgressCallback = void Function(Task task, double progress);

/// Universal task queue for managing asynchronous tasks
abstract class TaskQueue {
  /// Submit a new task to the queue
  Future<void> submitTask(Task task);

  /// Register a callback function for specific task types
  void registerCallback(String type, TaskCallback callback);

  /// Register completion callback
  void registerCompletionCallback(TaskCompletionCallback callback);

  /// Register progress callback
  void registerProgressCallback(TaskProgressCallback callback);

  /// Get current task list with optional filtering
  Future<List<Task>> getTasks([TaskFilter? filter]);

  /// Listen to task list changes
  Stream<List<Task>> get tasksStream;

  /// Get task statistics
  Future<TaskStats> getStats();

  /// Cancel a specific task
  Future<void> cancelTask(String taskId);

  /// Retry a failed task
  Future<void> retryTask(String taskId);

  /// Cancel all pending tasks
  Future<void> cancelAllTasks();

  /// Start task processing
  Future<void> start();

  /// Stop task processing
  Future<void> stop();

  /// Dispose resources
  Future<void> dispose();
}
