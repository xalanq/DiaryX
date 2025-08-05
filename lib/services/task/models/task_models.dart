import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_models.freezed.dart';
part 'task_models.g.dart';

/// Task status enumeration
enum TaskStatus { pending, running, completed, failed, cancelled, retrying }

/// Universal task model
@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String type,
    required int priority,
    required String label,
    required TaskStatus status,
    required DateTime createdAt,
    required Map<String, dynamic> data,
    @Default(0) int retryCount,
    DateTime? startedAt,
    DateTime? completedAt,
    String? error,
    Map<String, dynamic>? result,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

/// Task result wrapper
@freezed
class TaskResult with _$TaskResult {
  const factory TaskResult({
    required String taskId,
    required TaskStatus status,
    required DateTime timestamp,
    Map<String, dynamic>? data,
    String? error,
  }) = _TaskResult;

  factory TaskResult.fromJson(Map<String, dynamic> json) =>
      _$TaskResultFromJson(json);
}

/// Task filter for querying tasks
@freezed
class TaskFilter with _$TaskFilter {
  const factory TaskFilter({
    List<String>? types,
    List<TaskStatus>? statuses,
    List<int>? priorities,
    DateTime? createdAfter,
    DateTime? createdBefore,
    int? limit,
  }) = _TaskFilter;

  factory TaskFilter.fromJson(Map<String, dynamic> json) =>
      _$TaskFilterFromJson(json);
}

/// Task statistics
@freezed
class TaskStats with _$TaskStats {
  const factory TaskStats({
    required int totalTasks,
    required int pendingTasks,
    required int runningTasks,
    required int completedTasks,
    required int failedTasks,
    required int cancelledTasks,
    required Map<String, int> tasksByType,
    required Map<int, int> tasksByPriority,
  }) = _TaskStats;

  factory TaskStats.fromJson(Map<String, dynamic> json) =>
      _$TaskStatsFromJson(json);
}
