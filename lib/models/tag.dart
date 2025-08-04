import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag.freezed.dart';
part 'tag.g.dart';

/// Represents a tag for categorizing diary moments
@freezed
class Tag with _$Tag {
  const factory Tag({
    @Default(0) int id,
    required String name,
    String? color,
    required DateTime createdAt,
  }) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}
