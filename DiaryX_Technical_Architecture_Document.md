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
│   ├── entry.dart
│   ├── media_attachment.dart
│   ├── tag.dart
│   └── emotion_analysis.dart
├── stores/          # State management
│   ├── entry_store.dart
│   ├── auth_store.dart
│   └── search_store.dart
├── pages/           # Screen pages
│   ├── screens/
│   ├── views/
│   └── app_routes.dart
├── services/        # Business services
│   ├── database_service.dart
│   ├── ai_service.dart
│   ├── auth_service.dart
│   └── media_service.dart
├── utils/           # Utility functions
│   ├── date_helper.dart
│   ├── file_helper.dart
│   └── app_logger.dart
├── widgets/         # Reusable components
│   ├── common/
│   └── custom/
├── themes/          # Style themes
│   ├── app_theme.dart
│   ├── app_colors.dart
│   ├── colors.dart
│   └── text_styles.dart
└── consts/          # Configuration constants
    ├── api_urls.dart
    └── env_config.dart
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

### 2.5 Background Processing
```
Background Service Architecture:
├── Task Queue Manager
│   ├── Priority Queue (High: User-initiated, Medium: Auto-processing, Low: Analytics)
│   ├── Retry Logic (Exponential backoff)
│   └── Error Handling
├── AI Processing Workers
│   ├── Speech-to-Text Worker
│   ├── Image Analysis Worker
│   ├── Text Enhancement Worker
│   └── Vector Generation Worker
└── Progress Notification System
```

### 2.4 Routing Management
```dart
// Route constants - pages/app_routes.dart
class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String capture = '/capture';
  static const String timeline = '/timeline';
  static const String report = '/report';
  static const String search = '/search';
  static const String profile = '/profile';
  static const String entryDetail = '/entry';
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
    if (settings.name == AppRoutes.entryDetail) {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => EntryDetailScreen(entry: args['entry']),
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
// Diary entries table
@DataClassName('Entry')
class Entries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  TextColumn get contentType => textEnum<ContentType>()(); // 'text', 'voice', 'image', 'video', 'mixed'
  TextColumn get mood => text().nullable()(); // User-selected mood
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get aiProcessed => boolean().withDefault(const Constant(false))();
}

// Media attachments table
@DataClassName('MediaAttachment')
class MediaAttachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId => integer().references(Entries, #id)();
  TextColumn get filePath => text()();
  TextColumn get mediaType => textEnum<MediaType>()(); // 'image', 'video', 'audio'
  IntColumn get fileSize => integer().nullable()();
  RealColumn get duration => real().nullable()(); // Video/audio duration in seconds
  TextColumn get thumbnailPath => text().nullable()();
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

// Entry-tag association table
@DataClassName('EntryTag')
class EntryTags extends Table {
  IntColumn get entryId => integer().references(Entries, #id)();
  IntColumn get tagId => integer().references(Tags, #id)();

  @override
  Set<Column> get primaryKey => {entryId, tagId};
}

// AI processing queue table
@DataClassName('ProcessingTask')
class AiProcessingQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId => integer().references(Entries, #id)();
  TextColumn get taskType => textEnum<TaskType>()(); // 'speech_to_text', 'image_analysis', 'text_expansion'
  TextColumn get status => textEnum<ProcessingStatus>()(); // 'pending', 'processing', 'completed', 'failed'
  IntColumn get priority => integer().withDefault(const Constant(1))(); // 1=low, 2=medium, 3=high
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get processedAt => dateTime().nullable()();
}

// Vector embedding storage table
@DataClassName('Embedding')
class Embeddings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId => integer().references(Entries, #id)();
  BlobColumn get embeddingData => blob()(); // 768-dimensional vector
  TextColumn get embeddingType => textEnum<EmbeddingType>()(); // 'text', 'image', 'audio'
  DateTimeColumn get createdAt => dateTime()();
}

// Emotion analysis results table
@DataClassName('EmotionAnalysis')
class EmotionAnalysis extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId => integer().references(Entries, #id)();
  RealColumn get emotionScore => real().nullable()(); // -1.0 to 1.0 (negative to positive)
  TextColumn get primaryEmotion => text().nullable()(); // 'happy', 'sad', 'anxious', 'excited', 'neutral', etc.
  RealColumn get confidenceScore => real().nullable()(); // 0.0 to 1.0
  TextColumn get emotionKeywords => text().nullable()(); // JSON array of emotion-related keywords
  DateTimeColumn get analysisTimestamp => dateTime()();
}

// LLM analysis records table
@DataClassName('LLMAnalysis')
class LlmAnalysis extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId => integer().references(Entries, #id)();
  TextColumn get analysisType => textEnum<AnalysisType>()(); // 'emotion', 'summary', 'expansion', 'search_insight'
  TextColumn get analysisContent => text()();
  RealColumn get confidenceScore => real().nullable()(); // 0.0 to 1.0
  DateTimeColumn get createdAt => dateTime()();
}
```

#### 3.1.2 Enum Definitions
```dart
enum ContentType { text, voice, image, video, mixed }
enum MediaType { image, video, audio }
enum TaskType { speechToText, imageAnalysis, textExpansion }
enum ProcessingStatus { pending, processing, completed, failed }
enum EmbeddingType { text, image, audio }
enum AnalysisType { emotion, summary, expansion, searchInsight }
```

### 3.2 Vector Database Design (Chroma)

#### 3.2.1 Collections Structure
```python
# Entry embeddings collection
collection_name: "diary_entries"
embedding_dimension: 768  # Based on sentence-transformers models
metadata_schema: {
    "entry_id": int,
    "content_type": str,  # 'text', 'speech_transcript', 'image_description'
    "created_at": int,
    "mood": str,
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
- **Text Content**: Direct embedding of diary text
- **Speech Content**: Embedding of transcribed text
- **Image Content**: Embedding of AI-generated image descriptions
- **Video Content**: Embedding of extracted frame descriptions
- **Mixed Content**: Concatenated embeddings with weighted averaging

## 4. AI Integration Architecture

### 4.1 LLM Service Interface

#### 4.1.1 Abstract LLM Service
```dart
abstract class LLMService {
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

#### 4.1.2 AIService Implementation
```dart
abstract class AIService {
  // Speech to text
  Future<String> transcribeAudio(String audioPath);

  // Text enhancement
  Future<String> enhanceText(String originalText);

  // Text summarization
  Future<String> summarizeText(String text);

  // Image content analysis
  Future<String> analyzeImageContent(String imagePath);

  // Emotion analysis
  Future<EmotionAnalysis> analyzeEmotion(String text);

  // Tag generation
  Future<List<String>> generateTags(String content);

  // Search result summarization
  Future<String> summarizeSearchResults(List<SearchResult> results);

  // Streaming chat completion
  Stream<String> streamChatCompletion(List<ChatMessage> messages);

  // Content analysis
  Future<AnalysisResult> analyzeContent(String content);

  // Generate vector embeddings
  Future<List<double>> generateEmbedding(String text);
}

// Concrete implementation
class AIServiceImpl implements AIService {
  final LLMService _llmService;

  AIServiceImpl(this._llmService);

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

    final response = await _llmService.chatCompletion(messages);
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

    return await _llmService.chatCompletion(messages);
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

    return await _llmService.chatCompletion(messages);
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

    return await _llmService.chatCompletion(messages);
  }

  @override
  Future<EmotionAnalysis> analyzeEmotion(String text) async {
    final messages = [
      ChatMessage(
        role: 'system',
        content: '''You are an emotion analysis expert, responsible for analyzing the emotional state of text.
Please return the analysis result in JSON format:
{
  "emotion_score": -0.5, // -1.0 to 1.0, negative values indicate negative emotions
  "primary_emotion": "sad",
  "confidence_score": 0.8,
  "emotion_keywords": ["disappointed", "frustrated"]
}''',
      ),
      ChatMessage(
        role: 'user',
        content: 'Please analyze the emotions in the following text:\n\n$text',
      ),
    ];

    final response = await _llmService.chatCompletion(messages);
    return _parseEmotionAnalysis(response);
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

    final response = await _llmService.chatCompletion(messages);
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

    return await _llmService.chatCompletion(messages);
  }

  @override
  Stream<String> streamChatCompletion(List<ChatMessage> messages) async* {
    await for (final chunk in _llmService.streamChatCompletion(messages)) {
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

    final response = await _llmService.chatCompletion(messages);
    return _parseAnalysisResult(response);
  }

  @override
  Future<List<double>> generateEmbedding(String text) async {
    return await _llmService.generateEmbedding(text);
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

  EmotionAnalysis _parseEmotionAnalysis(String response) {
    // TODO: Parse emotion analysis JSON response
    return EmotionAnalysis(
      entryId: 0,
      emotionScore: 0.0,
      primaryEmotion: 'neutral',
      confidenceScore: 0.8,
      emotionKeywords: '[]',
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
class MockAIService implements AIService {
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
  Future<EmotionAnalysis> analyzeEmotion(String text) async {
    return EmotionAnalysis(
      entryId: 0,
      emotionScore: 0.2,
      primaryEmotion: 'neutral',
      confidenceScore: 0.8,
      emotionKeywords: '["neutral", "calm"]',
      analysisTimestamp: DateTime.now(),
    );
  }

  @override
  Future<List<String>> generateTags(String content) async {
    return ["mock", "tag", "sample", "content"];
  }

  @override
  Future<String> summarizeSearchResults(List<SearchResult> results) async {
    return "Mock search summary: Found ${results.length} relevant entries.";
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

### 4.2 Processing Queue System

#### 4.2.1 Queue Manager
```dart
class AIProcessingQueue {
  final Database _database;
  final AIService _aiService;
  final Queue<ProcessingTask> _highPriorityQueue = Queue();
  final Queue<ProcessingTask> _mediumPriorityQueue = Queue();
  final Queue<ProcessingTask> _lowPriorityQueue = Queue();

  bool _isProcessing = false;

  Future<void> addTask(ProcessingTask task) async {
    await _database.insertProcessingTask(task);
    _enqueueTask(task);
    _processNextTask();
  }

  // Automatically add emotion analysis task for new entries
  Future<void> addEmotionAnalysisTask(int entryId, String content) async {
    final task = ProcessingTask(
      id: _generateTaskId(),
      entryId: entryId,
      type: TaskType.emotion_analysis,
      priority: TaskPriority.low,
      parameters: {'content': content},
      createdAt: DateTime.now(),
      attempts: 0,
    );

    await addTask(task);
  }

  Future<void> _processNextTask() async {
    if (_isProcessing) return;

    final task = _getNextTask();
    if (task == null) return;

    _isProcessing = true;

    try {
      final result = await _executeTask(task);
      await _database.updateTaskStatus(task.id, 'completed', result);

      // If this was an emotion analysis task, store the results
      if (task.type == TaskType.emotion_analysis) {
        await _storeEmotionAnalysisResult(task.entryId, result);
      }
    } catch (e) {
      await _handleTaskError(task, e);
    } finally {
      _isProcessing = false;
      _processNextTask(); // Process next task
    }
  }

  Future<void> _storeEmotionAnalysisResult(int entryId, dynamic result) async {
    final emotionAnalysis = EmotionAnalysis(
      entryId: entryId,
      emotionScore: result['emotion_score'],
      primaryEmotion: result['primary_emotion'],
      confidenceScore: result['confidence_score'],
      emotionKeywords: result['emotion_keywords'],
      analysisTimestamp: DateTime.now().millisecondsSinceEpoch,
    );

    await _database.insertEmotionAnalysis(emotionAnalysis);
  }
}
```

#### 4.2.2 Task Prioritization
```dart
enum TaskPriority {
  high(3),    // User-initiated actions (text enhancement, manual search)
  medium(2),  // Automatic processing (speech-to-text, image analysis)
  low(1);     // Background analytics (emotion analysis, tag generation)

  const TaskPriority(this.value);
  final int value;
}

class ProcessingTask {
  final String id;
  final int entryId;
  final TaskType type;
  final TaskPriority priority;
  final Map<String, dynamic> parameters;
  final DateTime createdAt;
  final int attempts;
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

### 6.1 Entry Creation Flow
```
User Input → Input Validation → Local Storage → Background AI Processing → Vector Generation → Update UI
```

#### 6.1.1 Detailed Flow
1. **User Creates Entry**
   - Voice: Record audio → Save to local storage
   - Text: Direct input → Save to database
   - Image/Video: Capture → Compress → Save to local storage

2. **Immediate Storage**
   - Insert entry record into SQLite
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
   - Update entry with AI results

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

    // Fetch full entry data
    final searchResults = await _fetchEntryDetails(vectorResults);

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
  final String entryId;
  final AnalysisType type;
  final String content;
  final double confidenceScore;
  final DateTime createdAt;
}

enum AnalysisType {
  emotion,      // Emotion analysis
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

  Future<AnalysisResult> analyzeEntry(String entryId) async {
    final entry = await _database.getEntry(entryId);

    // Use Gemma 3n for simple analysis
    final analysis = await _aiService.analyzeContent(entry.content);

    // Save analysis result
    await _database.insertLLMAnalysis(
      LLMAnalysis(
        entryId: entryId,
        type: AnalysisType.emotion,
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
        entryId: task.entryId,
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
