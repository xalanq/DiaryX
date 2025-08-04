// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DraftMediaDataImpl _$$DraftMediaDataImplFromJson(Map<String, dynamic> json) =>
    _$DraftMediaDataImpl(
      filePath: json['filePath'] as String,
      mediaType: $enumDecode(_$MediaTypeEnumMap, json['mediaType']),
      fileSize: (json['fileSize'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toDouble(),
      thumbnailPath: json['thumbnailPath'] as String?,
    );

Map<String, dynamic> _$$DraftMediaDataImplToJson(
  _$DraftMediaDataImpl instance,
) => <String, dynamic>{
  'filePath': instance.filePath,
  'mediaType': _$MediaTypeEnumMap[instance.mediaType]!,
  'fileSize': instance.fileSize,
  'duration': instance.duration,
  'thumbnailPath': instance.thumbnailPath,
};

const _$MediaTypeEnumMap = {
  MediaType.image: 'image',
  MediaType.video: 'video',
  MediaType.audio: 'audio',
};

_$DraftDataImpl _$$DraftDataImplFromJson(Map<String, dynamic> json) =>
    _$DraftDataImpl(
      content: json['content'] as String,
      moods:
          (json['moods'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      mediaAttachments:
          (json['mediaAttachments'] as List<dynamic>?)
              ?.map((e) => DraftMediaData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lastModified: DateTime.parse(json['lastModified'] as String),
    );

Map<String, dynamic> _$$DraftDataImplToJson(_$DraftDataImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'moods': instance.moods,
      'mediaAttachments': instance.mediaAttachments,
      'lastModified': instance.lastModified.toIso8601String(),
    };
