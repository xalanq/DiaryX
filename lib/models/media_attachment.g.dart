// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaAttachmentImpl _$$MediaAttachmentImplFromJson(
  Map<String, dynamic> json,
) => _$MediaAttachmentImpl(
  id: (json['id'] as num?)?.toInt(),
  entryId: (json['entryId'] as num).toInt(),
  filePath: json['filePath'] as String,
  mediaType: $enumDecode(_$MediaTypeEnumMap, json['mediaType']),
  fileSize: (json['fileSize'] as num?)?.toInt(),
  duration: (json['duration'] as num?)?.toDouble(),
  thumbnailPath: json['thumbnailPath'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$MediaAttachmentImplToJson(
  _$MediaAttachmentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'entryId': instance.entryId,
  'filePath': instance.filePath,
  'mediaType': _$MediaTypeEnumMap[instance.mediaType]!,
  'fileSize': instance.fileSize,
  'duration': instance.duration,
  'thumbnailPath': instance.thumbnailPath,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$MediaTypeEnumMap = {
  MediaType.image: 'image',
  MediaType.video: 'video',
  MediaType.audio: 'audio',
};
