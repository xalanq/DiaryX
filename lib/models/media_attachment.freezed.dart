// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_attachment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MediaAttachment _$MediaAttachmentFromJson(Map<String, dynamic> json) {
  return _MediaAttachment.fromJson(json);
}

/// @nodoc
mixin _$MediaAttachment {
  int? get id => throw _privateConstructorUsedError;
  int get momentId => throw _privateConstructorUsedError;
  String get filePath => throw _privateConstructorUsedError;
  MediaType get mediaType => throw _privateConstructorUsedError;
  int? get fileSize => throw _privateConstructorUsedError;
  double? get duration =>
      throw _privateConstructorUsedError; // Video/audio duration in seconds
  String? get thumbnailPath => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MediaAttachment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MediaAttachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaAttachmentCopyWith<MediaAttachment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaAttachmentCopyWith<$Res> {
  factory $MediaAttachmentCopyWith(
    MediaAttachment value,
    $Res Function(MediaAttachment) then,
  ) = _$MediaAttachmentCopyWithImpl<$Res, MediaAttachment>;
  @useResult
  $Res call({
    int? id,
    int momentId,
    String filePath,
    MediaType mediaType,
    int? fileSize,
    double? duration,
    String? thumbnailPath,
    DateTime createdAt,
  });
}

/// @nodoc
class _$MediaAttachmentCopyWithImpl<$Res, $Val extends MediaAttachment>
    implements $MediaAttachmentCopyWith<$Res> {
  _$MediaAttachmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaAttachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? momentId = null,
    Object? filePath = null,
    Object? mediaType = null,
    Object? fileSize = freezed,
    Object? duration = freezed,
    Object? thumbnailPath = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            momentId: null == momentId
                ? _value.momentId
                : momentId // ignore: cast_nullable_to_non_nullable
                      as int,
            filePath: null == filePath
                ? _value.filePath
                : filePath // ignore: cast_nullable_to_non_nullable
                      as String,
            mediaType: null == mediaType
                ? _value.mediaType
                : mediaType // ignore: cast_nullable_to_non_nullable
                      as MediaType,
            fileSize: freezed == fileSize
                ? _value.fileSize
                : fileSize // ignore: cast_nullable_to_non_nullable
                      as int?,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as double?,
            thumbnailPath: freezed == thumbnailPath
                ? _value.thumbnailPath
                : thumbnailPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MediaAttachmentImplCopyWith<$Res>
    implements $MediaAttachmentCopyWith<$Res> {
  factory _$$MediaAttachmentImplCopyWith(
    _$MediaAttachmentImpl value,
    $Res Function(_$MediaAttachmentImpl) then,
  ) = __$$MediaAttachmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    int momentId,
    String filePath,
    MediaType mediaType,
    int? fileSize,
    double? duration,
    String? thumbnailPath,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$MediaAttachmentImplCopyWithImpl<$Res>
    extends _$MediaAttachmentCopyWithImpl<$Res, _$MediaAttachmentImpl>
    implements _$$MediaAttachmentImplCopyWith<$Res> {
  __$$MediaAttachmentImplCopyWithImpl(
    _$MediaAttachmentImpl _value,
    $Res Function(_$MediaAttachmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MediaAttachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? momentId = null,
    Object? filePath = null,
    Object? mediaType = null,
    Object? fileSize = freezed,
    Object? duration = freezed,
    Object? thumbnailPath = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$MediaAttachmentImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        momentId: null == momentId
            ? _value.momentId
            : momentId // ignore: cast_nullable_to_non_nullable
                  as int,
        filePath: null == filePath
            ? _value.filePath
            : filePath // ignore: cast_nullable_to_non_nullable
                  as String,
        mediaType: null == mediaType
            ? _value.mediaType
            : mediaType // ignore: cast_nullable_to_non_nullable
                  as MediaType,
        fileSize: freezed == fileSize
            ? _value.fileSize
            : fileSize // ignore: cast_nullable_to_non_nullable
                  as int?,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as double?,
        thumbnailPath: freezed == thumbnailPath
            ? _value.thumbnailPath
            : thumbnailPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MediaAttachmentImpl implements _MediaAttachment {
  const _$MediaAttachmentImpl({
    this.id,
    required this.momentId,
    required this.filePath,
    required this.mediaType,
    this.fileSize,
    this.duration,
    this.thumbnailPath,
    required this.createdAt,
  });

  factory _$MediaAttachmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$MediaAttachmentImplFromJson(json);

  @override
  final int? id;
  @override
  final int momentId;
  @override
  final String filePath;
  @override
  final MediaType mediaType;
  @override
  final int? fileSize;
  @override
  final double? duration;
  // Video/audio duration in seconds
  @override
  final String? thumbnailPath;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'MediaAttachment(id: $id, momentId: $momentId, filePath: $filePath, mediaType: $mediaType, fileSize: $fileSize, duration: $duration, thumbnailPath: $thumbnailPath, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaAttachmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.momentId, momentId) ||
                other.momentId == momentId) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.thumbnailPath, thumbnailPath) ||
                other.thumbnailPath == thumbnailPath) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    momentId,
    filePath,
    mediaType,
    fileSize,
    duration,
    thumbnailPath,
    createdAt,
  );

  /// Create a copy of MediaAttachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaAttachmentImplCopyWith<_$MediaAttachmentImpl> get copyWith =>
      __$$MediaAttachmentImplCopyWithImpl<_$MediaAttachmentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MediaAttachmentImplToJson(this);
  }
}

abstract class _MediaAttachment implements MediaAttachment {
  const factory _MediaAttachment({
    final int? id,
    required final int momentId,
    required final String filePath,
    required final MediaType mediaType,
    final int? fileSize,
    final double? duration,
    final String? thumbnailPath,
    required final DateTime createdAt,
  }) = _$MediaAttachmentImpl;

  factory _MediaAttachment.fromJson(Map<String, dynamic> json) =
      _$MediaAttachmentImpl.fromJson;

  @override
  int? get id;
  @override
  int get momentId;
  @override
  String get filePath;
  @override
  MediaType get mediaType;
  @override
  int? get fileSize;
  @override
  double? get duration; // Video/audio duration in seconds
  @override
  String? get thumbnailPath;
  @override
  DateTime get createdAt;

  /// Create a copy of MediaAttachment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaAttachmentImplCopyWith<_$MediaAttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
