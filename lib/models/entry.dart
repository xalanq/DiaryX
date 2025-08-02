import 'package:freezed_annotation/freezed_annotation.dart';

part 'entry.freezed.dart';
part 'entry.g.dart';

/// Content types for diary entries
enum ContentType { text, voice, image, video, mixed }

/// Represents a diary entry in the application
@freezed
class Entry with _$Entry {
  const factory Entry({
    int? id,
    required String content,
    required ContentType contentType,
    String? mood,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool aiProcessed,
  }) = _Entry;

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);
}
