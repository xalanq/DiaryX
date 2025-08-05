// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MomentImpl _$$MomentImplFromJson(Map<String, dynamic> json) => _$MomentImpl(
  id: (json['id'] as num?)?.toInt() ?? 0,
  content: json['content'] as String,
  aiSummary: json['aiSummary'] as String?,
  moods:
      (json['moods'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  images:
      (json['images'] as List<dynamic>?)
          ?.map((e) => MediaAttachment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  audios:
      (json['audios'] as List<dynamic>?)
          ?.map((e) => MediaAttachment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  videos:
      (json['videos'] as List<dynamic>?)
          ?.map((e) => MediaAttachment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  aiProcessed: json['aiProcessed'] as bool? ?? false,
);

Map<String, dynamic> _$$MomentImplToJson(_$MomentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'aiSummary': instance.aiSummary,
      'moods': instance.moods,
      'images': instance.images,
      'audios': instance.audios,
      'videos': instance.videos,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'aiProcessed': instance.aiProcessed,
    };
