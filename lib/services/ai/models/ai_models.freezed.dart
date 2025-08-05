// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) {
  return _SearchResult.fromJson(json);
}

/// @nodoc
mixin _$SearchResult {
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  double get relevanceScore => throw _privateConstructorUsedError;

  /// Serializes this SearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchResultCopyWith<SearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResultCopyWith<$Res> {
  factory $SearchResultCopyWith(
    SearchResult value,
    $Res Function(SearchResult) then,
  ) = _$SearchResultCopyWithImpl<$Res, SearchResult>;
  @useResult
  $Res call({
    String id,
    String content,
    String title,
    DateTime timestamp,
    List<String> tags,
    double relevanceScore,
  });
}

/// @nodoc
class _$SearchResultCopyWithImpl<$Res, $Val extends SearchResult>
    implements $SearchResultCopyWith<$Res> {
  _$SearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? title = null,
    Object? timestamp = null,
    Object? tags = null,
    Object? relevanceScore = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            relevanceScore: null == relevanceScore
                ? _value.relevanceScore
                : relevanceScore // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchResultImplCopyWith<$Res>
    implements $SearchResultCopyWith<$Res> {
  factory _$$SearchResultImplCopyWith(
    _$SearchResultImpl value,
    $Res Function(_$SearchResultImpl) then,
  ) = __$$SearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String content,
    String title,
    DateTime timestamp,
    List<String> tags,
    double relevanceScore,
  });
}

/// @nodoc
class __$$SearchResultImplCopyWithImpl<$Res>
    extends _$SearchResultCopyWithImpl<$Res, _$SearchResultImpl>
    implements _$$SearchResultImplCopyWith<$Res> {
  __$$SearchResultImplCopyWithImpl(
    _$SearchResultImpl _value,
    $Res Function(_$SearchResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? title = null,
    Object? timestamp = null,
    Object? tags = null,
    Object? relevanceScore = null,
  }) {
    return _then(
      _$SearchResultImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        relevanceScore: null == relevanceScore
            ? _value.relevanceScore
            : relevanceScore // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchResultImpl implements _SearchResult {
  const _$SearchResultImpl({
    required this.id,
    required this.content,
    required this.title,
    required this.timestamp,
    required final List<String> tags,
    required this.relevanceScore,
  }) : _tags = tags;

  factory _$SearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchResultImplFromJson(json);

  @override
  final String id;
  @override
  final String content;
  @override
  final String title;
  @override
  final DateTime timestamp;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final double relevanceScore;

  @override
  String toString() {
    return 'SearchResult(id: $id, content: $content, title: $title, timestamp: $timestamp, tags: $tags, relevanceScore: $relevanceScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.relevanceScore, relevanceScore) ||
                other.relevanceScore == relevanceScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    content,
    title,
    timestamp,
    const DeepCollectionEquality().hash(_tags),
    relevanceScore,
  );

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResultImplCopyWith<_$SearchResultImpl> get copyWith =>
      __$$SearchResultImplCopyWithImpl<_$SearchResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchResultImplToJson(this);
  }
}

abstract class _SearchResult implements SearchResult {
  const factory _SearchResult({
    required final String id,
    required final String content,
    required final String title,
    required final DateTime timestamp,
    required final List<String> tags,
    required final double relevanceScore,
  }) = _$SearchResultImpl;

  factory _SearchResult.fromJson(Map<String, dynamic> json) =
      _$SearchResultImpl.fromJson;

  @override
  String get id;
  @override
  String get content;
  @override
  String get title;
  @override
  DateTime get timestamp;
  @override
  List<String> get tags;
  @override
  double get relevanceScore;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchResultImplCopyWith<_$SearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalysisResult _$AnalysisResultFromJson(Map<String, dynamic> json) {
  return _AnalysisResult.fromJson(json);
}

/// @nodoc
mixin _$AnalysisResult {
  String get analysis => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this AnalysisResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalysisResultCopyWith<AnalysisResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalysisResultCopyWith<$Res> {
  factory $AnalysisResultCopyWith(
    AnalysisResult value,
    $Res Function(AnalysisResult) then,
  ) = _$AnalysisResultCopyWithImpl<$Res, AnalysisResult>;
  @useResult
  $Res call({
    String analysis,
    double confidence,
    List<String> tags,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class _$AnalysisResultCopyWithImpl<$Res, $Val extends AnalysisResult>
    implements $AnalysisResultCopyWith<$Res> {
  _$AnalysisResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? analysis = null,
    Object? confidence = null,
    Object? tags = null,
    Object? metadata = null,
  }) {
    return _then(
      _value.copyWith(
            analysis: null == analysis
                ? _value.analysis
                : analysis // ignore: cast_nullable_to_non_nullable
                      as String,
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as double,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnalysisResultImplCopyWith<$Res>
    implements $AnalysisResultCopyWith<$Res> {
  factory _$$AnalysisResultImplCopyWith(
    _$AnalysisResultImpl value,
    $Res Function(_$AnalysisResultImpl) then,
  ) = __$$AnalysisResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String analysis,
    double confidence,
    List<String> tags,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class __$$AnalysisResultImplCopyWithImpl<$Res>
    extends _$AnalysisResultCopyWithImpl<$Res, _$AnalysisResultImpl>
    implements _$$AnalysisResultImplCopyWith<$Res> {
  __$$AnalysisResultImplCopyWithImpl(
    _$AnalysisResultImpl _value,
    $Res Function(_$AnalysisResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? analysis = null,
    Object? confidence = null,
    Object? tags = null,
    Object? metadata = null,
  }) {
    return _then(
      _$AnalysisResultImpl(
        analysis: null == analysis
            ? _value.analysis
            : analysis // ignore: cast_nullable_to_non_nullable
                  as String,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as double,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        metadata: null == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalysisResultImpl implements _AnalysisResult {
  const _$AnalysisResultImpl({
    required this.analysis,
    required this.confidence,
    required final List<String> tags,
    required final Map<String, dynamic> metadata,
  }) : _tags = tags,
       _metadata = metadata;

  factory _$AnalysisResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalysisResultImplFromJson(json);

  @override
  final String analysis;
  @override
  final double confidence;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final Map<String, dynamic> _metadata;
  @override
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'AnalysisResult(analysis: $analysis, confidence: $confidence, tags: $tags, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisResultImpl &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    analysis,
    confidence,
    const DeepCollectionEquality().hash(_tags),
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisResultImplCopyWith<_$AnalysisResultImpl> get copyWith =>
      __$$AnalysisResultImplCopyWithImpl<_$AnalysisResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalysisResultImplToJson(this);
  }
}

abstract class _AnalysisResult implements AnalysisResult {
  const factory _AnalysisResult({
    required final String analysis,
    required final double confidence,
    required final List<String> tags,
    required final Map<String, dynamic> metadata,
  }) = _$AnalysisResultImpl;

  factory _AnalysisResult.fromJson(Map<String, dynamic> json) =
      _$AnalysisResultImpl.fromJson;

  @override
  String get analysis;
  @override
  double get confidence;
  @override
  List<String> get tags;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of AnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalysisResultImplCopyWith<_$AnalysisResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MoodAnalysis _$MoodAnalysisFromJson(Map<String, dynamic> json) {
  return _MoodAnalysis.fromJson(json);
}

/// @nodoc
mixin _$MoodAnalysis {
  String get primaryMood => throw _privateConstructorUsedError;
  double get moodScore => throw _privateConstructorUsedError;
  double get confidenceScore => throw _privateConstructorUsedError;
  List<String> get moodKeywords => throw _privateConstructorUsedError;
  List<String> get secondaryMoods => throw _privateConstructorUsedError;
  String? get emotionalContext => throw _privateConstructorUsedError;
  Map<String, double>? get moodDistribution =>
      throw _privateConstructorUsedError;
  DateTime? get analysisTimestamp => throw _privateConstructorUsedError;

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
    String primaryMood,
    double moodScore,
    double confidenceScore,
    List<String> moodKeywords,
    List<String> secondaryMoods,
    String? emotionalContext,
    Map<String, double>? moodDistribution,
    DateTime? analysisTimestamp,
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
    Object? primaryMood = null,
    Object? moodScore = null,
    Object? confidenceScore = null,
    Object? moodKeywords = null,
    Object? secondaryMoods = null,
    Object? emotionalContext = freezed,
    Object? moodDistribution = freezed,
    Object? analysisTimestamp = freezed,
  }) {
    return _then(
      _value.copyWith(
            primaryMood: null == primaryMood
                ? _value.primaryMood
                : primaryMood // ignore: cast_nullable_to_non_nullable
                      as String,
            moodScore: null == moodScore
                ? _value.moodScore
                : moodScore // ignore: cast_nullable_to_non_nullable
                      as double,
            confidenceScore: null == confidenceScore
                ? _value.confidenceScore
                : confidenceScore // ignore: cast_nullable_to_non_nullable
                      as double,
            moodKeywords: null == moodKeywords
                ? _value.moodKeywords
                : moodKeywords // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            secondaryMoods: null == secondaryMoods
                ? _value.secondaryMoods
                : secondaryMoods // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            emotionalContext: freezed == emotionalContext
                ? _value.emotionalContext
                : emotionalContext // ignore: cast_nullable_to_non_nullable
                      as String?,
            moodDistribution: freezed == moodDistribution
                ? _value.moodDistribution
                : moodDistribution // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>?,
            analysisTimestamp: freezed == analysisTimestamp
                ? _value.analysisTimestamp
                : analysisTimestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
    String primaryMood,
    double moodScore,
    double confidenceScore,
    List<String> moodKeywords,
    List<String> secondaryMoods,
    String? emotionalContext,
    Map<String, double>? moodDistribution,
    DateTime? analysisTimestamp,
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
    Object? primaryMood = null,
    Object? moodScore = null,
    Object? confidenceScore = null,
    Object? moodKeywords = null,
    Object? secondaryMoods = null,
    Object? emotionalContext = freezed,
    Object? moodDistribution = freezed,
    Object? analysisTimestamp = freezed,
  }) {
    return _then(
      _$MoodAnalysisImpl(
        primaryMood: null == primaryMood
            ? _value.primaryMood
            : primaryMood // ignore: cast_nullable_to_non_nullable
                  as String,
        moodScore: null == moodScore
            ? _value.moodScore
            : moodScore // ignore: cast_nullable_to_non_nullable
                  as double,
        confidenceScore: null == confidenceScore
            ? _value.confidenceScore
            : confidenceScore // ignore: cast_nullable_to_non_nullable
                  as double,
        moodKeywords: null == moodKeywords
            ? _value._moodKeywords
            : moodKeywords // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        secondaryMoods: null == secondaryMoods
            ? _value._secondaryMoods
            : secondaryMoods // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        emotionalContext: freezed == emotionalContext
            ? _value.emotionalContext
            : emotionalContext // ignore: cast_nullable_to_non_nullable
                  as String?,
        moodDistribution: freezed == moodDistribution
            ? _value._moodDistribution
            : moodDistribution // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>?,
        analysisTimestamp: freezed == analysisTimestamp
            ? _value.analysisTimestamp
            : analysisTimestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MoodAnalysisImpl implements _MoodAnalysis {
  const _$MoodAnalysisImpl({
    required this.primaryMood,
    required this.moodScore,
    required this.confidenceScore,
    required final List<String> moodKeywords,
    final List<String> secondaryMoods = const [],
    this.emotionalContext,
    final Map<String, double>? moodDistribution,
    this.analysisTimestamp,
  }) : _moodKeywords = moodKeywords,
       _secondaryMoods = secondaryMoods,
       _moodDistribution = moodDistribution;

  factory _$MoodAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoodAnalysisImplFromJson(json);

  @override
  final String primaryMood;
  @override
  final double moodScore;
  @override
  final double confidenceScore;
  final List<String> _moodKeywords;
  @override
  List<String> get moodKeywords {
    if (_moodKeywords is EqualUnmodifiableListView) return _moodKeywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moodKeywords);
  }

  final List<String> _secondaryMoods;
  @override
  @JsonKey()
  List<String> get secondaryMoods {
    if (_secondaryMoods is EqualUnmodifiableListView) return _secondaryMoods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_secondaryMoods);
  }

  @override
  final String? emotionalContext;
  final Map<String, double>? _moodDistribution;
  @override
  Map<String, double>? get moodDistribution {
    final value = _moodDistribution;
    if (value == null) return null;
    if (_moodDistribution is EqualUnmodifiableMapView) return _moodDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? analysisTimestamp;

  @override
  String toString() {
    return 'MoodAnalysis(primaryMood: $primaryMood, moodScore: $moodScore, confidenceScore: $confidenceScore, moodKeywords: $moodKeywords, secondaryMoods: $secondaryMoods, emotionalContext: $emotionalContext, moodDistribution: $moodDistribution, analysisTimestamp: $analysisTimestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoodAnalysisImpl &&
            (identical(other.primaryMood, primaryMood) ||
                other.primaryMood == primaryMood) &&
            (identical(other.moodScore, moodScore) ||
                other.moodScore == moodScore) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            const DeepCollectionEquality().equals(
              other._moodKeywords,
              _moodKeywords,
            ) &&
            const DeepCollectionEquality().equals(
              other._secondaryMoods,
              _secondaryMoods,
            ) &&
            (identical(other.emotionalContext, emotionalContext) ||
                other.emotionalContext == emotionalContext) &&
            const DeepCollectionEquality().equals(
              other._moodDistribution,
              _moodDistribution,
            ) &&
            (identical(other.analysisTimestamp, analysisTimestamp) ||
                other.analysisTimestamp == analysisTimestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    primaryMood,
    moodScore,
    confidenceScore,
    const DeepCollectionEquality().hash(_moodKeywords),
    const DeepCollectionEquality().hash(_secondaryMoods),
    emotionalContext,
    const DeepCollectionEquality().hash(_moodDistribution),
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
    required final String primaryMood,
    required final double moodScore,
    required final double confidenceScore,
    required final List<String> moodKeywords,
    final List<String> secondaryMoods,
    final String? emotionalContext,
    final Map<String, double>? moodDistribution,
    final DateTime? analysisTimestamp,
  }) = _$MoodAnalysisImpl;

  factory _MoodAnalysis.fromJson(Map<String, dynamic> json) =
      _$MoodAnalysisImpl.fromJson;

  @override
  String get primaryMood;
  @override
  double get moodScore;
  @override
  double get confidenceScore;
  @override
  List<String> get moodKeywords;
  @override
  List<String> get secondaryMoods;
  @override
  String? get emotionalContext;
  @override
  Map<String, double>? get moodDistribution;
  @override
  DateTime? get analysisTimestamp;

  /// Create a copy of MoodAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoodAnalysisImplCopyWith<_$MoodAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AIEngineConfig _$AIEngineConfigFromJson(Map<String, dynamic> json) {
  return _AIEngineConfig.fromJson(json);
}

/// @nodoc
mixin _$AIEngineConfig {
  String get serviceName => throw _privateConstructorUsedError;
  String get serviceType => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  Map<String, dynamic> get settings => throw _privateConstructorUsedError;
  List<String> get supportedFeatures => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this AIEngineConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIEngineConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIEngineConfigCopyWith<AIEngineConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIEngineConfigCopyWith<$Res> {
  factory $AIEngineConfigCopyWith(
    AIEngineConfig value,
    $Res Function(AIEngineConfig) then,
  ) = _$AIEngineConfigCopyWithImpl<$Res, AIEngineConfig>;
  @useResult
  $Res call({
    String serviceName,
    String serviceType,
    String version,
    bool isEnabled,
    Map<String, dynamic> settings,
    List<String> supportedFeatures,
    String? description,
    DateTime? lastUpdated,
  });
}

/// @nodoc
class _$AIEngineConfigCopyWithImpl<$Res, $Val extends AIEngineConfig>
    implements $AIEngineConfigCopyWith<$Res> {
  _$AIEngineConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIEngineConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceName = null,
    Object? serviceType = null,
    Object? version = null,
    Object? isEnabled = null,
    Object? settings = null,
    Object? supportedFeatures = null,
    Object? description = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _value.copyWith(
            serviceName: null == serviceName
                ? _value.serviceName
                : serviceName // ignore: cast_nullable_to_non_nullable
                      as String,
            serviceType: null == serviceType
                ? _value.serviceType
                : serviceType // ignore: cast_nullable_to_non_nullable
                      as String,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String,
            isEnabled: null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            settings: null == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            supportedFeatures: null == supportedFeatures
                ? _value.supportedFeatures
                : supportedFeatures // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastUpdated: freezed == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AIEngineConfigImplCopyWith<$Res>
    implements $AIEngineConfigCopyWith<$Res> {
  factory _$$AIEngineConfigImplCopyWith(
    _$AIEngineConfigImpl value,
    $Res Function(_$AIEngineConfigImpl) then,
  ) = __$$AIEngineConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String serviceName,
    String serviceType,
    String version,
    bool isEnabled,
    Map<String, dynamic> settings,
    List<String> supportedFeatures,
    String? description,
    DateTime? lastUpdated,
  });
}

/// @nodoc
class __$$AIEngineConfigImplCopyWithImpl<$Res>
    extends _$AIEngineConfigCopyWithImpl<$Res, _$AIEngineConfigImpl>
    implements _$$AIEngineConfigImplCopyWith<$Res> {
  __$$AIEngineConfigImplCopyWithImpl(
    _$AIEngineConfigImpl _value,
    $Res Function(_$AIEngineConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIEngineConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceName = null,
    Object? serviceType = null,
    Object? version = null,
    Object? isEnabled = null,
    Object? settings = null,
    Object? supportedFeatures = null,
    Object? description = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _$AIEngineConfigImpl(
        serviceName: null == serviceName
            ? _value.serviceName
            : serviceName // ignore: cast_nullable_to_non_nullable
                  as String,
        serviceType: null == serviceType
            ? _value.serviceType
            : serviceType // ignore: cast_nullable_to_non_nullable
                  as String,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String,
        isEnabled: null == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        settings: null == settings
            ? _value._settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        supportedFeatures: null == supportedFeatures
            ? _value._supportedFeatures
            : supportedFeatures // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastUpdated: freezed == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AIEngineConfigImpl implements _AIEngineConfig {
  const _$AIEngineConfigImpl({
    required this.serviceName,
    required this.serviceType,
    required this.version,
    required this.isEnabled,
    final Map<String, dynamic> settings = const {},
    final List<String> supportedFeatures = const [],
    this.description,
    this.lastUpdated,
  }) : _settings = settings,
       _supportedFeatures = supportedFeatures;

  factory _$AIEngineConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIEngineConfigImplFromJson(json);

  @override
  final String serviceName;
  @override
  final String serviceType;
  @override
  final String version;
  @override
  final bool isEnabled;
  final Map<String, dynamic> _settings;
  @override
  @JsonKey()
  Map<String, dynamic> get settings {
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_settings);
  }

  final List<String> _supportedFeatures;
  @override
  @JsonKey()
  List<String> get supportedFeatures {
    if (_supportedFeatures is EqualUnmodifiableListView)
      return _supportedFeatures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_supportedFeatures);
  }

  @override
  final String? description;
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'AIEngineConfig(serviceName: $serviceName, serviceType: $serviceType, version: $version, isEnabled: $isEnabled, settings: $settings, supportedFeatures: $supportedFeatures, description: $description, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIEngineConfigImpl &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            const DeepCollectionEquality().equals(
              other._supportedFeatures,
              _supportedFeatures,
            ) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    serviceName,
    serviceType,
    version,
    isEnabled,
    const DeepCollectionEquality().hash(_settings),
    const DeepCollectionEquality().hash(_supportedFeatures),
    description,
    lastUpdated,
  );

  /// Create a copy of AIEngineConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIEngineConfigImplCopyWith<_$AIEngineConfigImpl> get copyWith =>
      __$$AIEngineConfigImplCopyWithImpl<_$AIEngineConfigImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AIEngineConfigImplToJson(this);
  }
}

abstract class _AIEngineConfig implements AIEngineConfig {
  const factory _AIEngineConfig({
    required final String serviceName,
    required final String serviceType,
    required final String version,
    required final bool isEnabled,
    final Map<String, dynamic> settings,
    final List<String> supportedFeatures,
    final String? description,
    final DateTime? lastUpdated,
  }) = _$AIEngineConfigImpl;

  factory _AIEngineConfig.fromJson(Map<String, dynamic> json) =
      _$AIEngineConfigImpl.fromJson;

  @override
  String get serviceName;
  @override
  String get serviceType;
  @override
  String get version;
  @override
  bool get isEnabled;
  @override
  Map<String, dynamic> get settings;
  @override
  List<String> get supportedFeatures;
  @override
  String? get description;
  @override
  DateTime? get lastUpdated;

  /// Create a copy of AIEngineConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIEngineConfigImplCopyWith<_$AIEngineConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
