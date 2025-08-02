// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emotion_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EmotionAnalysis _$EmotionAnalysisFromJson(Map<String, dynamic> json) {
  return _EmotionAnalysis.fromJson(json);
}

/// @nodoc
mixin _$EmotionAnalysis {
  int? get id => throw _privateConstructorUsedError;
  int get entryId => throw _privateConstructorUsedError;
  double? get emotionScore =>
      throw _privateConstructorUsedError; // -1.0 to 1.0 (negative to positive)
  String? get primaryEmotion => throw _privateConstructorUsedError;
  double? get confidenceScore =>
      throw _privateConstructorUsedError; // 0.0 to 1.0
  String? get emotionKeywords =>
      throw _privateConstructorUsedError; // JSON array of emotion-related keywords
  DateTime get analysisTimestamp => throw _privateConstructorUsedError;

  /// Serializes this EmotionAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmotionAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmotionAnalysisCopyWith<EmotionAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmotionAnalysisCopyWith<$Res> {
  factory $EmotionAnalysisCopyWith(
    EmotionAnalysis value,
    $Res Function(EmotionAnalysis) then,
  ) = _$EmotionAnalysisCopyWithImpl<$Res, EmotionAnalysis>;
  @useResult
  $Res call({
    int? id,
    int entryId,
    double? emotionScore,
    String? primaryEmotion,
    double? confidenceScore,
    String? emotionKeywords,
    DateTime analysisTimestamp,
  });
}

/// @nodoc
class _$EmotionAnalysisCopyWithImpl<$Res, $Val extends EmotionAnalysis>
    implements $EmotionAnalysisCopyWith<$Res> {
  _$EmotionAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmotionAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? entryId = null,
    Object? emotionScore = freezed,
    Object? primaryEmotion = freezed,
    Object? confidenceScore = freezed,
    Object? emotionKeywords = freezed,
    Object? analysisTimestamp = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            entryId: null == entryId
                ? _value.entryId
                : entryId // ignore: cast_nullable_to_non_nullable
                      as int,
            emotionScore: freezed == emotionScore
                ? _value.emotionScore
                : emotionScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            primaryEmotion: freezed == primaryEmotion
                ? _value.primaryEmotion
                : primaryEmotion // ignore: cast_nullable_to_non_nullable
                      as String?,
            confidenceScore: freezed == confidenceScore
                ? _value.confidenceScore
                : confidenceScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            emotionKeywords: freezed == emotionKeywords
                ? _value.emotionKeywords
                : emotionKeywords // ignore: cast_nullable_to_non_nullable
                      as String?,
            analysisTimestamp: null == analysisTimestamp
                ? _value.analysisTimestamp
                : analysisTimestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmotionAnalysisImplCopyWith<$Res>
    implements $EmotionAnalysisCopyWith<$Res> {
  factory _$$EmotionAnalysisImplCopyWith(
    _$EmotionAnalysisImpl value,
    $Res Function(_$EmotionAnalysisImpl) then,
  ) = __$$EmotionAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    int entryId,
    double? emotionScore,
    String? primaryEmotion,
    double? confidenceScore,
    String? emotionKeywords,
    DateTime analysisTimestamp,
  });
}

/// @nodoc
class __$$EmotionAnalysisImplCopyWithImpl<$Res>
    extends _$EmotionAnalysisCopyWithImpl<$Res, _$EmotionAnalysisImpl>
    implements _$$EmotionAnalysisImplCopyWith<$Res> {
  __$$EmotionAnalysisImplCopyWithImpl(
    _$EmotionAnalysisImpl _value,
    $Res Function(_$EmotionAnalysisImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmotionAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? entryId = null,
    Object? emotionScore = freezed,
    Object? primaryEmotion = freezed,
    Object? confidenceScore = freezed,
    Object? emotionKeywords = freezed,
    Object? analysisTimestamp = null,
  }) {
    return _then(
      _$EmotionAnalysisImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        entryId: null == entryId
            ? _value.entryId
            : entryId // ignore: cast_nullable_to_non_nullable
                  as int,
        emotionScore: freezed == emotionScore
            ? _value.emotionScore
            : emotionScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        primaryEmotion: freezed == primaryEmotion
            ? _value.primaryEmotion
            : primaryEmotion // ignore: cast_nullable_to_non_nullable
                  as String?,
        confidenceScore: freezed == confidenceScore
            ? _value.confidenceScore
            : confidenceScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        emotionKeywords: freezed == emotionKeywords
            ? _value.emotionKeywords
            : emotionKeywords // ignore: cast_nullable_to_non_nullable
                  as String?,
        analysisTimestamp: null == analysisTimestamp
            ? _value.analysisTimestamp
            : analysisTimestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmotionAnalysisImpl implements _EmotionAnalysis {
  const _$EmotionAnalysisImpl({
    this.id,
    required this.entryId,
    this.emotionScore,
    this.primaryEmotion,
    this.confidenceScore,
    this.emotionKeywords,
    required this.analysisTimestamp,
  });

  factory _$EmotionAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmotionAnalysisImplFromJson(json);

  @override
  final int? id;
  @override
  final int entryId;
  @override
  final double? emotionScore;
  // -1.0 to 1.0 (negative to positive)
  @override
  final String? primaryEmotion;
  @override
  final double? confidenceScore;
  // 0.0 to 1.0
  @override
  final String? emotionKeywords;
  // JSON array of emotion-related keywords
  @override
  final DateTime analysisTimestamp;

  @override
  String toString() {
    return 'EmotionAnalysis(id: $id, entryId: $entryId, emotionScore: $emotionScore, primaryEmotion: $primaryEmotion, confidenceScore: $confidenceScore, emotionKeywords: $emotionKeywords, analysisTimestamp: $analysisTimestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmotionAnalysisImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entryId, entryId) || other.entryId == entryId) &&
            (identical(other.emotionScore, emotionScore) ||
                other.emotionScore == emotionScore) &&
            (identical(other.primaryEmotion, primaryEmotion) ||
                other.primaryEmotion == primaryEmotion) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            (identical(other.emotionKeywords, emotionKeywords) ||
                other.emotionKeywords == emotionKeywords) &&
            (identical(other.analysisTimestamp, analysisTimestamp) ||
                other.analysisTimestamp == analysisTimestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    entryId,
    emotionScore,
    primaryEmotion,
    confidenceScore,
    emotionKeywords,
    analysisTimestamp,
  );

  /// Create a copy of EmotionAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmotionAnalysisImplCopyWith<_$EmotionAnalysisImpl> get copyWith =>
      __$$EmotionAnalysisImplCopyWithImpl<_$EmotionAnalysisImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EmotionAnalysisImplToJson(this);
  }
}

abstract class _EmotionAnalysis implements EmotionAnalysis {
  const factory _EmotionAnalysis({
    final int? id,
    required final int entryId,
    final double? emotionScore,
    final String? primaryEmotion,
    final double? confidenceScore,
    final String? emotionKeywords,
    required final DateTime analysisTimestamp,
  }) = _$EmotionAnalysisImpl;

  factory _EmotionAnalysis.fromJson(Map<String, dynamic> json) =
      _$EmotionAnalysisImpl.fromJson;

  @override
  int? get id;
  @override
  int get entryId;
  @override
  double? get emotionScore; // -1.0 to 1.0 (negative to positive)
  @override
  String? get primaryEmotion;
  @override
  double? get confidenceScore; // 0.0 to 1.0
  @override
  String? get emotionKeywords; // JSON array of emotion-related keywords
  @override
  DateTime get analysisTimestamp;

  /// Create a copy of EmotionAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmotionAnalysisImplCopyWith<_$EmotionAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
