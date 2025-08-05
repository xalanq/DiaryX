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
    // Get all media attachments for this moment
    final mediaAttachments = await database.getMediaAttachmentsByMomentId(
      momentData.id,
    );

    // Get all moods for this moment
    final moodAssociations = await (database.select(
      database.momentMoods,
    )..where((mm) => mm.momentId.equals(momentData.id))).get();

    // Sort moods by MoodType enum order
    final moodStrings = moodAssociations.map((ma) => ma.mood).toList();
    moodStrings.sort((a, b) {
      final indexA = _getMoodTypeIndex(a);
      final indexB = _getMoodTypeIndex(b);
      return indexA.compareTo(indexB);
    });
    final moods = moodStrings;

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

    // Handle media attachments
    final allMedia = [...images, ...audios, ...videos];
    for (final media in allMedia) {
      if (media.id == 0) {
        // Convert absolute paths to relative paths for database storage
        final relativeFilePath = await FileHelper.toRelativePath(
          media.filePath,
        );
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
    }

    // Handle mood associations
    if (id == 0) {
      // For new moments, insert all mood associations
      for (final mood in moods) {
        final moodCompanion = MomentMoodsCompanion.insert(
          momentId: momentId,
          mood: mood,
          createdAt: DateTime.now(),
        );
        await database.into(database.momentMoods).insert(moodCompanion);
      }
    } else {
      // For existing moments, replace all mood associations
      // First delete existing associations
      await (database.delete(
        database.momentMoods,
      )..where((mm) => mm.momentId.equals(momentId))).go();

      // Then insert new associations
      for (final mood in moods) {
        final moodCompanion = MomentMoodsCompanion.insert(
          momentId: momentId,
          mood: mood,
          createdAt: DateTime.now(),
        );
        await database.into(database.momentMoods).insert(moodCompanion);
      }
    }

    return momentId;
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
