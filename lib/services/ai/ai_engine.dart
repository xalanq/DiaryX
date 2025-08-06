import 'dart:async';
import 'models/ai_models.dart';
import 'models/chat_models.dart';
import 'models/cancellation_token.dart';
import '../../models/moment.dart';

/// Enhanced AI engine interface
abstract class AIEngine {
  /// Streaming text enhancement - triggered when user clicks "Enhance" button
  /// Supports real-time output and user interruption
  Stream<String> enhanceText(
    String text, {
    CancellationToken? cancellationToken,
  });

  /// Mood analysis - triggered when user clicks "Analyze mood" button
  /// Supports user interruption and cancellation
  Future<MoodAnalysis> analyzeMood(
    String text, {
    CancellationToken? cancellationToken,
  });

  /// Tag generation - triggered when user clicks "Generate tags" button
  /// Supports user interruption and cancellation
  Future<List<String>> generateTags(
    String content, {
    CancellationToken? cancellationToken,
  });

  /// Streaming chat conversation - triggered when user asks questions in chat page
  /// Supports conversation based on moments
  Stream<String> chat(
    List<ChatMessage> messages,
    List<Moment> moments, {
    CancellationToken? cancellationToken,
  });

  /// Audio transcription - detailed transcription
  Future<String> transcribeAudio(
    String audioPath, {
    CancellationToken? cancellationToken,
  });

  /// Image analysis - detailed description
  Future<String> analyzeImage(
    String imagePath, {
    CancellationToken? cancellationToken,
  });

  /// Text summarization - content summary
  Future<String> summarizeText(
    String text, {
    CancellationToken? cancellationToken,
  });

  /// Text expansion - expand and elaborate content
  Stream<String> expandText(
    String text, {
    CancellationToken? cancellationToken,
  });

  /// Vector embedding generation - for semantic search
  Future<List<double>> generateEmbedding(
    String text, {
    CancellationToken? cancellationToken,
  });

  // ========== Service Management ==========

  /// Check if service is available
  Future<bool> isAvailable();

  /// Get engine configuration
  AIEngineConfig getConfig();

  /// Initialize the engine - called when switching to this engine
  Future<void> initialize();

  /// Dispose and cleanup resources - called when switching away from this engine
  Future<void> dispose();
}

/// AI engine exception
class AIEngineException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AIEngineException(this.message, {this.code, this.originalError});

  @override
  String toString() {
    return 'AIEngineException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}
