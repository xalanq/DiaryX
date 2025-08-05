import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_models.freezed.dart';
part 'ai_models.g.dart';

/// Search result model for AI processing
@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    required String id,
    required String content,
    required String title,
    required DateTime timestamp,
    required List<String> tags,
    required double relevanceScore,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  /// Create a summary search result
  factory SearchResult.summary(String summaryContent) {
    return SearchResult(
      id: 'summary',
      content: summaryContent,
      title: 'Search Summary',
      timestamp: DateTime.now(),
      tags: const ['summary'],
      relevanceScore: 1.0,
    );
  }
}

/// Analysis result model
@freezed
class AnalysisResult with _$AnalysisResult {
  const factory AnalysisResult({
    required String analysis,
    required double confidence,
    required List<String> tags,
    required Map<String, dynamic> metadata,
  }) = _AnalysisResult;

  factory AnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$AnalysisResultFromJson(json);
}

/// Mood analysis result from AI processing
@freezed
class MoodAnalysis with _$MoodAnalysis {
  const factory MoodAnalysis({
    required String primaryMood,
    required double moodScore,
    required double confidenceScore,
    required List<String> moodKeywords,
    @Default([]) List<String> secondaryMoods,
    String? emotionalContext,
    Map<String, double>? moodDistribution,
    DateTime? analysisTimestamp,
  }) = _MoodAnalysis;

  factory MoodAnalysis.fromJson(Map<String, dynamic> json) =>
      _$MoodAnalysisFromJson(json);
}

/// AI service configuration
@freezed
class AIServiceConfig with _$AIServiceConfig {
  const factory AIServiceConfig({
    required String serviceName,
    required String serviceType,
    required String version,
    required bool isEnabled,
    @Default({}) Map<String, dynamic> settings,
    @Default([]) List<String> supportedFeatures,
    String? description,
    DateTime? lastUpdated,
  }) = _AIServiceConfig;

  factory AIServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$AIServiceConfigFromJson(json);
}
