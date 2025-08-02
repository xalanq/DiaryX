import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';

import '../models/entry.dart';
import '../models/media_attachment.dart';
import '../consts/env_config.dart';
import '../utils/app_logger.dart';

part 'database_service.g.dart';

// Entries table
@DataClassName('EntryData')
class Entries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  TextColumn get contentType => textEnum<ContentType>()();
  TextColumn get mood => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get aiProcessed => boolean().withDefault(const Constant(false))();
}

// Media attachments table
@DataClassName('MediaAttachmentData')
class MediaAttachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId => integer().references(Entries, #id)();
  TextColumn get filePath => text()();
  TextColumn get mediaType => textEnum<MediaType>()();
  IntColumn get fileSize => integer().nullable()();
  RealColumn get duration => real().nullable()();
  TextColumn get thumbnailPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

// Tags table
@DataClassName('TagData')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get color => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

// Entry-tag association table
@DataClassName('EntryTagData')
class EntryTags extends Table {
  IntColumn get entryId => integer().references(Entries, #id)();
  IntColumn get tagId => integer().references(Tags, #id)();

  @override
  Set<Column> get primaryKey => {entryId, tagId};
}

// AI processing queue table
@DataClassName('ProcessingTaskData')
class AiProcessingQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId => integer().references(Entries, #id)();
  TextColumn get taskType => textEnum<TaskType>()();
  TextColumn get status => textEnum<ProcessingStatus>()();
  IntColumn get priority => integer().withDefault(const Constant(1))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get processedAt => dateTime().nullable()();
}

// Vector embedding storage table
@DataClassName('EmbeddingData')
class Embeddings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId => integer().references(Entries, #id)();
  BlobColumn get embeddingData => blob()();
  TextColumn get embeddingType => textEnum<EmbeddingType>()();
  DateTimeColumn get createdAt => dateTime()();
}

// Emotion analysis results table
@DataClassName('EmotionAnalysisData')
class EmotionAnalysisTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId => integer().references(Entries, #id)();
  RealColumn get emotionScore => real().nullable()();
  TextColumn get primaryEmotion => text().nullable()();
  RealColumn get confidenceScore => real().nullable()();
  TextColumn get emotionKeywords => text().nullable()();
  DateTimeColumn get analysisTimestamp => dateTime()();
}

// LLM analysis records table
@DataClassName('LLMAnalysisData')
class LlmAnalysisTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId => integer().references(Entries, #id)();
  TextColumn get analysisType => textEnum<AnalysisType>()();
  TextColumn get analysisContent => text()();
  RealColumn get confidenceScore => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

// Enum definitions for Drift
enum TaskType { speechToText, imageAnalysis, textExpansion }
enum ProcessingStatus { pending, processing, completed, failed }
enum EmbeddingType { text, image, audio }
enum AnalysisType { emotion, summary, expansion, searchInsight }

@DriftDatabase(tables: [
  Entries,
  MediaAttachments,
  Tags,
  EntryTags,
  AiProcessingQueue,
  Embeddings,
  EmotionAnalysisTable,
  LlmAnalysisTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => EnvConfig.databaseVersion;

  // Singleton pattern
  static AppDatabase? _instance;
  static AppDatabase get instance {
    _instance ??= AppDatabase();
    return _instance!;
  }

  // Entry operations
  Future<List<EntryData>> getAllEntries() async {
    AppLogger.database('SELECT', 'entries');
    return await select(entries).get();
  }

  Future<EntryData?> getEntryById(int id) async {
    AppLogger.database('SELECT BY ID', 'entries', {'id': id});
    return await (select(entries)..where((entry) => entry.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertEntry(EntryData entry) async {
    AppLogger.database('INSERT', 'entries', entry.toJson());
    return await into(entries).insert(entry);
  }

  Future<bool> updateEntry(EntryData entry) async {
    AppLogger.database('UPDATE', 'entries', entry.toJson());
    return await update(entries).replace(entry);
  }

  Future<int> deleteEntry(int id) async {
    AppLogger.database('DELETE', 'entries', {'id': id});
    return await (delete(entries)..where((entry) => entry.id.equals(id))).go();
  }

  // Media attachment operations
  Future<List<MediaAttachmentData>> getMediaAttachmentsByEntryId(int entryId) async {
    AppLogger.database('SELECT BY ENTRY ID', 'media_attachments', {'entryId': entryId});
    return await (select(mediaAttachments)..where((media) => media.entryId.equals(entryId))).get();
  }

  Future<int> insertMediaAttachment(MediaAttachmentData attachment) async {
    AppLogger.database('INSERT', 'media_attachments', attachment.toJson());
    return await into(mediaAttachments).insert(attachment);
  }

  Future<int> deleteMediaAttachment(int id) async {
    AppLogger.database('DELETE', 'media_attachments', {'id': id});
    return await (delete(mediaAttachments)..where((media) => media.id.equals(id))).go();
  }

  // Tag operations
  Future<List<TagData>> getAllTags() async {
    AppLogger.database('SELECT', 'tags');
    return await select(tags).get();
  }

  Future<TagData?> getTagByName(String name) async {
    AppLogger.database('SELECT BY NAME', 'tags', {'name': name});
    return await (select(tags)..where((tag) => tag.name.equals(name))).getSingleOrNull();
  }

  Future<int> insertTag(TagData tag) async {
    AppLogger.database('INSERT', 'tags', tag.toJson());
    return await into(tags).insert(tag);
  }

  // Entry-tag association operations
  Future<List<TagData>> getTagsForEntry(int entryId) async {
    AppLogger.database('SELECT TAGS FOR ENTRY', 'entry_tags', {'entryId': entryId});
    final query = select(tags).join([
      innerJoin(entryTags, entryTags.tagId.equalsExp(tags.id)),
    ])..where(entryTags.entryId.equals(entryId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(tags)).toList();
  }

  Future<void> addTagToEntry(int entryId, int tagId) async {
    AppLogger.database('INSERT', 'entry_tags', {'entryId': entryId, 'tagId': tagId});
    await into(entryTags).insert(EntryTagData(entryId: entryId, tagId: tagId));
  }

  Future<void> removeTagFromEntry(int entryId, int tagId) async {
    AppLogger.database('DELETE', 'entry_tags', {'entryId': entryId, 'tagId': tagId});
    await (delete(entryTags)..where((et) => et.entryId.equals(entryId) & et.tagId.equals(tagId))).go();
  }

  // Processing queue operations
  Future<List<ProcessingTaskData>> getPendingTasks() async {
    AppLogger.database('SELECT PENDING', 'ai_processing_queue');
    // TODO: Fix enum type issue in Phase 6
    return await select(aiProcessingQueue).get();
  }

  Future<int> insertProcessingTask(ProcessingTaskData task) async {
    AppLogger.database('INSERT', 'ai_processing_queue', task.toJson());
    return await into(aiProcessingQueue).insert(task);
  }

  Future<bool> updateTaskStatus(int taskId, ProcessingStatus status, {String? errorMessage}) async {
    AppLogger.database('UPDATE STATUS', 'ai_processing_queue', {'taskId': taskId, 'status': status.name});
    final result = await (update(aiProcessingQueue)..where((task) => task.id.equals(taskId)))
        .write(AiProcessingQueueCompanion(
      status: Value(status),
      processedAt: Value(DateTime.now()),
      errorMessage: Value(errorMessage),
    ));
    return result > 0;
  }

  // Emotion analysis operations
  Future<EmotionAnalysisData?> getEmotionAnalysisForEntry(int entryId) async {
    AppLogger.database('SELECT BY ENTRY ID', 'emotion_analysis', {'entryId': entryId});
    return await (select(emotionAnalysisTable)..where((ea) => ea.entryId.equals(entryId))).getSingleOrNull();
  }

  Future<int> insertEmotionAnalysis(EmotionAnalysisData analysis) async {
    AppLogger.database('INSERT', 'emotion_analysis', analysis.toJson());
    return await into(emotionAnalysisTable).insert(analysis);
  }

  // Embedding operations
  Future<int> insertEmbedding(EmbeddingData embedding) async {
    AppLogger.database('INSERT', 'embeddings', {'entryId': embedding.entryId, 'type': embedding.embeddingType.name});
    return await into(embeddings).insert(embedding);
  }

  Future<List<EmbeddingData>> getEmbeddingsByType(EmbeddingType type) async {
    AppLogger.database('SELECT BY TYPE', 'embeddings', {'type': type.name});
    // TODO: Fix enum type issue in Phase 6
    return await select(embeddings).get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, EnvConfig.databaseName));

    // Make sqlite3 available on Android and iOS
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    AppLogger.info('Database opened at: ${file.path}');
    return NativeDatabase.createInBackground(file);
  });
}
