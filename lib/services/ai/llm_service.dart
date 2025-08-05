import 'dart:async';
import 'models/chat_models.dart';
import 'models/cancellation_token.dart';

/// Abstract LLM service interface for AI operations
abstract class LLMService {
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

  /// Get service status information
  Future<Map<String, dynamic>> getStatus();
}

/// Exception for LLM service errors
class LLMServiceException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  LLMServiceException(this.message, {this.code, this.originalError});

  @override
  String toString() {
    return 'LLMServiceException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}
