import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';

import '../consts/env_config.dart';
import '../utils/app_logger.dart';
import '../models/moment.dart';
import '../models/media_attachment.dart';
import 'tables/moments_table.dart';
import 'tables/media_attachments_table.dart';
import 'tables/tags_table.dart';
import 'tables/ai_processing_table.dart';
import 'tables/embeddings_table.dart';
import 'tables/analysis_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Moments,
    MediaAttachments,
    Tags,
    MomentTags,
    AiProcessingQueue,
    Embeddings,
    EmotionAnalysisTable,
    LlmAnalysisTable,
  ],
)
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

  // Moment operations
  Future<List<MomentData>> getAllMoments() async {
    AppLogger.database('SELECT', 'moments');
    return await select(moments).get();
  }

  Future<MomentData?> getMomentById(int id) async {
    AppLogger.database('SELECT BY ID', 'moments', {'id': id});
    return await (select(
      moments,
    )..where((moment) => moment.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertMoment(MomentData moment) async {
    AppLogger.database('INSERT', 'moments', moment.toJson());
    return await into(moments).insert(moment);
  }

  Future<bool> updateMoment(MomentData moment) async {
    AppLogger.database('UPDATE', 'moments', moment.toJson());
    return await update(moments).replace(moment);
  }

  Future<int> deleteMoment(int id) async {
    AppLogger.database('DELETE', 'moments', {'id': id});
    return await (delete(
      moments,
    )..where((moment) => moment.id.equals(id))).go();
  }

  // Media attachment operations
  Future<List<MediaAttachmentData>> getMediaAttachmentsByMomentId(
    int momentId,
  ) async {
    AppLogger.database('SELECT BY MOMENT ID', 'media_attachments', {
      'momentId': momentId,
    });
    return await (select(
      mediaAttachments,
    )..where((media) => media.momentId.equals(momentId))).get();
  }

  Future<int> insertMediaAttachment(MediaAttachmentData attachment) async {
    AppLogger.database('INSERT', 'media_attachments', attachment.toJson());
    return await into(mediaAttachments).insert(attachment);
  }

  Future<int> deleteMediaAttachment(int id) async {
    AppLogger.database('DELETE', 'media_attachments', {'id': id});
    return await (delete(
      mediaAttachments,
    )..where((media) => media.id.equals(id))).go();
  }

  // Tag operations
  Future<List<TagData>> getAllTags() async {
    AppLogger.database('SELECT', 'tags');
    return await select(tags).get();
  }

  Future<TagData?> getTagByName(String name) async {
    AppLogger.database('SELECT BY NAME', 'tags', {'name': name});
    return await (select(
      tags,
    )..where((tag) => tag.name.equals(name))).getSingleOrNull();
  }

  Future<int> insertTag(TagData tag) async {
    AppLogger.database('INSERT', 'tags', tag.toJson());
    return await into(tags).insert(tag);
  }

  // Moment-tag association operations
  Future<List<TagData>> getTagsForMoment(int momentId) async {
    AppLogger.database('SELECT TAGS FOR MOMENT', 'moment_tags', {
      'momentId': momentId,
    });
    final query = select(tags).join([
      innerJoin(momentTags, momentTags.tagId.equalsExp(tags.id)),
    ])..where(momentTags.momentId.equals(momentId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(tags)).toList();
  }

  Future<void> addTagToMoment(int momentId, int tagId) async {
    AppLogger.database('INSERT', 'moment_tags', {
      'momentId': momentId,
      'tagId': tagId,
    });
    await into(
      momentTags,
    ).insert(MomentTagData(momentId: momentId, tagId: tagId));
  }

  Future<void> removeTagFromMoment(int momentId, int tagId) async {
    AppLogger.database('DELETE', 'moment_tags', {
      'momentId': momentId,
      'tagId': tagId,
    });
    await (delete(
          momentTags,
        )..where((mt) => mt.momentId.equals(momentId) & mt.tagId.equals(tagId)))
        .go();
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

  Future<bool> updateTaskStatus(
    int taskId,
    ProcessingStatus status, {
    String? errorMessage,
  }) async {
    AppLogger.database('UPDATE STATUS', 'ai_processing_queue', {
      'taskId': taskId,
      'status': status.name,
    });
    final result =
        await (update(
          aiProcessingQueue,
        )..where((task) => task.id.equals(taskId))).write(
          AiProcessingQueueCompanion(
            status: Value(status),
            processedAt: Value(DateTime.now()),
            errorMessage: Value(errorMessage),
          ),
        );
    return result > 0;
  }

  // Emotion analysis operations
  Future<EmotionAnalysisData?> getEmotionAnalysisForMoment(int momentId) async {
    AppLogger.database('SELECT BY MOMENT ID', 'emotion_analysis', {
      'momentId': momentId,
    });
    return await (select(
      emotionAnalysisTable,
    )..where((ea) => ea.momentId.equals(momentId))).getSingleOrNull();
  }

  Future<int> insertEmotionAnalysis(EmotionAnalysisData analysis) async {
    AppLogger.database('INSERT', 'emotion_analysis', analysis.toJson());
    return await into(emotionAnalysisTable).insert(analysis);
  }

  // Embedding operations
  Future<int> insertEmbedding(EmbeddingData embedding) async {
    AppLogger.database('INSERT', 'embeddings', {
      'momentId': embedding.momentId,
      'type': embedding.embeddingType.name,
    });
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
