import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_models.freezed.dart';
part 'chat_models.g.dart';

/// Base message model for chat interactions
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String role, // 'user', 'assistant', 'system'
    required String content,
    List<MediaItem>? images,
    List<MediaItem>? audios,
    List<MediaItem>? videos,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

/// Media item for multi-modal content
@freezed
class MediaItem with _$MediaItem {
  const factory MediaItem({
    required String type, // 'url' or 'base64'
    required String data,
  }) = _MediaItem;

  factory MediaItem.fromJson(Map<String, dynamic> json) =>
      _$MediaItemFromJson(json);
}
