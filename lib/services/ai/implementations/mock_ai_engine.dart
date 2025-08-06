import 'dart:async';
import 'dart:math';
import 'package:diaryx/utils/app_logger.dart';
import '../ai_engine.dart';
import '../models/cancellation_token.dart';
import '../models/ai_models.dart';
import '../models/chat_models.dart';
import '../../../models/moment.dart';

/// Mock implementation of AIEngine for testing and development
class MockAIEngine implements AIEngine {
  final Duration _responseDelay;
  final Random _random = Random();
  bool _isAvailable = true;

  MockAIEngine({Duration responseDelay = const Duration(milliseconds: 500)})
    : _responseDelay = responseDelay;

  @override
  Stream<String> enhanceText(
    String text, {
    CancellationToken? cancellationToken,
  }) async* {
    AppLogger.info('Mock: Enhancing text: ${text.length} chars');

    try {
      cancellationToken?.throwIfCancelled();

      if (text.isEmpty) {
        yield 'This appears to be an empty moment. ';
        await Future.delayed(
          Duration(milliseconds: 100),
        ).cancellable(cancellationToken ?? CancellationToken.none());
        yield 'Perhaps you\'d like to add some thoughts about your day?';
        return;
      }

      final enhanceParts = [
        'Your thoughts reveal ',
        'a thoughtful perspective on ',
        'life experiences. ',
        'The emotions you\'ve described ',
        'reflect personal growth and ',
        'the unique perspective you bring ',
        'to each day. Consider how this ',
        'moment connects to your broader ',
        'life themes and aspirations.',
      ];

      for (final part in enhanceParts) {
        cancellationToken?.throwIfCancelled();
        yield part;
        await Future.delayed(
          Duration(milliseconds: 150 + _random.nextInt(100)),
        ).cancellable(cancellationToken ?? CancellationToken.none());
      }
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Mock: Text enhancement was cancelled');
        rethrow;
      }
      AppLogger.error('Mock: Text enhancement failed', e);
      yield 'Error occurred while enhancing text.';
    }
  }

  @override
  Stream<String> expandText(
    String text, {
    CancellationToken? cancellationToken,
  }) async* {
    AppLogger.info('Mock: Expanding text: ${text.length} chars');

    try {
      cancellationToken?.throwIfCancelled();

      if (text.isEmpty) {
        yield 'This appears to be an empty moment. ';
        await Future.delayed(
          Duration(milliseconds: 100),
        ).cancellable(cancellationToken ?? CancellationToken.none());
        yield 'Perhaps you\'d like to elaborate on what you were thinking about?';
        return;
      }

      final expandParts = [
        'Building upon your original thoughts, ',
        'there are several additional layers to consider. ',
        'The experience you\'ve described ',
        'connects to broader themes in your life journey. ',
        'For instance, the emotions and reactions you mentioned ',
        'reflect patterns that many people experience ',
        'during similar circumstances. ',
        'This moment represents not just an isolated event, ',
        'but part of your ongoing personal growth and ',
        'self-discovery process. ',
        'Consider how this experience might influence ',
        'your future decisions and perspectives.',
      ];

      for (final part in expandParts) {
        cancellationToken?.throwIfCancelled();
        yield part;
        await Future.delayed(
          Duration(milliseconds: 200 + _random.nextInt(150)),
        ).cancellable(cancellationToken ?? CancellationToken.none());
      }
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Mock: Text expansion was cancelled');
        rethrow;
      }
      AppLogger.error('Mock: Text expansion failed', e);
      yield 'Error occurred while expanding text.';
    }
  }

  @override
  Future<MoodAnalysis> analyzeMood(
    String text, {
    CancellationToken? cancellationToken,
  }) async {
    AppLogger.info('Mock: Analyzing mood: ${text.length} chars');

    try {
      cancellationToken?.throwIfCancelled();

      await Future.delayed(
        _responseDelay,
      ).cancellable(cancellationToken ?? CancellationToken.none());

      cancellationToken?.throwIfCancelled();

      final moods = ['happy', 'reflective', 'peaceful', 'excited', 'grateful'];
      final primaryMood = moods[_random.nextInt(moods.length)];
      final moodScore = 0.6 + (_random.nextDouble() * 0.4);
      final confidence = 0.7 + (_random.nextDouble() * 0.3);

      return MoodAnalysis(
        primaryMood: primaryMood,
        moodScore: moodScore,
        confidenceScore: confidence,
        moodKeywords: _generateMoodKeywords(primaryMood),
        secondaryMoods: _generateSecondaryMoods(primaryMood),
        emotionalContext:
            'This content reflects $primaryMood emotions with positive undertones.',
        analysisTimestamp: DateTime.now(),
      );
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Mock: Mood analysis was cancelled');
        rethrow;
      }
      AppLogger.error('Mock: Mood analysis failed', e);
      return MoodAnalysis(
        primaryMood: 'error',
        moodScore: 0.5,
        confidenceScore: 0.3,
        moodKeywords: ['error'],
        analysisTimestamp: DateTime.now(),
      );
    }
  }

  @override
  Future<List<String>> generateTags(
    String content, {
    CancellationToken? cancellationToken,
  }) async {
    AppLogger.info('Mock: Generating tags: ${content.length} chars');

    try {
      cancellationToken?.throwIfCancelled();

      await Future.delayed(
        _responseDelay,
      ).cancellable(cancellationToken ?? CancellationToken.none());

      cancellationToken?.throwIfCancelled();

      if (content.isEmpty) {
        return ['empty', 'brief'];
      }

      final allTags = [
        'personal',
        'reflection',
        'gratitude',
        'growth',
        'relationship',
        'work',
        'travel',
        'nature',
        'family',
        'friends',
        'achievement',
        'challenge',
        'learning',
        'creativity',
        'health',
        'mindfulness',
        'goal',
        'memory',
        'emotion',
        'insight',
        'inspiration',
      ];

      final numTags = 3 + _random.nextInt(4);
      final selectedTags = <String>[];

      while (selectedTags.length < numTags &&
          selectedTags.length < allTags.length) {
        cancellationToken?.throwIfCancelled();
        final tag = allTags[_random.nextInt(allTags.length)];
        if (!selectedTags.contains(tag)) {
          selectedTags.add(tag);
        }
      }

      AppLogger.info(
        'Mock: Tag generation successful: ${selectedTags.length} tags',
      );
      return selectedTags;
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Mock: Tag generation was cancelled');
        rethrow;
      }
      AppLogger.error('Mock: Tag generation failed', e);
      return ['error', 'fallback'];
    }
  }

  @override
  Stream<String> chat(
    List<ChatMessage> messages,
    List<Moment> moments, {
    CancellationToken? cancellationToken,
  }) async* {
    AppLogger.info('Mock: Starting chat with ${moments.length} moments');

    try {
      // Add initial "thinking" delay to simulate AI processing
      await Future.delayed(
        Duration(milliseconds: 800 + _random.nextInt(700)), // 0.8-1.5 seconds
      ).cancellable(cancellationToken ?? CancellationToken.none());

      cancellationToken?.throwIfCancelled();

      // Generate context-aware responses with moment citations
      final responses = _generateMockResponses(moments);

      for (int i = 0; i < responses.length; i++) {
        cancellationToken?.throwIfCancelled();

        // Yield the response chunk
        yield responses[i];

        // Add realistic typing delays between chunks
        if (i < responses.length - 1) {
          // Don't delay after the last chunk
          final baseDelay = responses[i].length * 10; // 10ms per character
          final variableDelay = _random.nextInt(300); // 0-300ms random
          final totalDelay = (baseDelay + variableDelay).clamp(100, 800);

          await Future.delayed(
            Duration(milliseconds: totalDelay),
          ).cancellable(cancellationToken ?? CancellationToken.none());
        }
      }
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Mock: Chat was cancelled');
        rethrow;
      }
      AppLogger.error('Mock: Chat failed', e);
      yield 'Sorry, I encountered an error while processing your request.';
    }
  }

  // ========== Additional Operations ==========

  @override
  Future<String> transcribeAudio(
    String audioPath, {
    CancellationToken? cancellationToken,
  }) async {
    AppLogger.info('Mock: Transcribing audio: $audioPath');

    try {
      cancellationToken?.throwIfCancelled();
      await Future.delayed(
        _responseDelay,
      ).cancellable(cancellationToken ?? CancellationToken.none());

      final mockTranscriptions = [
        'Today was an amazing day! I went for a walk in the park and felt so peaceful.',
        'I\'m feeling a bit overwhelmed with work lately, but I\'m trying to stay positive.',
        'Had a great conversation with my friend today. It really lifted my spirits.',
        'The weather is beautiful today. I love how the sun feels on my face.',
        'I\'ve been thinking about my goals for this year and feeling motivated.',
      ];

      return mockTranscriptions[_random.nextInt(mockTranscriptions.length)];
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Mock: Audio transcription was cancelled');
        rethrow;
      }
      rethrow;
    }
  }

  @override
  Future<String> analyzeImage(
    String imagePath, {
    CancellationToken? cancellationToken,
  }) async {
    AppLogger.info('Mock: Analyzing image: $imagePath');

    try {
      cancellationToken?.throwIfCancelled();
      await Future.delayed(
        _responseDelay,
      ).cancellable(cancellationToken ?? CancellationToken.none());

      final mockDescriptions = [
        'A beautiful outdoor scene with natural lighting. The image captures tranquility and peace.',
        'An indoor setting with warm, inviting colors suggesting comfort and familiarity.',
        'A portrait showing genuine emotion and connection with intimate lighting atmosphere.',
        'A landscape with vibrant colors conveying freedom and openness.',
        'A candid moment capturing authentic emotion and spontaneous beauty.',
      ];

      return mockDescriptions[_random.nextInt(mockDescriptions.length)];
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Mock: Image analysis was cancelled');
        rethrow;
      }
      rethrow;
    }
  }

  @override
  Future<String> summarizeText(
    String text, {
    CancellationToken? cancellationToken,
  }) async {
    AppLogger.info('Mock: Summarizing text: ${text.length} chars');

    try {
      cancellationToken?.throwIfCancelled();
      await Future.delayed(
        _responseDelay,
      ).cancellable(cancellationToken ?? CancellationToken.none());

      if (text.isEmpty) {
        return 'No content to summarize.';
      }

      final words = text.split(' ');
      if (words.length <= 20) {
        return 'Brief reflection: ${text.substring(0, text.length.clamp(0, 100))}...';
      }

      return 'This moment captures a significant experience involving ${_generateRandomThemes().join(' and ')}. '
          'The content reflects personal growth, emotional awareness, and meaningful reflection on life experiences. '
          'Key themes include introspection, relationships, and the ongoing journey of self-discovery.';
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Mock: Text summarization was cancelled');
        rethrow;
      }
      rethrow;
    }
  }

  @override
  Future<List<double>> generateEmbedding(
    String text, {
    CancellationToken? cancellationToken,
  }) async {
    AppLogger.info('Mock: Generating embedding: ${text.length} chars');

    try {
      cancellationToken?.throwIfCancelled();
      await Future.delayed(
        Duration(milliseconds: 200),
      ).cancellable(cancellationToken ?? CancellationToken.none());

      // Generate a mock 768-dimensional embedding
      return List.generate(768, (index) => (_random.nextDouble() - 0.5) * 2);
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Mock: Embedding generation was cancelled');
        rethrow;
      }
      rethrow;
    }
  }

  // ========== Service Management ==========

  @override
  Future<bool> isAvailable() async {
    await Future.delayed(Duration(milliseconds: 100));
    return _isAvailable;
  }

  @override
  AIEngineConfig getConfig() {
    return AIEngineConfig(
      serviceName: 'MockAIEngine',
      serviceType: 'mock',
      version: '1.0.0',
      isEnabled: _isAvailable,
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
        'response_delay_ms': _responseDelay.inMilliseconds,
        'supports_cancellation': true,
        'supports_streaming': true,
        'mode': 'development',
      },
      description: 'Mock AI service for testing and development',
      lastUpdated: DateTime.now(),
    );
  }

  /// Set service availability for testing
  void setAvailable(bool available) {
    _isAvailable = available;
  }

  /// Set response delay for testing
  void setResponseDelay(Duration delay) {
    // Note: This would need to be implemented properly to actually change the delay
    AppLogger.info('Mock: Response delay set to ${delay.inMilliseconds}ms');
  }

  // ========== Helper Methods ==========

  List<String> _generateMoodKeywords(String primaryMood) {
    final keywords = {
      'happy': ['joyful', 'positive', 'upbeat', 'cheerful'],
      'sad': ['melancholy', 'downhearted', 'blue', 'sorrowful'],
      'anxious': ['worried', 'nervous', 'stressed', 'uneasy'],
      'excited': ['enthusiastic', 'energetic', 'thrilled', 'eager'],
      'peaceful': ['calm', 'serene', 'tranquil', 'relaxed'],
      'reflective': ['thoughtful', 'contemplative', 'introspective', 'pensive'],
      'grateful': ['thankful', 'appreciative', 'blessed', 'content'],
    };

    return keywords[primaryMood] ?? ['general', 'neutral'];
  }

  List<String> _generateSecondaryMoods(String primaryMood) {
    final secondary = {
      'happy': ['grateful', 'content'],
      'reflective': ['peaceful', 'thoughtful'],
      'peaceful': ['content', 'grateful'],
      'excited': ['happy', 'energetic'],
      'grateful': ['happy', 'peaceful'],
    };

    return secondary[primaryMood] ?? [];
  }

  List<String> _generateRandomThemes() {
    final themes = [
      'personal growth',
      'relationships',
      'career development',
      'health and wellness',
      'creativity',
      'spiritual journey',
      'family connections',
      'learning experiences',
    ];

    final selected = <String>[];
    final count = 2 + _random.nextInt(3);

    while (selected.length < count && selected.length < themes.length) {
      final theme = themes[_random.nextInt(themes.length)];
      if (!selected.contains(theme)) {
        selected.add(theme);
      }
    }

    return selected;
  }

  /// Generate mock responses with moment citations
  List<String> _generateMockResponses(List<Moment> moments) {
    if (moments.isEmpty) {
      // Provide varied responses for first-time users
      final emptyResponses = [
        [
          'Hello! I\'m here to be your thoughtful diary companion. ',
          'I can help you explore your thoughts, reflect on experiences, and gain insights from your daily moments. ',
          'What\'s on your mind today?',
        ],
        [
          'Hi there! I notice you haven\'t recorded any diary moments yet, but that\'s perfectly fine. ',
          'Sometimes the best conversations start with a simple question or thought. ',
          'What would you like to talk about?',
        ],
        [
          'Welcome! I\'m ready to listen and help you process whatever is on your mind. ',
          'Whether it\'s about today\'s experiences, future goals, or past reflections, ',
          'I\'m here to offer thoughtful perspectives. How are you feeling right now?',
        ],
      ];

      return emptyResponses[_random.nextInt(emptyResponses.length)];
    }

    final responses = <String>[];
    final momentCount = moments.length;

    // Add varied opening statements
    final openings = [
      'I\'ve been reflecting on your $momentCount diary moment${momentCount > 1 ? 's' : ''}, and ',
      'Looking through your recent entries ($momentCount moment${momentCount > 1 ? 's' : ''}), ',
      'Based on your $momentCount recorded moment${momentCount > 1 ? 's' : ''}, ',
      'I notice you have $momentCount thoughtful entry${momentCount > 1 ? 'ies' : ''} here. ',
    ];

    responses.add(openings[_random.nextInt(openings.length)]);

    // Reference specific moments with varied language
    if (moments.isNotEmpty) {
      final recentMoment = moments.first;
      final moodInfo = recentMoment.moods.isNotEmpty
          ? ' reflecting ${recentMoment.moods.join(' and ')} emotions'
          : '';

      final momentReferences = [
        'your most recent entry$moodInfo shows ',
        'I can see in your latest moment$moodInfo that ',
        'your recent reflection$moodInfo suggests ',
      ];

      final insights = [
        'a journey of personal growth and self-awareness. ',
        'thoughtful introspection and emotional intelligence. ',
        'meaningful engagement with your inner experiences. ',
        'a developing understanding of your emotional landscape. ',
      ];

      responses.add(momentReferences[_random.nextInt(momentReferences.length)]);
      responses.add(insights[_random.nextInt(insights.length)]);
    }

    // Add contextual analysis for multiple moments
    if (moments.length > 1) {
      final patterns = [
        'Across your entries, I notice patterns of resilience and emotional growth. ',
        'There\'s a beautiful thread of self-reflection woven through your recent moments. ',
        'Your entries show an evolving understanding of your experiences and emotions. ',
        'I can see consistent themes of mindfulness and personal insight in your writing. ',
      ];

      responses.add(patterns[_random.nextInt(patterns.length)]);
    }

    // Add engaging follow-up questions
    final followUps = [
      'What aspect of your recent experiences would you like to explore further?',
      'Is there a particular emotion or situation you\'d like to discuss more deeply?',
      'How are you feeling about the patterns I\'m noticing in your entries?',
      'What insights have you gained from your recent reflections?',
      'Would you like to dive deeper into any specific themes from your diary?',
    ];

    responses.add(followUps[_random.nextInt(followUps.length)]);

    return responses;
  }

  /// Initialize the mock engine
  @override
  Future<void> initialize() async {
    AppLogger.info('Mock AI engine initialized');
    // Mock engine doesn't need initialization
  }

  /// Dispose the mock engine
  @override
  Future<void> dispose() async {
    AppLogger.info('Mock AI engine disposed');
    // Mock engine doesn't need disposal
  }
}
