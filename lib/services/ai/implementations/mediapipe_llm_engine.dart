import 'dart:async';
import 'package:flutter/services.dart';
import 'package:diaryx/utils/app_logger.dart';
import '../llm_engine.dart';
import '../models/chat_models.dart';
import '../models/cancellation_token.dart';

/// MediaPipe LLM Engine implementation using platform channels
class MediaPipeLLMEngine implements LLMEngine {
  static const MethodChannel _channel = MethodChannel(
    'com.xalanq.diaryx/mediapipe_llm',
  );

  final String _modelPath;
  final MediaPipeLLMConfig _config;
  bool _isInitialized = false;

  MediaPipeLLMEngine({required String modelPath, MediaPipeLLMConfig? config})
    : _modelPath = modelPath,
      _config = config ?? MediaPipeLLMConfig();

  /// Initialize the MediaPipe LLM model
  Future<void> initialize() async {
    if (_isInitialized) {
      AppLogger.warn('MediaPipe LLM Engine already initialized');
      return;
    }

    try {
      AppLogger.info(
        'Initializing MediaPipe LLM Engine with model: $_modelPath',
      );

      final result = await _channel.invokeMethod('initialize', {
        'modelPath': _modelPath,
        'maxTokens': _config.maxTokens,
        'topK': _config.topK,
        'topP': _config.topP,
        'temperature': _config.temperature,
        'accelerator': _config.accelerator.name,
        'maxNumImages': _config.maxNumImages,
      });

      if (result['success'] == true) {
        _isInitialized = true;
        AppLogger.info('MediaPipe LLM Engine initialized successfully');
      } else {
        final error =
            result['error'] as String? ?? 'Unknown initialization error';
        throw LLMEngineException('Failed to initialize MediaPipe LLM: $error');
      }
    } on PlatformException catch (e) {
      AppLogger.error(
        'Platform exception during initialization: ${e.message}',
        e,
      );
      throw LLMEngineException(
        'Platform error during initialization: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      AppLogger.error('Unexpected error during initialization', e);
      throw LLMEngineException(
        'Unexpected error during initialization: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<String> chatCompletion(
    List<ChatMessage> messages, {
    CancellationToken? cancellationToken,
  }) async {
    await _ensureInitialized();
    cancellationToken?.throwIfCancelled();

    try {
      AppLogger.debug(
        'Executing chat completion with ${messages.length} messages',
      );

      final result = await _channel
          .invokeMethod('chatCompletion', {
            'messages': messages.map((msg) => _messageToMap(msg)).toList(),
          })
          .cancellable(cancellationToken ?? CancellationToken.none());

      if (result['success'] == true) {
        final response = result['response'] as String;
        AppLogger.debug(
          'Chat completion successful, response length: ${response.length}',
        );
        return response;
      } else {
        final error = result['error'] as String? ?? 'Unknown completion error';
        throw LLMEngineException('Chat completion failed: $error');
      }
    } on OperationCancelledException {
      AppLogger.info('Chat completion cancelled by user');
      rethrow;
    } on PlatformException catch (e) {
      AppLogger.error(
        'Platform exception during chat completion: ${e.message}',
        e,
      );
      throw LLMEngineException(
        'Platform error during chat completion: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      AppLogger.error('Unexpected error during chat completion', e);
      throw LLMEngineException(
        'Unexpected error during chat completion: $e',
        originalError: e,
      );
    }
  }

  @override
  Stream<String> streamChatCompletion(
    List<ChatMessage> messages, {
    CancellationToken? cancellationToken,
  }) async* {
    await _ensureInitialized();
    cancellationToken?.throwIfCancelled();

    try {
      AppLogger.debug(
        'Starting streaming chat completion with ${messages.length} messages',
      );

      // Create a stream subscription for platform events
      const eventChannel = EventChannel(
        'com.xalanq.diaryx/mediapipe_llm_stream',
      );
      StreamSubscription? subscription;

      // Start streaming inference
      await _channel.invokeMethod('startStreamingCompletion', {
        'messages': messages.map((msg) => _messageToMap(msg)).toList(),
      });

      final completer = Completer<void>();
      final streamController = StreamController<String>();

      subscription = eventChannel.receiveBroadcastStream().listen(
        (dynamic event) {
          cancellationToken?.throwIfCancelled();

          final data = event as Map<dynamic, dynamic>;
          final type = data['type'] as String;

          switch (type) {
            case 'chunk':
              final content = data['content'] as String;
              AppLogger.verbose(
                'Received stream chunk: ${content.length} chars',
              );
              streamController.add(content);
              break;
            case 'done':
              AppLogger.debug('Streaming completion finished');
              streamController.close();
              completer.complete();
              break;
            case 'error':
              final error =
                  data['error'] as String? ?? 'Unknown streaming error';
              AppLogger.error('Streaming error: $error');
              streamController.addError(
                LLMEngineException('Streaming error: $error'),
              );
              completer.completeError(
                LLMEngineException('Streaming error: $error'),
              );
              break;
          }
        },
        onError: (error) {
          AppLogger.error('Stream subscription error', error);
          streamController.addError(error);
          completer.completeError(error);
        },
        onDone: () {
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      );

      // Handle cancellation
      cancellationToken?.cancelled.then((_) async {
        AppLogger.info('Cancelling streaming completion');
        await subscription?.cancel();
        await _channel.invokeMethod('cancelStreaming');
        streamController.close();
      });

      // Yield stream data
      await for (final chunk in streamController.stream) {
        cancellationToken?.throwIfCancelled();
        yield chunk;
      }

      // Clean up
      await subscription.cancel();
      await completer.future;
    } on OperationCancelledException {
      AppLogger.info('Streaming completion cancelled by user');
      rethrow;
    } on PlatformException catch (e) {
      AppLogger.error(
        'Platform exception during streaming completion: ${e.message}',
        e,
      );
      throw LLMEngineException(
        'Platform error during streaming completion: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      AppLogger.error('Unexpected error during streaming completion', e);
      throw LLMEngineException(
        'Unexpected error during streaming completion: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<List<double>> generateEmbedding(
    String text, {
    CancellationToken? cancellationToken,
  }) async {
    throw UnimplementedError(
      'generateEmbedding is not implemented for MediaPipe LLM Engine',
    );
  }

  @override
  Future<bool> isAvailable() async {
    try {
      if (!_isInitialized) {
        return false;
      }

      final result = await _channel.invokeMethod('isAvailable');
      return result['available'] == true;
    } catch (e) {
      AppLogger.warn('Failed to check MediaPipe LLM availability: $e');
      return false;
    }
  }

  /// Clean up resources
  Future<void> dispose() async {
    if (!_isInitialized) {
      return;
    }

    try {
      AppLogger.info('Disposing MediaPipe LLM Engine');
      await _channel.invokeMethod('cleanup');
      _isInitialized = false;
      AppLogger.info('MediaPipe LLM Engine disposed successfully');
    } catch (e) {
      AppLogger.error('Error disposing MediaPipe LLM Engine', e);
    }
  }

  /// Reset the inference session (clear conversation context)
  Future<void> resetSession() async {
    await _ensureInitialized();

    try {
      AppLogger.debug('Resetting MediaPipe LLM session');
      await _channel.invokeMethod('resetSession');
      AppLogger.debug('MediaPipe LLM session reset successfully');
    } catch (e) {
      AppLogger.error('Error resetting MediaPipe LLM session', e);
      throw LLMEngineException('Failed to reset session: $e', originalError: e);
    }
  }

  /// Ensure the engine is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Convert ChatMessage to Map for platform channel
  Map<String, dynamic> _messageToMap(ChatMessage message) {
    final map = <String, dynamic>{
      'role': message.role,
      'content': message.content,
    };

    if (message.images != null && message.images!.isNotEmpty) {
      map['images'] = message.images!
          .map((item) => {'type': item.type, 'data': item.data})
          .toList();
    }

    if (message.audios != null && message.audios!.isNotEmpty) {
      map['audios'] = message.audios!
          .map((item) => {'type': item.type, 'data': item.data})
          .toList();
    }

    if (message.videos != null && message.videos!.isNotEmpty) {
      map['videos'] = message.videos!
          .map((item) => {'type': item.type, 'data': item.data})
          .toList();
    }

    return map;
  }
}

/// Configuration for MediaPipe LLM Engine
class MediaPipeLLMConfig {
  final int maxTokens;
  final int topK;
  final double topP;
  final double temperature;
  final MediaPipeAccelerator accelerator;
  final int maxNumImages;

  const MediaPipeLLMConfig({
    this.maxTokens = 512,
    this.topK = 40,
    this.topP = 0.95,
    this.temperature = 0.8,
    this.accelerator = MediaPipeAccelerator.gpu,
    this.maxNumImages = 1,
  });

  MediaPipeLLMConfig copyWith({
    int? maxTokens,
    int? topK,
    double? topP,
    double? temperature,
    MediaPipeAccelerator? accelerator,
    int? maxNumImages,
  }) {
    return MediaPipeLLMConfig(
      maxTokens: maxTokens ?? this.maxTokens,
      topK: topK ?? this.topK,
      topP: topP ?? this.topP,
      temperature: temperature ?? this.temperature,
      accelerator: accelerator ?? this.accelerator,
      maxNumImages: maxNumImages ?? this.maxNumImages,
    );
  }
}

/// MediaPipe accelerator options
enum MediaPipeAccelerator {
  cpu('CPU'),
  gpu('GPU');

  const MediaPipeAccelerator(this.name);
  final String name;
}
