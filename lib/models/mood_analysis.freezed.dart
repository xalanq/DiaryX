// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mood_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MoodAnalysis _$MoodAnalysisFromJson(Map<String, dynamic> json) {
  return _MoodAnalysis.fromJson(json);
}

/// @nodoc
mixin _$MoodAnalysis {
  int? get id => throw _privateConstructorUsedError;
  int get momentId => throw _privateConstructorUsedError;
  double? get moodScore =>
      throw _privateConstructorUsedError; // -1.0 to 1.0 (negative to positive)
  String? get primaryMood => throw _privateConstructorUsedError;
  double? get confidenceScore =>
      throw _privateConstructorUsedError; // 0.0 to 1.0
  String? get moodKeywords =>
      throw _privateConstructorUsedError; // JSON array of mood-related keywords
  DateTime get analysisTimestamp => throw _privateConstructorUsedError;

  /// Serializes this MoodAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MoodAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MoodAnalysisCopyWith<MoodAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoodAnalysisCopyWith<$Res> {
  factory $MoodAnalysisCopyWith(
    MoodAnalysis value,
    $Res Function(MoodAnalysis) then,
  ) = _$MoodAnalysisCopyWithImpl<$Res, MoodAnalysis>;
  @useResult
  $Res call({
    int? id,
    int momentId,
    double? moodScore,
    String? primaryMood,
    double? confidenceScore,
    String? moodKeywords,
    DateTime analysisTimestamp,
  });
}

/// @nodoc
class _$MoodAnalysisCopyWithImpl<$Res, $Val extends MoodAnalysis>
    implements $MoodAnalysisCopyWith<$Res> {
  _$MoodAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MoodAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? momentId = null,
    Object? moodScore = freezed,
    Object? primaryMood = freezed,
    Object? confidenceScore = freezed,
    Object? moodKeywords = freezed,
    Object? analysisTimestamp = null,
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
            moodScore: freezed == moodScore
                ? _value.moodScore
                : moodScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            primaryMood: freezed == primaryMood
                ? _value.primaryMood
                : primaryMood // ignore: cast_nullable_to_non_nullable
                      as String?,
            confidenceScore: freezed == confidenceScore
                ? _value.confidenceScore
                : confidenceScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            moodKeywords: freezed == moodKeywords
                ? _value.moodKeywords
                : moodKeywords // ignore: cast_nullable_to_non_nullable
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
abstract class _$$MoodAnalysisImplCopyWith<$Res>
    implements $MoodAnalysisCopyWith<$Res> {
  factory _$$MoodAnalysisImplCopyWith(
    _$MoodAnalysisImpl value,
    $Res Function(_$MoodAnalysisImpl) then,
  ) = __$$MoodAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    int momentId,
    double? moodScore,
    String? primaryMood,
    double? confidenceScore,
    String? moodKeywords,
    DateTime analysisTimestamp,
  });
}

/// @nodoc
class __$$MoodAnalysisImplCopyWithImpl<$Res>
    extends _$MoodAnalysisCopyWithImpl<$Res, _$MoodAnalysisImpl>
    implements _$$MoodAnalysisImplCopyWith<$Res> {
  __$$MoodAnalysisImplCopyWithImpl(
    _$MoodAnalysisImpl _value,
    $Res Function(_$MoodAnalysisImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MoodAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? momentId = null,
    Object? moodScore = freezed,
    Object? primaryMood = freezed,
    Object? confidenceScore = freezed,
    Object? moodKeywords = freezed,
    Object? analysisTimestamp = null,
  }) {
    return _then(
      _$MoodAnalysisImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        momentId: null == momentId
            ? _value.momentId
            : momentId // ignore: cast_nullable_to_non_nullable
                  as int,
        moodScore: freezed == moodScore
            ? _value.moodScore
            : moodScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        primaryMood: freezed == primaryMood
            ? _value.primaryMood
            : primaryMood // ignore: cast_nullable_to_non_nullable
                  as String?,
        confidenceScore: freezed == confidenceScore
            ? _value.confidenceScore
            : confidenceScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        moodKeywords: freezed == moodKeywords
            ? _value.moodKeywords
            : moodKeywords // ignore: cast_nullable_to_non_nullable
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
class _$MoodAnalysisImpl implements _MoodAnalysis {
  const _$MoodAnalysisImpl({
    this.id,
    required this.momentId,
    this.moodScore,
    this.primaryMood,
    this.confidenceScore,
    this.moodKeywords,
    required this.analysisTimestamp,
  });

  factory _$MoodAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoodAnalysisImplFromJson(json);

  @override
  final int? id;
  @override
  final int momentId;
  @override
  final double? moodScore;
  // -1.0 to 1.0 (negative to positive)
  @override
  final String? primaryMood;
  @override
  final double? confidenceScore;
  // 0.0 to 1.0
  @override
  final String? moodKeywords;
  // JSON array of mood-related keywords
  @override
  final DateTime analysisTimestamp;

  @override
  String toString() {
    return 'MoodAnalysis(id: $id, momentId: $momentId, moodScore: $moodScore, primaryMood: $primaryMood, confidenceScore: $confidenceScore, moodKeywords: $moodKeywords, analysisTimestamp: $analysisTimestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoodAnalysisImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.momentId, momentId) ||
                other.momentId == momentId) &&
            (identical(other.moodScore, moodScore) ||
                other.moodScore == moodScore) &&
            (identical(other.primaryMood, primaryMood) ||
                other.primaryMood == primaryMood) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            (identical(other.moodKeywords, moodKeywords) ||
                other.moodKeywords == moodKeywords) &&
            (identical(other.analysisTimestamp, analysisTimestamp) ||
                other.analysisTimestamp == analysisTimestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    momentId,
    moodScore,
    primaryMood,
    confidenceScore,
    moodKeywords,
    analysisTimestamp,
  );

  /// Create a copy of MoodAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoodAnalysisImplCopyWith<_$MoodAnalysisImpl> get copyWith =>
      __$$MoodAnalysisImplCopyWithImpl<_$MoodAnalysisImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MoodAnalysisImplToJson(this);
  }
}

abstract class _MoodAnalysis implements MoodAnalysis {
  const factory _MoodAnalysis({
    final int? id,
    required final int momentId,
    final double? moodScore,
    final String? primaryMood,
    final double? confidenceScore,
    final String? moodKeywords,
    required final DateTime analysisTimestamp,
  }) = _$MoodAnalysisImpl;

  factory _MoodAnalysis.fromJson(Map<String, dynamic> json) =
      _$MoodAnalysisImpl.fromJson;

  @override
  int? get id;
  @override
  int get momentId;
  @override
  double? get moodScore; // -1.0 to 1.0 (negative to positive)
  @override
  String? get primaryMood;
  @override
  double? get confidenceScore; // 0.0 to 1.0
  @override
  String? get moodKeywords; // JSON array of mood-related keywords
  @override
  DateTime get analysisTimestamp;

  /// Create a copy of MoodAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoodAnalysisImplCopyWith<_$MoodAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
