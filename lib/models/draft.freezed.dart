// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DraftMediaData _$DraftMediaDataFromJson(Map<String, dynamic> json) {
  return _DraftMediaData.fromJson(json);
}

/// @nodoc
mixin _$DraftMediaData {
  String get filePath => throw _privateConstructorUsedError;
  MediaType get mediaType => throw _privateConstructorUsedError;
  int? get fileSize => throw _privateConstructorUsedError;
  double? get duration =>
      throw _privateConstructorUsedError; // Video/audio duration in seconds
  String? get thumbnailPath => throw _privateConstructorUsedError;

  /// Serializes this DraftMediaData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DraftMediaData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DraftMediaDataCopyWith<DraftMediaData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DraftMediaDataCopyWith<$Res> {
  factory $DraftMediaDataCopyWith(
    DraftMediaData value,
    $Res Function(DraftMediaData) then,
  ) = _$DraftMediaDataCopyWithImpl<$Res, DraftMediaData>;
  @useResult
  $Res call({
    String filePath,
    MediaType mediaType,
    int? fileSize,
    double? duration,
    String? thumbnailPath,
  });
}

/// @nodoc
class _$DraftMediaDataCopyWithImpl<$Res, $Val extends DraftMediaData>
    implements $DraftMediaDataCopyWith<$Res> {
  _$DraftMediaDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DraftMediaData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filePath = null,
    Object? mediaType = null,
    Object? fileSize = freezed,
    Object? duration = freezed,
    Object? thumbnailPath = freezed,
  }) {
    return _then(
      _value.copyWith(
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DraftMediaDataImplCopyWith<$Res>
    implements $DraftMediaDataCopyWith<$Res> {
  factory _$$DraftMediaDataImplCopyWith(
    _$DraftMediaDataImpl value,
    $Res Function(_$DraftMediaDataImpl) then,
  ) = __$$DraftMediaDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String filePath,
    MediaType mediaType,
    int? fileSize,
    double? duration,
    String? thumbnailPath,
  });
}

/// @nodoc
class __$$DraftMediaDataImplCopyWithImpl<$Res>
    extends _$DraftMediaDataCopyWithImpl<$Res, _$DraftMediaDataImpl>
    implements _$$DraftMediaDataImplCopyWith<$Res> {
  __$$DraftMediaDataImplCopyWithImpl(
    _$DraftMediaDataImpl _value,
    $Res Function(_$DraftMediaDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DraftMediaData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filePath = null,
    Object? mediaType = null,
    Object? fileSize = freezed,
    Object? duration = freezed,
    Object? thumbnailPath = freezed,
  }) {
    return _then(
      _$DraftMediaDataImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DraftMediaDataImpl implements _DraftMediaData {
  const _$DraftMediaDataImpl({
    required this.filePath,
    required this.mediaType,
    this.fileSize,
    this.duration,
    this.thumbnailPath,
  });

  factory _$DraftMediaDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DraftMediaDataImplFromJson(json);

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
  String toString() {
    return 'DraftMediaData(filePath: $filePath, mediaType: $mediaType, fileSize: $fileSize, duration: $duration, thumbnailPath: $thumbnailPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DraftMediaDataImpl &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.thumbnailPath, thumbnailPath) ||
                other.thumbnailPath == thumbnailPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    filePath,
    mediaType,
    fileSize,
    duration,
    thumbnailPath,
  );

  /// Create a copy of DraftMediaData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DraftMediaDataImplCopyWith<_$DraftMediaDataImpl> get copyWith =>
      __$$DraftMediaDataImplCopyWithImpl<_$DraftMediaDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DraftMediaDataImplToJson(this);
  }
}

abstract class _DraftMediaData implements DraftMediaData {
  const factory _DraftMediaData({
    required final String filePath,
    required final MediaType mediaType,
    final int? fileSize,
    final double? duration,
    final String? thumbnailPath,
  }) = _$DraftMediaDataImpl;

  factory _DraftMediaData.fromJson(Map<String, dynamic> json) =
      _$DraftMediaDataImpl.fromJson;

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

  /// Create a copy of DraftMediaData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DraftMediaDataImplCopyWith<_$DraftMediaDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DraftData _$DraftDataFromJson(Map<String, dynamic> json) {
  return _DraftData.fromJson(json);
}

/// @nodoc
mixin _$DraftData {
  String get content => throw _privateConstructorUsedError;
  List<String> get moods => throw _privateConstructorUsedError;
  List<DraftMediaData> get mediaAttachments =>
      throw _privateConstructorUsedError;
  DateTime get lastModified => throw _privateConstructorUsedError;

  /// Serializes this DraftData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DraftData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DraftDataCopyWith<DraftData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DraftDataCopyWith<$Res> {
  factory $DraftDataCopyWith(DraftData value, $Res Function(DraftData) then) =
      _$DraftDataCopyWithImpl<$Res, DraftData>;
  @useResult
  $Res call({
    String content,
    List<String> moods,
    List<DraftMediaData> mediaAttachments,
    DateTime lastModified,
  });
}

/// @nodoc
class _$DraftDataCopyWithImpl<$Res, $Val extends DraftData>
    implements $DraftDataCopyWith<$Res> {
  _$DraftDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DraftData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? moods = null,
    Object? mediaAttachments = null,
    Object? lastModified = null,
  }) {
    return _then(
      _value.copyWith(
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            moods: null == moods
                ? _value.moods
                : moods // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            mediaAttachments: null == mediaAttachments
                ? _value.mediaAttachments
                : mediaAttachments // ignore: cast_nullable_to_non_nullable
                      as List<DraftMediaData>,
            lastModified: null == lastModified
                ? _value.lastModified
                : lastModified // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DraftDataImplCopyWith<$Res>
    implements $DraftDataCopyWith<$Res> {
  factory _$$DraftDataImplCopyWith(
    _$DraftDataImpl value,
    $Res Function(_$DraftDataImpl) then,
  ) = __$$DraftDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String content,
    List<String> moods,
    List<DraftMediaData> mediaAttachments,
    DateTime lastModified,
  });
}

/// @nodoc
class __$$DraftDataImplCopyWithImpl<$Res>
    extends _$DraftDataCopyWithImpl<$Res, _$DraftDataImpl>
    implements _$$DraftDataImplCopyWith<$Res> {
  __$$DraftDataImplCopyWithImpl(
    _$DraftDataImpl _value,
    $Res Function(_$DraftDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DraftData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? moods = null,
    Object? mediaAttachments = null,
    Object? lastModified = null,
  }) {
    return _then(
      _$DraftDataImpl(
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        moods: null == moods
            ? _value._moods
            : moods // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        mediaAttachments: null == mediaAttachments
            ? _value._mediaAttachments
            : mediaAttachments // ignore: cast_nullable_to_non_nullable
                  as List<DraftMediaData>,
        lastModified: null == lastModified
            ? _value.lastModified
            : lastModified // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DraftDataImpl implements _DraftData {
  const _$DraftDataImpl({
    required this.content,
    final List<String> moods = const [],
    final List<DraftMediaData> mediaAttachments = const [],
    required this.lastModified,
  }) : _moods = moods,
       _mediaAttachments = mediaAttachments;

  factory _$DraftDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DraftDataImplFromJson(json);

  @override
  final String content;
  final List<String> _moods;
  @override
  @JsonKey()
  List<String> get moods {
    if (_moods is EqualUnmodifiableListView) return _moods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moods);
  }

  final List<DraftMediaData> _mediaAttachments;
  @override
  @JsonKey()
  List<DraftMediaData> get mediaAttachments {
    if (_mediaAttachments is EqualUnmodifiableListView)
      return _mediaAttachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mediaAttachments);
  }

  @override
  final DateTime lastModified;

  @override
  String toString() {
    return 'DraftData(content: $content, moods: $moods, mediaAttachments: $mediaAttachments, lastModified: $lastModified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DraftDataImpl &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._moods, _moods) &&
            const DeepCollectionEquality().equals(
              other._mediaAttachments,
              _mediaAttachments,
            ) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    content,
    const DeepCollectionEquality().hash(_moods),
    const DeepCollectionEquality().hash(_mediaAttachments),
    lastModified,
  );

  /// Create a copy of DraftData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DraftDataImplCopyWith<_$DraftDataImpl> get copyWith =>
      __$$DraftDataImplCopyWithImpl<_$DraftDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DraftDataImplToJson(this);
  }
}

abstract class _DraftData implements DraftData {
  const factory _DraftData({
    required final String content,
    final List<String> moods,
    final List<DraftMediaData> mediaAttachments,
    required final DateTime lastModified,
  }) = _$DraftDataImpl;

  factory _DraftData.fromJson(Map<String, dynamic> json) =
      _$DraftDataImpl.fromJson;

  @override
  String get content;
  @override
  List<String> get moods;
  @override
  List<DraftMediaData> get mediaAttachments;
  @override
  DateTime get lastModified;

  /// Create a copy of DraftData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DraftDataImplCopyWith<_$DraftDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
