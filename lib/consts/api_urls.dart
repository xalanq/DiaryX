/// API URLs and endpoints for DiaryX
class ApiUrls {
  /// Private constructor to prevent instantiation
  ApiUrls._();

  // Base URLs
  static const String ollamaBaseUrl = 'http://localhost:11434';
  static const String ollamaApiPath = '/api';

  // Ollama endpoints
  static const String ollamaChatEndpoint = '$ollamaBaseUrl$ollamaApiPath/chat';
  static const String ollamaEmbeddingsEndpoint = '$ollamaBaseUrl$ollamaApiPath/embeddings';
  static const String ollamaModelsEndpoint = '$ollamaBaseUrl$ollamaApiPath/tags';

  // Default model configuration
  static const String defaultOllamaModel = 'gemma2:2b';
  static const String defaultEmbeddingModel = 'nomic-embed-text';

  // Request timeout
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration streamTimeout = Duration(minutes: 5);
}
