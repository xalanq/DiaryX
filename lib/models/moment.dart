import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:drift/drift.dart' hide JsonKey;
import 'media_attachment.dart';
import 'mood.dart';

import '../databases/app_database.dart';
import '../utils/file_helper.dart';

part 'moment.freezed.dart';
part 'moment.g.dart';

/// Represents a diary moment in the application
@freezed
class Moment with _$Moment {
  const factory Moment({
    @Default(0) int id,
    required String content,
    String? aiSummary, // AI-generated summary of the moment
    @Default([])
    List<String> moods, // List of mood names associated with this moment
    @Default([]) List<String> tags, // List of tags associated with this moment
    @Default([]) List<MediaAttachment> images,
    @Default([]) List<MediaAttachment> audios,
    @Default([]) List<MediaAttachment> videos,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool aiProcessed,
  }) = _Moment;

  factory Moment.fromJson(Map<String, dynamic> json) => _$MomentFromJson(json);
}

/// Extension methods for Moment conversions and database operations
extension MomentExtensions on Moment {
  /// Convert from database MomentData to Moment
  static Future<Moment> fromMomentData(
    MomentData momentData,
    AppDatabase database,
  ) async {
    // Fetch all related data concurrently for better performance
    final results = await Future.wait([
      // Get all media attachments for this moment
      database.getMediaAttachmentsByMomentId(momentData.id),
      // Get all moods for this moment
      (database.select(
        database.momentMoods,
      )..where((mm) => mm.momentId.equals(momentData.id))).get(),
      // Get all tags for this moment
      database.getTagsForMoment(momentData.id),
    ]);

    final mediaAttachments = results[0] as List<MediaAttachmentData>;
    final moodAssociations = results[1] as List<MomentMoodData>;
    final tags = results[2] as List<String>;

    // Sort moods by MoodType enum order
    final moodStrings = moodAssociations.map((ma) => ma.mood).toList();
    moodStrings.sort((a, b) {
      final indexA = _getMoodTypeIndex(a);
      final indexB = _getMoodTypeIndex(b);
      return indexA.compareTo(indexB);
    });
    final moods = moodStrings;

    // Tags are already sorted from database query

    // Separate media by type
    final images = <MediaAttachment>[];
    final audios = <MediaAttachment>[];
    final videos = <MediaAttachment>[];

    for (final attachment in mediaAttachments) {
      // Convert relative paths from database to absolute paths for file access
      final absoluteFilePath = await FileHelper.toAbsolutePath(
        attachment.filePath,
      );
      final absoluteThumbnailPath = attachment.thumbnailPath != null
          ? await FileHelper.toAbsolutePath(attachment.thumbnailPath!)
          : null;

      final mediaAttachment = MediaAttachment(
        id: attachment.id,
        momentId: attachment.momentId,
        filePath: absoluteFilePath,
        mediaType: attachment.mediaType,
        fileSize: attachment.fileSize,
        duration: attachment.duration,
        thumbnailPath: absoluteThumbnailPath,
        aiSummary: attachment.aiSummary,
        aiProcessed: attachment.aiProcessed,
        createdAt: attachment.createdAt,
      );

      switch (attachment.mediaType) {
        case MediaType.image:
          images.add(mediaAttachment);
          break;
        case MediaType.audio:
          audios.add(mediaAttachment);
          break;
        case MediaType.video:
          videos.add(mediaAttachment);
          break;
      }
    }

    return Moment(
      id: momentData.id,
      content: momentData.content,
      aiSummary: momentData.aiSummary,
      moods: moods,
      tags: tags,
      images: images,
      audios: audios,
      videos: videos,
      createdAt: momentData.createdAt,
      updatedAt: momentData.updatedAt,
      aiProcessed: momentData.aiProcessed,
    );
  }

  /// Convert to database MomentData
  MomentData toMomentData() {
    return MomentData(
      id: id,
      content: content,
      aiSummary: aiSummary,
      createdAt: createdAt,
      updatedAt: updatedAt,
      aiProcessed: aiProcessed,
    );
  }

  /// Save moment and its media attachments to database
  Future<int> save(AppDatabase database) async {
    int momentId;
    if (id == 0) {
      // Insert new moment using Companion
      final companion = MomentsCompanion.insert(
        content: content,
        aiSummary: Value(aiSummary),
        createdAt: createdAt,
        updatedAt: updatedAt,
        aiProcessed: Value(aiProcessed),
      );
      momentId = await database.insertMoment(companion);
    } else {
      // Update existing moment using Companion
      final companion = MomentsCompanion(
        id: Value(id),
        content: Value(content),
        aiSummary: Value(aiSummary),
        createdAt: Value(createdAt),
        updatedAt: Value(updatedAt),
        aiProcessed: Value(aiProcessed),
      );
      await database.updateMoment(companion);
      momentId = id;
    }

    // Handle media attachments - process new media concurrently
    final allMedia = [...images, ...audios, ...videos];
    final newMediaFutures = <Future<void>>[];

    for (final media in allMedia) {
      if (media.id == 0) {
        // Create concurrent media insertion future
        final future = _insertMediaAttachment(database, media, momentId);
        newMediaFutures.add(future);
      }
    }

    // Wait for all media insertions to complete concurrently
    if (newMediaFutures.isNotEmpty) {
      await Future.wait(newMediaFutures);
    }

    // Handle mood and tag associations concurrently
    final associationFutures = <Future<void>>[];

    // Handle mood associations
    if (id == 0) {
      // For new moments, insert all mood associations concurrently
      if (moods.isNotEmpty) {
        associationFutures.add(
          _insertMoodAssociations(database, momentId, moods),
        );
      }
    } else {
      // For existing moments, replace all mood associations
      associationFutures.add(
        _replaceMoodAssociations(database, momentId, moods),
      );
    }

    // Handle tag associations
    if (id == 0) {
      // For new moments, insert all tag associations
      if (tags.isNotEmpty) {
        associationFutures.add(
          _insertTagAssociations(database, momentId, tags),
        );
      }
    } else {
      // For existing moments, replace all tag associations
      associationFutures.add(_replaceTagAssociations(database, momentId, tags));
    }

    // Wait for all association operations to complete concurrently
    if (associationFutures.isNotEmpty) {
      await Future.wait(associationFutures);
    }

    return momentId;
  }

  /// Helper method to insert a single media attachment
  static Future<void> _insertMediaAttachment(
    AppDatabase database,
    MediaAttachment media,
    int momentId,
  ) async {
    // Convert absolute paths to relative paths for database storage
    final relativeFilePath = await FileHelper.toRelativePath(media.filePath);
    final relativeThumbnailPath = media.thumbnailPath != null
        ? await FileHelper.toRelativePath(media.thumbnailPath!)
        : null;

    // Insert new media attachment using Companion
    final companion = MediaAttachmentsCompanion.insert(
      momentId: momentId,
      filePath: relativeFilePath,
      mediaType: media.mediaType,
      fileSize: Value(media.fileSize),
      duration: Value(media.duration),
      thumbnailPath: Value(relativeThumbnailPath),
      aiSummary: Value(media.aiSummary),
      aiProcessed: Value(media.aiProcessed),
      createdAt: media.createdAt,
    );
    await database.insertMediaAttachment(companion);
  }

  /// Helper method to insert mood associations concurrently
  static Future<void> _insertMoodAssociations(
    AppDatabase database,
    int momentId,
    List<String> moods,
  ) async {
    final moodFutures = moods.map((mood) {
      final moodCompanion = MomentMoodsCompanion.insert(
        momentId: momentId,
        mood: mood,
        createdAt: DateTime.now(),
      );
      return database.into(database.momentMoods).insert(moodCompanion);
    });
    await Future.wait(moodFutures);
  }

  /// Helper method to replace mood associations
  static Future<void> _replaceMoodAssociations(
    AppDatabase database,
    int momentId,
    List<String> moods,
  ) async {
    // First delete existing associations
    await (database.delete(
      database.momentMoods,
    )..where((mm) => mm.momentId.equals(momentId))).go();

    // Then insert new associations concurrently
    if (moods.isNotEmpty) {
      await _insertMoodAssociations(database, momentId, moods);
    }
  }

  /// Helper method to insert tag associations
  static Future<void> _insertTagAssociations(
    AppDatabase database,
    int momentId,
    List<String> tags,
  ) async {
    // Insert all tag associations concurrently
    final tagAssociationFutures = tags.map((tag) async {
      await database.addTagToMoment(momentId, tag);
    });

    await Future.wait(tagAssociationFutures);
  }

  /// Helper method to replace tag associations
  static Future<void> _replaceTagAssociations(
    AppDatabase database,
    int momentId,
    List<String> tags,
  ) async {
    // First delete existing associations
    await (database.delete(
      database.momentTags,
    )..where((mt) => mt.momentId.equals(momentId))).go();

    // Then insert new associations
    if (tags.isNotEmpty) {
      await _insertTagAssociations(database, momentId, tags);
    }
  }

  /// Get the index of a mood string in MoodType enum order
  /// Returns a high number for unknown moods to sort them to the end
  static int _getMoodTypeIndex(String moodString) {
    try {
      // Convert string to MoodType enum
      final moodType = MoodType.values.firstWhere(
        (mood) => mood.name == moodString,
        orElse: () => throw StateError('Mood not found'),
      );
      return moodType.index;
    } catch (e) {
      // Unknown mood strings get sorted to the end
      return MoodType.values.length;
    }
  }
}
