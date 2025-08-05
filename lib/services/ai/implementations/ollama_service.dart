import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:diaryx/utils/app_logger.dart';
import '../llm_service.dart';
import '../models/chat_models.dart';
import '../models/cancellation_token.dart';

/// Ollama service implementation for LLM operations
class OllamaService implements LLMService {
  final String _baseUrl;
  final String _modelName;
  final Dio _httpClient;
  final Duration? _timeout;

  OllamaService({
    required String baseUrl,
    required String modelName,
    Duration? timeout,
  }) : _baseUrl = baseUrl.endsWith('/')
           ? baseUrl.substring(0, baseUrl.length - 1)
           : baseUrl,
       _modelName = modelName,
       _timeout = timeout,
       _httpClient = Dio() {
    // Configure Dio with timeout and interceptors
    _httpClient.options.connectTimeout = _timeout;
    _httpClient.options.receiveTimeout = _timeout;
    _httpClient.options.sendTimeout = _timeout;

    // Add logging interceptor for debugging
    _httpClient.interceptors.add(
      LogInterceptor(
        requestBody: false, // Don't log request body to avoid large content
        responseBody: false, // Don't log response body to avoid large content
        logPrint: (obj) => AppLogger.debug('Ollama HTTP: $obj'),
      ),
    );
  }

  @override
  Future<String> chatCompletion(
    List<ChatMessage> messages, {
    CancellationToken? cancellationToken,
  }) async {
    try {
      cancellationToken?.throwIfCancelled();

      AppLogger.info(
        'Ollama chat completion request with ${messages.length} messages',
      );

      final response = await _httpClient
          .post(
            '$_baseUrl/api/chat',
            data: {
              'model': _modelName,
              'messages': messages.map((msg) => _formatMessage(msg)).toList(),
              'stream': false,
            },
          )
          .cancellable(cancellationToken ?? CancellationToken.none());

      if (response.statusCode == 200) {
        final responseData = response.data;
        final content = responseData['message']?['content'] ?? '';
        AppLogger.info(
          'Ollama chat completion successful: ${content.length} chars',
        );
        return content;
      } else {
        throw LLMServiceException(
          'Ollama API returned status ${response.statusCode}',
          code: 'HTTP_ERROR',
        );
      }
    } on DioException catch (e) {
      AppLogger.error('Ollama chat completion failed', e);
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('Unexpected error in Ollama chat completion', e);
      throw LLMServiceException('Unexpected error: $e', originalError: e);
    }
  }

  @override
  Stream<String> streamChatCompletion(
    List<ChatMessage> messages, {
    CancellationToken? cancellationToken,
  }) async* {
    try {
      cancellationToken?.throwIfCancelled();

      AppLogger.info('Ollama streaming chat completion request');

      final response = await _httpClient
          .post(
            '$_baseUrl/api/chat',
            data: {
              'model': _modelName,
              'messages': messages.map((msg) => _formatMessage(msg)).toList(),
              'stream': true,
            },
            options: Options(
              responseType: ResponseType.stream,
              headers: {'Accept': 'application/x-ndjson'},
            ),
          )
          .cancellable(cancellationToken ?? CancellationToken.none());

      if (response.statusCode == 200) {
        final stream = response.data.stream as Stream<Uint8List>;
        String buffer = '';

        // Apply cancellation to the stream
        final cancellableStream = cancellationToken != null
            ? stream.cancellable(cancellationToken)
            : stream;

        await for (final chunk in cancellableStream) {
          buffer += utf8.decode(chunk);

          // Process complete lines
          final lines = buffer.split('\n');
          buffer = lines.removeLast(); // Keep incomplete line in buffer

          for (final line in lines) {
            if (line.trim().isNotEmpty) {
              try {
                final data = jsonDecode(line);
                final content = data['message']?['content'];
                if (content != null && content.isNotEmpty) {
                  yield content;
                }

                // Check if done
                if (data['done'] == true) {
                  return;
                }
              } catch (e) {
                AppLogger.warn(
                  'Failed to parse streaming response line: $line',
                );
              }
            }
          }
        }
      } else {
        throw LLMServiceException(
          'Ollama streaming API returned status ${response.statusCode}',
          code: 'HTTP_ERROR',
        );
      }
    } on DioException catch (e) {
      AppLogger.error('Ollama streaming chat completion failed', e);
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error(
        'Unexpected error in Ollama streaming chat completion',
        e,
      );
      throw LLMServiceException(
        'Unexpected streaming error: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<List<double>> generateEmbedding(
    String text, {
    CancellationToken? cancellationToken,
  }) async {
    try {
      cancellationToken?.throwIfCancelled();

      AppLogger.info(
        'Ollama embedding generation request: ${text.length} chars',
      );

      final response = await _httpClient
          .post(
            '$_baseUrl/api/embeddings',
            data: {'model': _modelName, 'prompt': text},
          )
          .cancellable(cancellationToken ?? CancellationToken.none());

      if (response.statusCode == 200) {
        final responseData = response.data;
        final embedding = responseData['embedding'];
        if (embedding is List) {
          final result = embedding.map((e) => (e as num).toDouble()).toList();
          AppLogger.info(
            'Ollama embedding generation successful: ${result.length} dimensions',
          );
          return result;
        } else {
          throw LLMServiceException(
            'Invalid embedding format in response',
            code: 'INVALID_RESPONSE',
          );
        }
      } else {
        throw LLMServiceException(
          'Ollama embeddings API returned status ${response.statusCode}',
          code: 'HTTP_ERROR',
        );
      }
    } on DioException catch (e) {
      AppLogger.error('Ollama embedding generation failed', e);
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('Unexpected error in Ollama embedding generation', e);
      throw LLMServiceException(
        'Unexpected embedding error: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> isAvailable() async {
    try {
      AppLogger.info('Checking Ollama service availability');

      final response = await _httpClient.get(
        '$_baseUrl/api/tags',
        options: Options(receiveTimeout: const Duration(seconds: 5)),
      );

      final isAvailable = response.statusCode == 200;
      AppLogger.info('Ollama service availability: $isAvailable');
      return isAvailable;
    } catch (e) {
      AppLogger.warn('Ollama service not available: $e');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getStatus() async {
    try {
      final response = await _httpClient.get('$_baseUrl/api/tags');

      if (response.statusCode == 200) {
        final data = response.data;
        final models = data['models'] as List?;
        final hasModel =
            models?.any((model) => model['name'] == _modelName) ?? false;

        return {
          'available': true,
          'baseUrl': _baseUrl,
          'modelName': _modelName,
          'modelExists': hasModel,
          'totalModels': models?.length ?? 0,
          'timestamp': DateTime.now().toIso8601String(),
        };
      } else {
        return {
          'available': false,
          'error': 'HTTP ${response.statusCode}',
          'timestamp': DateTime.now().toIso8601String(),
        };
      }
    } catch (e) {
      return {
        'available': false,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Format a ChatMessage for Ollama API
  Map<String, dynamic> _formatMessage(ChatMessage message) {
    final result = <String, dynamic>{
      'role': message.role,
      'content': message.content,
    };

    // Add images if present
    if (message.images != null && message.images!.isNotEmpty) {
      result['images'] = message.images!.map((img) => img.data).toList();
    }

    return result;
  }

  /// Handle Dio exceptions and convert to LLMServiceException
  LLMServiceException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return LLMServiceException(
          'Request timeout: ${e.message}',
          code: 'TIMEOUT',
          originalError: e,
        );
      case DioExceptionType.connectionError:
        return LLMServiceException(
          'Connection error: ${e.message}',
          code: 'CONNECTION_ERROR',
          originalError: e,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;
        return LLMServiceException(
          'HTTP $statusCode: ${responseData ?? e.message}',
          code: 'HTTP_ERROR',
          originalError: e,
        );
      case DioExceptionType.cancel:
        return LLMServiceException(
          'Request cancelled',
          code: 'CANCELLED',
          originalError: e,
        );
      default:
        return LLMServiceException(
          'Network error: ${e.message}',
          code: 'NETWORK_ERROR',
          originalError: e,
        );
    }
  }

  /// Dispose resources
  void dispose() {
    _httpClient.close();
  }
}
