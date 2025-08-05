import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';

import '../consts/env_config.dart';
import '../utils/app_logger.dart';
import '../models/media_attachment.dart';
import 'tables/moments_table.dart';
import 'tables/media_attachments_table.dart';
import 'tables/tags_table.dart';
import 'tables/moment_moods_table.dart';
import 'tables/key_values_table.dart';
import 'tables/task_queue_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Moments,
    MediaAttachments,
    Tags,
    MomentTags,
    MomentMoods,
    KeyValues,
    TaskQueue,
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
    if (kDebugMode) {
      AppLogger.database('SELECT', 'moments');
    }
    return await select(moments).get();
  }

  Future<MomentData?> getMomentById(int id) async {
    if (kDebugMode) {
      AppLogger.database('SELECT BY ID', 'moments', {'id': id});
    }
    return await (select(
      moments,
    )..where((moment) => moment.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertMoment(MomentsCompanion moment) async {
    if (kDebugMode) {
      AppLogger.database('INSERT', 'moments', {'moment': moment.toString()});
    }
    return await into(moments).insert(moment);
  }

  Future<bool> updateMoment(MomentsCompanion moment) async {
    if (kDebugMode) {
      AppLogger.database('UPDATE', 'moments', {'moment': moment.toString()});
    }
    return await update(moments).replace(moment);
  }

  Future<int> deleteMoment(int id) async {
    if (kDebugMode) {
      AppLogger.database('DELETE', 'moments', {'id': id});
    }
    return await (delete(
      moments,
    )..where((moment) => moment.id.equals(id))).go();
  }

  // Media attachment operations
  Future<List<MediaAttachmentData>> getMediaAttachmentsByMomentId(
    int momentId,
  ) async {
    if (kDebugMode) {
      AppLogger.database('SELECT BY MOMENT ID', 'media_attachments', {
        'momentId': momentId,
      });
    }
    return await (select(
      mediaAttachments,
    )..where((media) => media.momentId.equals(momentId))).get();
  }

  Future<int> insertMediaAttachment(
    MediaAttachmentsCompanion attachment,
  ) async {
    if (kDebugMode) {
      AppLogger.database('INSERT', 'media_attachments', {
        'attachment': attachment.toString(),
      });
    }
    return await into(mediaAttachments).insert(attachment);
  }

  Future<int> deleteMediaAttachment(int id) async {
    if (kDebugMode) {
      AppLogger.database('DELETE', 'media_attachments', {'id': id});
    }
    return await (delete(
      mediaAttachments,
    )..where((media) => media.id.equals(id))).go();
  }

  // Tag operations
  Future<List<TagData>> getAllTags() async {
    if (kDebugMode) {
      AppLogger.database('SELECT', 'tags');
    }
    return await select(tags).get();
  }

  Future<TagData?> getTagByName(String name) async {
    if (kDebugMode) {
      AppLogger.database('SELECT BY NAME', 'tags', {'name': name});
    }
    return await (select(
      tags,
    )..where((tag) => tag.name.equals(name))).getSingleOrNull();
  }

  Future<int> insertTag(TagsCompanion tag) async {
    if (kDebugMode) {
      AppLogger.database('INSERT', 'tags', {'tag': tag.toString()});
    }
    return await into(tags).insert(tag);
  }

  // Moment-tag association operations
  Future<List<TagData>> getTagsForMoment(int momentId) async {
    if (kDebugMode) {
      AppLogger.database('SELECT TAGS FOR MOMENT', 'moment_tags', {
        'momentId': momentId,
      });
    }
    final query = select(tags).join([
      innerJoin(momentTags, momentTags.tagId.equalsExp(tags.id)),
    ])..where(momentTags.momentId.equals(momentId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(tags)).toList();
  }

  Future<void> addTagToMoment(int momentId, int tagId) async {
    if (kDebugMode) {
      AppLogger.database('INSERT', 'moment_tags', {
        'momentId': momentId,
        'tagId': tagId,
      });
    }
    await into(
      momentTags,
    ).insert(MomentTagsCompanion.insert(momentId: momentId, tagId: tagId));
  }

  Future<void> removeTagFromMoment(int momentId, int tagId) async {
    if (kDebugMode) {
      AppLogger.database('DELETE', 'moment_tags', {
        'momentId': momentId,
        'tagId': tagId,
      });
    }
    await (delete(
          momentTags,
        )..where((mt) => mt.momentId.equals(momentId) & mt.tagId.equals(tagId)))
        .go();
  }

  // Key-Value operations
  Future<String?> getValue(String key) async {
    if (kDebugMode) {
      AppLogger.database('SELECT BY KEY', 'key_values', {'key': key});
    }
    final result = await (select(
      keyValues,
    )..where((kv) => kv.key.equals(key))).getSingleOrNull();
    return result?.value;
  }

  Future<void> setValue(String key, String value) async {
    if (kDebugMode) {
      AppLogger.database('SET VALUE', 'key_values', {
        'key': key,
        'valueLength': value.length,
      });
    }
    final now = DateTime.now();

    final existing = await (select(
      keyValues,
    )..where((kv) => kv.key.equals(key))).getSingleOrNull();

    if (existing != null) {
      // Update existing
      await (update(keyValues)..where((kv) => kv.key.equals(key))).write(
        KeyValuesCompanion(value: Value(value), updatedAt: Value(now)),
      );
    } else {
      // Insert new
      await into(keyValues).insert(
        KeyValuesCompanion.insert(
          key: key,
          value: value,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
  }

  Future<void> deleteValue(String key) async {
    if (kDebugMode) {
      AppLogger.database('DELETE BY KEY', 'key_values', {'key': key});
    }
    await (delete(keyValues)..where((kv) => kv.key.equals(key))).go();
  }

  Future<Map<String, String>> getAllKeyValues() async {
    if (kDebugMode) {
      AppLogger.database('SELECT ALL', 'key_values');
    }
    final results = await select(keyValues).get();
    return {for (var kv in results) kv.key: kv.value};
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

    if (kDebugMode) {
      AppLogger.info('Database opened at: ${file.path}');
    }
    return NativeDatabase.createInBackground(file);
  });
}
