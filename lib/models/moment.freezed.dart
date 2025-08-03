// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Moment _$MomentFromJson(Map<String, dynamic> json) {
  return _Moment.fromJson(json);
}

/// @nodoc
mixin _$Moment {
  int? get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<String> get moods => throw _privateConstructorUsedError;
  List<MediaAttachment> get images => throw _privateConstructorUsedError;
  List<MediaAttachment> get audios => throw _privateConstructorUsedError;
  List<MediaAttachment> get videos => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get aiProcessed => throw _privateConstructorUsedError;

  /// Serializes this Moment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Moment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MomentCopyWith<Moment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MomentCopyWith<$Res> {
  factory $MomentCopyWith(Moment value, $Res Function(Moment) then) =
      _$MomentCopyWithImpl<$Res, Moment>;
  @useResult
  $Res call({
    int? id,
    String content,
    List<String> moods,
    List<MediaAttachment> images,
    List<MediaAttachment> audios,
    List<MediaAttachment> videos,
    DateTime createdAt,
    DateTime updatedAt,
    bool aiProcessed,
  });
}

/// @nodoc
class _$MomentCopyWithImpl<$Res, $Val extends Moment>
    implements $MomentCopyWith<$Res> {
  _$MomentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Moment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? content = null,
    Object? moods = null,
    Object? images = null,
    Object? audios = null,
    Object? videos = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? aiProcessed = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            moods: null == moods
                ? _value.moods
                : moods // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<MediaAttachment>,
            audios: null == audios
                ? _value.audios
                : audios // ignore: cast_nullable_to_non_nullable
                      as List<MediaAttachment>,
            videos: null == videos
                ? _value.videos
                : videos // ignore: cast_nullable_to_non_nullable
                      as List<MediaAttachment>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            aiProcessed: null == aiProcessed
                ? _value.aiProcessed
                : aiProcessed // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MomentImplCopyWith<$Res> implements $MomentCopyWith<$Res> {
  factory _$$MomentImplCopyWith(
    _$MomentImpl value,
    $Res Function(_$MomentImpl) then,
  ) = __$$MomentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String content,
    List<String> moods,
    List<MediaAttachment> images,
    List<MediaAttachment> audios,
    List<MediaAttachment> videos,
    DateTime createdAt,
    DateTime updatedAt,
    bool aiProcessed,
  });
}

/// @nodoc
class __$$MomentImplCopyWithImpl<$Res>
    extends _$MomentCopyWithImpl<$Res, _$MomentImpl>
    implements _$$MomentImplCopyWith<$Res> {
  __$$MomentImplCopyWithImpl(
    _$MomentImpl _value,
    $Res Function(_$MomentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Moment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? content = null,
    Object? moods = null,
    Object? images = null,
    Object? audios = null,
    Object? videos = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? aiProcessed = null,
  }) {
    return _then(
      _$MomentImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        moods: null == moods
            ? _value._moods
            : moods // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<MediaAttachment>,
        audios: null == audios
            ? _value._audios
            : audios // ignore: cast_nullable_to_non_nullable
                  as List<MediaAttachment>,
        videos: null == videos
            ? _value._videos
            : videos // ignore: cast_nullable_to_non_nullable
                  as List<MediaAttachment>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        aiProcessed: null == aiProcessed
            ? _value.aiProcessed
            : aiProcessed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MomentImpl implements _Moment {
  const _$MomentImpl({
    this.id,
    required this.content,
    final List<String> moods = const [],
    final List<MediaAttachment> images = const [],
    final List<MediaAttachment> audios = const [],
    final List<MediaAttachment> videos = const [],
    required this.createdAt,
    required this.updatedAt,
    this.aiProcessed = false,
  }) : _moods = moods,
       _images = images,
       _audios = audios,
       _videos = videos;

  factory _$MomentImpl.fromJson(Map<String, dynamic> json) =>
      _$$MomentImplFromJson(json);

  @override
  final int? id;
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

  final List<MediaAttachment> _images;
  @override
  @JsonKey()
  List<MediaAttachment> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<MediaAttachment> _audios;
  @override
  @JsonKey()
  List<MediaAttachment> get audios {
    if (_audios is EqualUnmodifiableListView) return _audios;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_audios);
  }

  final List<MediaAttachment> _videos;
  @override
  @JsonKey()
  List<MediaAttachment> get videos {
    if (_videos is EqualUnmodifiableListView) return _videos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videos);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final bool aiProcessed;

  @override
  String toString() {
    return 'Moment(id: $id, content: $content, moods: $moods, images: $images, audios: $audios, videos: $videos, createdAt: $createdAt, updatedAt: $updatedAt, aiProcessed: $aiProcessed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MomentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._moods, _moods) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(other._audios, _audios) &&
            const DeepCollectionEquality().equals(other._videos, _videos) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.aiProcessed, aiProcessed) ||
                other.aiProcessed == aiProcessed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    content,
    const DeepCollectionEquality().hash(_moods),
    const DeepCollectionEquality().hash(_images),
    const DeepCollectionEquality().hash(_audios),
    const DeepCollectionEquality().hash(_videos),
    createdAt,
    updatedAt,
    aiProcessed,
  );

  /// Create a copy of Moment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MomentImplCopyWith<_$MomentImpl> get copyWith =>
      __$$MomentImplCopyWithImpl<_$MomentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MomentImplToJson(this);
  }
}

abstract class _Moment implements Moment {
  const factory _Moment({
    final int? id,
    required final String content,
    final List<String> moods,
    final List<MediaAttachment> images,
    final List<MediaAttachment> audios,
    final List<MediaAttachment> videos,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final bool aiProcessed,
  }) = _$MomentImpl;

  factory _Moment.fromJson(Map<String, dynamic> json) = _$MomentImpl.fromJson;

  @override
  int? get id;
  @override
  String get content;
  @override
  List<String> get moods;
  @override
  List<MediaAttachment> get images;
  @override
  List<MediaAttachment> get audios;
  @override
  List<MediaAttachment> get videos;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get aiProcessed;

  /// Create a copy of Moment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MomentImplCopyWith<_$MomentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
