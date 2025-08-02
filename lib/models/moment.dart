import 'package:freezed_annotation/freezed_annotation.dart';

part 'moment.freezed.dart';
part 'moment.g.dart';

/// Content types for diary moments
enum ContentType { text, voice, image, video, mixed }

/// Represents a diary moment in the application
@freezed
class Moment with _$Moment {
  const factory Moment({
    int? id,
    required String content,
    required ContentType contentType,
    String? mood,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool aiProcessed,
  }) = _Moment;

  factory Moment.fromJson(Map<String, dynamic> json) => _$MomentFromJson(json);
}
