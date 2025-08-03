import 'package:freezed_annotation/freezed_annotation.dart';
import 'media_attachment.dart';
import '../databases/app_database.dart';

part 'moment.freezed.dart';
part 'moment.g.dart';

/// Represents a diary moment in the application
@freezed
class Moment with _$Moment {
  const factory Moment({
    int? id,
    required String content,
    @Default([]) List<String> moods,
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

    // Separate media by type
    final images = <MediaAttachment>[];
    final audios = <MediaAttachment>[];
    final videos = <MediaAttachment>[];

    for (final attachment in mediaAttachments) {
      final mediaAttachment = MediaAttachment(
        id: attachment.id,
        momentId: attachment.momentId,
        filePath: attachment.filePath,
        mediaType: attachment.mediaType,
        fileSize: attachment.fileSize,
        duration: attachment.duration,
        thumbnailPath: attachment.thumbnailPath,
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

    // Parse moods from JSON string
    List<String> moods = [];
    if (momentData.moods != null && momentData.moods!.isNotEmpty) {
      try {
        final List<dynamic> moodsList =
            (momentData.moods!.startsWith('[') &&
                momentData.moods!.endsWith(']'))
            ? eval(momentData.moods!) as List<dynamic>
            : [momentData.moods!];
        moods = moodsList.map((mood) => mood.toString()).toList();
      } catch (e) {
        moods = [momentData.moods!];
      }
    }

    return Moment(
      id: momentData.id,
      content: momentData.content,
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
      id: id ?? 0,
      content: content,
      moods: moods.isEmpty ? null : '[${moods.map((m) => '"$m"').join(', ')}]',
      createdAt: createdAt,
      updatedAt: updatedAt,
      aiProcessed: aiProcessed,
    );
  }

  /// Save moment and its media attachments to database
  Future<int> save(AppDatabase database) async {
    final momentData = toMomentData();

    int momentId;
    if (id == null) {
      // Insert new moment
      momentId = await database.insertMoment(momentData);
    } else {
      // Update existing moment
      await database.updateMoment(momentData);
      momentId = id!;
    }

    // Handle media attachments
    final allMedia = [...images, ...audios, ...videos];
    for (final media in allMedia) {
      if (media.id == null) {
        // Insert new media attachment
        final mediaData = MediaAttachmentData(
          id: 0,
          momentId: momentId,
          filePath: media.filePath,
          mediaType: media.mediaType,
          fileSize: media.fileSize,
          duration: media.duration,
          thumbnailPath: media.thumbnailPath,
          createdAt: media.createdAt,
        );
        await database.insertMediaAttachment(mediaData);
      }
    }

    return momentId;
  }
}

// Helper function to safely evaluate JSON strings
dynamic eval(String jsonString) {
  // Simple JSON array parser for mood strings
  if (jsonString.startsWith('[') && jsonString.endsWith(']')) {
    final content = jsonString.substring(1, jsonString.length - 1);
    if (content.isEmpty) return [];
    return content.split(',').map((s) => s.trim().replaceAll('"', '')).toList();
  }
  return jsonString;
}
