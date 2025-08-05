# DiaryX Technical Architecture Document

## 1. Technology Stack Overview

### 1.1 Core Framework

- **Flutter 3.32.8**: Cross-platform mobile application framework
- **Dart SDK**: Latest stable version for Flutter 3.32.8
- **Target Platforms**: iOS 12.0+, Android API 21+ (Android 5.0)

### 1.2 Local Data Management

- **Database**: SQLite with Drift ORM for structured data
- **Vector Database**: Chroma for semantic search capabilities
- **File Storage**: Native device storage for media files
- **Security**: Basic numeric password protection

### 1.3 AI and Machine Learning

- **LLM Integration**: Gemma 3n model interface
- **API Compatibility**: OpenAI-compatible API for Ollama integration
- **Vector Embeddings**: Support for 768-dimension embeddings (typical for modern models)
- **Processing**: Async queue system for background AI operations

### 1.4 Media and File Handling

- **Camera**: camera package for photo/video capture
- **Audio**: record: 5.1.0 for basic voice recording and playback
- **Image Processing**: image package for compression and manipulation
- **File Management**: path_provider for file system access

### 1.5 UI and Animation

- **Animation**: Flutter's built-in animation system + animations package
- **Glass Morphism**: Custom implementations using BackdropFilter
- **Charts**: fl_chart for data visualization
- **Icons**: flutter_svg for vector icon support
- **Typography**: DO NOT use letterSpacing in text styles as it negatively affects readability and visual appeal
- **Responsive Layout**: Avoid fixed widths/heights, use padding, Row, Column, Expanded, Flexible and other flexible layout widgets to adapt to different screen sizes

### 1.6 Numeric Password Authentication

- **Password Storage**: flutter_secure_storage for basic password storage
- **Password Validation**: Simple 4-6 digit numeric password validation
- **Basic Security**: Simple retry limitation mechanism

## 2. System Architecture

### 2.1 Architecture Pattern

**Simple MVC-like Architecture**

```
lib/
├── models/          # Data models
│   ├── moment.dart
│   ├── media_attachment.dart
│   ├── tag.dart
│   └── mood_analysis.dart
├── stores/          # State management
│   ├── moment_store.dart
│   ├── auth_store.dart
│   └── search_store.dart
├── screens/         # Screen pages
│   ├── capture/
│   │   └── capture_screen.dart
│   ├── timeline/
│   │   └── timeline_screen.dart
│   ├── search/
│   │   └── search_screen.dart
│   ├── report/
│   │   └── report_screen.dart
│   └── profile/
│       └── profile_screen.dart
├── databases/       # Database management
│   ├── app_database.dart
│   └── tables/
│       ├── moments_table.dart
│       ├── media_attachments_table.dart
│       ├── tags_table.dart
│       ├── key_values_table.dart
│       └── task_queue_table.dart
├── services/        # Business services
│   ├── ai/          # AI engine with optimized architecture
│   │   ├── ai_engine.dart (AIEngine interface)
│   │   ├── ai_service.dart (AIService manager)
│   │   ├── llm_engine.dart (LLMEngine interface)
│   │   ├── models/
│   │   │   ├── models.dart
│   │   │   ├── ai_models.dart
│   │   │   ├── chat_models.dart
│   │   │   ├── config_models.dart
│   │   │   ├── llm_models.dart
│   │   │   └── cancellation_token.dart
│   │   ├── configs/
│   │   │   └── ai_config_service.dart
│   │   └── implementations/
│   │       ├── ai_service_impl.dart (AIEngineImpl)
│   │       ├── ollama_service.dart (OllamaService)
│   │       └── mock_ai_service.dart (MockAIEngine)
│   ├── task/        # Universal task queue system
│   │   ├── task_queue.dart
│   │   ├── task_service.dart
│   │   ├── task_integration_example.dart
│   │   ├── models/
│   │   │   ├── models.dart
│   │   │   └── task_models.dart
│   │   └── implementations/
│   │       ├── memory_task_queue.dart
│   │       └── database_task_queue.dart
│   ├── auth/
│   │   └── auth_service.dart
│   └── media/
│       └── media_service.dart
├── utils/           # Utility functions
│   ├── date_helper.dart
│   ├── file_helper.dart
│   └── app_logger.dart
├── widgets/         # Reusable components
│   ├── app_button/
│   │   └── app_button.dart
│   ├── custom_app_bar/
│   │   └── custom_app_bar.dart
│   ├── error_states/
│   │   └── error_states.dart
│   ├── glass_card/
│   │   └── glass_card.dart
│   ├── loading_states/
│   │   └── loading_states.dart
│   └── main_layout/
│       └── main_layout.dart
├── themes/          # Style themes
│   ├── app_theme.dart
│   ├── app_colors.dart
│   ├── colors.dart
│   └── text_styles.dart
├── consts/          # Configuration constants
│   ├── api_urls.dart
│   └── env_config.dart
└── app_routes.dart  # App routing configuration
```

### 2.2 State Management

- **Global State**: Provider + ChangeNotifier for application state management
- **Local State**: StatefulWidget for simple UI state
- **Data Persistence**: SharedPreferences for user settings and configuration
- **Async State**: FutureBuilder and StreamBuilder for async data display
- **State Updates**: notifyListeners() for UI update notifications

### 2.3 Service Management

- **Direct Instantiation**: Create service instances directly when needed
- **Singleton Pattern**: Simple singleton pattern for database, AI services, etc.
- **Service Passing**: Pass service dependencies through constructors
- **Initialization**: Global service initialization in main.dart

### 2.5 Universal Task Queue System

```
Universal Task Queue Architecture:
├── TaskService (Singleton)
│   ├── Task Queue Interface (Abstract)
│   │   ├── MemoryTaskQueue (In-memory implementation)
│   │   └── DatabaseTaskQueue (Persistent implementation)
│   ├── Task Management
│   │   ├── Priority-based Processing (High/Normal/Low)
│   │   ├── Concurrent Task Execution (Configurable limits)
│   │   ├── Retry Logic with Exponential Backoff
│   │   └── Comprehensive Error Handling
│   ├── Task Handler Registration
│   │   ├── Dynamic Handler Registration by Task Type
│   │   ├── Decoupled Service Integration
│   │   └── Callback-based Task Execution
│   └── Status Tracking & Statistics
│       ├── Real-time Task Status Updates
│       ├── Task Performance Metrics
│       └── Progress Notification System
├── AI Service Integration (Example)
│   ├── Speech-to-Text Tasks
│   ├── Image Analysis Tasks
│   ├── Text Enhancement Tasks
│   └── Vector Generation Tasks
└── Database Schema
    └── TaskQueue Table with Indexing
```

### 2.4 Routing Management

```dart
// Route constants - lib/app_routes.dart
class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String capture = '/capture';
  static const String timeline = '/timeline';
  static const String report = '/report';
  static const String search = '/search';
  static const String profile = '/profile';
  static const String momentDetail = '/moment';
  static const String llmAnalysis = '/analysis';
}

// Simple route configuration - main.dart
MaterialApp(
  routes: {
    AppRoutes.splash: (context) => SplashScreen(),
    AppRoutes.auth: (context) => AuthScreen(),
    AppRoutes.home: (context) => HomeScreen(),
    AppRoutes.capture: (context) => CaptureScreen(),
    AppRoutes.timeline: (context) => TimelineScreen(),
    AppRoutes.report: (context) => ReportScreen(),
    AppRoutes.search: (context) => SearchScreen(),
    AppRoutes.profile: (context) => ProfileScreen(),
    AppRoutes.llmAnalysis: (context) => LLMAnalysisScreen(),
  },
  onGenerateRoute: (settings) {
    // Handle routes that require parameters
    if (settings.name == AppRoutes.momentDetail) {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => MomentDetailScreen(moment: args['moment']),
      );
    }
    return null;
  },
)
```

## 3. Database Design

### 3.1 Drift Table Model Definitions

#### 3.1.1 Core Table Models

```dart
// Diary moments table
@DataClassName('MomentData')
class Moments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  TextColumn get aiSummary => text().nullable()(); // AI-generated summary of the moment
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get aiProcessed => boolean().withDefault(const Constant(false))();
}

// Media attachments table
@DataClassName('MediaAttachment')
class MediaAttachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get momentId => integer().references(Moments, #id)();
  TextColumn get filePath => text()();
  TextColumn get mediaType => textEnum<MediaType>()(); // 'image', 'video', 'audio'
  IntColumn get fileSize => integer().nullable()();
  RealColumn get duration => real().nullable()(); // Video/audio duration in seconds
  TextColumn get thumbnailPath => text().nullable()();
  TextColumn get aiSummary => text().nullable()(); // AI-generated summary of media content
  BoolColumn get aiProcessed => boolean().withDefault(const Constant(false))(); // Whether AI has processed this media
  DateTimeColumn get createdAt => dateTime()();
}

// Tags table
@DataClassName('Tag')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get color => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

// Moment-tag association table
@DataClassName('MomentTag')
class MomentTags extends Table {
  IntColumn get momentId => integer().references(Moments, #id)();
  IntColumn get tagId => integer().references(Tags, #id)();

  @override
  Set<Column> get primaryKey => {momentId, tagId};
}

// Moment-mood association table
@DataClassName('MomentMoodData')
class MomentMoods extends Table {
  IntColumn get momentId => integer().references(Moments, #id)();
  TextColumn get mood => text()(); // Mood name (string value from MoodType enum)
  DateTimeColumn get createdAt => dateTime()(); // When this mood association was created

  @override
  Set<Column> get primaryKey => {momentId, mood};
}

// Legacy AI processing queue table has been removed
// All AI processing tasks are now handled by the universal TaskQueue system

// Universal task queue table
@TableIndex(name: 'idx_task_queue_status_priority', columns: {#status, #priority, #createdAt})
@TableIndex(name: 'idx_task_queue_type', columns: {#type})
@TableIndex(name: 'idx_task_queue_completed_at', columns: {#completedAt})
@DataClassName('TaskQueueData')
class TaskQueue extends Table {
  TextColumn get taskId => text()(); // Unique task identifier
  TextColumn get type => text()(); // Generic task type as string
  IntColumn get priority => integer().withDefault(const Constant(0))();
  TextColumn get label => text()(); // Human-readable task label
  TextColumn get status => text()(); // 'pending', 'running', 'completed', 'failed', 'cancelled', 'retrying'
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get data => text()(); // Task data as JSON string
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get error => text().nullable()();
  TextColumn get result => text().nullable()(); // Task result as JSON string

  @override
  Set<Column> get primaryKey => {taskId};
}


```

#### 3.1.2 Enum Definitions

```dart
enum MediaType { image, video, audio }
// Note: TaskType and ProcessingStatus enums are no longer needed as the universal task queue uses string-based types
// Note: EmbeddingType and AnalysisType enums have been removed as embeddings and analysis tables are no longer used
```

### 3.2 Vector Database Design (Chroma)

#### 3.2.1 Collections Structure

```python
# Moment embeddings collection
collection_name: "diary_moments"
embedding_dimension: 768  # Based on sentence-transformers models
metadata_schema: {
    "moment_id": int,
    "media_types": List[str],  # ['text', 'image', 'audio', 'video'] based on content
    "created_at": int,
    "moods": List[str],
    "tags": List[str]
}

# Search embeddings collection
collection_name: "search_queries"
embedding_dimension: 768
metadata_schema: {
    "query": str,
    "timestamp": int,
    "result_count": int
}
```

#### 3.2.2 Vector Generation Strategy

- **Text Content**: Direct embedding of moment text
- **Audio Content**: Embedding of transcribed text
- **Image Content**: Embedding of AI-generated image descriptions
- **Video Content**: Embedding of extracted frame descriptions
- **Multi-Media Content**: Concatenated embeddings with weighted averaging

## 4. AI Integration Architecture

### 4.1 LLM Engine Interface

#### 4.1.1 Abstract LLM Engine

```dart
abstract class LLMEngine {
  // Non-streaming chat completion
  Future<String> chatCompletion(List<ChatMessage> messages);

  // Streaming chat completion
  Stream<String> streamChatCompletion(List<ChatMessage> messages);

  // Generate vector embeddings
  Future<List<double>> generateEmbedding(String text);
}

// Message model
class ChatMessage {
  final String role; // 'user', 'assistant', 'system'
  final String content;
  final List<MediaItem>? images;
  final List<MediaItem>? audios;
  final List<MediaItem>? videos;

  ChatMessage({
    required this.role,
    required this.content,
    this.images,
    this.audios,
    this.videos,
  });
}

class MediaItem {
  final String type; // 'url' or 'base64'
  final String data;

  MediaItem({
    required this.type,
    required this.data,
  });
}
```

#### 4.1.2 Enhanced AIEngine Implementation

```dart
abstract class AIEngine {
  // ========== Streaming Operations ==========

  /// Streaming text enhancement with cancellation support
  Stream<String> enhanceText(String text, CancellationToken cancellationToken);

  /// Streaming chat conversation with moment summaries
  Stream<String> chat(List<ChatMessage> messages, List<String> momentSummaries, CancellationToken cancellationToken);

  // ========== Cancellable Operations ==========

  /// Mood analysis with cancellation support
  Future<MoodAnalysis> analyzeMood(String text, CancellationToken cancellationToken);

  /// Tag generation with cancellation support
  Future<List<String>> generateTags(String content, CancellationToken cancellationToken);

  /// Audio transcription with cancellation support
  Future<String> transcribeAudio(String audioPath, CancellationToken cancellationToken);

  /// Image analysis with cancellation support
  Future<String> analyzeImage(String imagePath, CancellationToken cancellationToken);

  /// Text summarization with cancellation support
  Future<String> summarizeText(String text, CancellationToken cancellationToken);

  /// Vector embedding generation with cancellation support
  Future<List<double>> generateEmbedding(String text, CancellationToken cancellationToken);

  // ========== Service Management ==========

  /// Check if AI service is available
  Future<bool> isAvailable();

  /// Get structured AI engine configuration
  AIEngineConfig getConfig();


}

// Supporting models for structured configuration and status
class AIEngineConfig {
  final AIEngineType engineType;
  final String modelName;
  final String baseUrl;
  final Map<String, dynamic> parameters;
  final bool streamingSupported;
  final bool cancellationSupported;

  const AIEngineConfig({
    required this.engineType,
    required this.modelName,
    required this.baseUrl,
    required this.parameters,
    required this.streamingSupported,
    required this.cancellationSupported,
  });
}


enum AIEngineType { ollama, gemma, mock }

// Concrete implementation
class AIEngineImpl implements AIEngine {
  final LLMEngine _llmEngine;

  AIEngineImpl(this._llmEngine);

  @override
  Future<String> transcribeAudio(String audioPath) async {
    final audioData = await _loadAudioAsBase64(audioPath);
    final messages = [
      ChatMessage(
        role: 'user',
        content: 'Please transcribe the following audio to text:',
        audios: [MediaItem(type: 'base64', data: audioData)],
      ),
    ];

    final response = await _llmEngine.chatCompletion(messages);
    return _extractTranscription(response);
  }

  @override
  Future<String> enhanceText(String originalText) async {
    final messages = [
      ChatMessage(
        role: 'system',
        content: 'You are a professional text editing assistant, responsible for expanding and polishing user diary content. Please maintain the core meaning of the original text while adding more details and context.',
      ),
      ChatMessage(
        role: 'user',
        content: 'Please expand the following diary content:\n\n$originalText',
      ),
    ];

    return await _llmEngine.chatCompletion(messages);
  }

  @override
  Future<String> summarizeText(String text) async {
    final messages = [
      ChatMessage(
        role: 'system',
        content: 'You are a professional summarization assistant, responsible for providing concise and comprehensive summaries of user diary content.',
      ),
      ChatMessage(
        role: 'user',
        content: 'Please summarize the following diary content:\n\n$text',
      ),
    ];

    return await _llmEngine.chatCompletion(messages);
  }

  @override
  Future<String> analyzeImageContent(String imagePath) async {
    final imageData = await _loadImageAsBase64(imagePath);
    final messages = [
      ChatMessage(
        role: 'system',
        content: 'You are an image analysis assistant, responsible for describing image content and extracting key information.',
      ),
      ChatMessage(
        role: 'user',
        content: 'Please analyze the content of this image:',
        images: [MediaItem(type: 'base64', data: imageData)],
      ),
    ];

    return await _llmEngine.chatCompletion(messages);
  }

  @override
  Future<MoodAnalysis> analyzeMood(String text) async {
    final messages = [
      ChatMessage(
        role: 'system',
        content: '''You are a mood analysis expert, responsible for analyzing the mood state of text.
Please return the analysis result in JSON format:
{
  "mood_score": -0.5, // -1.0 to 1.0, negative values indicate negative moods
  "primary_mood": "sad",
  "confidence_score": 0.8,
  "mood_keywords": ["disappointed", "frustrated"]
}''',
      ),
      ChatMessage(
        role: 'user',
        content: 'Please analyze the moods in the following text:\n\n$text',
      ),
    ];

    final response = await _llmEngine.chatCompletion(messages);
    return _parseMoodAnalysis(response);
  }

  @override
  Future<List<String>> generateTags(String content) async {
    final messages = [
      ChatMessage(
        role: 'system',
        content: 'You are a tag generation assistant, responsible for generating relevant tags for diary content. Please return 5-8 tags separated by commas.',
      ),
      ChatMessage(
        role: 'user',
        content: 'Please generate tags for the following content:\n\n$content',
      ),
    ];

    final response = await _llmEngine.chatCompletion(messages);
    return _parseTags(response);
  }

  @override
  Future<String> summarizeSearchResults(List<SearchResult> results) async {
    final content = results.map((r) => r.content).join('\n\n');
    final messages = [
      ChatMessage(
        role: 'system',
        content: 'You are a search summarization assistant, responsible for providing comprehensive summaries of multiple search results.',
      ),
      ChatMessage(
        role: 'user',
        content: 'Please summarize the following search results:\n\n$content',
      ),
    ];

    return await _llmEngine.chatCompletion(messages);
  }

  @override
  Stream<String> streamChatCompletion(List<ChatMessage> messages) async* {
    await for (final chunk in _llmEngine.streamChatCompletion(messages)) {
      yield chunk;
    }
  }

  @override
  Future<AnalysisResult> analyzeContent(String content) async {
    final messages = [
      ChatMessage(
        role: 'system',
        content: '''You are a diary analysis assistant, responsible for analyzing diary content and providing insights.
Please return the analysis result in JSON format:
{
  "analysis": "analysis content",
  "confidence": 0.8,
  "tags": ["tag1", "tag2"],
  "metadata": {"key": "value"}
}''',
      ),
      ChatMessage(
        role: 'user',
        content: 'Please analyze the following diary content:\n\n$content',
      ),
    ];

    final response = await _llmEngine.chatCompletion(messages);
    return _parseAnalysisResult(response);
  }

  @override
  Future<List<double>> generateEmbedding(String text) async {
    return await _llmEngine.generateEmbedding(text);
  }

  // Helper methods
  Future<String> _loadAudioAsBase64(String audioPath) async {
    // TODO: Implement audio file to base64 conversion
    return 'base64_audio_data';
  }

  Future<String> _loadImageAsBase64(String imagePath) async {
    // TODO: Implement image file to base64 conversion
    return 'base64_image_data';
  }

  String _extractTranscription(String response) {
    // TODO: Extract transcription text from LLM response
    return response.trim();
  }

  MoodAnalysis _parseMoodAnalysis(String response) {
    // TODO: Parse mood analysis JSON response
    return MoodAnalysis(
      momentId: 0,
      moodScore: 0.0,
      primaryMood: 'neutral',
      confidenceScore: 0.8,
      moodKeywords: '[]',
      analysisTimestamp: DateTime.now(),
    );
  }

  List<String> _parseTags(String response) {
    // TODO: Parse tags response
    return response.split(',').map((tag) => tag.trim()).toList();
  }

  AnalysisResult _parseAnalysisResult(String response) {
    // TODO: Parse analysis result JSON response
    return AnalysisResult(
      analysis: response,
      confidence: 0.8,
      tags: [],
      metadata: {},
    );
  }
}

// Mock implementation
class MockAIEngine implements AIEngine {
  @override
  Future<String> transcribeAudio(String audioPath) async {
    return "Mock transcription: This is a sample transcription of the audio content.";
  }

  @override
  Future<String> enhanceText(String originalText) async {
    return "$originalText\n\n[AI Enhancement]: Additional context and elaboration based on the original content.";
  }

  @override
  Future<String> summarizeText(String text) async {
    return "Mock summary: This is a concise summary of the provided content.";
  }

  @override
  Future<String> analyzeImageContent(String imagePath) async {
    return "Mock image analysis: This image appears to contain various elements and objects.";
  }

  @override
  Future<MoodAnalysis> analyzeMood(String text) async {
    return MoodAnalysis(
      momentId: 0,
      moodScore: 0.2,
      primaryMood: 'neutral',
      confidenceScore: 0.8,
      moodKeywords: '["neutral", "calm"]',
      analysisTimestamp: DateTime.now(),
    );
  }

  @override
  Future<List<String>> generateTags(String content) async {
    return ["mock", "tag", "sample", "content"];
  }

  @override
  Future<String> summarizeSearchResults(List<SearchResult> results) async {
    return "Mock search summary: Found ${results.length} relevant moments.";
  }

  @override
  Stream<String> streamChatCompletion(List<ChatMessage> messages) async* {
    yield "Mock streaming response: ";
    await Future.delayed(Duration(milliseconds: 100));
    yield "This is a sample streaming response for testing purposes.";
  }

  @override
  Future<AnalysisResult> analyzeContent(String content) async {
    return AnalysisResult(
      analysis: "Mock analysis: This is a sample analysis of the content.",
      confidence: 0.8,
      tags: ["mock", "analysis"],
      metadata: {"type": "mock"},
    );
  }

  @override
  Future<List<double>> generateEmbedding(String text) async {
    return List.generate(768, (index) => (index % 100) / 100.0);
  }
}
```

#### 4.1.3 Gemma 3n Implementation

```dart
class Gemma3nService implements LLMService {
  final String _modelPath;
  final GemmaInferenceEngine _engine;

  Gemma3nService(this._modelPath) : _engine = GemmaInferenceEngine(_modelPath);

  @override
  Future<String> chatCompletion(List<ChatMessage> messages) async {
    // TODO: Implement Gemma 3n chat completion
    final prompt = _formatMessagesToPrompt(messages);
    return await _engine.generateText(prompt);
  }

  @override
  Stream<String> streamChatCompletion(List<ChatMessage> messages) async* {
    // TODO: Implement Gemma 3n streaming chat completion
    final prompt = _formatMessagesToPrompt(messages);
    await for (final chunk in _engine.generateTextStream(prompt)) {
      yield chunk;
    }
  }

  @override
  Future<List<double>> generateEmbedding(String text) async {
    // TODO: Implement Gemma 3n embedding generation
    return await _engine.generateEmbedding(text);
  }

  String _formatMessagesToPrompt(List<ChatMessage> messages) {
    // Format messages to Gemma 3n input format
    return messages.map((msg) => '${msg.role}: ${msg.content}').join('\n');
  }
}
```

#### 4.1.4 Ollama Implementation

```dart
class OllamaService implements LLMService {
  final String _baseUrl;
  final String _modelName;
  final Dio _httpClient;

  OllamaService(this._baseUrl, this._modelName) : _httpClient = Dio();

  @override
  Future<String> chatCompletion(List<ChatMessage> messages) async {
    final response = await _httpClient.post(
      '$_baseUrl/api/chat',
      data: {
        'model': _modelName,
        'messages': messages.map((msg) => {
          'role': msg.role,
          'content': msg.content,
          if (msg.images != null) 'images': msg.images!.map((img) => {
            'type': img.type,
            'data': img.data,
          }).toList(),
          if (msg.audios != null) 'audios': msg.audios!.map((audio) => {
            'type': audio.type,
            'data': audio.data,
          }).toList(),
          if (msg.videos != null) 'videos': msg.videos!.map((video) => {
            'type': video.type,
            'data': video.data,
          }).toList(),
        }).toList(),
      },
    );

    return response.data['message']['content'];
  }

  @override
  Stream<String> streamChatCompletion(List<ChatMessage> messages) async* {
    final response = await _httpClient.post(
      '$_baseUrl/api/chat',
      data: {
        'model': _modelName,
        'messages': messages.map((msg) => {
          'role': msg.role,
          'content': msg.content,
          if (msg.images != null) 'images': msg.images!.map((img) => {
            'type': img.type,
            'data': img.data,
          }).toList(),
          if (msg.audios != null) 'audios': msg.audios!.map((audio) => {
            'type': audio.type,
            'data': audio.data,
          }).toList(),
          if (msg.videos != null) 'videos': msg.videos!.map((video) => {
            'type': video.type,
            'data': video.data,
          }).toList(),
        }).toList(),
        'stream': true,
      },
      options: Options(responseType: ResponseType.stream),
    );

    await for (final chunk in response.data.stream) {
      yield parseStreamChunk(chunk);
    }
  }

  @override
  Future<List<double>> generateEmbedding(String text) async {
    final response = await _httpClient.post(
      '$_baseUrl/api/embeddings',
      data: {
        'model': _modelName,
        'input': text,
      },
    );

    return List<double>.from(response.data['data'][0]['embedding']);
  }

  String parseStreamChunk(dynamic chunk) {
    // TODO: Parse SSE format streaming response
    return chunk.toString();
  }
}
```

### 4.2 Universal Task Queue System

#### 4.2.1 TaskQueue Interface

```dart
typedef TaskCallback = Future<Map<String, dynamic>> Function(Task task);
typedef TaskCompletionCallback = void Function(Task task, bool success, Map<String, dynamic>? result, String? error);
typedef TaskProgressCallback = void Function(Task task, double progress);

/// Abstract interface for task queue implementations
abstract class TaskQueue {
  /// Submit a task to the queue
  Future<void> submitTask(Task task);

  /// Register a callback for a specific task type
  void registerCallback(TaskType type, TaskCallback callback);

  /// Register completion callback
  void registerCompletionCallback(TaskCompletionCallback callback);

  /// Register progress callback
  void registerProgressCallback(TaskProgressCallback callback);

  /// Get tasks with optional filtering
  Future<List<Task>> getTasks([TaskFilter? filter]);

  /// Stream of task list changes
  Stream<List<Task>> get tasksStream;

  /// Get task statistics
  Future<TaskStats> getStats();

  /// Cancel a specific task
  Future<void> cancelTask(String taskId);

  /// Retry a failed task
  Future<void> retryTask(String taskId);

  /// Cancel all pending/running tasks
  Future<void> cancelAllTasks();

  /// Start the queue processing
  Future<void> start();

  /// Stop the queue processing
  Future<void> stop();

  /// Dispose resources
  Future<void> dispose();
}

/// Task model with generic string-based type system
class Task {
  final String id;
  final TaskType type; // String-based type for flexibility
  final int priority;
  final String label;
  final TaskStatus status;
  final DateTime createdAt;
  final Map<String, dynamic> data;
  final int retryCount;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? error;
  final Map<String, dynamic>? result;

  const Task({
    required this.id,
    required this.type,
    required this.priority,
    required this.label,
    required this.status,
    required this.createdAt,
    required this.data,
    this.retryCount = 0,
    this.startedAt,
    this.completedAt,
    this.error,
    this.result,
  });
}

/// Generic task type as string for maximum flexibility
typedef TaskType = String;

enum TaskStatus { pending, running, completed, failed, cancelled, retrying }
```

#### 4.2.2 TaskService Implementation

```dart
/// Singleton service for managing the universal task queue
class TaskService {
  static TaskService? _instance;
  static TaskService get instance {
    _instance ??= TaskService._();
    return _instance!;
  }

  TaskService._();

  TaskQueue? _taskQueue;
  final Map<TaskType, TaskCallback> _handlers = {};

  /// Initialize the task service with a specific queue implementation
  Future<void> initialize({TaskQueue? taskQueue}) async {
    _taskQueue = taskQueue ?? MemoryTaskQueue();
    await _taskQueue!.start();
  }

  /// Register a handler for a specific task type
  void registerTaskHandler(TaskType type, TaskCallback handler) {
    _handlers[type] = handler;

    // Register the handler with the queue
    _taskQueue?.registerCallback(type, (task) async {
      final handler = _handlers[task.type];
      if (handler == null) {
        throw Exception('No handler registered for task type: ${task.type}');
      }

      return await handler(task);
    });
  }

  /// Submit a task to the queue
  Future<void> submitTask(Task task) async {
    await _taskQueue?.submitTask(task);
  }

  /// Get tasks with optional filtering
  Future<List<Task>> getTasks([TaskFilter? filter]) async {
    return await _taskQueue?.getTasks(filter) ?? [];
  }

  /// Stream of task changes
  Stream<List<Task>> get tasksStream => _taskQueue?.tasksStream ?? Stream.empty();

  /// Get task statistics
  Future<TaskStats> getStats() async {
    return await _taskQueue?.getStats() ?? TaskStats.empty();
  }

  /// Cancel a task
  Future<void> cancelTask(String taskId) async {
    await _taskQueue?.cancelTask(taskId);
  }

  /// Retry a task
  Future<void> retryTask(String taskId) async {
    await _taskQueue?.retryTask(taskId);
  }

  /// Cancel all tasks
  Future<void> cancelAllTasks() async {
    await _taskQueue?.cancelAllTasks();
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _taskQueue?.dispose();
    _handlers.clear();
    _instance = null;
  }
}

#### 4.2.3 AI Service Integration Example

```dart
/// Example of how AI service integrates with the universal task queue
class AITaskIntegration {
  final TaskService _taskService = TaskService.instance;
  final AIService _aiService;

  AITaskIntegration(this._aiService);

  /// Initialize AI task handlers
  Future<void> initialize() async {
    // Register handlers for different AI task types
    _taskService.registerTaskHandler('audio_transcription', _handleAudioTranscription);
    _taskService.registerTaskHandler('image_analysis', _handleImageAnalysis);
    _taskService.registerTaskHandler('text_summary', _handleTextSummary);
    _taskService.registerTaskHandler('mood_analysis', _handleMoodAnalysis);
    _taskService.registerTaskHandler('tag_generation', _handleTagGeneration);
  }

  /// Submit audio transcription task
  Future<void> submitAudioTranscription(String audioPath, String momentId) async {
    final task = Task(
      id: 'audio_${DateTime.now().millisecondsSinceEpoch}',
      type: 'audio_transcription',
      priority: 5, // Normal priority
      label: 'Transcribe audio recording',
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
      data: {
        'audioPath': audioPath,
        'momentId': momentId,
      },
    );

    await _taskService.submitTask(task);
  }

  /// Handle audio transcription task
  Future<Map<String, dynamic>> _handleAudioTranscription(Task task) async {
    final audioPath = task.data['audioPath'] as String;
    final cancellationToken = CancellationToken();

    final transcription = await _aiService.transcribeAudio(audioPath, cancellationToken);

    return {
      'transcription': transcription,
      'processed_at': DateTime.now().toIso8601String(),
    };
  }

  /// Handle image analysis task
  Future<Map<String, dynamic>> _handleImageAnalysis(Task task) async {
    final imagePath = task.data['imagePath'] as String;
    final cancellationToken = CancellationToken();

    final analysis = await _aiService.analyzeImage(imagePath, cancellationToken);

    return {
      'analysis': analysis,
      'processed_at': DateTime.now().toIso8601String(),
    };
  }

  /// Handle text summary task
  Future<Map<String, dynamic>> _handleTextSummary(Task task) async {
    final text = task.data['text'] as String;
    final cancellationToken = CancellationToken();

    final summary = await _aiService.summarizeText(text, cancellationToken);

    return {
      'summary': summary,
      'processed_at': DateTime.now().toIso8601String(),
    };
  }

  /// Handle mood analysis task
  Future<Map<String, dynamic>> _handleMoodAnalysis(Task task) async {
    final text = task.data['text'] as String;
    final cancellationToken = CancellationToken();

    final moodAnalysis = await _aiService.analyzeMood(text, cancellationToken);

    return {
      'mood_score': modeAnalysis.moodScore,
      'primary_mood': moodAnalysis.primaryMood,
      'confidence_score': moodAnalysis.confidenceScore,
      'mood_keywords': moodAnalysis.moodKeywords,
      'processed_at': DateTime.now().toIso8601String(),
    };
  }

  /// Handle tag generation task
  Future<Map<String, dynamic>> _handleTagGeneration(Task task) async {
    final text = task.data['text'] as String;
    final cancellationToken = CancellationToken();

    final tags = await _aiService.generateTags(text, cancellationToken);

    return {
      'tags': tags,
      'processed_at': DateTime.now().toIso8601String(),
    };
  }
}
```

## 5. Security Implementation

### 5.1 Basic Security Strategy

#### 5.1.1 Simple Password Authentication

```dart
class AuthenticationService {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<bool> authenticateUser(String inputPassword) async {
    final storedPassword = await _secureStorage.read(key: 'user_password');
    return inputPassword == storedPassword;
  }

  Future<void> setPassword(String password) async {
    await _secureStorage.write(key: 'user_password', value: password);
  }
}
```

#### 5.1.2 Basic Data Protection

```dart
class BasicSecurityService {
  // Simple password validation
  bool isValidPassword(String password) {
    return password.length >= 4 && password.length <= 6 && password.contains(RegExp(r'^[0-9]+$'));
  }

  // Basic retry limitation
  int _failedAttempts = 0;
  static const int maxAttempts = 5;

  Future<bool> canAttemptLogin() async {
    return _failedAttempts < maxAttempts;
  }

  void recordFailedAttempt() {
    _failedAttempts++;
  }

  void resetFailedAttempts() {
    _failedAttempts = 0;
  }
}
```

## 6. Data Flow Architecture

### 6.1 Moment Creation Flow

```
User Input → Input Validation → Local Storage → Background AI Processing → Vector Generation → Update UI
```

#### 6.1.1 Detailed Flow

1. **User Creates Moment**

   - Voice: Record audio → Save to local storage
   - Text: Direct input → Save to database
   - Image/Video: Capture → Compress → Save to local storage

2. **Immediate Storage**

   - Insert moment record into SQLite
   - Save media files to local storage
   - Queue AI processing tasks

3. **Background Processing**

   - Speech-to-text conversion
   - Image content analysis
   - Mood analysis
   - Tag generation
   - Vector embedding creation

4. **Vector Storage**
   - Generate embeddings for all text content
   - Store in Chroma database
   - Update moment with AI results

### 6.2 Search Flow

```
User Query → Query Processing → Vector Search → Result Ranking → AI Summarization → Display Results
```

#### 6.2.1 Search Implementation

```dart
class SearchService {
  final ChromaDatabase _vectorDB;
  final AIService _aiService;

  Future<List<SearchResult>> search(String query) async {
    // Generate query embedding
    final queryEmbedding = await _aiService.generateEmbedding(query);

    // Perform vector search
    final vectorResults = await _vectorDB.similaritySearch(
      queryEmbedding,
      limit: 50,
      threshold: 0.7,
    );

    // Fetch full moment data
    final searchResults = await _fetchMomentDetails(vectorResults);

    // Rank results by relevance and recency
    final rankedResults = _rankResults(searchResults, query);

    // Generate AI summary if multiple results
    if (rankedResults.length > 3) {
      final summary = await _aiService.summarizeSearchResults(rankedResults);
      return [SearchResult.summary(summary), ...rankedResults];
    }

    return rankedResults;
  }
}
```

## 7. Simple LLM Analysis Service Architecture

### 7.1 LLM Analysis Data Models

#### 7.1.1 Core LLM Analysis Models

```dart
class LLMAnalysis {
  final String id;
  final String momentId;
  final AnalysisType type;
  final String content;
  final double confidenceScore;
  final DateTime createdAt;
}

enum AnalysisType {
  mood,         // Mood analysis
  summary,      // Content summarization
  expansion,    // Content expansion
  searchInsight // Search insights
}

class AnalysisResult {
  final String analysis;
  final double confidence;
  final List<String> tags;
  final Map<String, dynamic> metadata;
}
```

### 7.2 LLM Analysis Service Implementation

#### 7.2.1 Simple LLM Analysis Service

```dart
class SimpleLLMAnalysisService {
  final AIService _aiService;
  final Database _database;

  Future<AnalysisResult> analyzeMoment(String momentId) async {
    final moment = await _database.getMoment(momentId);

    // Use Gemma 3n for simple analysis
    final analysis = await _aiService.analyzeContent(moment.content);

    // Save analysis result
    await _database.insertLLMAnalysis(
      LLMAnalysis(
        momentId: momentId,
        type: AnalysisType.mood,
        content: analysis.analysis,
        confidenceScore: analysis.confidence,
        createdAt: DateTime.now(),
      ),
    );

    return analysis;
  }

  Future<AnalysisResult> expandText(String text) async {
    // Use Gemma 3n for text expansion
    return await _aiService.expandText(text);
  }

  Future<AnalysisResult> summarizeContent(String content) async {
    // Use Gemma 3n for content summarization
    return await _aiService.summarizeContent(content);
  }
}
```

#### 7.2.2 Asynchronous Processing Queue Management

```dart
class AsyncProcessingQueue {
  final AIService _aiService;
  final Database _database;
  final StreamController<ProcessingStatus> _statusController;

  Future<void> addToQueue(ProcessingTask task) async {
    // Set priority based on task type
    final priority = _getTaskPriority(task.type);

    await _database.insertProcessingTask(
      ProcessingTask(
        id: task.id,
        type: task.type,
        priority: priority,
        status: ProcessingStatus.pending,
        momentId: task.momentId,
        createdAt: DateTime.now(),
      ),
    );

    // Notify UI updates
    _statusController.add(ProcessingStatus.pending);
  }

  int _getTaskPriority(TaskType type) {
    switch (type) {
      case TaskType.userInitiated:
        return 3; // Highest priority
      case TaskType.autoProcessing:
        return 2; // Medium priority
      case TaskType.analysis:
        return 1; // Low priority
    }
  }

  Future<void> processQueue() async {
    final pendingTasks = await _database.getPendingTasks();

    for (final task in pendingTasks) {
      try {
        await _processTask(task);
        await _database.updateTaskStatus(task.id, ProcessingStatus.completed);
      } catch (e) {
        await _database.updateTaskStatus(task.id, ProcessingStatus.failed);
        await _handleProcessingError(task, e);
      }
    }
  }

  Future<void> _processTask(ProcessingTask task) async {
    switch (task.type) {
      case TaskType.speechToText:
        await _processSpeechToText(task);
        break;
      case TaskType.imageAnalysis:
        await _processImageAnalysis(task);
        break;
      case TaskType.textExpansion:
        await _processTextExpansion(task);
        break;
    }
  }
}
```

## 8. Logging System

### 8.1 Using the logger library

```dart
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 8,
      lineLength: 80,
      noBoxingByDefault: true,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static final Logger logs = _logger;

  static void info(String message) {
    _logger.i(message);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void debug(String message) {
    _logger.d(message);
  }

  static void warn(String message) {
    _logger.w(message);
  }

  static void verbose(String message) {
    _logger.v(message);
  }
}
```

This technical architecture document provides a comprehensive foundation for implementing DiaryX with robust security, scalable architecture, and intelligent AI integration while maintaining the offline-first principle and user privacy focus.
