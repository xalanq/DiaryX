import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_attachment.freezed.dart';
part 'media_attachment.g.dart';

/// Media types for attachments
enum MediaType { image, video, audio }

/// Represents a media attachment for diary moments
@freezed
class MediaAttachment with _$MediaAttachment {
  const factory MediaAttachment({
    @Default(0) int id,
    required int momentId,
    required String filePath,
    required MediaType mediaType,
    int? fileSize,
    double? duration, // Video/audio duration in seconds
    String? thumbnailPath,
    required DateTime createdAt,
  }) = _MediaAttachment;

  factory MediaAttachment.fromJson(Map<String, dynamic> json) =>
      _$MediaAttachmentFromJson(json);
}
