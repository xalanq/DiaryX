import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:diaryx/utils/app_logger.dart';
import '../ai_service.dart';
import '../llm_service.dart';
import '../models/cancellation_token.dart';
import '../models/ai_models.dart';
import '../models/chat_models.dart';
import '../../../models/moment.dart';

/// Concrete implementation of AIService using an LLM backend
class AIServiceImpl implements AIService {
  final LLMService _llmService;

  AIServiceImpl(this._llmService);

  // ========== Real-time Operations ==========

  @override
  Stream<String> enhanceText(
    String text, {
    CancellationToken? cancellationToken,
  }) async* {
    try {
      AppLogger.info('Enhancing text: ${text.length} chars');

      cancellationToken?.throwIfCancelled();

      if (text.trim().isEmpty) {
        yield 'Please provide some text to enhance.';
        return;
      }

      final messages = [
        ChatMessage(
          role: 'system',
          content:
              '''You are a professional writing assistant. Enhance the following text by:
1. Improving clarity and flow
2. Enhancing vocabulary where appropriate
3. Maintaining the original tone and meaning
4. Making it more engaging and readable

Provide the enhanced version directly.''',
        ),
        ChatMessage(
          role: 'user',
          content: 'Please enhance this text:\n\n$text',
        ),
      ];

      cancellationToken?.throwIfCancelled();

      await for (final chunk
          in _llmService
              .streamChatCompletion(
                messages,
                cancellationToken: cancellationToken,
              )
              .cancellable(cancellationToken ?? CancellationToken.none())) {
        cancellationToken?.throwIfCancelled();
        yield chunk;
      }
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Text enhancement was cancelled');
        rethrow;
      }
      AppLogger.error('Text enhancement failed', e);
      throw AIServiceException('Failed to enhance text: $e', originalError: e);
    }
  }

  @override
  Future<MoodAnalysis> analyzeMood(
    String text, {
    CancellationToken? cancellationToken,
  }) async {
    try {
      AppLogger.info('Analyzing mood: ${text.length} chars');

      cancellationToken?.throwIfCancelled();

      if (text.trim().isEmpty) {
        return MoodAnalysis(
          primaryMood: 'neutral',
          moodScore: 0.5,
          confidenceScore: 1.0,
          moodKeywords: ['empty'],
          analysisTimestamp: DateTime.now(),
        );
      }

      final messages = [
        ChatMessage(
          role: 'system',
          content:
              '''You are a mood analysis expert. Analyze the emotional content and return a JSON response:
{
  "primaryMood": "happy/sad/anxious/excited/peaceful/angry/frustrated/content/reflective/nostalgic",
  "moodScore": 0.8,
  "confidenceScore": 0.9,
  "moodKeywords": ["joyful", "optimistic"],
  "secondaryMoods": ["grateful", "hopeful"],
  "emotionalContext": "Brief context about the emotional state"
}

Respond only with valid JSON.''',
        ),
        ChatMessage(
          role: 'user',
          content: 'Analyze the mood of this text:\n\n$text',
        ),
      ];

      cancellationToken?.throwIfCancelled();

      final response = await _llmService
          .chatCompletion(messages, cancellationToken: cancellationToken)
          .cancellable(cancellationToken ?? CancellationToken.none());

      cancellationToken?.throwIfCancelled();

      final moodAnalysis = _parseMoodAnalysis(response);
      AppLogger.info('Mood analysis successful: ${moodAnalysis.primaryMood}');
      return moodAnalysis;
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Mood analysis was cancelled');
        rethrow;
      }
      AppLogger.error('Mood analysis failed', e);
      return MoodAnalysis(
        primaryMood: 'unknown',
        moodScore: 0.5,
        confidenceScore: 0.3,
        moodKeywords: ['error'],
        emotionalContext: 'Analysis failed: ${e.toString()}',
        analysisTimestamp: DateTime.now(),
      );
    }
  }

  @override
  Future<List<String>> generateTags(
    String content, {
    CancellationToken? cancellationToken,
  }) async {
    try {
      AppLogger.info('Generating tags: ${content.length} chars');

      cancellationToken?.throwIfCancelled();

      if (content.trim().isEmpty) {
        return ['empty'];
      }

      final messages = [
        ChatMessage(
          role: 'system',
          content:
              '''Generate 4-7 relevant tags for diary content. Return only comma-separated tags.
Example: personal, growth, reflection, gratitude, work''',
        ),
        ChatMessage(role: 'user', content: 'Generate tags for:\n\n$content'),
      ];

      cancellationToken?.throwIfCancelled();

      final response = await _llmService
          .chatCompletion(messages, cancellationToken: cancellationToken)
          .cancellable(cancellationToken ?? CancellationToken.none());

      cancellationToken?.throwIfCancelled();

      final tags = _parseTags(response);
      AppLogger.info('Tag generation successful: ${tags.length} tags');
      return tags;
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Tag generation was cancelled');
        rethrow;
      }
      AppLogger.error('Tag generation failed', e);
      throw AIServiceException('Failed to generate tags: $e', originalError: e);
    }
  }

  @override
  Stream<String> chat(
    List<ChatMessage> messages,
    List<Moment> moments, {
    CancellationToken? cancellationToken,
  }) async* {
    try {
      AppLogger.info('Starting chat with ${moments.length} moments');

      // Extract context from moments
      final momentContext = moments.take(10).map((moment) {
        String context = '${moment.createdAt.toString().substring(0, 16)}: ${moment.content}';
        if (moment.aiSummary != null) {
          context += ' (Summary: ${moment.aiSummary})';
        }
        if (moment.moods.isNotEmpty) {
          context += ' [Moods: ${moment.moods.join(', ')}]';
        }
        return context;
      }).join('\n- ');

      final contextualMessages = [
        ChatMessage(
          role: 'system',
          content:
              '''You are a personal diary assistant with access to the user's diary moments.
Use this context to provide thoughtful, personalized responses.

Context from diary entries:
$momentContext

Provide helpful, empathetic responses based on this context.''',
        ),
        ...messages,
      ];

      cancellationToken?.throwIfCancelled();

      await for (final chunk
          in _llmService
              .streamChatCompletion(
                contextualMessages,
                cancellationToken: cancellationToken,
              )
              .cancellable(cancellationToken ?? CancellationToken.none())) {
        cancellationToken?.throwIfCancelled();
        yield chunk;
      }
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Chat was cancelled');
        rethrow;
      }
      AppLogger.error('Chat failed', e);
      throw AIServiceException('Failed to chat: $e', originalError: e);
    }
  }

  @override
  Future<String> transcribeAudio(
    String audioPath, {
    CancellationToken? cancellationToken,
  }) async {
    try {
      AppLogger.info('Transcribing audio: $audioPath');

      cancellationToken?.throwIfCancelled();

      final audioData = await _loadAudioAsBase64(audioPath);

      cancellationToken?.throwIfCancelled();

      final messages = [
        ChatMessage(
          role: 'system',
          content: '''Provide detailed, accurate transcriptions that:
1. Capture every word and nuance
2. Include natural speech patterns
3. Maintain proper punctuation
4. Preserve emotional tone''',
        ),
        ChatMessage(
          role: 'user',
          content: 'Transcribe this audio:',
          audios: [MediaItem(type: 'base64', data: audioData)],
        ),
      ];

      cancellationToken?.throwIfCancelled();

      final response = await _llmService.chatCompletion(
        messages,
        cancellationToken: cancellationToken,
      );
      final transcription = _extractTranscription(response);

      AppLogger.info(
        'Audio transcription successful: ${transcription.length} chars',
      );
      return transcription;
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Audio transcription was cancelled');
        rethrow;
      }
      AppLogger.error('Audio transcription failed', e);
      throw AIServiceException(
        'Failed to transcribe audio: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<String> analyzeImage(
    String imagePath, {
    CancellationToken? cancellationToken,
  }) async {
    try {
      AppLogger.info('Analyzing image: $imagePath');

      cancellationToken?.throwIfCancelled();

      final imageData = await _loadImageAsBase64(imagePath);

      cancellationToken?.throwIfCancelled();

      final messages = [
        ChatMessage(
          role: 'system',
          content: '''Provide detailed image descriptions that:
1. Describe visual elements comprehensively
2. Note colors, lighting, composition
3. Identify objects, people, settings
4. Capture mood and atmosphere''',
        ),
        ChatMessage(
          role: 'user',
          content: 'Describe this image in detail:',
          images: [MediaItem(type: 'base64', data: imageData)],
        ),
      ];

      cancellationToken?.throwIfCancelled();

      final response = await _llmService.chatCompletion(
        messages,
        cancellationToken: cancellationToken,
      );
      AppLogger.info('Image analysis successful: ${response.length} chars');
      return response.trim();
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Image analysis was cancelled');
        rethrow;
      }
      AppLogger.error('Image analysis failed', e);
      throw AIServiceException('Failed to analyze image: $e', originalError: e);
    }
  }

  @override
  Future<String> summarizeText(
    String text, {
    CancellationToken? cancellationToken,
  }) async {
    try {
      AppLogger.info('Summarizing text: ${text.length} chars');

      cancellationToken?.throwIfCancelled();

      if (text.trim().isEmpty) {
        return 'Empty content';
      }

      final messages = [
        ChatMessage(
          role: 'system',
          content: '''Create concise summaries that:
1. Capture key events, thoughts, and emotions
2. Preserve personal voice and important details
3. Maintain emotional context
4. Keep summaries meaningful but brief''',
        ),
        ChatMessage(role: 'user', content: 'Summarize this content:\n\n$text'),
      ];

      cancellationToken?.throwIfCancelled();

      final response = await _llmService.chatCompletion(
        messages,
        cancellationToken: cancellationToken,
      );
      AppLogger.info('Text summarization successful: ${response.length} chars');
      return response.trim();
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Text summarization was cancelled');
        rethrow;
      }
      AppLogger.error('Text summarization failed', e);
      throw AIServiceException(
        'Failed to summarize text: $e',
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
      AppLogger.info('Generating embedding: ${text.length} chars');

      cancellationToken?.throwIfCancelled();

      final embedding = await _llmService.generateEmbedding(text);
      AppLogger.info(
        'Embedding generation successful: ${embedding.length} dimensions',
      );
      return embedding;
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Embedding generation was cancelled');
        rethrow;
      }
      AppLogger.error('Embedding generation failed', e);
      throw AIServiceException(
        'Failed to generate embedding: $e',
        originalError: e,
      );
    }
  }

  // ========== Service Management ==========

  @override
  Future<bool> isAvailable() async {
    try {
      return await _llmService.isAvailable();
    } catch (e) {
      AppLogger.warn('AI service availability check failed', e);
      return false;
    }
  }

  @override
  AIServiceConfig getConfig() {
    return AIServiceConfig(
      serviceName: 'AIServiceImpl',
      serviceType: 'llm_backend',
      version: '1.0.0',
      isEnabled: true,
      supportedFeatures: [
        'text_polishing_stream',
        'mood_analysis_cancellable',
        'tag_generation_cancellable',
        'chat_with_context',
        'detailed_transcription',
        'detailed_image_analysis',
        'text_summarization',
        'auto_tagging',
        'embeddings',
      ],
      settings: {
        'llm_service': _llmService.runtimeType.toString(),
        'supports_cancellation': true,
        'supports_streaming': true,
      },
      description: 'AI service implementation using LLM backend',
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<AIServiceStatus> getStatus() async {
    try {
      final llmStatus = await _llmService.getStatus();
      return AIServiceStatus(
        serviceName: 'AIServiceImpl',
        status: ServiceStatus.operational,
        capabilities: [
          'text_polishing_stream',
          'mood_analysis_cancellable',
          'tag_generation_cancellable',
          'chat_with_context',
          'detailed_transcription',
          'detailed_image_analysis',
          'text_summarization',
          'auto_tagging',
          'embeddings',
        ],
        timestamp: DateTime.now(),
        version: '1.0.0',
        llmBackend: llmStatus,
      );
    } catch (e) {
      return AIServiceStatus(
        serviceName: 'AIServiceImpl',
        status: ServiceStatus.error,
        capabilities: [],
        timestamp: DateTime.now(),
        error: e.toString(),
      );
    }
  }

  // ========== Helper Methods ==========

  Future<String> _loadAudioAsBase64(String audioPath) async {
    try {
      final file = File(audioPath);
      if (!await file.exists()) {
        throw AIServiceException('Audio file not found: $audioPath');
      }

      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      throw AIServiceException(
        'Failed to load audio file: $e',
        originalError: e,
      );
    }
  }

  Future<String> _loadImageAsBase64(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw AIServiceException('Image file not found: $imagePath');
      }

      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      throw AIServiceException(
        'Failed to load image file: $e',
        originalError: e,
      );
    }
  }

  String _extractTranscription(String response) {
    // Simple extraction - in real implementation, this might be more sophisticated
    return response.trim();
  }

  List<String> _parseTags(String response) {
    try {
      // Parse comma-separated tags
      return response
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .take(7)
          .toList();
    } catch (e) {
      AppLogger.warn('Failed to parse tags: $response');
      return ['personal', 'diary'];
    }
  }

  MoodAnalysis _parseMoodAnalysis(String response) {
    try {
      String jsonStr = response.trim();

      // Find JSON object in response
      final startIndex = jsonStr.indexOf('{');
      final endIndex = jsonStr.lastIndexOf('}') + 1;

      if (startIndex >= 0 && endIndex > startIndex) {
        jsonStr = jsonStr.substring(startIndex, endIndex);
      }

      final data = jsonDecode(jsonStr);

      return MoodAnalysis(
        primaryMood: data['primaryMood'] ?? 'neutral',
        moodScore: (data['moodScore'] ?? 0.5).toDouble(),
        confidenceScore: (data['confidenceScore'] ?? 0.8).toDouble(),
        moodKeywords: List<String>.from(data['moodKeywords'] ?? ['general']),
        secondaryMoods: List<String>.from(data['secondaryMoods'] ?? []),
        emotionalContext: data['emotionalContext'],
        analysisTimestamp: DateTime.now(),
      );
    } catch (e) {
      AppLogger.warn('Failed to parse mood analysis: $response');
      return MoodAnalysis(
        primaryMood: 'neutral',
        moodScore: 0.5,
        confidenceScore: 0.5,
        moodKeywords: ['general'],
        analysisTimestamp: DateTime.now(),
      );
    }
  }
}
