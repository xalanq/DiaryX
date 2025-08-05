// Example of how to integrate the universal task service with specific services (like AI)
// This file demonstrates the proper decoupled approach

import 'dart:math';
import 'package:diaryx/consts/env_config.dart';
import 'package:diaryx/databases/app_database.dart';
import '../ai/ai_service_manager.dart';
import '../ai/models/cancellation_token.dart';
import 'task_service.dart';
import 'implementations/memory_task_queue.dart';
import 'implementations/database_task_queue.dart';
import 'models/task_models.dart';

/// Example of how AI service can use the universal task system
/// This integration code should be in a separate integration layer, not in TaskService itself
class TaskIntegrationExample {
  final TaskService _taskService = TaskService.instance;
  final AIServiceManager _aiServiceManager = AIServiceManager.instance;

  // Task type constants
  static const String customTaskType = 'custom';
  static const String dataProcessingType = 'data_processing';
  static const String fileProcessingType = 'file_processing';

  /// Initialize the integration between AI service and task system
  Future<void> initialize({bool useDatabase = false}) async {
    if (useDatabase) {
      // Initialize task service with a database queue
      final taskQueue = DatabaseTaskQueue(AppDatabase.instance);
      await _taskService.initialize(taskQueue: taskQueue);
    } else {
      // Initialize task service with a memory queue
      final taskQueue = MemoryTaskQueue();
      await _taskService.initialize(taskQueue: taskQueue);
    }

    // Register AI-specific task handlers
    _registerAITaskHandlers();
  }

  /// Register handlers for AI-related tasks
  void _registerAITaskHandlers() {
    // Register handler for custom AI tasks using the universal task system
    _taskService.registerTaskHandler(customTaskType, _handleCustomTask);
    _taskService.registerTaskHandler(dataProcessingType, _handleDataProcessing);
    _taskService.registerTaskHandler(fileProcessingType, _handleFileProcessing);
  }

  /// Example: Submit AI text polishing as a custom task
  Future<void> submitTextPolishingTask({
    required String text,
    required String contextId,
    int priority = EnvConfig.normalPriority,
  }) async {
    final task = Task(
      id: _generateTaskId('text_polish'),
      type: customTaskType,
      priority: priority,
      label: 'Polishing text content',
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
      data: {
        'operation': 'text_polishing',
        'text': text,
        'contextId': contextId,
      },
    );

    await _taskService.submitTask(task);
  }

  /// Example: Submit mood analysis as a data processing task
  Future<void> submitMoodAnalysisTask({
    required String content,
    required String contextId,
    int priority = EnvConfig.normalPriority,
  }) async {
    final task = Task(
      id: _generateTaskId('mood_analysis'),
      type: dataProcessingType,
      priority: priority,
      label: 'Analyzing mood and emotions',
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
      data: {
        'operation': 'mood_analysis',
        'content': content,
        'contextId': contextId,
      },
    );

    await _taskService.submitTask(task);
  }

  /// Handler for custom tasks (AI operations)
  Future<Map<String, dynamic>> _handleCustomTask(Task task) async {
    final operation = task.data['operation'] as String?;

    switch (operation) {
      case 'text_polishing':
        return await _handleTextPolishing(task);
      case 'tag_generation':
        return await _handleTagGeneration(task);
      default:
        throw Exception('Unknown custom operation: $operation');
    }
  }

  /// Handler for data processing tasks (AI analysis)
  Future<Map<String, dynamic>> _handleDataProcessing(Task task) async {
    final operation = task.data['operation'] as String?;

    switch (operation) {
      case 'mood_analysis':
        return await _handleMoodAnalysis(task);
      case 'content_summarization':
        return await _handleContentSummarization(task);
      default:
        throw Exception('Unknown data processing operation: $operation');
    }
  }

  /// Handler for file processing tasks (AI file operations)
  Future<Map<String, dynamic>> _handleFileProcessing(Task task) async {
    final operation = task.data['operation'] as String?;

    switch (operation) {
      case 'audio_transcription':
        return await _handleAudioTranscription(task);
      case 'image_analysis':
        return await _handleImageAnalysis(task);
      default:
        throw Exception('Unknown file processing operation: $operation');
    }
  }

  // ========== Specific AI Task Handlers ==========

  Future<Map<String, dynamic>> _handleTextPolishing(Task task) async {
    final text = task.data['text'] as String;
    final cancellationToken = CancellationToken();

    final buffer = StringBuffer();
    await for (final chunk in _aiServiceManager.enhanceText(
      text,
      cancellationToken,
    )) {
      buffer.write(chunk);
    }

    return {
      'polishedText': buffer.toString(),
      'originalLength': text.length,
      'polishedLength': buffer.length,
    };
  }

  Future<Map<String, dynamic>> _handleMoodAnalysis(Task task) async {
    final content = task.data['content'] as String;
    final cancellationToken = CancellationToken();

    final moodAnalysis = await _aiServiceManager.analyzeMood(
      content,
      cancellationToken,
    );

    return {
      'primaryMood': moodAnalysis?.primaryMood,
      'moodScore': moodAnalysis?.moodScore,
      'confidence': moodAnalysis?.confidenceScore,
      'keywords': moodAnalysis?.moodKeywords,
    };
  }

  Future<Map<String, dynamic>> _handleTagGeneration(Task task) async {
    final content = task.data['content'] as String;
    final cancellationToken = CancellationToken();

    final tags = await _aiServiceManager.generateTags(
      content,
      cancellationToken,
    );

    return {'tags': tags, 'tagCount': tags?.length ?? 0};
  }

  Future<Map<String, dynamic>> _handleAudioTranscription(Task task) async {
    final audioPath = task.data['audioPath'] as String;

    final cancellationToken = CancellationToken();
    final transcription = await _aiServiceManager.transcribeAudio(
      audioPath,
      cancellationToken,
    );

    return {
      'transcription': transcription,
      'audioPath': audioPath,
      'wordCount': transcription?.split(' ').length ?? 0,
    };
  }

  Future<Map<String, dynamic>> _handleImageAnalysis(Task task) async {
    final imagePath = task.data['imagePath'] as String;

    final cancellationToken = CancellationToken();
    final analysis = await _aiServiceManager.analyzeImage(
      imagePath,
      cancellationToken,
    );

    return {
      'analysis': analysis,
      'imagePath': imagePath,
      'analysisLength': analysis?.length ?? 0,
    };
  }

  Future<Map<String, dynamic>> _handleContentSummarization(Task task) async {
    final content = task.data['content'] as String;

    final cancellationToken = CancellationToken();
    final summary = await _aiServiceManager.summarizeText(
      content,
      cancellationToken,
    );

    return {
      'summary': summary,
      'originalLength': content.length,
      'summaryLength': summary?.length ?? 0,
    };
  }

  // ========== Utility Methods ==========

  String _generateTaskId(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000);
    return '${prefix}_${timestamp}_$random';
  }
}
