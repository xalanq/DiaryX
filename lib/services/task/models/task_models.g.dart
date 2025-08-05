// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
  id: json['id'] as String,
  type: json['type'] as String,
  priority: (json['priority'] as num).toInt(),
  label: json['label'] as String,
  status: $enumDecode(_$TaskStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  data: json['data'] as Map<String, dynamic>,
  retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  error: json['error'] as String?,
  result: json['result'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'priority': instance.priority,
      'label': instance.label,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'data': instance.data,
      'retryCount': instance.retryCount,
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'error': instance.error,
      'result': instance.result,
    };

const _$TaskStatusEnumMap = {
  TaskStatus.pending: 'pending',
  TaskStatus.running: 'running',
  TaskStatus.completed: 'completed',
  TaskStatus.failed: 'failed',
  TaskStatus.cancelled: 'cancelled',
  TaskStatus.retrying: 'retrying',
};

_$TaskResultImpl _$$TaskResultImplFromJson(Map<String, dynamic> json) =>
    _$TaskResultImpl(
      taskId: json['taskId'] as String,
      status: $enumDecode(_$TaskStatusEnumMap, json['status']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      data: json['data'] as Map<String, dynamic>?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$TaskResultImplToJson(_$TaskResultImpl instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'data': instance.data,
      'error': instance.error,
    };

_$TaskFilterImpl _$$TaskFilterImplFromJson(Map<String, dynamic> json) =>
    _$TaskFilterImpl(
      types: (json['types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      statuses: (json['statuses'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$TaskStatusEnumMap, e))
          .toList(),
      priorities: (json['priorities'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      createdAfter: json['createdAfter'] == null
          ? null
          : DateTime.parse(json['createdAfter'] as String),
      createdBefore: json['createdBefore'] == null
          ? null
          : DateTime.parse(json['createdBefore'] as String),
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TaskFilterImplToJson(
  _$TaskFilterImpl instance,
) => <String, dynamic>{
  'types': instance.types,
  'statuses': instance.statuses?.map((e) => _$TaskStatusEnumMap[e]!).toList(),
  'priorities': instance.priorities,
  'createdAfter': instance.createdAfter?.toIso8601String(),
  'createdBefore': instance.createdBefore?.toIso8601String(),
  'limit': instance.limit,
};

_$TaskStatsImpl _$$TaskStatsImplFromJson(Map<String, dynamic> json) =>
    _$TaskStatsImpl(
      totalTasks: (json['totalTasks'] as num).toInt(),
      pendingTasks: (json['pendingTasks'] as num).toInt(),
      runningTasks: (json['runningTasks'] as num).toInt(),
      completedTasks: (json['completedTasks'] as num).toInt(),
      failedTasks: (json['failedTasks'] as num).toInt(),
      cancelledTasks: (json['cancelledTasks'] as num).toInt(),
      tasksByType: Map<String, int>.from(json['tasksByType'] as Map),
      tasksByPriority: (json['tasksByPriority'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), (e as num).toInt()),
      ),
    );

Map<String, dynamic> _$$TaskStatsImplToJson(_$TaskStatsImpl instance) =>
    <String, dynamic>{
      'totalTasks': instance.totalTasks,
      'pendingTasks': instance.pendingTasks,
      'runningTasks': instance.runningTasks,
      'completedTasks': instance.completedTasks,
      'failedTasks': instance.failedTasks,
      'cancelledTasks': instance.cancelledTasks,
      'tasksByType': instance.tasksByType,
      'tasksByPriority': instance.tasksByPriority.map(
        (k, e) => MapEntry(k.toString(), e),
      ),
    };
