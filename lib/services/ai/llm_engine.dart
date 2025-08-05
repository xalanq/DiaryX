import 'dart:async';
import 'models/chat_models.dart';
import 'models/cancellation_token.dart';

/// Abstract LLM engine interface for AI operations
abstract class LLMEngine {
  /// Non-streaming chat completion
  Future<String> chatCompletion(
    List<ChatMessage> messages, {
    CancellationToken? cancellationToken,
  });

  /// Streaming chat completion
  Stream<String> streamChatCompletion(
    List<ChatMessage> messages, {
    CancellationToken? cancellationToken,
  });

  /// Generate vector embeddings for semantic search
  Future<List<double>> generateEmbedding(
    String text, {
    CancellationToken? cancellationToken,
  });

  /// Test if the service is available
  Future<bool> isAvailable();
}

/// Exception for LLM engine errors
class LLMEngineException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  LLMEngineException(this.message, {this.code, this.originalError});

  @override
  String toString() {
    return 'LLMEngineException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}
