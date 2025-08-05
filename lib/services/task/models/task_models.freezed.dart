// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
mixin _$Task {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  TaskStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  int get retryCount => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  Map<String, dynamic>? get result => throw _privateConstructorUsedError;

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call({
    String id,
    String type,
    int priority,
    String label,
    TaskStatus status,
    DateTime createdAt,
    Map<String, dynamic> data,
    int retryCount,
    DateTime? startedAt,
    DateTime? completedAt,
    String? error,
    Map<String, dynamic>? result,
  });
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? priority = null,
    Object? label = null,
    Object? status = null,
    Object? createdAt = null,
    Object? data = null,
    Object? retryCount = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? error = freezed,
    Object? result = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as int,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TaskStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            retryCount: null == retryCount
                ? _value.retryCount
                : retryCount // ignore: cast_nullable_to_non_nullable
                      as int,
            startedAt: freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            result: freezed == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
    _$TaskImpl value,
    $Res Function(_$TaskImpl) then,
  ) = __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String type,
    int priority,
    String label,
    TaskStatus status,
    DateTime createdAt,
    Map<String, dynamic> data,
    int retryCount,
    DateTime? startedAt,
    DateTime? completedAt,
    String? error,
    Map<String, dynamic>? result,
  });
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
    : super(_value, _then);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? priority = null,
    Object? label = null,
    Object? status = null,
    Object? createdAt = null,
    Object? data = null,
    Object? retryCount = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? error = freezed,
    Object? result = freezed,
  }) {
    return _then(
      _$TaskImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as int,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TaskStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        retryCount: null == retryCount
            ? _value.retryCount
            : retryCount // ignore: cast_nullable_to_non_nullable
                  as int,
        startedAt: freezed == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        result: freezed == result
            ? _value._result
            : result // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskImpl implements _Task {
  const _$TaskImpl({
    required this.id,
    required this.type,
    required this.priority,
    required this.label,
    required this.status,
    required this.createdAt,
    required final Map<String, dynamic> data,
    this.retryCount = 0,
    this.startedAt,
    this.completedAt,
    this.error,
    final Map<String, dynamic>? result,
  }) : _data = data,
       _result = result;

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final int priority;
  @override
  final String label;
  @override
  final TaskStatus status;
  @override
  final DateTime createdAt;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  @JsonKey()
  final int retryCount;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? completedAt;
  @override
  final String? error;
  final Map<String, dynamic>? _result;
  @override
  Map<String, dynamic>? get result {
    final value = _result;
    if (value == null) return null;
    if (_result is EqualUnmodifiableMapView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Task(id: $id, type: $type, priority: $priority, label: $label, status: $status, createdAt: $createdAt, data: $data, retryCount: $retryCount, startedAt: $startedAt, completedAt: $completedAt, error: $error, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality().equals(other._result, _result));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    priority,
    label,
    status,
    createdAt,
    const DeepCollectionEquality().hash(_data),
    retryCount,
    startedAt,
    completedAt,
    error,
    const DeepCollectionEquality().hash(_result),
  );

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(this);
  }
}

abstract class _Task implements Task {
  const factory _Task({
    required final String id,
    required final String type,
    required final int priority,
    required final String label,
    required final TaskStatus status,
    required final DateTime createdAt,
    required final Map<String, dynamic> data,
    final int retryCount,
    final DateTime? startedAt,
    final DateTime? completedAt,
    final String? error,
    final Map<String, dynamic>? result,
  }) = _$TaskImpl;

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override
  int get priority;
  @override
  String get label;
  @override
  TaskStatus get status;
  @override
  DateTime get createdAt;
  @override
  Map<String, dynamic> get data;
  @override
  int get retryCount;
  @override
  DateTime? get startedAt;
  @override
  DateTime? get completedAt;
  @override
  String? get error;
  @override
  Map<String, dynamic>? get result;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskResult _$TaskResultFromJson(Map<String, dynamic> json) {
  return _TaskResult.fromJson(json);
}

/// @nodoc
mixin _$TaskResult {
  String get taskId => throw _privateConstructorUsedError;
  TaskStatus get status => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this TaskResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskResultCopyWith<TaskResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskResultCopyWith<$Res> {
  factory $TaskResultCopyWith(
    TaskResult value,
    $Res Function(TaskResult) then,
  ) = _$TaskResultCopyWithImpl<$Res, TaskResult>;
  @useResult
  $Res call({
    String taskId,
    TaskStatus status,
    DateTime timestamp,
    Map<String, dynamic>? data,
    String? error,
  });
}

/// @nodoc
class _$TaskResultCopyWithImpl<$Res, $Val extends TaskResult>
    implements $TaskResultCopyWith<$Res> {
  _$TaskResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? status = null,
    Object? timestamp = null,
    Object? data = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            taskId: null == taskId
                ? _value.taskId
                : taskId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TaskStatus,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskResultImplCopyWith<$Res>
    implements $TaskResultCopyWith<$Res> {
  factory _$$TaskResultImplCopyWith(
    _$TaskResultImpl value,
    $Res Function(_$TaskResultImpl) then,
  ) = __$$TaskResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String taskId,
    TaskStatus status,
    DateTime timestamp,
    Map<String, dynamic>? data,
    String? error,
  });
}

/// @nodoc
class __$$TaskResultImplCopyWithImpl<$Res>
    extends _$TaskResultCopyWithImpl<$Res, _$TaskResultImpl>
    implements _$$TaskResultImplCopyWith<$Res> {
  __$$TaskResultImplCopyWithImpl(
    _$TaskResultImpl _value,
    $Res Function(_$TaskResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? status = null,
    Object? timestamp = null,
    Object? data = freezed,
    Object? error = freezed,
  }) {
    return _then(
      _$TaskResultImpl(
        taskId: null == taskId
            ? _value.taskId
            : taskId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TaskStatus,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        data: freezed == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskResultImpl implements _TaskResult {
  const _$TaskResultImpl({
    required this.taskId,
    required this.status,
    required this.timestamp,
    final Map<String, dynamic>? data,
    this.error,
  }) : _data = data;

  factory _$TaskResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskResultImplFromJson(json);

  @override
  final String taskId;
  @override
  final TaskStatus status;
  @override
  final DateTime timestamp;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? error;

  @override
  String toString() {
    return 'TaskResult(taskId: $taskId, status: $status, timestamp: $timestamp, data: $data, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskResultImpl &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    taskId,
    status,
    timestamp,
    const DeepCollectionEquality().hash(_data),
    error,
  );

  /// Create a copy of TaskResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskResultImplCopyWith<_$TaskResultImpl> get copyWith =>
      __$$TaskResultImplCopyWithImpl<_$TaskResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskResultImplToJson(this);
  }
}

abstract class _TaskResult implements TaskResult {
  const factory _TaskResult({
    required final String taskId,
    required final TaskStatus status,
    required final DateTime timestamp,
    final Map<String, dynamic>? data,
    final String? error,
  }) = _$TaskResultImpl;

  factory _TaskResult.fromJson(Map<String, dynamic> json) =
      _$TaskResultImpl.fromJson;

  @override
  String get taskId;
  @override
  TaskStatus get status;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic>? get data;
  @override
  String? get error;

  /// Create a copy of TaskResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskResultImplCopyWith<_$TaskResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskFilter _$TaskFilterFromJson(Map<String, dynamic> json) {
  return _TaskFilter.fromJson(json);
}

/// @nodoc
mixin _$TaskFilter {
  List<String>? get types => throw _privateConstructorUsedError;
  List<TaskStatus>? get statuses => throw _privateConstructorUsedError;
  List<int>? get priorities => throw _privateConstructorUsedError;
  DateTime? get createdAfter => throw _privateConstructorUsedError;
  DateTime? get createdBefore => throw _privateConstructorUsedError;
  int? get limit => throw _privateConstructorUsedError;

  /// Serializes this TaskFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskFilterCopyWith<TaskFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskFilterCopyWith<$Res> {
  factory $TaskFilterCopyWith(
    TaskFilter value,
    $Res Function(TaskFilter) then,
  ) = _$TaskFilterCopyWithImpl<$Res, TaskFilter>;
  @useResult
  $Res call({
    List<String>? types,
    List<TaskStatus>? statuses,
    List<int>? priorities,
    DateTime? createdAfter,
    DateTime? createdBefore,
    int? limit,
  });
}

/// @nodoc
class _$TaskFilterCopyWithImpl<$Res, $Val extends TaskFilter>
    implements $TaskFilterCopyWith<$Res> {
  _$TaskFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? types = freezed,
    Object? statuses = freezed,
    Object? priorities = freezed,
    Object? createdAfter = freezed,
    Object? createdBefore = freezed,
    Object? limit = freezed,
  }) {
    return _then(
      _value.copyWith(
            types: freezed == types
                ? _value.types
                : types // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            statuses: freezed == statuses
                ? _value.statuses
                : statuses // ignore: cast_nullable_to_non_nullable
                      as List<TaskStatus>?,
            priorities: freezed == priorities
                ? _value.priorities
                : priorities // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
            createdAfter: freezed == createdAfter
                ? _value.createdAfter
                : createdAfter // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdBefore: freezed == createdBefore
                ? _value.createdBefore
                : createdBefore // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            limit: freezed == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskFilterImplCopyWith<$Res>
    implements $TaskFilterCopyWith<$Res> {
  factory _$$TaskFilterImplCopyWith(
    _$TaskFilterImpl value,
    $Res Function(_$TaskFilterImpl) then,
  ) = __$$TaskFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<String>? types,
    List<TaskStatus>? statuses,
    List<int>? priorities,
    DateTime? createdAfter,
    DateTime? createdBefore,
    int? limit,
  });
}

/// @nodoc
class __$$TaskFilterImplCopyWithImpl<$Res>
    extends _$TaskFilterCopyWithImpl<$Res, _$TaskFilterImpl>
    implements _$$TaskFilterImplCopyWith<$Res> {
  __$$TaskFilterImplCopyWithImpl(
    _$TaskFilterImpl _value,
    $Res Function(_$TaskFilterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? types = freezed,
    Object? statuses = freezed,
    Object? priorities = freezed,
    Object? createdAfter = freezed,
    Object? createdBefore = freezed,
    Object? limit = freezed,
  }) {
    return _then(
      _$TaskFilterImpl(
        types: freezed == types
            ? _value._types
            : types // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        statuses: freezed == statuses
            ? _value._statuses
            : statuses // ignore: cast_nullable_to_non_nullable
                  as List<TaskStatus>?,
        priorities: freezed == priorities
            ? _value._priorities
            : priorities // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        createdAfter: freezed == createdAfter
            ? _value.createdAfter
            : createdAfter // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdBefore: freezed == createdBefore
            ? _value.createdBefore
            : createdBefore // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskFilterImpl implements _TaskFilter {
  const _$TaskFilterImpl({
    final List<String>? types,
    final List<TaskStatus>? statuses,
    final List<int>? priorities,
    this.createdAfter,
    this.createdBefore,
    this.limit,
  }) : _types = types,
       _statuses = statuses,
       _priorities = priorities;

  factory _$TaskFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskFilterImplFromJson(json);

  final List<String>? _types;
  @override
  List<String>? get types {
    final value = _types;
    if (value == null) return null;
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<TaskStatus>? _statuses;
  @override
  List<TaskStatus>? get statuses {
    final value = _statuses;
    if (value == null) return null;
    if (_statuses is EqualUnmodifiableListView) return _statuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<int>? _priorities;
  @override
  List<int>? get priorities {
    final value = _priorities;
    if (value == null) return null;
    if (_priorities is EqualUnmodifiableListView) return _priorities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? createdAfter;
  @override
  final DateTime? createdBefore;
  @override
  final int? limit;

  @override
  String toString() {
    return 'TaskFilter(types: $types, statuses: $statuses, priorities: $priorities, createdAfter: $createdAfter, createdBefore: $createdBefore, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskFilterImpl &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            const DeepCollectionEquality().equals(other._statuses, _statuses) &&
            const DeepCollectionEquality().equals(
              other._priorities,
              _priorities,
            ) &&
            (identical(other.createdAfter, createdAfter) ||
                other.createdAfter == createdAfter) &&
            (identical(other.createdBefore, createdBefore) ||
                other.createdBefore == createdBefore) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_types),
    const DeepCollectionEquality().hash(_statuses),
    const DeepCollectionEquality().hash(_priorities),
    createdAfter,
    createdBefore,
    limit,
  );

  /// Create a copy of TaskFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskFilterImplCopyWith<_$TaskFilterImpl> get copyWith =>
      __$$TaskFilterImplCopyWithImpl<_$TaskFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskFilterImplToJson(this);
  }
}

abstract class _TaskFilter implements TaskFilter {
  const factory _TaskFilter({
    final List<String>? types,
    final List<TaskStatus>? statuses,
    final List<int>? priorities,
    final DateTime? createdAfter,
    final DateTime? createdBefore,
    final int? limit,
  }) = _$TaskFilterImpl;

  factory _TaskFilter.fromJson(Map<String, dynamic> json) =
      _$TaskFilterImpl.fromJson;

  @override
  List<String>? get types;
  @override
  List<TaskStatus>? get statuses;
  @override
  List<int>? get priorities;
  @override
  DateTime? get createdAfter;
  @override
  DateTime? get createdBefore;
  @override
  int? get limit;

  /// Create a copy of TaskFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskFilterImplCopyWith<_$TaskFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskStats _$TaskStatsFromJson(Map<String, dynamic> json) {
  return _TaskStats.fromJson(json);
}

/// @nodoc
mixin _$TaskStats {
  int get totalTasks => throw _privateConstructorUsedError;
  int get pendingTasks => throw _privateConstructorUsedError;
  int get runningTasks => throw _privateConstructorUsedError;
  int get completedTasks => throw _privateConstructorUsedError;
  int get failedTasks => throw _privateConstructorUsedError;
  int get cancelledTasks => throw _privateConstructorUsedError;
  Map<String, int> get tasksByType => throw _privateConstructorUsedError;
  Map<int, int> get tasksByPriority => throw _privateConstructorUsedError;

  /// Serializes this TaskStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskStatsCopyWith<TaskStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskStatsCopyWith<$Res> {
  factory $TaskStatsCopyWith(TaskStats value, $Res Function(TaskStats) then) =
      _$TaskStatsCopyWithImpl<$Res, TaskStats>;
  @useResult
  $Res call({
    int totalTasks,
    int pendingTasks,
    int runningTasks,
    int completedTasks,
    int failedTasks,
    int cancelledTasks,
    Map<String, int> tasksByType,
    Map<int, int> tasksByPriority,
  });
}

/// @nodoc
class _$TaskStatsCopyWithImpl<$Res, $Val extends TaskStats>
    implements $TaskStatsCopyWith<$Res> {
  _$TaskStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalTasks = null,
    Object? pendingTasks = null,
    Object? runningTasks = null,
    Object? completedTasks = null,
    Object? failedTasks = null,
    Object? cancelledTasks = null,
    Object? tasksByType = null,
    Object? tasksByPriority = null,
  }) {
    return _then(
      _value.copyWith(
            totalTasks: null == totalTasks
                ? _value.totalTasks
                : totalTasks // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingTasks: null == pendingTasks
                ? _value.pendingTasks
                : pendingTasks // ignore: cast_nullable_to_non_nullable
                      as int,
            runningTasks: null == runningTasks
                ? _value.runningTasks
                : runningTasks // ignore: cast_nullable_to_non_nullable
                      as int,
            completedTasks: null == completedTasks
                ? _value.completedTasks
                : completedTasks // ignore: cast_nullable_to_non_nullable
                      as int,
            failedTasks: null == failedTasks
                ? _value.failedTasks
                : failedTasks // ignore: cast_nullable_to_non_nullable
                      as int,
            cancelledTasks: null == cancelledTasks
                ? _value.cancelledTasks
                : cancelledTasks // ignore: cast_nullable_to_non_nullable
                      as int,
            tasksByType: null == tasksByType
                ? _value.tasksByType
                : tasksByType // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            tasksByPriority: null == tasksByPriority
                ? _value.tasksByPriority
                : tasksByPriority // ignore: cast_nullable_to_non_nullable
                      as Map<int, int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskStatsImplCopyWith<$Res>
    implements $TaskStatsCopyWith<$Res> {
  factory _$$TaskStatsImplCopyWith(
    _$TaskStatsImpl value,
    $Res Function(_$TaskStatsImpl) then,
  ) = __$$TaskStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalTasks,
    int pendingTasks,
    int runningTasks,
    int completedTasks,
    int failedTasks,
    int cancelledTasks,
    Map<String, int> tasksByType,
    Map<int, int> tasksByPriority,
  });
}

/// @nodoc
class __$$TaskStatsImplCopyWithImpl<$Res>
    extends _$TaskStatsCopyWithImpl<$Res, _$TaskStatsImpl>
    implements _$$TaskStatsImplCopyWith<$Res> {
  __$$TaskStatsImplCopyWithImpl(
    _$TaskStatsImpl _value,
    $Res Function(_$TaskStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalTasks = null,
    Object? pendingTasks = null,
    Object? runningTasks = null,
    Object? completedTasks = null,
    Object? failedTasks = null,
    Object? cancelledTasks = null,
    Object? tasksByType = null,
    Object? tasksByPriority = null,
  }) {
    return _then(
      _$TaskStatsImpl(
        totalTasks: null == totalTasks
            ? _value.totalTasks
            : totalTasks // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingTasks: null == pendingTasks
            ? _value.pendingTasks
            : pendingTasks // ignore: cast_nullable_to_non_nullable
                  as int,
        runningTasks: null == runningTasks
            ? _value.runningTasks
            : runningTasks // ignore: cast_nullable_to_non_nullable
                  as int,
        completedTasks: null == completedTasks
            ? _value.completedTasks
            : completedTasks // ignore: cast_nullable_to_non_nullable
                  as int,
        failedTasks: null == failedTasks
            ? _value.failedTasks
            : failedTasks // ignore: cast_nullable_to_non_nullable
                  as int,
        cancelledTasks: null == cancelledTasks
            ? _value.cancelledTasks
            : cancelledTasks // ignore: cast_nullable_to_non_nullable
                  as int,
        tasksByType: null == tasksByType
            ? _value._tasksByType
            : tasksByType // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        tasksByPriority: null == tasksByPriority
            ? _value._tasksByPriority
            : tasksByPriority // ignore: cast_nullable_to_non_nullable
                  as Map<int, int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskStatsImpl implements _TaskStats {
  const _$TaskStatsImpl({
    required this.totalTasks,
    required this.pendingTasks,
    required this.runningTasks,
    required this.completedTasks,
    required this.failedTasks,
    required this.cancelledTasks,
    required final Map<String, int> tasksByType,
    required final Map<int, int> tasksByPriority,
  }) : _tasksByType = tasksByType,
       _tasksByPriority = tasksByPriority;

  factory _$TaskStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskStatsImplFromJson(json);

  @override
  final int totalTasks;
  @override
  final int pendingTasks;
  @override
  final int runningTasks;
  @override
  final int completedTasks;
  @override
  final int failedTasks;
  @override
  final int cancelledTasks;
  final Map<String, int> _tasksByType;
  @override
  Map<String, int> get tasksByType {
    if (_tasksByType is EqualUnmodifiableMapView) return _tasksByType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tasksByType);
  }

  final Map<int, int> _tasksByPriority;
  @override
  Map<int, int> get tasksByPriority {
    if (_tasksByPriority is EqualUnmodifiableMapView) return _tasksByPriority;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tasksByPriority);
  }

  @override
  String toString() {
    return 'TaskStats(totalTasks: $totalTasks, pendingTasks: $pendingTasks, runningTasks: $runningTasks, completedTasks: $completedTasks, failedTasks: $failedTasks, cancelledTasks: $cancelledTasks, tasksByType: $tasksByType, tasksByPriority: $tasksByPriority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskStatsImpl &&
            (identical(other.totalTasks, totalTasks) ||
                other.totalTasks == totalTasks) &&
            (identical(other.pendingTasks, pendingTasks) ||
                other.pendingTasks == pendingTasks) &&
            (identical(other.runningTasks, runningTasks) ||
                other.runningTasks == runningTasks) &&
            (identical(other.completedTasks, completedTasks) ||
                other.completedTasks == completedTasks) &&
            (identical(other.failedTasks, failedTasks) ||
                other.failedTasks == failedTasks) &&
            (identical(other.cancelledTasks, cancelledTasks) ||
                other.cancelledTasks == cancelledTasks) &&
            const DeepCollectionEquality().equals(
              other._tasksByType,
              _tasksByType,
            ) &&
            const DeepCollectionEquality().equals(
              other._tasksByPriority,
              _tasksByPriority,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalTasks,
    pendingTasks,
    runningTasks,
    completedTasks,
    failedTasks,
    cancelledTasks,
    const DeepCollectionEquality().hash(_tasksByType),
    const DeepCollectionEquality().hash(_tasksByPriority),
  );

  /// Create a copy of TaskStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskStatsImplCopyWith<_$TaskStatsImpl> get copyWith =>
      __$$TaskStatsImplCopyWithImpl<_$TaskStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskStatsImplToJson(this);
  }
}

abstract class _TaskStats implements TaskStats {
  const factory _TaskStats({
    required final int totalTasks,
    required final int pendingTasks,
    required final int runningTasks,
    required final int completedTasks,
    required final int failedTasks,
    required final int cancelledTasks,
    required final Map<String, int> tasksByType,
    required final Map<int, int> tasksByPriority,
  }) = _$TaskStatsImpl;

  factory _TaskStats.fromJson(Map<String, dynamic> json) =
      _$TaskStatsImpl.fromJson;

  @override
  int get totalTasks;
  @override
  int get pendingTasks;
  @override
  int get runningTasks;
  @override
  int get completedTasks;
  @override
  int get failedTasks;
  @override
  int get cancelledTasks;
  @override
  Map<String, int> get tasksByType;
  @override
  Map<int, int> get tasksByPriority;

  /// Create a copy of TaskStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskStatsImplCopyWith<_$TaskStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
