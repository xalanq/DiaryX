import 'package:freezed_annotation/freezed_annotation.dart';
import 'media_attachment.dart';

part 'draft.freezed.dart';
part 'draft.g.dart';

/// Draft media data model for storing media information before creating moment
@freezed
class DraftMediaData with _$DraftMediaData {
  const factory DraftMediaData({
    @Default(0) int id, // Include id to track existing attachments
    required String filePath,
    required MediaType mediaType,
    int? fileSize,
    double? duration, // Video/audio duration in seconds
    String? thumbnailPath,
  }) = _DraftMediaData;

  factory DraftMediaData.fromJson(Map<String, dynamic> json) =>
      _$DraftMediaDataFromJson(json);
}

/// Draft data model for storing draft moment information
@freezed
class DraftData with _$DraftData {
  const factory DraftData({
    required String content,
    @Default([]) List<String> moods,
    @Default([]) List<DraftMediaData> mediaAttachments,
    required DateTime lastModified,
  }) = _DraftData;

  factory DraftData.fromJson(Map<String, dynamic> json) =>
      _$DraftDataFromJson(json);
}

/// Extension methods for DraftData
extension DraftDataExtensions on DraftData {
  /// Check if draft has any content (text, moods, or media)
  bool get hasContent =>
      content.isNotEmpty || moods.isNotEmpty || mediaAttachments.isNotEmpty;
}
