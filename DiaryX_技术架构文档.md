# DiaryX 技术架构文档

## 1. 技术栈概览

### 1.1 核心框架

- **Flutter 3.32.8**：跨平台移动应用框架
- **Dart SDK**：Flutter 3.32.8 的最新稳定版本
- **目标平台**：iOS 12.0+、Android API 21+（Android 5.0）

### 1.2 本地数据管理

- **数据库**：使用 Drift ORM 的 SQLite 结构化数据
- **向量数据库**：Chroma 用于语义搜索能力
- **文件存储**：媒体文件的原生设备存储
- **安全性**：基础数字密码保护

### 1.3 AI 和机器学习

- **LLM 集成**：Gemma 3n 模型接口
- **API 兼容性**：支持 Ollama 集成的 OpenAI 兼容 API
- **向量嵌入**：支持 768 维嵌入（现代模型的典型维度）
- **处理**：后台 AI 操作的异步队列系统

### 1.4 媒体和文件处理

- **相机**：camera 包用于照片/视频捕捉
- **音频**：record: 5.1.0 用于基础语音录制和播放
- **图像处理**：image 包用于压缩和操作
- **文件管理**：path_provider 用于文件系统访问

### 1.5 UI 和动画

- **动画**：Flutter 内置动画系统 + animations 包
- **玻璃拟态**：使用 BackdropFilter 的自定义实现
- **图表**：fl_chart 用于数据可视化
- **图标**：flutter_svg 用于矢量图标支持
- **字体排版**：禁止在文本样式中使用 letterSpacing，因为它会影响可读性和视觉美观
- **响应式布局**：避免固定宽高，使用 padding、Row、Column、Expanded、Flexible 等弹性布局组件以适应不同屏幕尺寸

### 1.6 数字密码认证

- **密码存储**：flutter_secure_storage 用于基础密码存储
- **密码验证**：简单的 4-6 位数字密码验证
- **基础安全**：简单的重试限制机制

## 2. 系统架构

### 2.1 架构模式

**简单的类 MVC 架构**

```
lib/
├── models/          # 数据模型
│   ├── moment.dart
│   ├── media_attachment.dart
│   ├── tag.dart
│   └── mood_analysis.dart
├── stores/          # 状态管理
│   ├── moment_store.dart
│   ├── auth_store.dart
│   └── search_store.dart
├── screens/         # 页面视图
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
├── databases/       # 数据库管理
│   ├── app_database.dart
│   └── tables/
│       ├── moments_table.dart
│       ├── media_attachments_table.dart
│       ├── tags_table.dart
│       ├── embeddings_table.dart
│       ├── analysis_tables.dart
│       └── task_queue_table.dart
├── services/        # 业务服务
│   ├── ai/          # 优化架构的AI服务
│   │   ├── ai_service.dart
│   │   ├── ai_service_manager.dart
│   │   ├── llm_service.dart
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
│   │       ├── ai_service_impl.dart
│   │       ├── ollama_service.dart
│   │       └── mock_ai_service.dart
│   ├── task/        # 通用任务队列系统
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
├── utils/           # 工具函数
│   ├── date_helper.dart
│   ├── file_helper.dart
│   └── app_logger.dart
├── widgets/         # 可复用组件
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
├── themes/          # 样式主题
│   ├── app_theme.dart
│   ├── app_colors.dart
│   ├── colors.dart
│   └── text_styles.dart
├── consts/          # 配置常量
│   ├── api_urls.dart
│   └── env_config.dart
└── app_routes.dart  # 应用路由配置
```

### 2.2 状态管理

- **全局状态**：Provider + ChangeNotifier 用于应用状态管理
- **本地状态**：StatefulWidget 用于简单 UI 状态
- **数据持久化**：SharedPreferences 用于用户设置和配置
- **异步状态**：FutureBuilder 和 StreamBuilder 用于异步数据展示
- **状态更新**：notifyListeners() 用于通知 UI 更新

### 2.3 服务管理

- **直接实例化**：在需要时直接创建服务实例
- **单例模式**：对于数据库、AI 服务等使用简单的单例模式
- **服务传递**：通过构造函数传递服务依赖
- **初始化**：在 main.dart 中进行全局服务初始化

### 2.5 通用任务队列系统

```
通用任务队列架构：
├── TaskService（单例）
│   ├── 任务队列接口（抽象）
│   │   ├── MemoryTaskQueue（内存实现）
│   │   └── DatabaseTaskQueue（持久化实现）
│   ├── 任务管理
│   │   ├── 基于优先级的处理（高/普通/低）
│   │   ├── 并发任务执行（可配置限制）
│   │   ├── 指数退避重试逻辑
│   │   └── 全面错误处理
│   ├── 任务处理器注册
│   │   ├── 按任务类型动态注册处理器
│   │   ├── 解耦的服务集成
│   │   └── 基于回调的任务执行
│   └── 状态跟踪和统计
│       ├── 实时任务状态更新
│       ├── 任务性能指标
│       └── 进度通知系统
├── AI服务集成（示例）
│   ├── 语音转文字任务
│   ├── 图像分析任务
│   ├── 文本增强任务
│   └── 向量生成任务
└── 数据库架构
    └── TaskQueue表及索引
```

### 2.4 路由管理

```dart
// 路由常量 - lib/app_routes.dart
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

// 简单路由配置 - main.dart
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
    // 处理需要参数的路由
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

## 3. 数据库设计

### 3.1 Drift 表模型定义

#### 3.1.1 核心表模型

```dart
// 日记时刻表
@DataClassName('MomentData')
class Moments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  TextColumn get aiSummary => text().nullable()(); // AI 生成的时刻摘要
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get aiProcessed => boolean().withDefault(const Constant(false))();
}

// 媒体附件表
@DataClassName('MediaAttachmentData')
class MediaAttachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get momentId => integer().references(Moments, #id)();
  TextColumn get filePath => text()();
  TextColumn get mediaType => textEnum<MediaType>()(); // 'image', 'video', 'audio'
  IntColumn get fileSize => integer().nullable()();
  RealColumn get duration => real().nullable()(); // 视频/音频时长（秒）
  TextColumn get thumbnailPath => text().nullable()();
  TextColumn get aiSummary => text().nullable()(); // AI 生成的媒体内容摘要
  BoolColumn get aiProcessed => boolean().withDefault(const Constant(false))(); // AI 是否已处理此媒体
  DateTimeColumn get createdAt => dateTime()();
}

// 标签表
@DataClassName('Tag')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get color => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

// 时刻标签关联表
@DataClassName('MomentTag')
class MomentTags extends Table {
  IntColumn get momentId => integer().references(Moments, #id)();
  IntColumn get tagId => integer().references(Tags, #id)();

  @override
  Set<Column> get primaryKey => {momentId, tagId};
}

// 时刻情绪关联表
@DataClassName('MomentMoodData')
class MomentMoods extends Table {
  IntColumn get momentId => integer().references(Moments, #id)();
  TextColumn get mood => text()(); // 情绪名称（来自 MoodType 枚举的字符串值）
  DateTimeColumn get createdAt => dateTime()(); // 此情绪关联创建的时间

  @override
  Set<Column> get primaryKey => {momentId, mood};
}

// AI 处理队列表已移除
// 所有 AI 处理任务现在通过通用任务队列系统处理

// 通用任务队列表
@TableIndex(name: 'idx_task_queue_status_priority', columns: {#status, #priority, #createdAt})
@TableIndex(name: 'idx_task_queue_type', columns: {#type})
@TableIndex(name: 'idx_task_queue_completed_at', columns: {#completedAt})
@DataClassName('TaskQueueData')
class TaskQueue extends Table {
  TextColumn get taskId => text()(); // 唯一任务标识符
  TextColumn get type => text()(); // 通用任务类型字符串
  IntColumn get priority => integer().withDefault(const Constant(0))();
  TextColumn get label => text()(); // 人类可读的任务标签
  TextColumn get status => text()(); // 'pending', 'running', 'completed', 'failed', 'cancelled', 'retrying'
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get data => text()(); // 任务数据（JSON字符串）
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get error => text().nullable()();
  TextColumn get result => text().nullable()(); // 任务结果（JSON字符串）

  @override
  Set<Column> get primaryKey => {taskId};
}

// 向量嵌入存储表
@DataClassName('Embedding')
class Embeddings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get momentId => integer().references(Moments, #id)();
  BlobColumn get embeddingData => blob()(); // 768维向量
  TextColumn get embeddingType => textEnum<EmbeddingType>()(); // 'text', 'image', 'audio'
  DateTimeColumn get createdAt => dateTime()();
}

// 心情分析结果表
@DataClassName('MoodAnalysis')
class MoodAnalysis extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get momentId => integer().references(Moments, #id)();
  RealColumn get moodScore => real().nullable()(); // -1.0 到 1.0（负面到正面）
  TextColumn get primaryMood => text().nullable()(); // 'happy', 'sad', 'anxious', 'excited', 'neutral', etc.
  RealColumn get confidenceScore => real().nullable()(); // 0.0 到 1.0
  TextColumn get moodKeywords => text().nullable()(); // 心情相关关键词的 JSON 数组
  DateTimeColumn get analysisTimestamp => dateTime()();
}

// LLM分析记录表
@DataClassName('LLMAnalysis')
class LlmAnalysis extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get momentId => integer().references(Moments, #id)();
  TextColumn get analysisType => textEnum<AnalysisType>()(); // 'mood', 'summary', 'expansion', 'search_insight'
  TextColumn get analysisContent => text()();
  RealColumn get confidenceScore => real().nullable()(); // 0.0 到 1.0
  DateTimeColumn get createdAt => dateTime()();
}
```

#### 3.1.2 枚举定义

```dart
enum ContentType { text, voice, image, video, mixed }
enum MediaType { image, video, audio }
enum EmbeddingType { text, image, audio }
enum AnalysisType { mood, summary, expansion, searchInsight }
// 注意：TaskType 和 ProcessingStatus 枚举已移除，通用任务队列使用基于字符串的类型
```

### 3.2 向量数据库设计（Chroma）

#### 3.2.1 集合结构

```python
# 时刻嵌入集合
collection_name: "diary_moments"
embedding_dimension: 768  # 基于 sentence-transformers 模型
metadata_schema: {
    "moment_id": int,
    "content_type": str,  # 'text', 'speech_transcript', 'image_description'
    "created_at": int,
    "mood": str,
    "tags": List[str]
}

# 搜索嵌入集合
collection_name: "search_queries"
embedding_dimension: 768
metadata_schema: {
    "query": str,
    "timestamp": int,
    "result_count": int
}
```

#### 3.2.2 向量生成策略

- **文本内容**：日记文本的直接嵌入
- **语音内容**：转录文本的嵌入
- **图像内容**：AI 生成图像描述的嵌入
- **视频内容**：提取帧描述的嵌入
- **混合内容**：带加权平均的连接嵌入

## 4. AI 集成架构

### 4.1 LLM 服务接口

#### 4.1.1 抽象 LLM 服务

```dart
abstract class LLMService {
  // 非流式对话补全
  Future<String> chatCompletion(List<ChatMessage> messages);

  // 流式对话补全
  Stream<String> streamChatCompletion(List<ChatMessage> messages);

  // 生成向量嵌入
  Future<List<double>> generateEmbedding(String text);
}

// 消息模型
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

#### 4.1.2 AIService 实现

```dart
abstract class AIService {
  // 语音转文字
  Future<String> transcribeAudio(String audioPath);

  // 文本增强
  Future<String> enhanceText(String originalText);

  // 文本总结
  Future<String> summarizeText(String text);

  // 图像内容分析
  Future<String> analyzeImageContent(String imagePath);

  // 情绪分析
  Future<MoodAnalysis> analyzeMood(String text);

  // 标签生成
  Future<List<String>> generateTags(String content);

  // 搜索总结
  Future<String> summarizeSearchResults(List<SearchResult> results);

  // 流式对话补全
  Stream<String> streamChatCompletion(List<ChatMessage> messages);

  // 内容分析
  Future<AnalysisResult> analyzeContent(String content);

  // 生成向量嵌入
  Future<List<double>> generateEmbedding(String text);
}

// 具体实现
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

    final response = await _llmService.chatCompletion(messages);
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

  // 辅助方法
  Future<String> _loadAudioAsBase64(String audioPath) async {
    // TODO: 实现音频文件转base64
    return 'base64_audio_data';
  }

  Future<String> _loadImageAsBase64(String imagePath) async {
    // TODO: 实现图片文件转base64
    return 'base64_image_data';
  }

  String _extractTranscription(String response) {
    // TODO: 从LLM响应中提取转录文本
    return response.trim();
  }

  MoodAnalysis _parseMoodAnalysis(String response) {
    // TODO: 解析心情分析JSON响应
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
    // TODO: 解析标签响应
    return response.split(',').map((tag) => tag.trim()).toList();
  }

  AnalysisResult _parseAnalysisResult(String response) {
    // TODO: 解析分析结果JSON响应
    return AnalysisResult(
      analysis: response,
      confidence: 0.8,
      tags: [],
      metadata: {},
    );
  }
}

// Mock实现
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

#### 4.1.3 Gemma 3n 实现

```dart
class Gemma3nService implements LLMService {
  final String _modelPath;
  final GemmaInferenceEngine _engine;

  Gemma3nService(this._modelPath) : _engine = GemmaInferenceEngine(_modelPath);

  @override
  Future<String> chatCompletion(List<ChatMessage> messages) async {
    // TODO: 实现Gemma 3n的对话补全
    final prompt = _formatMessagesToPrompt(messages);
    return await _engine.generateText(prompt);
  }

  @override
  Stream<String> streamChatCompletion(List<ChatMessage> messages) async* {
    // TODO: 实现Gemma 3n的流式对话补全
    final prompt = _formatMessagesToPrompt(messages);
    await for (final chunk in _engine.generateTextStream(prompt)) {
      yield chunk;
    }
  }

  @override
  Future<List<double>> generateEmbedding(String text) async {
    // TODO: 实现Gemma 3n的向量嵌入生成
    return await _engine.generateEmbedding(text);
  }

  String _formatMessagesToPrompt(List<ChatMessage> messages) {
    // 将消息格式化为Gemma 3n的输入格式
    return messages.map((msg) => '${msg.role}: ${msg.content}').join('\n');
  }
}
```

#### 4.1.4 Ollama 实现

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
    // TODO: 解析SSE格式的流式响应
    return chunk.toString();
  }
}
```

### 4.2 通用任务队列系统

#### 4.2.1 任务队列管理

所有 AI 处理任务现在通过位于 `lib/services/task/` 的通用任务队列系统进行管理。此系统提供：

- **解耦架构**：任务队列完全独立于 AI 服务
- **灵活的任务类型**：基于字符串的任务类型，支持动态扩展
- **优先级支持**：高、中、低优先级任务处理
- **持久化**：支持内存和数据库任务队列实现
- **状态跟踪**：实时任务状态更新和统计
- **错误处理**：重试机制和错误恢复

有关详细实现，请参阅 `lib/services/task/README.md`。

## 5. 安全实现

### 5.1 基础安全策略

#### 5.1.1 简单密码认证

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

#### 5.1.2 基础数据保护

```dart
class BasicSecurityService {
  // 简单密码验证
  bool isValidPassword(String password) {
    return password.length >= 4 && password.length <= 6 && password.contains(RegExp(r'^[0-9]+$'));
  }

  // 基础重试限制
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

## 6. 数据流架构

### 6.1 时刻创建流程

```
用户输入 → 输入验证 → 本地存储 → 后台 AI 处理 → 向量生成 → 更新 UI
```

#### 6.1.1 详细流程

1. **用户创建时刻**

   - 语音：录制音频 → 保存到本地存储
   - 文字：直接输入 → 保存到数据库
   - 图像/视频：捕捉 → 压缩 → 保存到本地存储

2. **即时存储**

   - 插入时刻记录到 SQLite
   - 保存媒体文件到本地存储
   - 队列 AI 处理任务

3. **后台处理**

   - 语音转文字转换
   - 图像内容分析
   - 情绪分析
   - 标签生成
   - 向量嵌入创建

4. **向量存储**
   - 为所有文本内容生成嵌入
   - 存储在 Chroma 数据库中
   - 用 AI 结果更新时刻

### 6.2 搜索流程

```
用户查询 → 查询处理 → 向量搜索 → 结果排名 → AI 总结 → 显示结果
```

#### 6.2.1 搜索实现

```dart
class SearchService {
  final ChromaDatabase _vectorDB;
  final AIService _aiService;

  Future<List<SearchResult>> search(String query) async {
    // 生成查询嵌入
    final queryEmbedding = await _aiService.generateEmbedding(query);

    // 执行向量搜索
    final vectorResults = await _vectorDB.similaritySearch(
      queryEmbedding,
      limit: 50,
      threshold: 0.7,
    );

    // 获取完整时刻数据
    final searchResults = await _fetchMomentDetails(vectorResults);

    // 按相关性和新鲜度排名结果
    final rankedResults = _rankResults(searchResults, query);

    // 如果多个结果，生成 AI 总结
    if (rankedResults.length > 3) {
      final summary = await _aiService.summarizeSearchResults(rankedResults);
      return [SearchResult.summary(summary), ...rankedResults];
    }

    return rankedResults;
  }
}
```

## 7. 简单 LLM 分析服务架构

### 7.1 LLM 分析数据模型

#### 7.1.1 核心 LLM 分析模型

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
  mood,      // 情绪分析
  summary,      // 内容总结
  expansion,    // 内容扩写
  searchInsight // 搜索洞察
}

class AnalysisResult {
  final String analysis;
  final double confidence;
  final List<String> tags;
  final Map<String, dynamic> metadata;
}
```

### 7.2 LLM 分析服务实现

#### 7.2.1 简单 LLM 分析服务

```dart
class SimpleLLMAnalysisService {
  final AIService _aiService;
  final Database _database;

  Future<AnalysisResult> analyzeMoment(String momentId) async {
    final moment = await _database.getMoment(momentId);

    // 使用Gemma 3n进行简单分析
    final analysis = await _aiService.analyzeContent(moment.content);

    // 保存分析结果
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
    // 使用Gemma 3n进行文本扩写
    return await _aiService.expandText(text);
  }

  Future<AnalysisResult> summarizeContent(String content) async {
    // 使用Gemma 3n进行内容总结
    return await _aiService.summarizeContent(content);
  }
}
```

#### 7.2.2 异步处理队列管理

```dart
class AsyncProcessingQueue {
  final AIService _aiService;
  final Database _database;
  final StreamController<ProcessingStatus> _statusController;

  Future<void> addToQueue(ProcessingTask task) async {
    // 根据任务类型设置优先级
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

    // 通知UI更新
    _statusController.add(ProcessingStatus.pending);
  }

  int _getTaskPriority(TaskType type) {
    switch (type) {
      case TaskType.userInitiated:
        return 3; // 最高优先级
      case TaskType.autoProcessing:
        return 2; // 中等优先级
      case TaskType.analysis:
        return 1; // 低优先级
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

## 8. 日志系统

### 8.1 使用 logger 库

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

本技术架构文档为实施 DiaryX 提供了全面的基础，具有强大的安全性、可扩展架构和智能 AI 集成，同时保持离线优先原则和用户隐私重点。
