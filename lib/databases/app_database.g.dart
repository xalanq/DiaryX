// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MomentsTable extends Moments with TableInfo<$MomentsTable, MomentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MomentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moodsMeta = const VerificationMeta('moods');
  @override
  late final GeneratedColumn<String> moods = GeneratedColumn<String>(
    'moods',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aiProcessedMeta = const VerificationMeta(
    'aiProcessed',
  );
  @override
  late final GeneratedColumn<bool> aiProcessed = GeneratedColumn<bool>(
    'ai_processed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ai_processed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    moods,
    createdAt,
    updatedAt,
    aiProcessed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moments';
  @override
  VerificationContext validateIntegrity(
    Insertable<MomentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('moods')) {
      context.handle(
        _moodsMeta,
        moods.isAcceptableOrUnknown(data['moods']!, _moodsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('ai_processed')) {
      context.handle(
        _aiProcessedMeta,
        aiProcessed.isAcceptableOrUnknown(
          data['ai_processed']!,
          _aiProcessedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MomentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MomentData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      moods: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}moods'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      aiProcessed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ai_processed'],
      )!,
    );
  }

  @override
  $MomentsTable createAlias(String alias) {
    return $MomentsTable(attachedDatabase, alias);
  }
}

class MomentData extends DataClass implements Insertable<MomentData> {
  final int id;
  final String content;
  final String? moods;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool aiProcessed;
  const MomentData({
    required this.id,
    required this.content,
    this.moods,
    required this.createdAt,
    required this.updatedAt,
    required this.aiProcessed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || moods != null) {
      map['moods'] = Variable<String>(moods);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['ai_processed'] = Variable<bool>(aiProcessed);
    return map;
  }

  MomentsCompanion toCompanion(bool nullToAbsent) {
    return MomentsCompanion(
      id: Value(id),
      content: Value(content),
      moods: moods == null && nullToAbsent
          ? const Value.absent()
          : Value(moods),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      aiProcessed: Value(aiProcessed),
    );
  }

  factory MomentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MomentData(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      moods: serializer.fromJson<String?>(json['moods']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      aiProcessed: serializer.fromJson<bool>(json['aiProcessed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'moods': serializer.toJson<String?>(moods),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'aiProcessed': serializer.toJson<bool>(aiProcessed),
    };
  }

  MomentData copyWith({
    int? id,
    String? content,
    Value<String?> moods = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? aiProcessed,
  }) => MomentData(
    id: id ?? this.id,
    content: content ?? this.content,
    moods: moods.present ? moods.value : this.moods,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    aiProcessed: aiProcessed ?? this.aiProcessed,
  );
  MomentData copyWithCompanion(MomentsCompanion data) {
    return MomentData(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      moods: data.moods.present ? data.moods.value : this.moods,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      aiProcessed: data.aiProcessed.present
          ? data.aiProcessed.value
          : this.aiProcessed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MomentData(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('moods: $moods, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('aiProcessed: $aiProcessed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, content, moods, createdAt, updatedAt, aiProcessed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MomentData &&
          other.id == this.id &&
          other.content == this.content &&
          other.moods == this.moods &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.aiProcessed == this.aiProcessed);
}

class MomentsCompanion extends UpdateCompanion<MomentData> {
  final Value<int> id;
  final Value<String> content;
  final Value<String?> moods;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> aiProcessed;
  const MomentsCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.moods = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.aiProcessed = const Value.absent(),
  });
  MomentsCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    this.moods = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.aiProcessed = const Value.absent(),
  }) : content = Value(content),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MomentData> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<String>? moods,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? aiProcessed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (moods != null) 'moods': moods,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (aiProcessed != null) 'ai_processed': aiProcessed,
    });
  }

  MomentsCompanion copyWith({
    Value<int>? id,
    Value<String>? content,
    Value<String?>? moods,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? aiProcessed,
  }) {
    return MomentsCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      moods: moods ?? this.moods,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      aiProcessed: aiProcessed ?? this.aiProcessed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (moods.present) {
      map['moods'] = Variable<String>(moods.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (aiProcessed.present) {
      map['ai_processed'] = Variable<bool>(aiProcessed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MomentsCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('moods: $moods, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('aiProcessed: $aiProcessed')
          ..write(')'))
        .toString();
  }
}

class $MediaAttachmentsTable extends MediaAttachments
    with TableInfo<$MediaAttachmentsTable, MediaAttachmentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _momentIdMeta = const VerificationMeta(
    'momentId',
  );
  @override
  late final GeneratedColumn<int> momentId = GeneratedColumn<int>(
    'moment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES moments (id)',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MediaType, String> mediaType =
      GeneratedColumn<String>(
        'media_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MediaType>($MediaAttachmentsTable.$convertermediaType);
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<double> duration = GeneratedColumn<double>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    momentId,
    filePath,
    mediaType,
    fileSize,
    duration,
    thumbnailPath,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaAttachmentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('moment_id')) {
      context.handle(
        _momentIdMeta,
        momentId.isAcceptableOrUnknown(data['moment_id']!, _momentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_momentIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaAttachmentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaAttachmentData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      momentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moment_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      mediaType: $MediaAttachmentsTable.$convertermediaType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}media_type'],
        )!,
      ),
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}duration'],
      ),
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MediaAttachmentsTable createAlias(String alias) {
    return $MediaAttachmentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MediaType, String, String> $convertermediaType =
      const EnumNameConverter<MediaType>(MediaType.values);
}

class MediaAttachmentData extends DataClass
    implements Insertable<MediaAttachmentData> {
  final int id;
  final int momentId;
  final String filePath;
  final MediaType mediaType;
  final int? fileSize;
  final double? duration;
  final String? thumbnailPath;
  final DateTime createdAt;
  const MediaAttachmentData({
    required this.id,
    required this.momentId,
    required this.filePath,
    required this.mediaType,
    this.fileSize,
    this.duration,
    this.thumbnailPath,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['moment_id'] = Variable<int>(momentId);
    map['file_path'] = Variable<String>(filePath);
    {
      map['media_type'] = Variable<String>(
        $MediaAttachmentsTable.$convertermediaType.toSql(mediaType),
      );
    }
    if (!nullToAbsent || fileSize != null) {
      map['file_size'] = Variable<int>(fileSize);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<double>(duration);
    }
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MediaAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return MediaAttachmentsCompanion(
      id: Value(id),
      momentId: Value(momentId),
      filePath: Value(filePath),
      mediaType: Value(mediaType),
      fileSize: fileSize == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSize),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      createdAt: Value(createdAt),
    );
  }

  factory MediaAttachmentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaAttachmentData(
      id: serializer.fromJson<int>(json['id']),
      momentId: serializer.fromJson<int>(json['momentId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      mediaType: $MediaAttachmentsTable.$convertermediaType.fromJson(
        serializer.fromJson<String>(json['mediaType']),
      ),
      fileSize: serializer.fromJson<int?>(json['fileSize']),
      duration: serializer.fromJson<double?>(json['duration']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'momentId': serializer.toJson<int>(momentId),
      'filePath': serializer.toJson<String>(filePath),
      'mediaType': serializer.toJson<String>(
        $MediaAttachmentsTable.$convertermediaType.toJson(mediaType),
      ),
      'fileSize': serializer.toJson<int?>(fileSize),
      'duration': serializer.toJson<double?>(duration),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MediaAttachmentData copyWith({
    int? id,
    int? momentId,
    String? filePath,
    MediaType? mediaType,
    Value<int?> fileSize = const Value.absent(),
    Value<double?> duration = const Value.absent(),
    Value<String?> thumbnailPath = const Value.absent(),
    DateTime? createdAt,
  }) => MediaAttachmentData(
    id: id ?? this.id,
    momentId: momentId ?? this.momentId,
    filePath: filePath ?? this.filePath,
    mediaType: mediaType ?? this.mediaType,
    fileSize: fileSize.present ? fileSize.value : this.fileSize,
    duration: duration.present ? duration.value : this.duration,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    createdAt: createdAt ?? this.createdAt,
  );
  MediaAttachmentData copyWithCompanion(MediaAttachmentsCompanion data) {
    return MediaAttachmentData(
      id: data.id.present ? data.id.value : this.id,
      momentId: data.momentId.present ? data.momentId.value : this.momentId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      duration: data.duration.present ? data.duration.value : this.duration,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaAttachmentData(')
          ..write('id: $id, ')
          ..write('momentId: $momentId, ')
          ..write('filePath: $filePath, ')
          ..write('mediaType: $mediaType, ')
          ..write('fileSize: $fileSize, ')
          ..write('duration: $duration, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    momentId,
    filePath,
    mediaType,
    fileSize,
    duration,
    thumbnailPath,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaAttachmentData &&
          other.id == this.id &&
          other.momentId == this.momentId &&
          other.filePath == this.filePath &&
          other.mediaType == this.mediaType &&
          other.fileSize == this.fileSize &&
          other.duration == this.duration &&
          other.thumbnailPath == this.thumbnailPath &&
          other.createdAt == this.createdAt);
}

class MediaAttachmentsCompanion extends UpdateCompanion<MediaAttachmentData> {
  final Value<int> id;
  final Value<int> momentId;
  final Value<String> filePath;
  final Value<MediaType> mediaType;
  final Value<int?> fileSize;
  final Value<double?> duration;
  final Value<String?> thumbnailPath;
  final Value<DateTime> createdAt;
  const MediaAttachmentsCompanion({
    this.id = const Value.absent(),
    this.momentId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.duration = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MediaAttachmentsCompanion.insert({
    this.id = const Value.absent(),
    required int momentId,
    required String filePath,
    required MediaType mediaType,
    this.fileSize = const Value.absent(),
    this.duration = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    required DateTime createdAt,
  }) : momentId = Value(momentId),
       filePath = Value(filePath),
       mediaType = Value(mediaType),
       createdAt = Value(createdAt);
  static Insertable<MediaAttachmentData> custom({
    Expression<int>? id,
    Expression<int>? momentId,
    Expression<String>? filePath,
    Expression<String>? mediaType,
    Expression<int>? fileSize,
    Expression<double>? duration,
    Expression<String>? thumbnailPath,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (momentId != null) 'moment_id': momentId,
      if (filePath != null) 'file_path': filePath,
      if (mediaType != null) 'media_type': mediaType,
      if (fileSize != null) 'file_size': fileSize,
      if (duration != null) 'duration': duration,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MediaAttachmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? momentId,
    Value<String>? filePath,
    Value<MediaType>? mediaType,
    Value<int?>? fileSize,
    Value<double?>? duration,
    Value<String?>? thumbnailPath,
    Value<DateTime>? createdAt,
  }) {
    return MediaAttachmentsCompanion(
      id: id ?? this.id,
      momentId: momentId ?? this.momentId,
      filePath: filePath ?? this.filePath,
      mediaType: mediaType ?? this.mediaType,
      fileSize: fileSize ?? this.fileSize,
      duration: duration ?? this.duration,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (momentId.present) {
      map['moment_id'] = Variable<int>(momentId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(
        $MediaAttachmentsTable.$convertermediaType.toSql(mediaType.value),
      );
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (duration.present) {
      map['duration'] = Variable<double>(duration.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('momentId: $momentId, ')
          ..write('filePath: $filePath, ')
          ..write('mediaType: $mediaType, ')
          ..write('fileSize: $fileSize, ')
          ..write('duration: $duration, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, TagData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, color, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<TagData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class TagData extends DataClass implements Insertable<TagData> {
  final int id;
  final String name;
  final String? color;
  final DateTime createdAt;
  const TagData({
    required this.id,
    required this.name,
    this.color,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      createdAt: Value(createdAt),
    );
  }

  factory TagData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String?>(json['color']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String?>(color),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TagData copyWith({
    int? id,
    String? name,
    Value<String?> color = const Value.absent(),
    DateTime? createdAt,
  }) => TagData(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color.present ? color.value : this.color,
    createdAt: createdAt ?? this.createdAt,
  );
  TagData copyWithCompanion(TagsCompanion data) {
    return TagData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagData &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.createdAt == this.createdAt);
}

class TagsCompanion extends UpdateCompanion<TagData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> color;
  final Value<DateTime> createdAt;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<TagData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TagsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? color,
    Value<DateTime>? createdAt,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MomentTagsTable extends MomentTags
    with TableInfo<$MomentTagsTable, MomentTagData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MomentTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _momentIdMeta = const VerificationMeta(
    'momentId',
  );
  @override
  late final GeneratedColumn<int> momentId = GeneratedColumn<int>(
    'moment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES moments (id)',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [momentId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moment_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<MomentTagData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('moment_id')) {
      context.handle(
        _momentIdMeta,
        momentId.isAcceptableOrUnknown(data['moment_id']!, _momentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_momentIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {momentId, tagId};
  @override
  MomentTagData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MomentTagData(
      momentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moment_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $MomentTagsTable createAlias(String alias) {
    return $MomentTagsTable(attachedDatabase, alias);
  }
}

class MomentTagData extends DataClass implements Insertable<MomentTagData> {
  final int momentId;
  final int tagId;
  const MomentTagData({required this.momentId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['moment_id'] = Variable<int>(momentId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  MomentTagsCompanion toCompanion(bool nullToAbsent) {
    return MomentTagsCompanion(momentId: Value(momentId), tagId: Value(tagId));
  }

  factory MomentTagData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MomentTagData(
      momentId: serializer.fromJson<int>(json['momentId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'momentId': serializer.toJson<int>(momentId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  MomentTagData copyWith({int? momentId, int? tagId}) => MomentTagData(
    momentId: momentId ?? this.momentId,
    tagId: tagId ?? this.tagId,
  );
  MomentTagData copyWithCompanion(MomentTagsCompanion data) {
    return MomentTagData(
      momentId: data.momentId.present ? data.momentId.value : this.momentId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MomentTagData(')
          ..write('momentId: $momentId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(momentId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MomentTagData &&
          other.momentId == this.momentId &&
          other.tagId == this.tagId);
}

class MomentTagsCompanion extends UpdateCompanion<MomentTagData> {
  final Value<int> momentId;
  final Value<int> tagId;
  final Value<int> rowid;
  const MomentTagsCompanion({
    this.momentId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MomentTagsCompanion.insert({
    required int momentId,
    required int tagId,
    this.rowid = const Value.absent(),
  }) : momentId = Value(momentId),
       tagId = Value(tagId);
  static Insertable<MomentTagData> custom({
    Expression<int>? momentId,
    Expression<int>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (momentId != null) 'moment_id': momentId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MomentTagsCompanion copyWith({
    Value<int>? momentId,
    Value<int>? tagId,
    Value<int>? rowid,
  }) {
    return MomentTagsCompanion(
      momentId: momentId ?? this.momentId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (momentId.present) {
      map['moment_id'] = Variable<int>(momentId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MomentTagsCompanion(')
          ..write('momentId: $momentId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiProcessingQueueTable extends AiProcessingQueue
    with TableInfo<$AiProcessingQueueTable, ProcessingTaskData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiProcessingQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _momentIdMeta = const VerificationMeta(
    'momentId',
  );
  @override
  late final GeneratedColumn<int> momentId = GeneratedColumn<int>(
    'moment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES moments (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskType, String> taskType =
      GeneratedColumn<String>(
        'task_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TaskType>($AiProcessingQueueTable.$convertertaskType);
  @override
  late final GeneratedColumnWithTypeConverter<ProcessingStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ProcessingStatus>(
        $AiProcessingQueueTable.$converterstatus,
      );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _processedAtMeta = const VerificationMeta(
    'processedAt',
  );
  @override
  late final GeneratedColumn<DateTime> processedAt = GeneratedColumn<DateTime>(
    'processed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    momentId,
    taskType,
    status,
    priority,
    attempts,
    errorMessage,
    createdAt,
    processedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_processing_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProcessingTaskData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('moment_id')) {
      context.handle(
        _momentIdMeta,
        momentId.isAcceptableOrUnknown(data['moment_id']!, _momentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_momentIdMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('processed_at')) {
      context.handle(
        _processedAtMeta,
        processedAt.isAcceptableOrUnknown(
          data['processed_at']!,
          _processedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProcessingTaskData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProcessingTaskData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      momentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moment_id'],
      )!,
      taskType: $AiProcessingQueueTable.$convertertaskType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}task_type'],
        )!,
      ),
      status: $AiProcessingQueueTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      processedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}processed_at'],
      ),
    );
  }

  @override
  $AiProcessingQueueTable createAlias(String alias) {
    return $AiProcessingQueueTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskType, String, String> $convertertaskType =
      const EnumNameConverter<TaskType>(TaskType.values);
  static JsonTypeConverter2<ProcessingStatus, String, String> $converterstatus =
      const EnumNameConverter<ProcessingStatus>(ProcessingStatus.values);
}

class ProcessingTaskData extends DataClass
    implements Insertable<ProcessingTaskData> {
  final int id;
  final int momentId;
  final TaskType taskType;
  final ProcessingStatus status;
  final int priority;
  final int attempts;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime? processedAt;
  const ProcessingTaskData({
    required this.id,
    required this.momentId,
    required this.taskType,
    required this.status,
    required this.priority,
    required this.attempts,
    this.errorMessage,
    required this.createdAt,
    this.processedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['moment_id'] = Variable<int>(momentId);
    {
      map['task_type'] = Variable<String>(
        $AiProcessingQueueTable.$convertertaskType.toSql(taskType),
      );
    }
    {
      map['status'] = Variable<String>(
        $AiProcessingQueueTable.$converterstatus.toSql(status),
      );
    }
    map['priority'] = Variable<int>(priority);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || processedAt != null) {
      map['processed_at'] = Variable<DateTime>(processedAt);
    }
    return map;
  }

  AiProcessingQueueCompanion toCompanion(bool nullToAbsent) {
    return AiProcessingQueueCompanion(
      id: Value(id),
      momentId: Value(momentId),
      taskType: Value(taskType),
      status: Value(status),
      priority: Value(priority),
      attempts: Value(attempts),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdAt: Value(createdAt),
      processedAt: processedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(processedAt),
    );
  }

  factory ProcessingTaskData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProcessingTaskData(
      id: serializer.fromJson<int>(json['id']),
      momentId: serializer.fromJson<int>(json['momentId']),
      taskType: $AiProcessingQueueTable.$convertertaskType.fromJson(
        serializer.fromJson<String>(json['taskType']),
      ),
      status: $AiProcessingQueueTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      priority: serializer.fromJson<int>(json['priority']),
      attempts: serializer.fromJson<int>(json['attempts']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      processedAt: serializer.fromJson<DateTime?>(json['processedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'momentId': serializer.toJson<int>(momentId),
      'taskType': serializer.toJson<String>(
        $AiProcessingQueueTable.$convertertaskType.toJson(taskType),
      ),
      'status': serializer.toJson<String>(
        $AiProcessingQueueTable.$converterstatus.toJson(status),
      ),
      'priority': serializer.toJson<int>(priority),
      'attempts': serializer.toJson<int>(attempts),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'processedAt': serializer.toJson<DateTime?>(processedAt),
    };
  }

  ProcessingTaskData copyWith({
    int? id,
    int? momentId,
    TaskType? taskType,
    ProcessingStatus? status,
    int? priority,
    int? attempts,
    Value<String?> errorMessage = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> processedAt = const Value.absent(),
  }) => ProcessingTaskData(
    id: id ?? this.id,
    momentId: momentId ?? this.momentId,
    taskType: taskType ?? this.taskType,
    status: status ?? this.status,
    priority: priority ?? this.priority,
    attempts: attempts ?? this.attempts,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    createdAt: createdAt ?? this.createdAt,
    processedAt: processedAt.present ? processedAt.value : this.processedAt,
  );
  ProcessingTaskData copyWithCompanion(AiProcessingQueueCompanion data) {
    return ProcessingTaskData(
      id: data.id.present ? data.id.value : this.id,
      momentId: data.momentId.present ? data.momentId.value : this.momentId,
      taskType: data.taskType.present ? data.taskType.value : this.taskType,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      processedAt: data.processedAt.present
          ? data.processedAt.value
          : this.processedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProcessingTaskData(')
          ..write('id: $id, ')
          ..write('momentId: $momentId, ')
          ..write('taskType: $taskType, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('attempts: $attempts, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('processedAt: $processedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    momentId,
    taskType,
    status,
    priority,
    attempts,
    errorMessage,
    createdAt,
    processedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProcessingTaskData &&
          other.id == this.id &&
          other.momentId == this.momentId &&
          other.taskType == this.taskType &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.attempts == this.attempts &&
          other.errorMessage == this.errorMessage &&
          other.createdAt == this.createdAt &&
          other.processedAt == this.processedAt);
}

class AiProcessingQueueCompanion extends UpdateCompanion<ProcessingTaskData> {
  final Value<int> id;
  final Value<int> momentId;
  final Value<TaskType> taskType;
  final Value<ProcessingStatus> status;
  final Value<int> priority;
  final Value<int> attempts;
  final Value<String?> errorMessage;
  final Value<DateTime> createdAt;
  final Value<DateTime?> processedAt;
  const AiProcessingQueueCompanion({
    this.id = const Value.absent(),
    this.momentId = const Value.absent(),
    this.taskType = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.attempts = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.processedAt = const Value.absent(),
  });
  AiProcessingQueueCompanion.insert({
    this.id = const Value.absent(),
    required int momentId,
    required TaskType taskType,
    required ProcessingStatus status,
    this.priority = const Value.absent(),
    this.attempts = const Value.absent(),
    this.errorMessage = const Value.absent(),
    required DateTime createdAt,
    this.processedAt = const Value.absent(),
  }) : momentId = Value(momentId),
       taskType = Value(taskType),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<ProcessingTaskData> custom({
    Expression<int>? id,
    Expression<int>? momentId,
    Expression<String>? taskType,
    Expression<String>? status,
    Expression<int>? priority,
    Expression<int>? attempts,
    Expression<String>? errorMessage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? processedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (momentId != null) 'moment_id': momentId,
      if (taskType != null) 'task_type': taskType,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (attempts != null) 'attempts': attempts,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdAt != null) 'created_at': createdAt,
      if (processedAt != null) 'processed_at': processedAt,
    });
  }

  AiProcessingQueueCompanion copyWith({
    Value<int>? id,
    Value<int>? momentId,
    Value<TaskType>? taskType,
    Value<ProcessingStatus>? status,
    Value<int>? priority,
    Value<int>? attempts,
    Value<String?>? errorMessage,
    Value<DateTime>? createdAt,
    Value<DateTime?>? processedAt,
  }) {
    return AiProcessingQueueCompanion(
      id: id ?? this.id,
      momentId: momentId ?? this.momentId,
      taskType: taskType ?? this.taskType,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      attempts: attempts ?? this.attempts,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      processedAt: processedAt ?? this.processedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (momentId.present) {
      map['moment_id'] = Variable<int>(momentId.value);
    }
    if (taskType.present) {
      map['task_type'] = Variable<String>(
        $AiProcessingQueueTable.$convertertaskType.toSql(taskType.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $AiProcessingQueueTable.$converterstatus.toSql(status.value),
      );
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (processedAt.present) {
      map['processed_at'] = Variable<DateTime>(processedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiProcessingQueueCompanion(')
          ..write('id: $id, ')
          ..write('momentId: $momentId, ')
          ..write('taskType: $taskType, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('attempts: $attempts, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('processedAt: $processedAt')
          ..write(')'))
        .toString();
  }
}

class $EmbeddingsTable extends Embeddings
    with TableInfo<$EmbeddingsTable, EmbeddingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmbeddingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _momentIdMeta = const VerificationMeta(
    'momentId',
  );
  @override
  late final GeneratedColumn<int> momentId = GeneratedColumn<int>(
    'moment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES moments (id)',
    ),
  );
  static const VerificationMeta _embeddingDataMeta = const VerificationMeta(
    'embeddingData',
  );
  @override
  late final GeneratedColumn<Uint8List> embeddingData =
      GeneratedColumn<Uint8List>(
        'embedding_data',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  @override
  late final GeneratedColumnWithTypeConverter<EmbeddingType, String>
  embeddingType = GeneratedColumn<String>(
    'embedding_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<EmbeddingType>($EmbeddingsTable.$converterembeddingType);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    momentId,
    embeddingData,
    embeddingType,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'embeddings';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmbeddingData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('moment_id')) {
      context.handle(
        _momentIdMeta,
        momentId.isAcceptableOrUnknown(data['moment_id']!, _momentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_momentIdMeta);
    }
    if (data.containsKey('embedding_data')) {
      context.handle(
        _embeddingDataMeta,
        embeddingData.isAcceptableOrUnknown(
          data['embedding_data']!,
          _embeddingDataMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_embeddingDataMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmbeddingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmbeddingData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      momentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moment_id'],
      )!,
      embeddingData: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}embedding_data'],
      )!,
      embeddingType: $EmbeddingsTable.$converterembeddingType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}embedding_type'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EmbeddingsTable createAlias(String alias) {
    return $EmbeddingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EmbeddingType, String, String>
  $converterembeddingType = const EnumNameConverter<EmbeddingType>(
    EmbeddingType.values,
  );
}

class EmbeddingData extends DataClass implements Insertable<EmbeddingData> {
  final int id;
  final int momentId;
  final Uint8List embeddingData;
  final EmbeddingType embeddingType;
  final DateTime createdAt;
  const EmbeddingData({
    required this.id,
    required this.momentId,
    required this.embeddingData,
    required this.embeddingType,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['moment_id'] = Variable<int>(momentId);
    map['embedding_data'] = Variable<Uint8List>(embeddingData);
    {
      map['embedding_type'] = Variable<String>(
        $EmbeddingsTable.$converterembeddingType.toSql(embeddingType),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EmbeddingsCompanion toCompanion(bool nullToAbsent) {
    return EmbeddingsCompanion(
      id: Value(id),
      momentId: Value(momentId),
      embeddingData: Value(embeddingData),
      embeddingType: Value(embeddingType),
      createdAt: Value(createdAt),
    );
  }

  factory EmbeddingData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmbeddingData(
      id: serializer.fromJson<int>(json['id']),
      momentId: serializer.fromJson<int>(json['momentId']),
      embeddingData: serializer.fromJson<Uint8List>(json['embeddingData']),
      embeddingType: $EmbeddingsTable.$converterembeddingType.fromJson(
        serializer.fromJson<String>(json['embeddingType']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'momentId': serializer.toJson<int>(momentId),
      'embeddingData': serializer.toJson<Uint8List>(embeddingData),
      'embeddingType': serializer.toJson<String>(
        $EmbeddingsTable.$converterembeddingType.toJson(embeddingType),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EmbeddingData copyWith({
    int? id,
    int? momentId,
    Uint8List? embeddingData,
    EmbeddingType? embeddingType,
    DateTime? createdAt,
  }) => EmbeddingData(
    id: id ?? this.id,
    momentId: momentId ?? this.momentId,
    embeddingData: embeddingData ?? this.embeddingData,
    embeddingType: embeddingType ?? this.embeddingType,
    createdAt: createdAt ?? this.createdAt,
  );
  EmbeddingData copyWithCompanion(EmbeddingsCompanion data) {
    return EmbeddingData(
      id: data.id.present ? data.id.value : this.id,
      momentId: data.momentId.present ? data.momentId.value : this.momentId,
      embeddingData: data.embeddingData.present
          ? data.embeddingData.value
          : this.embeddingData,
      embeddingType: data.embeddingType.present
          ? data.embeddingType.value
          : this.embeddingType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmbeddingData(')
          ..write('id: $id, ')
          ..write('momentId: $momentId, ')
          ..write('embeddingData: $embeddingData, ')
          ..write('embeddingType: $embeddingType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    momentId,
    $driftBlobEquality.hash(embeddingData),
    embeddingType,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmbeddingData &&
          other.id == this.id &&
          other.momentId == this.momentId &&
          $driftBlobEquality.equals(other.embeddingData, this.embeddingData) &&
          other.embeddingType == this.embeddingType &&
          other.createdAt == this.createdAt);
}

class EmbeddingsCompanion extends UpdateCompanion<EmbeddingData> {
  final Value<int> id;
  final Value<int> momentId;
  final Value<Uint8List> embeddingData;
  final Value<EmbeddingType> embeddingType;
  final Value<DateTime> createdAt;
  const EmbeddingsCompanion({
    this.id = const Value.absent(),
    this.momentId = const Value.absent(),
    this.embeddingData = const Value.absent(),
    this.embeddingType = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EmbeddingsCompanion.insert({
    this.id = const Value.absent(),
    required int momentId,
    required Uint8List embeddingData,
    required EmbeddingType embeddingType,
    required DateTime createdAt,
  }) : momentId = Value(momentId),
       embeddingData = Value(embeddingData),
       embeddingType = Value(embeddingType),
       createdAt = Value(createdAt);
  static Insertable<EmbeddingData> custom({
    Expression<int>? id,
    Expression<int>? momentId,
    Expression<Uint8List>? embeddingData,
    Expression<String>? embeddingType,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (momentId != null) 'moment_id': momentId,
      if (embeddingData != null) 'embedding_data': embeddingData,
      if (embeddingType != null) 'embedding_type': embeddingType,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EmbeddingsCompanion copyWith({
    Value<int>? id,
    Value<int>? momentId,
    Value<Uint8List>? embeddingData,
    Value<EmbeddingType>? embeddingType,
    Value<DateTime>? createdAt,
  }) {
    return EmbeddingsCompanion(
      id: id ?? this.id,
      momentId: momentId ?? this.momentId,
      embeddingData: embeddingData ?? this.embeddingData,
      embeddingType: embeddingType ?? this.embeddingType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (momentId.present) {
      map['moment_id'] = Variable<int>(momentId.value);
    }
    if (embeddingData.present) {
      map['embedding_data'] = Variable<Uint8List>(embeddingData.value);
    }
    if (embeddingType.present) {
      map['embedding_type'] = Variable<String>(
        $EmbeddingsTable.$converterembeddingType.toSql(embeddingType.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmbeddingsCompanion(')
          ..write('id: $id, ')
          ..write('momentId: $momentId, ')
          ..write('embeddingData: $embeddingData, ')
          ..write('embeddingType: $embeddingType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MoodAnalysisTableTable extends MoodAnalysisTable
    with TableInfo<$MoodAnalysisTableTable, MoodAnalysisData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodAnalysisTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _momentIdMeta = const VerificationMeta(
    'momentId',
  );
  @override
  late final GeneratedColumn<int> momentId = GeneratedColumn<int>(
    'moment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES moments (id)',
    ),
  );
  static const VerificationMeta _moodScoreMeta = const VerificationMeta(
    'moodScore',
  );
  @override
  late final GeneratedColumn<double> moodScore = GeneratedColumn<double>(
    'mood_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _primaryMoodMeta = const VerificationMeta(
    'primaryMood',
  );
  @override
  late final GeneratedColumn<String> primaryMood = GeneratedColumn<String>(
    'primary_mood',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceScoreMeta = const VerificationMeta(
    'confidenceScore',
  );
  @override
  late final GeneratedColumn<double> confidenceScore = GeneratedColumn<double>(
    'confidence_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moodKeywordsMeta = const VerificationMeta(
    'moodKeywords',
  );
  @override
  late final GeneratedColumn<String> moodKeywords = GeneratedColumn<String>(
    'mood_keywords',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _analysisTimestampMeta = const VerificationMeta(
    'analysisTimestamp',
  );
  @override
  late final GeneratedColumn<DateTime> analysisTimestamp =
      GeneratedColumn<DateTime>(
        'analysis_timestamp',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    momentId,
    moodScore,
    primaryMood,
    confidenceScore,
    moodKeywords,
    analysisTimestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_analysis_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodAnalysisData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('moment_id')) {
      context.handle(
        _momentIdMeta,
        momentId.isAcceptableOrUnknown(data['moment_id']!, _momentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_momentIdMeta);
    }
    if (data.containsKey('mood_score')) {
      context.handle(
        _moodScoreMeta,
        moodScore.isAcceptableOrUnknown(data['mood_score']!, _moodScoreMeta),
      );
    }
    if (data.containsKey('primary_mood')) {
      context.handle(
        _primaryMoodMeta,
        primaryMood.isAcceptableOrUnknown(
          data['primary_mood']!,
          _primaryMoodMeta,
        ),
      );
    }
    if (data.containsKey('confidence_score')) {
      context.handle(
        _confidenceScoreMeta,
        confidenceScore.isAcceptableOrUnknown(
          data['confidence_score']!,
          _confidenceScoreMeta,
        ),
      );
    }
    if (data.containsKey('mood_keywords')) {
      context.handle(
        _moodKeywordsMeta,
        moodKeywords.isAcceptableOrUnknown(
          data['mood_keywords']!,
          _moodKeywordsMeta,
        ),
      );
    }
    if (data.containsKey('analysis_timestamp')) {
      context.handle(
        _analysisTimestampMeta,
        analysisTimestamp.isAcceptableOrUnknown(
          data['analysis_timestamp']!,
          _analysisTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_analysisTimestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoodAnalysisData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodAnalysisData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      momentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moment_id'],
      )!,
      moodScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mood_score'],
      ),
      primaryMood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_mood'],
      ),
      confidenceScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence_score'],
      ),
      moodKeywords: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood_keywords'],
      ),
      analysisTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}analysis_timestamp'],
      )!,
    );
  }

  @override
  $MoodAnalysisTableTable createAlias(String alias) {
    return $MoodAnalysisTableTable(attachedDatabase, alias);
  }
}

class MoodAnalysisData extends DataClass
    implements Insertable<MoodAnalysisData> {
  final int id;
  final int momentId;
  final double? moodScore;
  final String? primaryMood;
  final double? confidenceScore;
  final String? moodKeywords;
  final DateTime analysisTimestamp;
  const MoodAnalysisData({
    required this.id,
    required this.momentId,
    this.moodScore,
    this.primaryMood,
    this.confidenceScore,
    this.moodKeywords,
    required this.analysisTimestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['moment_id'] = Variable<int>(momentId);
    if (!nullToAbsent || moodScore != null) {
      map['mood_score'] = Variable<double>(moodScore);
    }
    if (!nullToAbsent || primaryMood != null) {
      map['primary_mood'] = Variable<String>(primaryMood);
    }
    if (!nullToAbsent || confidenceScore != null) {
      map['confidence_score'] = Variable<double>(confidenceScore);
    }
    if (!nullToAbsent || moodKeywords != null) {
      map['mood_keywords'] = Variable<String>(moodKeywords);
    }
    map['analysis_timestamp'] = Variable<DateTime>(analysisTimestamp);
    return map;
  }

  MoodAnalysisTableCompanion toCompanion(bool nullToAbsent) {
    return MoodAnalysisTableCompanion(
      id: Value(id),
      momentId: Value(momentId),
      moodScore: moodScore == null && nullToAbsent
          ? const Value.absent()
          : Value(moodScore),
      primaryMood: primaryMood == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryMood),
      confidenceScore: confidenceScore == null && nullToAbsent
          ? const Value.absent()
          : Value(confidenceScore),
      moodKeywords: moodKeywords == null && nullToAbsent
          ? const Value.absent()
          : Value(moodKeywords),
      analysisTimestamp: Value(analysisTimestamp),
    );
  }

  factory MoodAnalysisData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodAnalysisData(
      id: serializer.fromJson<int>(json['id']),
      momentId: serializer.fromJson<int>(json['momentId']),
      moodScore: serializer.fromJson<double?>(json['moodScore']),
      primaryMood: serializer.fromJson<String?>(json['primaryMood']),
      confidenceScore: serializer.fromJson<double?>(json['confidenceScore']),
      moodKeywords: serializer.fromJson<String?>(json['moodKeywords']),
      analysisTimestamp: serializer.fromJson<DateTime>(
        json['analysisTimestamp'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'momentId': serializer.toJson<int>(momentId),
      'moodScore': serializer.toJson<double?>(moodScore),
      'primaryMood': serializer.toJson<String?>(primaryMood),
      'confidenceScore': serializer.toJson<double?>(confidenceScore),
      'moodKeywords': serializer.toJson<String?>(moodKeywords),
      'analysisTimestamp': serializer.toJson<DateTime>(analysisTimestamp),
    };
  }

  MoodAnalysisData copyWith({
    int? id,
    int? momentId,
    Value<double?> moodScore = const Value.absent(),
    Value<String?> primaryMood = const Value.absent(),
    Value<double?> confidenceScore = const Value.absent(),
    Value<String?> moodKeywords = const Value.absent(),
    DateTime? analysisTimestamp,
  }) => MoodAnalysisData(
    id: id ?? this.id,
    momentId: momentId ?? this.momentId,
    moodScore: moodScore.present ? moodScore.value : this.moodScore,
    primaryMood: primaryMood.present ? primaryMood.value : this.primaryMood,
    confidenceScore: confidenceScore.present
        ? confidenceScore.value
        : this.confidenceScore,
    moodKeywords: moodKeywords.present ? moodKeywords.value : this.moodKeywords,
    analysisTimestamp: analysisTimestamp ?? this.analysisTimestamp,
  );
  MoodAnalysisData copyWithCompanion(MoodAnalysisTableCompanion data) {
    return MoodAnalysisData(
      id: data.id.present ? data.id.value : this.id,
      momentId: data.momentId.present ? data.momentId.value : this.momentId,
      moodScore: data.moodScore.present ? data.moodScore.value : this.moodScore,
      primaryMood: data.primaryMood.present
          ? data.primaryMood.value
          : this.primaryMood,
      confidenceScore: data.confidenceScore.present
          ? data.confidenceScore.value
          : this.confidenceScore,
      moodKeywords: data.moodKeywords.present
          ? data.moodKeywords.value
          : this.moodKeywords,
      analysisTimestamp: data.analysisTimestamp.present
          ? data.analysisTimestamp.value
          : this.analysisTimestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodAnalysisData(')
          ..write('id: $id, ')
          ..write('momentId: $momentId, ')
          ..write('moodScore: $moodScore, ')
          ..write('primaryMood: $primaryMood, ')
          ..write('confidenceScore: $confidenceScore, ')
          ..write('moodKeywords: $moodKeywords, ')
          ..write('analysisTimestamp: $analysisTimestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    momentId,
    moodScore,
    primaryMood,
    confidenceScore,
    moodKeywords,
    analysisTimestamp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodAnalysisData &&
          other.id == this.id &&
          other.momentId == this.momentId &&
          other.moodScore == this.moodScore &&
          other.primaryMood == this.primaryMood &&
          other.confidenceScore == this.confidenceScore &&
          other.moodKeywords == this.moodKeywords &&
          other.analysisTimestamp == this.analysisTimestamp);
}

class MoodAnalysisTableCompanion extends UpdateCompanion<MoodAnalysisData> {
  final Value<int> id;
  final Value<int> momentId;
  final Value<double?> moodScore;
  final Value<String?> primaryMood;
  final Value<double?> confidenceScore;
  final Value<String?> moodKeywords;
  final Value<DateTime> analysisTimestamp;
  const MoodAnalysisTableCompanion({
    this.id = const Value.absent(),
    this.momentId = const Value.absent(),
    this.moodScore = const Value.absent(),
    this.primaryMood = const Value.absent(),
    this.confidenceScore = const Value.absent(),
    this.moodKeywords = const Value.absent(),
    this.analysisTimestamp = const Value.absent(),
  });
  MoodAnalysisTableCompanion.insert({
    this.id = const Value.absent(),
    required int momentId,
    this.moodScore = const Value.absent(),
    this.primaryMood = const Value.absent(),
    this.confidenceScore = const Value.absent(),
    this.moodKeywords = const Value.absent(),
    required DateTime analysisTimestamp,
  }) : momentId = Value(momentId),
       analysisTimestamp = Value(analysisTimestamp);
  static Insertable<MoodAnalysisData> custom({
    Expression<int>? id,
    Expression<int>? momentId,
    Expression<double>? moodScore,
    Expression<String>? primaryMood,
    Expression<double>? confidenceScore,
    Expression<String>? moodKeywords,
    Expression<DateTime>? analysisTimestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (momentId != null) 'moment_id': momentId,
      if (moodScore != null) 'mood_score': moodScore,
      if (primaryMood != null) 'primary_mood': primaryMood,
      if (confidenceScore != null) 'confidence_score': confidenceScore,
      if (moodKeywords != null) 'mood_keywords': moodKeywords,
      if (analysisTimestamp != null) 'analysis_timestamp': analysisTimestamp,
    });
  }

  MoodAnalysisTableCompanion copyWith({
    Value<int>? id,
    Value<int>? momentId,
    Value<double?>? moodScore,
    Value<String?>? primaryMood,
    Value<double?>? confidenceScore,
    Value<String?>? moodKeywords,
    Value<DateTime>? analysisTimestamp,
  }) {
    return MoodAnalysisTableCompanion(
      id: id ?? this.id,
      momentId: momentId ?? this.momentId,
      moodScore: moodScore ?? this.moodScore,
      primaryMood: primaryMood ?? this.primaryMood,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      moodKeywords: moodKeywords ?? this.moodKeywords,
      analysisTimestamp: analysisTimestamp ?? this.analysisTimestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (momentId.present) {
      map['moment_id'] = Variable<int>(momentId.value);
    }
    if (moodScore.present) {
      map['mood_score'] = Variable<double>(moodScore.value);
    }
    if (primaryMood.present) {
      map['primary_mood'] = Variable<String>(primaryMood.value);
    }
    if (confidenceScore.present) {
      map['confidence_score'] = Variable<double>(confidenceScore.value);
    }
    if (moodKeywords.present) {
      map['mood_keywords'] = Variable<String>(moodKeywords.value);
    }
    if (analysisTimestamp.present) {
      map['analysis_timestamp'] = Variable<DateTime>(analysisTimestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodAnalysisTableCompanion(')
          ..write('id: $id, ')
          ..write('momentId: $momentId, ')
          ..write('moodScore: $moodScore, ')
          ..write('primaryMood: $primaryMood, ')
          ..write('confidenceScore: $confidenceScore, ')
          ..write('moodKeywords: $moodKeywords, ')
          ..write('analysisTimestamp: $analysisTimestamp')
          ..write(')'))
        .toString();
  }
}

class $LlmAnalysisTableTable extends LlmAnalysisTable
    with TableInfo<$LlmAnalysisTableTable, LLMAnalysisData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LlmAnalysisTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _momentIdMeta = const VerificationMeta(
    'momentId',
  );
  @override
  late final GeneratedColumn<int> momentId = GeneratedColumn<int>(
    'moment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES moments (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<AnalysisType, String>
  analysisType = GeneratedColumn<String>(
    'analysis_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<AnalysisType>($LlmAnalysisTableTable.$converteranalysisType);
  static const VerificationMeta _analysisContentMeta = const VerificationMeta(
    'analysisContent',
  );
  @override
  late final GeneratedColumn<String> analysisContent = GeneratedColumn<String>(
    'analysis_content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceScoreMeta = const VerificationMeta(
    'confidenceScore',
  );
  @override
  late final GeneratedColumn<double> confidenceScore = GeneratedColumn<double>(
    'confidence_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    momentId,
    analysisType,
    analysisContent,
    confidenceScore,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'llm_analysis_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LLMAnalysisData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('moment_id')) {
      context.handle(
        _momentIdMeta,
        momentId.isAcceptableOrUnknown(data['moment_id']!, _momentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_momentIdMeta);
    }
    if (data.containsKey('analysis_content')) {
      context.handle(
        _analysisContentMeta,
        analysisContent.isAcceptableOrUnknown(
          data['analysis_content']!,
          _analysisContentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_analysisContentMeta);
    }
    if (data.containsKey('confidence_score')) {
      context.handle(
        _confidenceScoreMeta,
        confidenceScore.isAcceptableOrUnknown(
          data['confidence_score']!,
          _confidenceScoreMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LLMAnalysisData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LLMAnalysisData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      momentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moment_id'],
      )!,
      analysisType: $LlmAnalysisTableTable.$converteranalysisType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}analysis_type'],
        )!,
      ),
      analysisContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_content'],
      )!,
      confidenceScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence_score'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LlmAnalysisTableTable createAlias(String alias) {
    return $LlmAnalysisTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AnalysisType, String, String>
  $converteranalysisType = const EnumNameConverter<AnalysisType>(
    AnalysisType.values,
  );
}

class LLMAnalysisData extends DataClass implements Insertable<LLMAnalysisData> {
  final int id;
  final int momentId;
  final AnalysisType analysisType;
  final String analysisContent;
  final double? confidenceScore;
  final DateTime createdAt;
  const LLMAnalysisData({
    required this.id,
    required this.momentId,
    required this.analysisType,
    required this.analysisContent,
    this.confidenceScore,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['moment_id'] = Variable<int>(momentId);
    {
      map['analysis_type'] = Variable<String>(
        $LlmAnalysisTableTable.$converteranalysisType.toSql(analysisType),
      );
    }
    map['analysis_content'] = Variable<String>(analysisContent);
    if (!nullToAbsent || confidenceScore != null) {
      map['confidence_score'] = Variable<double>(confidenceScore);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LlmAnalysisTableCompanion toCompanion(bool nullToAbsent) {
    return LlmAnalysisTableCompanion(
      id: Value(id),
      momentId: Value(momentId),
      analysisType: Value(analysisType),
      analysisContent: Value(analysisContent),
      confidenceScore: confidenceScore == null && nullToAbsent
          ? const Value.absent()
          : Value(confidenceScore),
      createdAt: Value(createdAt),
    );
  }

  factory LLMAnalysisData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LLMAnalysisData(
      id: serializer.fromJson<int>(json['id']),
      momentId: serializer.fromJson<int>(json['momentId']),
      analysisType: $LlmAnalysisTableTable.$converteranalysisType.fromJson(
        serializer.fromJson<String>(json['analysisType']),
      ),
      analysisContent: serializer.fromJson<String>(json['analysisContent']),
      confidenceScore: serializer.fromJson<double?>(json['confidenceScore']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'momentId': serializer.toJson<int>(momentId),
      'analysisType': serializer.toJson<String>(
        $LlmAnalysisTableTable.$converteranalysisType.toJson(analysisType),
      ),
      'analysisContent': serializer.toJson<String>(analysisContent),
      'confidenceScore': serializer.toJson<double?>(confidenceScore),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LLMAnalysisData copyWith({
    int? id,
    int? momentId,
    AnalysisType? analysisType,
    String? analysisContent,
    Value<double?> confidenceScore = const Value.absent(),
    DateTime? createdAt,
  }) => LLMAnalysisData(
    id: id ?? this.id,
    momentId: momentId ?? this.momentId,
    analysisType: analysisType ?? this.analysisType,
    analysisContent: analysisContent ?? this.analysisContent,
    confidenceScore: confidenceScore.present
        ? confidenceScore.value
        : this.confidenceScore,
    createdAt: createdAt ?? this.createdAt,
  );
  LLMAnalysisData copyWithCompanion(LlmAnalysisTableCompanion data) {
    return LLMAnalysisData(
      id: data.id.present ? data.id.value : this.id,
      momentId: data.momentId.present ? data.momentId.value : this.momentId,
      analysisType: data.analysisType.present
          ? data.analysisType.value
          : this.analysisType,
      analysisContent: data.analysisContent.present
          ? data.analysisContent.value
          : this.analysisContent,
      confidenceScore: data.confidenceScore.present
          ? data.confidenceScore.value
          : this.confidenceScore,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LLMAnalysisData(')
          ..write('id: $id, ')
          ..write('momentId: $momentId, ')
          ..write('analysisType: $analysisType, ')
          ..write('analysisContent: $analysisContent, ')
          ..write('confidenceScore: $confidenceScore, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    momentId,
    analysisType,
    analysisContent,
    confidenceScore,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LLMAnalysisData &&
          other.id == this.id &&
          other.momentId == this.momentId &&
          other.analysisType == this.analysisType &&
          other.analysisContent == this.analysisContent &&
          other.confidenceScore == this.confidenceScore &&
          other.createdAt == this.createdAt);
}

class LlmAnalysisTableCompanion extends UpdateCompanion<LLMAnalysisData> {
  final Value<int> id;
  final Value<int> momentId;
  final Value<AnalysisType> analysisType;
  final Value<String> analysisContent;
  final Value<double?> confidenceScore;
  final Value<DateTime> createdAt;
  const LlmAnalysisTableCompanion({
    this.id = const Value.absent(),
    this.momentId = const Value.absent(),
    this.analysisType = const Value.absent(),
    this.analysisContent = const Value.absent(),
    this.confidenceScore = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LlmAnalysisTableCompanion.insert({
    this.id = const Value.absent(),
    required int momentId,
    required AnalysisType analysisType,
    required String analysisContent,
    this.confidenceScore = const Value.absent(),
    required DateTime createdAt,
  }) : momentId = Value(momentId),
       analysisType = Value(analysisType),
       analysisContent = Value(analysisContent),
       createdAt = Value(createdAt);
  static Insertable<LLMAnalysisData> custom({
    Expression<int>? id,
    Expression<int>? momentId,
    Expression<String>? analysisType,
    Expression<String>? analysisContent,
    Expression<double>? confidenceScore,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (momentId != null) 'moment_id': momentId,
      if (analysisType != null) 'analysis_type': analysisType,
      if (analysisContent != null) 'analysis_content': analysisContent,
      if (confidenceScore != null) 'confidence_score': confidenceScore,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LlmAnalysisTableCompanion copyWith({
    Value<int>? id,
    Value<int>? momentId,
    Value<AnalysisType>? analysisType,
    Value<String>? analysisContent,
    Value<double?>? confidenceScore,
    Value<DateTime>? createdAt,
  }) {
    return LlmAnalysisTableCompanion(
      id: id ?? this.id,
      momentId: momentId ?? this.momentId,
      analysisType: analysisType ?? this.analysisType,
      analysisContent: analysisContent ?? this.analysisContent,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (momentId.present) {
      map['moment_id'] = Variable<int>(momentId.value);
    }
    if (analysisType.present) {
      map['analysis_type'] = Variable<String>(
        $LlmAnalysisTableTable.$converteranalysisType.toSql(analysisType.value),
      );
    }
    if (analysisContent.present) {
      map['analysis_content'] = Variable<String>(analysisContent.value);
    }
    if (confidenceScore.present) {
      map['confidence_score'] = Variable<double>(confidenceScore.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LlmAnalysisTableCompanion(')
          ..write('id: $id, ')
          ..write('momentId: $momentId, ')
          ..write('analysisType: $analysisType, ')
          ..write('analysisContent: $analysisContent, ')
          ..write('confidenceScore: $confidenceScore, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $KeyValuesTable extends KeyValues
    with TableInfo<$KeyValuesTable, KeyValue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KeyValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'key_values';
  @override
  VerificationContext validateIntegrity(
    Insertable<KeyValue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  KeyValue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KeyValue(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KeyValuesTable createAlias(String alias) {
    return $KeyValuesTable(attachedDatabase, alias);
  }
}

class KeyValue extends DataClass implements Insertable<KeyValue> {
  /// Unique key identifier
  final String key;

  /// Value stored as text (can be JSON for complex data)
  final String value;

  /// When this key-value pair was created
  final DateTime createdAt;

  /// When this key-value pair was last updated
  final DateTime updatedAt;
  const KeyValue({
    required this.key,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KeyValuesCompanion toCompanion(bool nullToAbsent) {
    return KeyValuesCompanion(
      key: Value(key),
      value: Value(value),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KeyValue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KeyValue(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KeyValue copyWith({
    String? key,
    String? value,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => KeyValue(
    key: key ?? this.key,
    value: value ?? this.value,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  KeyValue copyWithCompanion(KeyValuesCompanion data) {
    return KeyValue(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KeyValue(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KeyValue &&
          other.key == this.key &&
          other.value == this.value &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KeyValuesCompanion extends UpdateCompanion<KeyValue> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const KeyValuesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KeyValuesCompanion.insert({
    required String key,
    required String value,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<KeyValue> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KeyValuesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return KeyValuesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KeyValuesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MomentsTable moments = $MomentsTable(this);
  late final $MediaAttachmentsTable mediaAttachments = $MediaAttachmentsTable(
    this,
  );
  late final $TagsTable tags = $TagsTable(this);
  late final $MomentTagsTable momentTags = $MomentTagsTable(this);
  late final $AiProcessingQueueTable aiProcessingQueue =
      $AiProcessingQueueTable(this);
  late final $EmbeddingsTable embeddings = $EmbeddingsTable(this);
  late final $MoodAnalysisTableTable moodAnalysisTable =
      $MoodAnalysisTableTable(this);
  late final $LlmAnalysisTableTable llmAnalysisTable = $LlmAnalysisTableTable(
    this,
  );
  late final $KeyValuesTable keyValues = $KeyValuesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    moments,
    mediaAttachments,
    tags,
    momentTags,
    aiProcessingQueue,
    embeddings,
    moodAnalysisTable,
    llmAnalysisTable,
    keyValues,
  ];
}

typedef $$MomentsTableCreateCompanionBuilder =
    MomentsCompanion Function({
      Value<int> id,
      required String content,
      Value<String?> moods,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> aiProcessed,
    });
typedef $$MomentsTableUpdateCompanionBuilder =
    MomentsCompanion Function({
      Value<int> id,
      Value<String> content,
      Value<String?> moods,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> aiProcessed,
    });

final class $$MomentsTableReferences
    extends BaseReferences<_$AppDatabase, $MomentsTable, MomentData> {
  $$MomentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MediaAttachmentsTable, List<MediaAttachmentData>>
  _mediaAttachmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mediaAttachments,
    aliasName: $_aliasNameGenerator(
      db.moments.id,
      db.mediaAttachments.momentId,
    ),
  );

  $$MediaAttachmentsTableProcessedTableManager get mediaAttachmentsRefs {
    final manager = $$MediaAttachmentsTableTableManager(
      $_db,
      $_db.mediaAttachments,
    ).filter((f) => f.momentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _mediaAttachmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MomentTagsTable, List<MomentTagData>>
  _momentTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.momentTags,
    aliasName: $_aliasNameGenerator(db.moments.id, db.momentTags.momentId),
  );

  $$MomentTagsTableProcessedTableManager get momentTagsRefs {
    final manager = $$MomentTagsTableTableManager(
      $_db,
      $_db.momentTags,
    ).filter((f) => f.momentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_momentTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AiProcessingQueueTable, List<ProcessingTaskData>>
  _aiProcessingQueueRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.aiProcessingQueue,
        aliasName: $_aliasNameGenerator(
          db.moments.id,
          db.aiProcessingQueue.momentId,
        ),
      );

  $$AiProcessingQueueTableProcessedTableManager get aiProcessingQueueRefs {
    final manager = $$AiProcessingQueueTableTableManager(
      $_db,
      $_db.aiProcessingQueue,
    ).filter((f) => f.momentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _aiProcessingQueueRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EmbeddingsTable, List<EmbeddingData>>
  _embeddingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.embeddings,
    aliasName: $_aliasNameGenerator(db.moments.id, db.embeddings.momentId),
  );

  $$EmbeddingsTableProcessedTableManager get embeddingsRefs {
    final manager = $$EmbeddingsTableTableManager(
      $_db,
      $_db.embeddings,
    ).filter((f) => f.momentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_embeddingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MoodAnalysisTableTable, List<MoodAnalysisData>>
  _moodAnalysisTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.moodAnalysisTable,
        aliasName: $_aliasNameGenerator(
          db.moments.id,
          db.moodAnalysisTable.momentId,
        ),
      );

  $$MoodAnalysisTableTableProcessedTableManager get moodAnalysisTableRefs {
    final manager = $$MoodAnalysisTableTableTableManager(
      $_db,
      $_db.moodAnalysisTable,
    ).filter((f) => f.momentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _moodAnalysisTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LlmAnalysisTableTable, List<LLMAnalysisData>>
  _llmAnalysisTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.llmAnalysisTable,
    aliasName: $_aliasNameGenerator(
      db.moments.id,
      db.llmAnalysisTable.momentId,
    ),
  );

  $$LlmAnalysisTableTableProcessedTableManager get llmAnalysisTableRefs {
    final manager = $$LlmAnalysisTableTableTableManager(
      $_db,
      $_db.llmAnalysisTable,
    ).filter((f) => f.momentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _llmAnalysisTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MomentsTableFilterComposer
    extends Composer<_$AppDatabase, $MomentsTable> {
  $$MomentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moods => $composableBuilder(
    column: $table.moods,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get aiProcessed => $composableBuilder(
    column: $table.aiProcessed,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mediaAttachmentsRefs(
    Expression<bool> Function($$MediaAttachmentsTableFilterComposer f) f,
  ) {
    final $$MediaAttachmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaAttachments,
      getReferencedColumn: (t) => t.momentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaAttachmentsTableFilterComposer(
            $db: $db,
            $table: $db.mediaAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> momentTagsRefs(
    Expression<bool> Function($$MomentTagsTableFilterComposer f) f,
  ) {
    final $$MomentTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.momentTags,
      getReferencedColumn: (t) => t.momentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentTagsTableFilterComposer(
            $db: $db,
            $table: $db.momentTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> aiProcessingQueueRefs(
    Expression<bool> Function($$AiProcessingQueueTableFilterComposer f) f,
  ) {
    final $$AiProcessingQueueTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aiProcessingQueue,
      getReferencedColumn: (t) => t.momentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiProcessingQueueTableFilterComposer(
            $db: $db,
            $table: $db.aiProcessingQueue,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> embeddingsRefs(
    Expression<bool> Function($$EmbeddingsTableFilterComposer f) f,
  ) {
    final $$EmbeddingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.embeddings,
      getReferencedColumn: (t) => t.momentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmbeddingsTableFilterComposer(
            $db: $db,
            $table: $db.embeddings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> moodAnalysisTableRefs(
    Expression<bool> Function($$MoodAnalysisTableTableFilterComposer f) f,
  ) {
    final $$MoodAnalysisTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moodAnalysisTable,
      getReferencedColumn: (t) => t.momentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodAnalysisTableTableFilterComposer(
            $db: $db,
            $table: $db.moodAnalysisTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> llmAnalysisTableRefs(
    Expression<bool> Function($$LlmAnalysisTableTableFilterComposer f) f,
  ) {
    final $$LlmAnalysisTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.llmAnalysisTable,
      getReferencedColumn: (t) => t.momentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LlmAnalysisTableTableFilterComposer(
            $db: $db,
            $table: $db.llmAnalysisTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MomentsTableOrderingComposer
    extends Composer<_$AppDatabase, $MomentsTable> {
  $$MomentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moods => $composableBuilder(
    column: $table.moods,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get aiProcessed => $composableBuilder(
    column: $table.aiProcessed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MomentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MomentsTable> {
  $$MomentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get moods =>
      $composableBuilder(column: $table.moods, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get aiProcessed => $composableBuilder(
    column: $table.aiProcessed,
    builder: (column) => column,
  );

  Expression<T> mediaAttachmentsRefs<T extends Object>(
    Expression<T> Function($$MediaAttachmentsTableAnnotationComposer a) f,
  ) {
    final $$MediaAttachmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaAttachments,
      getReferencedColumn: (t) => t.momentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaAttachmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> momentTagsRefs<T extends Object>(
    Expression<T> Function($$MomentTagsTableAnnotationComposer a) f,
  ) {
    final $$MomentTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.momentTags,
      getReferencedColumn: (t) => t.momentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.momentTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> aiProcessingQueueRefs<T extends Object>(
    Expression<T> Function($$AiProcessingQueueTableAnnotationComposer a) f,
  ) {
    final $$AiProcessingQueueTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.aiProcessingQueue,
          getReferencedColumn: (t) => t.momentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AiProcessingQueueTableAnnotationComposer(
                $db: $db,
                $table: $db.aiProcessingQueue,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> embeddingsRefs<T extends Object>(
    Expression<T> Function($$EmbeddingsTableAnnotationComposer a) f,
  ) {
    final $$EmbeddingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.embeddings,
      getReferencedColumn: (t) => t.momentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmbeddingsTableAnnotationComposer(
            $db: $db,
            $table: $db.embeddings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> moodAnalysisTableRefs<T extends Object>(
    Expression<T> Function($$MoodAnalysisTableTableAnnotationComposer a) f,
  ) {
    final $$MoodAnalysisTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.moodAnalysisTable,
          getReferencedColumn: (t) => t.momentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MoodAnalysisTableTableAnnotationComposer(
                $db: $db,
                $table: $db.moodAnalysisTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> llmAnalysisTableRefs<T extends Object>(
    Expression<T> Function($$LlmAnalysisTableTableAnnotationComposer a) f,
  ) {
    final $$LlmAnalysisTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.llmAnalysisTable,
      getReferencedColumn: (t) => t.momentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LlmAnalysisTableTableAnnotationComposer(
            $db: $db,
            $table: $db.llmAnalysisTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MomentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MomentsTable,
          MomentData,
          $$MomentsTableFilterComposer,
          $$MomentsTableOrderingComposer,
          $$MomentsTableAnnotationComposer,
          $$MomentsTableCreateCompanionBuilder,
          $$MomentsTableUpdateCompanionBuilder,
          (MomentData, $$MomentsTableReferences),
          MomentData,
          PrefetchHooks Function({
            bool mediaAttachmentsRefs,
            bool momentTagsRefs,
            bool aiProcessingQueueRefs,
            bool embeddingsRefs,
            bool moodAnalysisTableRefs,
            bool llmAnalysisTableRefs,
          })
        > {
  $$MomentsTableTableManager(_$AppDatabase db, $MomentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MomentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MomentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MomentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> moods = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> aiProcessed = const Value.absent(),
              }) => MomentsCompanion(
                id: id,
                content: content,
                moods: moods,
                createdAt: createdAt,
                updatedAt: updatedAt,
                aiProcessed: aiProcessed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String content,
                Value<String?> moods = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> aiProcessed = const Value.absent(),
              }) => MomentsCompanion.insert(
                id: id,
                content: content,
                moods: moods,
                createdAt: createdAt,
                updatedAt: updatedAt,
                aiProcessed: aiProcessed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MomentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                mediaAttachmentsRefs = false,
                momentTagsRefs = false,
                aiProcessingQueueRefs = false,
                embeddingsRefs = false,
                moodAnalysisTableRefs = false,
                llmAnalysisTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (mediaAttachmentsRefs) db.mediaAttachments,
                    if (momentTagsRefs) db.momentTags,
                    if (aiProcessingQueueRefs) db.aiProcessingQueue,
                    if (embeddingsRefs) db.embeddings,
                    if (moodAnalysisTableRefs) db.moodAnalysisTable,
                    if (llmAnalysisTableRefs) db.llmAnalysisTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (mediaAttachmentsRefs)
                        await $_getPrefetchedData<
                          MomentData,
                          $MomentsTable,
                          MediaAttachmentData
                        >(
                          currentTable: table,
                          referencedTable: $$MomentsTableReferences
                              ._mediaAttachmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MomentsTableReferences(
                                db,
                                table,
                                p0,
                              ).mediaAttachmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.momentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (momentTagsRefs)
                        await $_getPrefetchedData<
                          MomentData,
                          $MomentsTable,
                          MomentTagData
                        >(
                          currentTable: table,
                          referencedTable: $$MomentsTableReferences
                              ._momentTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MomentsTableReferences(
                                db,
                                table,
                                p0,
                              ).momentTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.momentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (aiProcessingQueueRefs)
                        await $_getPrefetchedData<
                          MomentData,
                          $MomentsTable,
                          ProcessingTaskData
                        >(
                          currentTable: table,
                          referencedTable: $$MomentsTableReferences
                              ._aiProcessingQueueRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MomentsTableReferences(
                                db,
                                table,
                                p0,
                              ).aiProcessingQueueRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.momentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (embeddingsRefs)
                        await $_getPrefetchedData<
                          MomentData,
                          $MomentsTable,
                          EmbeddingData
                        >(
                          currentTable: table,
                          referencedTable: $$MomentsTableReferences
                              ._embeddingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MomentsTableReferences(
                                db,
                                table,
                                p0,
                              ).embeddingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.momentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (moodAnalysisTableRefs)
                        await $_getPrefetchedData<
                          MomentData,
                          $MomentsTable,
                          MoodAnalysisData
                        >(
                          currentTable: table,
                          referencedTable: $$MomentsTableReferences
                              ._moodAnalysisTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MomentsTableReferences(
                                db,
                                table,
                                p0,
                              ).moodAnalysisTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.momentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (llmAnalysisTableRefs)
                        await $_getPrefetchedData<
                          MomentData,
                          $MomentsTable,
                          LLMAnalysisData
                        >(
                          currentTable: table,
                          referencedTable: $$MomentsTableReferences
                              ._llmAnalysisTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MomentsTableReferences(
                                db,
                                table,
                                p0,
                              ).llmAnalysisTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.momentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MomentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MomentsTable,
      MomentData,
      $$MomentsTableFilterComposer,
      $$MomentsTableOrderingComposer,
      $$MomentsTableAnnotationComposer,
      $$MomentsTableCreateCompanionBuilder,
      $$MomentsTableUpdateCompanionBuilder,
      (MomentData, $$MomentsTableReferences),
      MomentData,
      PrefetchHooks Function({
        bool mediaAttachmentsRefs,
        bool momentTagsRefs,
        bool aiProcessingQueueRefs,
        bool embeddingsRefs,
        bool moodAnalysisTableRefs,
        bool llmAnalysisTableRefs,
      })
    >;
typedef $$MediaAttachmentsTableCreateCompanionBuilder =
    MediaAttachmentsCompanion Function({
      Value<int> id,
      required int momentId,
      required String filePath,
      required MediaType mediaType,
      Value<int?> fileSize,
      Value<double?> duration,
      Value<String?> thumbnailPath,
      required DateTime createdAt,
    });
typedef $$MediaAttachmentsTableUpdateCompanionBuilder =
    MediaAttachmentsCompanion Function({
      Value<int> id,
      Value<int> momentId,
      Value<String> filePath,
      Value<MediaType> mediaType,
      Value<int?> fileSize,
      Value<double?> duration,
      Value<String?> thumbnailPath,
      Value<DateTime> createdAt,
    });

final class $$MediaAttachmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MediaAttachmentsTable,
          MediaAttachmentData
        > {
  $$MediaAttachmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MomentsTable _momentIdTable(_$AppDatabase db) =>
      db.moments.createAlias(
        $_aliasNameGenerator(db.mediaAttachments.momentId, db.moments.id),
      );

  $$MomentsTableProcessedTableManager get momentId {
    final $_column = $_itemColumn<int>('moment_id')!;

    final manager = $$MomentsTableTableManager(
      $_db,
      $_db.moments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_momentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MediaAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $MediaAttachmentsTable> {
  $$MediaAttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MediaType, MediaType, String> get mediaType =>
      $composableBuilder(
        column: $table.mediaType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MomentsTableFilterComposer get momentId {
    final $$MomentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableFilterComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaAttachmentsTable> {
  $$MediaAttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MomentsTableOrderingComposer get momentId {
    final $$MomentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableOrderingComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaAttachmentsTable> {
  $$MediaAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MediaType, String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<double> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MomentsTableAnnotationComposer get momentId {
    final $$MomentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableAnnotationComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaAttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaAttachmentsTable,
          MediaAttachmentData,
          $$MediaAttachmentsTableFilterComposer,
          $$MediaAttachmentsTableOrderingComposer,
          $$MediaAttachmentsTableAnnotationComposer,
          $$MediaAttachmentsTableCreateCompanionBuilder,
          $$MediaAttachmentsTableUpdateCompanionBuilder,
          (MediaAttachmentData, $$MediaAttachmentsTableReferences),
          MediaAttachmentData,
          PrefetchHooks Function({bool momentId})
        > {
  $$MediaAttachmentsTableTableManager(
    _$AppDatabase db,
    $MediaAttachmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaAttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaAttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> momentId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<MediaType> mediaType = const Value.absent(),
                Value<int?> fileSize = const Value.absent(),
                Value<double?> duration = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MediaAttachmentsCompanion(
                id: id,
                momentId: momentId,
                filePath: filePath,
                mediaType: mediaType,
                fileSize: fileSize,
                duration: duration,
                thumbnailPath: thumbnailPath,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int momentId,
                required String filePath,
                required MediaType mediaType,
                Value<int?> fileSize = const Value.absent(),
                Value<double?> duration = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                required DateTime createdAt,
              }) => MediaAttachmentsCompanion.insert(
                id: id,
                momentId: momentId,
                filePath: filePath,
                mediaType: mediaType,
                fileSize: fileSize,
                duration: duration,
                thumbnailPath: thumbnailPath,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MediaAttachmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({momentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (momentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.momentId,
                                referencedTable:
                                    $$MediaAttachmentsTableReferences
                                        ._momentIdTable(db),
                                referencedColumn:
                                    $$MediaAttachmentsTableReferences
                                        ._momentIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MediaAttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaAttachmentsTable,
      MediaAttachmentData,
      $$MediaAttachmentsTableFilterComposer,
      $$MediaAttachmentsTableOrderingComposer,
      $$MediaAttachmentsTableAnnotationComposer,
      $$MediaAttachmentsTableCreateCompanionBuilder,
      $$MediaAttachmentsTableUpdateCompanionBuilder,
      (MediaAttachmentData, $$MediaAttachmentsTableReferences),
      MediaAttachmentData,
      PrefetchHooks Function({bool momentId})
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> color,
      required DateTime createdAt,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> color,
      Value<DateTime> createdAt,
    });

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, TagData> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MomentTagsTable, List<MomentTagData>>
  _momentTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.momentTags,
    aliasName: $_aliasNameGenerator(db.tags.id, db.momentTags.tagId),
  );

  $$MomentTagsTableProcessedTableManager get momentTagsRefs {
    final manager = $$MomentTagsTableTableManager(
      $_db,
      $_db.momentTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_momentTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> momentTagsRefs(
    Expression<bool> Function($$MomentTagsTableFilterComposer f) f,
  ) {
    final $$MomentTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.momentTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentTagsTableFilterComposer(
            $db: $db,
            $table: $db.momentTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> momentTagsRefs<T extends Object>(
    Expression<T> Function($$MomentTagsTableAnnotationComposer a) f,
  ) {
    final $$MomentTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.momentTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.momentTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          TagData,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (TagData, $$TagsTableReferences),
          TagData,
          PrefetchHooks Function({bool momentTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                name: name,
                color: color,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> color = const Value.absent(),
                required DateTime createdAt,
              }) => TagsCompanion.insert(
                id: id,
                name: name,
                color: color,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TagsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({momentTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (momentTagsRefs) db.momentTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (momentTagsRefs)
                    await $_getPrefetchedData<
                      TagData,
                      $TagsTable,
                      MomentTagData
                    >(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences
                          ._momentTagsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TagsTableReferences(db, table, p0).momentTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      TagData,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (TagData, $$TagsTableReferences),
      TagData,
      PrefetchHooks Function({bool momentTagsRefs})
    >;
typedef $$MomentTagsTableCreateCompanionBuilder =
    MomentTagsCompanion Function({
      required int momentId,
      required int tagId,
      Value<int> rowid,
    });
typedef $$MomentTagsTableUpdateCompanionBuilder =
    MomentTagsCompanion Function({
      Value<int> momentId,
      Value<int> tagId,
      Value<int> rowid,
    });

final class $$MomentTagsTableReferences
    extends BaseReferences<_$AppDatabase, $MomentTagsTable, MomentTagData> {
  $$MomentTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MomentsTable _momentIdTable(_$AppDatabase db) => db.moments
      .createAlias($_aliasNameGenerator(db.momentTags.momentId, db.moments.id));

  $$MomentsTableProcessedTableManager get momentId {
    final $_column = $_itemColumn<int>('moment_id')!;

    final manager = $$MomentsTableTableManager(
      $_db,
      $_db.moments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_momentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) => db.tags.createAlias(
    $_aliasNameGenerator(db.momentTags.tagId, db.tags.id),
  );

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MomentTagsTableFilterComposer
    extends Composer<_$AppDatabase, $MomentTagsTable> {
  $$MomentTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MomentsTableFilterComposer get momentId {
    final $$MomentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableFilterComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MomentTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $MomentTagsTable> {
  $$MomentTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MomentsTableOrderingComposer get momentId {
    final $$MomentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableOrderingComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MomentTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MomentTagsTable> {
  $$MomentTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MomentsTableAnnotationComposer get momentId {
    final $$MomentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableAnnotationComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MomentTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MomentTagsTable,
          MomentTagData,
          $$MomentTagsTableFilterComposer,
          $$MomentTagsTableOrderingComposer,
          $$MomentTagsTableAnnotationComposer,
          $$MomentTagsTableCreateCompanionBuilder,
          $$MomentTagsTableUpdateCompanionBuilder,
          (MomentTagData, $$MomentTagsTableReferences),
          MomentTagData,
          PrefetchHooks Function({bool momentId, bool tagId})
        > {
  $$MomentTagsTableTableManager(_$AppDatabase db, $MomentTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MomentTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MomentTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MomentTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> momentId = const Value.absent(),
                Value<int> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MomentTagsCompanion(
                momentId: momentId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int momentId,
                required int tagId,
                Value<int> rowid = const Value.absent(),
              }) => MomentTagsCompanion.insert(
                momentId: momentId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MomentTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({momentId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (momentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.momentId,
                                referencedTable: $$MomentTagsTableReferences
                                    ._momentIdTable(db),
                                referencedColumn: $$MomentTagsTableReferences
                                    ._momentIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable: $$MomentTagsTableReferences
                                    ._tagIdTable(db),
                                referencedColumn: $$MomentTagsTableReferences
                                    ._tagIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MomentTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MomentTagsTable,
      MomentTagData,
      $$MomentTagsTableFilterComposer,
      $$MomentTagsTableOrderingComposer,
      $$MomentTagsTableAnnotationComposer,
      $$MomentTagsTableCreateCompanionBuilder,
      $$MomentTagsTableUpdateCompanionBuilder,
      (MomentTagData, $$MomentTagsTableReferences),
      MomentTagData,
      PrefetchHooks Function({bool momentId, bool tagId})
    >;
typedef $$AiProcessingQueueTableCreateCompanionBuilder =
    AiProcessingQueueCompanion Function({
      Value<int> id,
      required int momentId,
      required TaskType taskType,
      required ProcessingStatus status,
      Value<int> priority,
      Value<int> attempts,
      Value<String?> errorMessage,
      required DateTime createdAt,
      Value<DateTime?> processedAt,
    });
typedef $$AiProcessingQueueTableUpdateCompanionBuilder =
    AiProcessingQueueCompanion Function({
      Value<int> id,
      Value<int> momentId,
      Value<TaskType> taskType,
      Value<ProcessingStatus> status,
      Value<int> priority,
      Value<int> attempts,
      Value<String?> errorMessage,
      Value<DateTime> createdAt,
      Value<DateTime?> processedAt,
    });

final class $$AiProcessingQueueTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AiProcessingQueueTable,
          ProcessingTaskData
        > {
  $$AiProcessingQueueTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MomentsTable _momentIdTable(_$AppDatabase db) =>
      db.moments.createAlias(
        $_aliasNameGenerator(db.aiProcessingQueue.momentId, db.moments.id),
      );

  $$MomentsTableProcessedTableManager get momentId {
    final $_column = $_itemColumn<int>('moment_id')!;

    final manager = $$MomentsTableTableManager(
      $_db,
      $_db.moments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_momentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AiProcessingQueueTableFilterComposer
    extends Composer<_$AppDatabase, $AiProcessingQueueTable> {
  $$AiProcessingQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskType, TaskType, String> get taskType =>
      $composableBuilder(
        column: $table.taskType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<ProcessingStatus, ProcessingStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MomentsTableFilterComposer get momentId {
    final $$MomentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableFilterComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AiProcessingQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $AiProcessingQueueTable> {
  $$AiProcessingQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MomentsTableOrderingComposer get momentId {
    final $$MomentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableOrderingComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AiProcessingQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiProcessingQueueTable> {
  $$AiProcessingQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskType, String> get taskType =>
      $composableBuilder(column: $table.taskType, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ProcessingStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => column,
  );

  $$MomentsTableAnnotationComposer get momentId {
    final $$MomentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableAnnotationComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AiProcessingQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiProcessingQueueTable,
          ProcessingTaskData,
          $$AiProcessingQueueTableFilterComposer,
          $$AiProcessingQueueTableOrderingComposer,
          $$AiProcessingQueueTableAnnotationComposer,
          $$AiProcessingQueueTableCreateCompanionBuilder,
          $$AiProcessingQueueTableUpdateCompanionBuilder,
          (ProcessingTaskData, $$AiProcessingQueueTableReferences),
          ProcessingTaskData,
          PrefetchHooks Function({bool momentId})
        > {
  $$AiProcessingQueueTableTableManager(
    _$AppDatabase db,
    $AiProcessingQueueTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiProcessingQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiProcessingQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiProcessingQueueTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> momentId = const Value.absent(),
                Value<TaskType> taskType = const Value.absent(),
                Value<ProcessingStatus> status = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> processedAt = const Value.absent(),
              }) => AiProcessingQueueCompanion(
                id: id,
                momentId: momentId,
                taskType: taskType,
                status: status,
                priority: priority,
                attempts: attempts,
                errorMessage: errorMessage,
                createdAt: createdAt,
                processedAt: processedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int momentId,
                required TaskType taskType,
                required ProcessingStatus status,
                Value<int> priority = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> processedAt = const Value.absent(),
              }) => AiProcessingQueueCompanion.insert(
                id: id,
                momentId: momentId,
                taskType: taskType,
                status: status,
                priority: priority,
                attempts: attempts,
                errorMessage: errorMessage,
                createdAt: createdAt,
                processedAt: processedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AiProcessingQueueTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({momentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (momentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.momentId,
                                referencedTable:
                                    $$AiProcessingQueueTableReferences
                                        ._momentIdTable(db),
                                referencedColumn:
                                    $$AiProcessingQueueTableReferences
                                        ._momentIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AiProcessingQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiProcessingQueueTable,
      ProcessingTaskData,
      $$AiProcessingQueueTableFilterComposer,
      $$AiProcessingQueueTableOrderingComposer,
      $$AiProcessingQueueTableAnnotationComposer,
      $$AiProcessingQueueTableCreateCompanionBuilder,
      $$AiProcessingQueueTableUpdateCompanionBuilder,
      (ProcessingTaskData, $$AiProcessingQueueTableReferences),
      ProcessingTaskData,
      PrefetchHooks Function({bool momentId})
    >;
typedef $$EmbeddingsTableCreateCompanionBuilder =
    EmbeddingsCompanion Function({
      Value<int> id,
      required int momentId,
      required Uint8List embeddingData,
      required EmbeddingType embeddingType,
      required DateTime createdAt,
    });
typedef $$EmbeddingsTableUpdateCompanionBuilder =
    EmbeddingsCompanion Function({
      Value<int> id,
      Value<int> momentId,
      Value<Uint8List> embeddingData,
      Value<EmbeddingType> embeddingType,
      Value<DateTime> createdAt,
    });

final class $$EmbeddingsTableReferences
    extends BaseReferences<_$AppDatabase, $EmbeddingsTable, EmbeddingData> {
  $$EmbeddingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MomentsTable _momentIdTable(_$AppDatabase db) => db.moments
      .createAlias($_aliasNameGenerator(db.embeddings.momentId, db.moments.id));

  $$MomentsTableProcessedTableManager get momentId {
    final $_column = $_itemColumn<int>('moment_id')!;

    final manager = $$MomentsTableTableManager(
      $_db,
      $_db.moments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_momentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EmbeddingsTableFilterComposer
    extends Composer<_$AppDatabase, $EmbeddingsTable> {
  $$EmbeddingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get embeddingData => $composableBuilder(
    column: $table.embeddingData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EmbeddingType, EmbeddingType, String>
  get embeddingType => $composableBuilder(
    column: $table.embeddingType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MomentsTableFilterComposer get momentId {
    final $$MomentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableFilterComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmbeddingsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmbeddingsTable> {
  $$EmbeddingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get embeddingData => $composableBuilder(
    column: $table.embeddingData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get embeddingType => $composableBuilder(
    column: $table.embeddingType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MomentsTableOrderingComposer get momentId {
    final $$MomentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableOrderingComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmbeddingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmbeddingsTable> {
  $$EmbeddingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<Uint8List> get embeddingData => $composableBuilder(
    column: $table.embeddingData,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<EmbeddingType, String> get embeddingType =>
      $composableBuilder(
        column: $table.embeddingType,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MomentsTableAnnotationComposer get momentId {
    final $$MomentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableAnnotationComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmbeddingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmbeddingsTable,
          EmbeddingData,
          $$EmbeddingsTableFilterComposer,
          $$EmbeddingsTableOrderingComposer,
          $$EmbeddingsTableAnnotationComposer,
          $$EmbeddingsTableCreateCompanionBuilder,
          $$EmbeddingsTableUpdateCompanionBuilder,
          (EmbeddingData, $$EmbeddingsTableReferences),
          EmbeddingData,
          PrefetchHooks Function({bool momentId})
        > {
  $$EmbeddingsTableTableManager(_$AppDatabase db, $EmbeddingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmbeddingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmbeddingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmbeddingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> momentId = const Value.absent(),
                Value<Uint8List> embeddingData = const Value.absent(),
                Value<EmbeddingType> embeddingType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EmbeddingsCompanion(
                id: id,
                momentId: momentId,
                embeddingData: embeddingData,
                embeddingType: embeddingType,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int momentId,
                required Uint8List embeddingData,
                required EmbeddingType embeddingType,
                required DateTime createdAt,
              }) => EmbeddingsCompanion.insert(
                id: id,
                momentId: momentId,
                embeddingData: embeddingData,
                embeddingType: embeddingType,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmbeddingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({momentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (momentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.momentId,
                                referencedTable: $$EmbeddingsTableReferences
                                    ._momentIdTable(db),
                                referencedColumn: $$EmbeddingsTableReferences
                                    ._momentIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EmbeddingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmbeddingsTable,
      EmbeddingData,
      $$EmbeddingsTableFilterComposer,
      $$EmbeddingsTableOrderingComposer,
      $$EmbeddingsTableAnnotationComposer,
      $$EmbeddingsTableCreateCompanionBuilder,
      $$EmbeddingsTableUpdateCompanionBuilder,
      (EmbeddingData, $$EmbeddingsTableReferences),
      EmbeddingData,
      PrefetchHooks Function({bool momentId})
    >;
typedef $$MoodAnalysisTableTableCreateCompanionBuilder =
    MoodAnalysisTableCompanion Function({
      Value<int> id,
      required int momentId,
      Value<double?> moodScore,
      Value<String?> primaryMood,
      Value<double?> confidenceScore,
      Value<String?> moodKeywords,
      required DateTime analysisTimestamp,
    });
typedef $$MoodAnalysisTableTableUpdateCompanionBuilder =
    MoodAnalysisTableCompanion Function({
      Value<int> id,
      Value<int> momentId,
      Value<double?> moodScore,
      Value<String?> primaryMood,
      Value<double?> confidenceScore,
      Value<String?> moodKeywords,
      Value<DateTime> analysisTimestamp,
    });

final class $$MoodAnalysisTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MoodAnalysisTableTable,
          MoodAnalysisData
        > {
  $$MoodAnalysisTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MomentsTable _momentIdTable(_$AppDatabase db) =>
      db.moments.createAlias(
        $_aliasNameGenerator(db.moodAnalysisTable.momentId, db.moments.id),
      );

  $$MomentsTableProcessedTableManager get momentId {
    final $_column = $_itemColumn<int>('moment_id')!;

    final manager = $$MomentsTableTableManager(
      $_db,
      $_db.moments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_momentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MoodAnalysisTableTableFilterComposer
    extends Composer<_$AppDatabase, $MoodAnalysisTableTable> {
  $$MoodAnalysisTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get moodScore => $composableBuilder(
    column: $table.moodScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryMood => $composableBuilder(
    column: $table.primaryMood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidenceScore => $composableBuilder(
    column: $table.confidenceScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moodKeywords => $composableBuilder(
    column: $table.moodKeywords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get analysisTimestamp => $composableBuilder(
    column: $table.analysisTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  $$MomentsTableFilterComposer get momentId {
    final $$MomentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableFilterComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodAnalysisTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodAnalysisTableTable> {
  $$MoodAnalysisTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get moodScore => $composableBuilder(
    column: $table.moodScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryMood => $composableBuilder(
    column: $table.primaryMood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidenceScore => $composableBuilder(
    column: $table.confidenceScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moodKeywords => $composableBuilder(
    column: $table.moodKeywords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get analysisTimestamp => $composableBuilder(
    column: $table.analysisTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  $$MomentsTableOrderingComposer get momentId {
    final $$MomentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableOrderingComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodAnalysisTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodAnalysisTableTable> {
  $$MoodAnalysisTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get moodScore =>
      $composableBuilder(column: $table.moodScore, builder: (column) => column);

  GeneratedColumn<String> get primaryMood => $composableBuilder(
    column: $table.primaryMood,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidenceScore => $composableBuilder(
    column: $table.confidenceScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moodKeywords => $composableBuilder(
    column: $table.moodKeywords,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get analysisTimestamp => $composableBuilder(
    column: $table.analysisTimestamp,
    builder: (column) => column,
  );

  $$MomentsTableAnnotationComposer get momentId {
    final $$MomentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableAnnotationComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodAnalysisTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodAnalysisTableTable,
          MoodAnalysisData,
          $$MoodAnalysisTableTableFilterComposer,
          $$MoodAnalysisTableTableOrderingComposer,
          $$MoodAnalysisTableTableAnnotationComposer,
          $$MoodAnalysisTableTableCreateCompanionBuilder,
          $$MoodAnalysisTableTableUpdateCompanionBuilder,
          (MoodAnalysisData, $$MoodAnalysisTableTableReferences),
          MoodAnalysisData,
          PrefetchHooks Function({bool momentId})
        > {
  $$MoodAnalysisTableTableTableManager(
    _$AppDatabase db,
    $MoodAnalysisTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodAnalysisTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodAnalysisTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodAnalysisTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> momentId = const Value.absent(),
                Value<double?> moodScore = const Value.absent(),
                Value<String?> primaryMood = const Value.absent(),
                Value<double?> confidenceScore = const Value.absent(),
                Value<String?> moodKeywords = const Value.absent(),
                Value<DateTime> analysisTimestamp = const Value.absent(),
              }) => MoodAnalysisTableCompanion(
                id: id,
                momentId: momentId,
                moodScore: moodScore,
                primaryMood: primaryMood,
                confidenceScore: confidenceScore,
                moodKeywords: moodKeywords,
                analysisTimestamp: analysisTimestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int momentId,
                Value<double?> moodScore = const Value.absent(),
                Value<String?> primaryMood = const Value.absent(),
                Value<double?> confidenceScore = const Value.absent(),
                Value<String?> moodKeywords = const Value.absent(),
                required DateTime analysisTimestamp,
              }) => MoodAnalysisTableCompanion.insert(
                id: id,
                momentId: momentId,
                moodScore: moodScore,
                primaryMood: primaryMood,
                confidenceScore: confidenceScore,
                moodKeywords: moodKeywords,
                analysisTimestamp: analysisTimestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MoodAnalysisTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({momentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (momentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.momentId,
                                referencedTable:
                                    $$MoodAnalysisTableTableReferences
                                        ._momentIdTable(db),
                                referencedColumn:
                                    $$MoodAnalysisTableTableReferences
                                        ._momentIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MoodAnalysisTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodAnalysisTableTable,
      MoodAnalysisData,
      $$MoodAnalysisTableTableFilterComposer,
      $$MoodAnalysisTableTableOrderingComposer,
      $$MoodAnalysisTableTableAnnotationComposer,
      $$MoodAnalysisTableTableCreateCompanionBuilder,
      $$MoodAnalysisTableTableUpdateCompanionBuilder,
      (MoodAnalysisData, $$MoodAnalysisTableTableReferences),
      MoodAnalysisData,
      PrefetchHooks Function({bool momentId})
    >;
typedef $$LlmAnalysisTableTableCreateCompanionBuilder =
    LlmAnalysisTableCompanion Function({
      Value<int> id,
      required int momentId,
      required AnalysisType analysisType,
      required String analysisContent,
      Value<double?> confidenceScore,
      required DateTime createdAt,
    });
typedef $$LlmAnalysisTableTableUpdateCompanionBuilder =
    LlmAnalysisTableCompanion Function({
      Value<int> id,
      Value<int> momentId,
      Value<AnalysisType> analysisType,
      Value<String> analysisContent,
      Value<double?> confidenceScore,
      Value<DateTime> createdAt,
    });

final class $$LlmAnalysisTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $LlmAnalysisTableTable, LLMAnalysisData> {
  $$LlmAnalysisTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MomentsTable _momentIdTable(_$AppDatabase db) =>
      db.moments.createAlias(
        $_aliasNameGenerator(db.llmAnalysisTable.momentId, db.moments.id),
      );

  $$MomentsTableProcessedTableManager get momentId {
    final $_column = $_itemColumn<int>('moment_id')!;

    final manager = $$MomentsTableTableManager(
      $_db,
      $_db.moments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_momentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LlmAnalysisTableTableFilterComposer
    extends Composer<_$AppDatabase, $LlmAnalysisTableTable> {
  $$LlmAnalysisTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AnalysisType, AnalysisType, String>
  get analysisType => $composableBuilder(
    column: $table.analysisType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get analysisContent => $composableBuilder(
    column: $table.analysisContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidenceScore => $composableBuilder(
    column: $table.confidenceScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MomentsTableFilterComposer get momentId {
    final $$MomentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableFilterComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LlmAnalysisTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LlmAnalysisTableTable> {
  $$LlmAnalysisTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get analysisType => $composableBuilder(
    column: $table.analysisType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get analysisContent => $composableBuilder(
    column: $table.analysisContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidenceScore => $composableBuilder(
    column: $table.confidenceScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MomentsTableOrderingComposer get momentId {
    final $$MomentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableOrderingComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LlmAnalysisTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LlmAnalysisTableTable> {
  $$LlmAnalysisTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AnalysisType, String> get analysisType =>
      $composableBuilder(
        column: $table.analysisType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get analysisContent => $composableBuilder(
    column: $table.analysisContent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidenceScore => $composableBuilder(
    column: $table.confidenceScore,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MomentsTableAnnotationComposer get momentId {
    final $$MomentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.momentId,
      referencedTable: $db.moments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentsTableAnnotationComposer(
            $db: $db,
            $table: $db.moments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LlmAnalysisTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LlmAnalysisTableTable,
          LLMAnalysisData,
          $$LlmAnalysisTableTableFilterComposer,
          $$LlmAnalysisTableTableOrderingComposer,
          $$LlmAnalysisTableTableAnnotationComposer,
          $$LlmAnalysisTableTableCreateCompanionBuilder,
          $$LlmAnalysisTableTableUpdateCompanionBuilder,
          (LLMAnalysisData, $$LlmAnalysisTableTableReferences),
          LLMAnalysisData,
          PrefetchHooks Function({bool momentId})
        > {
  $$LlmAnalysisTableTableTableManager(
    _$AppDatabase db,
    $LlmAnalysisTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LlmAnalysisTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LlmAnalysisTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LlmAnalysisTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> momentId = const Value.absent(),
                Value<AnalysisType> analysisType = const Value.absent(),
                Value<String> analysisContent = const Value.absent(),
                Value<double?> confidenceScore = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LlmAnalysisTableCompanion(
                id: id,
                momentId: momentId,
                analysisType: analysisType,
                analysisContent: analysisContent,
                confidenceScore: confidenceScore,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int momentId,
                required AnalysisType analysisType,
                required String analysisContent,
                Value<double?> confidenceScore = const Value.absent(),
                required DateTime createdAt,
              }) => LlmAnalysisTableCompanion.insert(
                id: id,
                momentId: momentId,
                analysisType: analysisType,
                analysisContent: analysisContent,
                confidenceScore: confidenceScore,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LlmAnalysisTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({momentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (momentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.momentId,
                                referencedTable:
                                    $$LlmAnalysisTableTableReferences
                                        ._momentIdTable(db),
                                referencedColumn:
                                    $$LlmAnalysisTableTableReferences
                                        ._momentIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LlmAnalysisTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LlmAnalysisTableTable,
      LLMAnalysisData,
      $$LlmAnalysisTableTableFilterComposer,
      $$LlmAnalysisTableTableOrderingComposer,
      $$LlmAnalysisTableTableAnnotationComposer,
      $$LlmAnalysisTableTableCreateCompanionBuilder,
      $$LlmAnalysisTableTableUpdateCompanionBuilder,
      (LLMAnalysisData, $$LlmAnalysisTableTableReferences),
      LLMAnalysisData,
      PrefetchHooks Function({bool momentId})
    >;
typedef $$KeyValuesTableCreateCompanionBuilder =
    KeyValuesCompanion Function({
      required String key,
      required String value,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$KeyValuesTableUpdateCompanionBuilder =
    KeyValuesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$KeyValuesTableFilterComposer
    extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KeyValuesTableOrderingComposer
    extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KeyValuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$KeyValuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KeyValuesTable,
          KeyValue,
          $$KeyValuesTableFilterComposer,
          $$KeyValuesTableOrderingComposer,
          $$KeyValuesTableAnnotationComposer,
          $$KeyValuesTableCreateCompanionBuilder,
          $$KeyValuesTableUpdateCompanionBuilder,
          (KeyValue, BaseReferences<_$AppDatabase, $KeyValuesTable, KeyValue>),
          KeyValue,
          PrefetchHooks Function()
        > {
  $$KeyValuesTableTableManager(_$AppDatabase db, $KeyValuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KeyValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KeyValuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KeyValuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KeyValuesCompanion(
                key: key,
                value: value,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => KeyValuesCompanion.insert(
                key: key,
                value: value,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KeyValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KeyValuesTable,
      KeyValue,
      $$KeyValuesTableFilterComposer,
      $$KeyValuesTableOrderingComposer,
      $$KeyValuesTableAnnotationComposer,
      $$KeyValuesTableCreateCompanionBuilder,
      $$KeyValuesTableUpdateCompanionBuilder,
      (KeyValue, BaseReferences<_$AppDatabase, $KeyValuesTable, KeyValue>),
      KeyValue,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MomentsTableTableManager get moments =>
      $$MomentsTableTableManager(_db, _db.moments);
  $$MediaAttachmentsTableTableManager get mediaAttachments =>
      $$MediaAttachmentsTableTableManager(_db, _db.mediaAttachments);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$MomentTagsTableTableManager get momentTags =>
      $$MomentTagsTableTableManager(_db, _db.momentTags);
  $$AiProcessingQueueTableTableManager get aiProcessingQueue =>
      $$AiProcessingQueueTableTableManager(_db, _db.aiProcessingQueue);
  $$EmbeddingsTableTableManager get embeddings =>
      $$EmbeddingsTableTableManager(_db, _db.embeddings);
  $$MoodAnalysisTableTableTableManager get moodAnalysisTable =>
      $$MoodAnalysisTableTableTableManager(_db, _db.moodAnalysisTable);
  $$LlmAnalysisTableTableTableManager get llmAnalysisTable =>
      $$LlmAnalysisTableTableTableManager(_db, _db.llmAnalysisTable);
  $$KeyValuesTableTableManager get keyValues =>
      $$KeyValuesTableTableManager(_db, _db.keyValues);
}
