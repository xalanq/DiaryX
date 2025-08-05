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
  static const VerificationMeta _aiSummaryMeta = const VerificationMeta(
    'aiSummary',
  );
  @override
  late final GeneratedColumn<String> aiSummary = GeneratedColumn<String>(
    'ai_summary',
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
    aiSummary,
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
    if (data.containsKey('ai_summary')) {
      context.handle(
        _aiSummaryMeta,
        aiSummary.isAcceptableOrUnknown(data['ai_summary']!, _aiSummaryMeta),
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
      aiSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_summary'],
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
  /// Primary key, auto-incrementing unique identifier
  final int id;

  /// Main content of the diary moment
  final String content;

  /// AI-generated summary of the moment
  final String? aiSummary;

  /// When this moment was originally created
  final DateTime createdAt;

  /// When this moment was last updated
  final DateTime updatedAt;

  /// Whether AI has processed this moment
  final bool aiProcessed;
  const MomentData({
    required this.id,
    required this.content,
    this.aiSummary,
    required this.createdAt,
    required this.updatedAt,
    required this.aiProcessed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || aiSummary != null) {
      map['ai_summary'] = Variable<String>(aiSummary);
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
      aiSummary: aiSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(aiSummary),
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
      aiSummary: serializer.fromJson<String?>(json['aiSummary']),
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
      'aiSummary': serializer.toJson<String?>(aiSummary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'aiProcessed': serializer.toJson<bool>(aiProcessed),
    };
  }

  MomentData copyWith({
    int? id,
    String? content,
    Value<String?> aiSummary = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? aiProcessed,
  }) => MomentData(
    id: id ?? this.id,
    content: content ?? this.content,
    aiSummary: aiSummary.present ? aiSummary.value : this.aiSummary,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    aiProcessed: aiProcessed ?? this.aiProcessed,
  );
  MomentData copyWithCompanion(MomentsCompanion data) {
    return MomentData(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      aiSummary: data.aiSummary.present ? data.aiSummary.value : this.aiSummary,
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
          ..write('aiSummary: $aiSummary, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('aiProcessed: $aiProcessed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, content, aiSummary, createdAt, updatedAt, aiProcessed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MomentData &&
          other.id == this.id &&
          other.content == this.content &&
          other.aiSummary == this.aiSummary &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.aiProcessed == this.aiProcessed);
}

class MomentsCompanion extends UpdateCompanion<MomentData> {
  final Value<int> id;
  final Value<String> content;
  final Value<String?> aiSummary;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> aiProcessed;
  const MomentsCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.aiSummary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.aiProcessed = const Value.absent(),
  });
  MomentsCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    this.aiSummary = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.aiProcessed = const Value.absent(),
  }) : content = Value(content),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MomentData> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<String>? aiSummary,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? aiProcessed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (aiSummary != null) 'ai_summary': aiSummary,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (aiProcessed != null) 'ai_processed': aiProcessed,
    });
  }

  MomentsCompanion copyWith({
    Value<int>? id,
    Value<String>? content,
    Value<String?>? aiSummary,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? aiProcessed,
  }) {
    return MomentsCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      aiSummary: aiSummary ?? this.aiSummary,
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
    if (aiSummary.present) {
      map['ai_summary'] = Variable<String>(aiSummary.value);
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
          ..write('aiSummary: $aiSummary, ')
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
  static const VerificationMeta _aiSummaryMeta = const VerificationMeta(
    'aiSummary',
  );
  @override
  late final GeneratedColumn<String> aiSummary = GeneratedColumn<String>(
    'ai_summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    aiSummary,
    aiProcessed,
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
    if (data.containsKey('ai_summary')) {
      context.handle(
        _aiSummaryMeta,
        aiSummary.isAcceptableOrUnknown(data['ai_summary']!, _aiSummaryMeta),
      );
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
      aiSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_summary'],
      ),
      aiProcessed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ai_processed'],
      )!,
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
  /// Primary key, auto-incrementing unique identifier
  final int id;

  /// Foreign key referencing the associated moment
  final int momentId;

  /// Local file path where the media is stored
  final String filePath;

  /// Type of media (image, video, audio)
  final MediaType mediaType;

  /// Size of the media file in bytes
  final int? fileSize;

  /// Duration in seconds for video/audio files
  final double? duration;

  /// Path to generated thumbnail for video/image files
  final String? thumbnailPath;

  /// AI-generated summary of media content
  final String? aiSummary;

  /// Whether AI has processed this media
  final bool aiProcessed;

  /// When this media attachment was created
  final DateTime createdAt;
  const MediaAttachmentData({
    required this.id,
    required this.momentId,
    required this.filePath,
    required this.mediaType,
    this.fileSize,
    this.duration,
    this.thumbnailPath,
    this.aiSummary,
    required this.aiProcessed,
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
    if (!nullToAbsent || aiSummary != null) {
      map['ai_summary'] = Variable<String>(aiSummary);
    }
    map['ai_processed'] = Variable<bool>(aiProcessed);
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
      aiSummary: aiSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(aiSummary),
      aiProcessed: Value(aiProcessed),
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
      aiSummary: serializer.fromJson<String?>(json['aiSummary']),
      aiProcessed: serializer.fromJson<bool>(json['aiProcessed']),
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
      'aiSummary': serializer.toJson<String?>(aiSummary),
      'aiProcessed': serializer.toJson<bool>(aiProcessed),
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
    Value<String?> aiSummary = const Value.absent(),
    bool? aiProcessed,
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
    aiSummary: aiSummary.present ? aiSummary.value : this.aiSummary,
    aiProcessed: aiProcessed ?? this.aiProcessed,
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
      aiSummary: data.aiSummary.present ? data.aiSummary.value : this.aiSummary,
      aiProcessed: data.aiProcessed.present
          ? data.aiProcessed.value
          : this.aiProcessed,
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
          ..write('aiSummary: $aiSummary, ')
          ..write('aiProcessed: $aiProcessed, ')
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
    aiSummary,
    aiProcessed,
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
          other.aiSummary == this.aiSummary &&
          other.aiProcessed == this.aiProcessed &&
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
  final Value<String?> aiSummary;
  final Value<bool> aiProcessed;
  final Value<DateTime> createdAt;
  const MediaAttachmentsCompanion({
    this.id = const Value.absent(),
    this.momentId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.duration = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.aiSummary = const Value.absent(),
    this.aiProcessed = const Value.absent(),
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
    this.aiSummary = const Value.absent(),
    this.aiProcessed = const Value.absent(),
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
    Expression<String>? aiSummary,
    Expression<bool>? aiProcessed,
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
      if (aiSummary != null) 'ai_summary': aiSummary,
      if (aiProcessed != null) 'ai_processed': aiProcessed,
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
    Value<String?>? aiSummary,
    Value<bool>? aiProcessed,
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
      aiSummary: aiSummary ?? this.aiSummary,
      aiProcessed: aiProcessed ?? this.aiProcessed,
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
    if (aiSummary.present) {
      map['ai_summary'] = Variable<String>(aiSummary.value);
    }
    if (aiProcessed.present) {
      map['ai_processed'] = Variable<bool>(aiProcessed.value);
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
          ..write('aiSummary: $aiSummary, ')
          ..write('aiProcessed: $aiProcessed, ')
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
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
    'tag',
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
  @override
  List<GeneratedColumn> get $columns => [momentId, tag, createdAt];
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
    if (data.containsKey('tag')) {
      context.handle(
        _tagMeta,
        tag.isAcceptableOrUnknown(data['tag']!, _tagMeta),
      );
    } else if (isInserting) {
      context.missing(_tagMeta);
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
  Set<GeneratedColumn> get $primaryKey => {momentId, tag};
  @override
  MomentTagData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MomentTagData(
      momentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moment_id'],
      )!,
      tag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MomentTagsTable createAlias(String alias) {
    return $MomentTagsTable(attachedDatabase, alias);
  }
}

class MomentTagData extends DataClass implements Insertable<MomentTagData> {
  /// Foreign key referencing the moment
  final int momentId;

  /// Tag name as string (no separate table needed)
  final String tag;

  /// When this tag association was created
  final DateTime createdAt;
  const MomentTagData({
    required this.momentId,
    required this.tag,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['moment_id'] = Variable<int>(momentId);
    map['tag'] = Variable<String>(tag);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MomentTagsCompanion toCompanion(bool nullToAbsent) {
    return MomentTagsCompanion(
      momentId: Value(momentId),
      tag: Value(tag),
      createdAt: Value(createdAt),
    );
  }

  factory MomentTagData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MomentTagData(
      momentId: serializer.fromJson<int>(json['momentId']),
      tag: serializer.fromJson<String>(json['tag']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'momentId': serializer.toJson<int>(momentId),
      'tag': serializer.toJson<String>(tag),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MomentTagData copyWith({int? momentId, String? tag, DateTime? createdAt}) =>
      MomentTagData(
        momentId: momentId ?? this.momentId,
        tag: tag ?? this.tag,
        createdAt: createdAt ?? this.createdAt,
      );
  MomentTagData copyWithCompanion(MomentTagsCompanion data) {
    return MomentTagData(
      momentId: data.momentId.present ? data.momentId.value : this.momentId,
      tag: data.tag.present ? data.tag.value : this.tag,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MomentTagData(')
          ..write('momentId: $momentId, ')
          ..write('tag: $tag, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(momentId, tag, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MomentTagData &&
          other.momentId == this.momentId &&
          other.tag == this.tag &&
          other.createdAt == this.createdAt);
}

class MomentTagsCompanion extends UpdateCompanion<MomentTagData> {
  final Value<int> momentId;
  final Value<String> tag;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MomentTagsCompanion({
    this.momentId = const Value.absent(),
    this.tag = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MomentTagsCompanion.insert({
    required int momentId,
    required String tag,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : momentId = Value(momentId),
       tag = Value(tag),
       createdAt = Value(createdAt);
  static Insertable<MomentTagData> custom({
    Expression<int>? momentId,
    Expression<String>? tag,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (momentId != null) 'moment_id': momentId,
      if (tag != null) 'tag': tag,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MomentTagsCompanion copyWith({
    Value<int>? momentId,
    Value<String>? tag,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MomentTagsCompanion(
      momentId: momentId ?? this.momentId,
      tag: tag ?? this.tag,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (momentId.present) {
      map['moment_id'] = Variable<int>(momentId.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
          ..write('tag: $tag, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MomentMoodsTable extends MomentMoods
    with TableInfo<$MomentMoodsTable, MomentMoodData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MomentMoodsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
    'mood',
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
  @override
  List<GeneratedColumn> get $columns => [momentId, mood, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moment_moods';
  @override
  VerificationContext validateIntegrity(
    Insertable<MomentMoodData> instance, {
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
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    } else if (isInserting) {
      context.missing(_moodMeta);
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
  Set<GeneratedColumn> get $primaryKey => {momentId, mood};
  @override
  MomentMoodData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MomentMoodData(
      momentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moment_id'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MomentMoodsTable createAlias(String alias) {
    return $MomentMoodsTable(attachedDatabase, alias);
  }
}

class MomentMoodData extends DataClass implements Insertable<MomentMoodData> {
  /// Foreign key referencing the moment
  final int momentId;

  /// Mood name (string value from MoodType enum)
  final String mood;

  /// When this mood association was created
  final DateTime createdAt;
  const MomentMoodData({
    required this.momentId,
    required this.mood,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['moment_id'] = Variable<int>(momentId);
    map['mood'] = Variable<String>(mood);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MomentMoodsCompanion toCompanion(bool nullToAbsent) {
    return MomentMoodsCompanion(
      momentId: Value(momentId),
      mood: Value(mood),
      createdAt: Value(createdAt),
    );
  }

  factory MomentMoodData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MomentMoodData(
      momentId: serializer.fromJson<int>(json['momentId']),
      mood: serializer.fromJson<String>(json['mood']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'momentId': serializer.toJson<int>(momentId),
      'mood': serializer.toJson<String>(mood),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MomentMoodData copyWith({int? momentId, String? mood, DateTime? createdAt}) =>
      MomentMoodData(
        momentId: momentId ?? this.momentId,
        mood: mood ?? this.mood,
        createdAt: createdAt ?? this.createdAt,
      );
  MomentMoodData copyWithCompanion(MomentMoodsCompanion data) {
    return MomentMoodData(
      momentId: data.momentId.present ? data.momentId.value : this.momentId,
      mood: data.mood.present ? data.mood.value : this.mood,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MomentMoodData(')
          ..write('momentId: $momentId, ')
          ..write('mood: $mood, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(momentId, mood, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MomentMoodData &&
          other.momentId == this.momentId &&
          other.mood == this.mood &&
          other.createdAt == this.createdAt);
}

class MomentMoodsCompanion extends UpdateCompanion<MomentMoodData> {
  final Value<int> momentId;
  final Value<String> mood;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MomentMoodsCompanion({
    this.momentId = const Value.absent(),
    this.mood = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MomentMoodsCompanion.insert({
    required int momentId,
    required String mood,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : momentId = Value(momentId),
       mood = Value(mood),
       createdAt = Value(createdAt);
  static Insertable<MomentMoodData> custom({
    Expression<int>? momentId,
    Expression<String>? mood,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (momentId != null) 'moment_id': momentId,
      if (mood != null) 'mood': mood,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MomentMoodsCompanion copyWith({
    Value<int>? momentId,
    Value<String>? mood,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MomentMoodsCompanion(
      momentId: momentId ?? this.momentId,
      mood: mood ?? this.mood,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (momentId.present) {
      map['moment_id'] = Variable<int>(momentId.value);
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MomentMoodsCompanion(')
          ..write('momentId: $momentId, ')
          ..write('mood: $mood, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
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

class $TaskQueueTable extends TaskQueue
    with TableInfo<$TaskQueueTable, TaskQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
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
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
    'result',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    taskId,
    type,
    priority,
    label,
    status,
    createdAt,
    data,
    retryCount,
    startedAt,
    completedAt,
    error,
    result,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('result')) {
      context.handle(
        _resultMeta,
        result.isAcceptableOrUnknown(data['result']!, _resultMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId};
  @override
  TaskQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskQueueData(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      result: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result'],
      ),
    );
  }

  @override
  $TaskQueueTable createAlias(String alias) {
    return $TaskQueueTable(attachedDatabase, alias);
  }
}

class TaskQueueData extends DataClass implements Insertable<TaskQueueData> {
  /// Unique task identifier
  final String taskId;

  /// Task type as string (e.g., 'audio_transcription', 'image_analysis')
  final String type;

  /// Task priority (higher number = higher priority)
  final int priority;

  /// Human-readable task label for display
  final String label;

  /// Task status (pending, running, completed, failed, cancelled, retrying)
  final String status;

  /// Task creation timestamp
  final DateTime createdAt;

  /// Task data as JSON string
  final String data;

  /// Number of retry attempts
  final int retryCount;

  /// Task start timestamp (nullable)
  final DateTime? startedAt;

  /// Task completion timestamp (nullable)
  final DateTime? completedAt;

  /// Error message if task failed (nullable)
  final String? error;

  /// Task result as JSON string (nullable)
  final String? result;
  const TaskQueueData({
    required this.taskId,
    required this.type,
    required this.priority,
    required this.label,
    required this.status,
    required this.createdAt,
    required this.data,
    required this.retryCount,
    this.startedAt,
    this.completedAt,
    this.error,
    this.result,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<String>(taskId);
    map['type'] = Variable<String>(type);
    map['priority'] = Variable<int>(priority);
    map['label'] = Variable<String>(label);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['data'] = Variable<String>(data);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    if (!nullToAbsent || result != null) {
      map['result'] = Variable<String>(result);
    }
    return map;
  }

  TaskQueueCompanion toCompanion(bool nullToAbsent) {
    return TaskQueueCompanion(
      taskId: Value(taskId),
      type: Value(type),
      priority: Value(priority),
      label: Value(label),
      status: Value(status),
      createdAt: Value(createdAt),
      data: Value(data),
      retryCount: Value(retryCount),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
      result: result == null && nullToAbsent
          ? const Value.absent()
          : Value(result),
    );
  }

  factory TaskQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskQueueData(
      taskId: serializer.fromJson<String>(json['taskId']),
      type: serializer.fromJson<String>(json['type']),
      priority: serializer.fromJson<int>(json['priority']),
      label: serializer.fromJson<String>(json['label']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      data: serializer.fromJson<String>(json['data']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      error: serializer.fromJson<String?>(json['error']),
      result: serializer.fromJson<String?>(json['result']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<String>(taskId),
      'type': serializer.toJson<String>(type),
      'priority': serializer.toJson<int>(priority),
      'label': serializer.toJson<String>(label),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'data': serializer.toJson<String>(data),
      'retryCount': serializer.toJson<int>(retryCount),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'error': serializer.toJson<String?>(error),
      'result': serializer.toJson<String?>(result),
    };
  }

  TaskQueueData copyWith({
    String? taskId,
    String? type,
    int? priority,
    String? label,
    String? status,
    DateTime? createdAt,
    String? data,
    int? retryCount,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    Value<String?> error = const Value.absent(),
    Value<String?> result = const Value.absent(),
  }) => TaskQueueData(
    taskId: taskId ?? this.taskId,
    type: type ?? this.type,
    priority: priority ?? this.priority,
    label: label ?? this.label,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    data: data ?? this.data,
    retryCount: retryCount ?? this.retryCount,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    error: error.present ? error.value : this.error,
    result: result.present ? result.value : this.result,
  );
  TaskQueueData copyWithCompanion(TaskQueueCompanion data) {
    return TaskQueueData(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      type: data.type.present ? data.type.value : this.type,
      priority: data.priority.present ? data.priority.value : this.priority,
      label: data.label.present ? data.label.value : this.label,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      data: data.data.present ? data.data.value : this.data,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      error: data.error.present ? data.error.value : this.error,
      result: data.result.present ? data.result.value : this.result,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskQueueData(')
          ..write('taskId: $taskId, ')
          ..write('type: $type, ')
          ..write('priority: $priority, ')
          ..write('label: $label, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('data: $data, ')
          ..write('retryCount: $retryCount, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('error: $error, ')
          ..write('result: $result')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    taskId,
    type,
    priority,
    label,
    status,
    createdAt,
    data,
    retryCount,
    startedAt,
    completedAt,
    error,
    result,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskQueueData &&
          other.taskId == this.taskId &&
          other.type == this.type &&
          other.priority == this.priority &&
          other.label == this.label &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.data == this.data &&
          other.retryCount == this.retryCount &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.error == this.error &&
          other.result == this.result);
}

class TaskQueueCompanion extends UpdateCompanion<TaskQueueData> {
  final Value<String> taskId;
  final Value<String> type;
  final Value<int> priority;
  final Value<String> label;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<String> data;
  final Value<int> retryCount;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<String?> error;
  final Value<String?> result;
  final Value<int> rowid;
  const TaskQueueCompanion({
    this.taskId = const Value.absent(),
    this.type = const Value.absent(),
    this.priority = const Value.absent(),
    this.label = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.data = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.error = const Value.absent(),
    this.result = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskQueueCompanion.insert({
    required String taskId,
    required String type,
    this.priority = const Value.absent(),
    required String label,
    required String status,
    required DateTime createdAt,
    required String data,
    this.retryCount = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.error = const Value.absent(),
    this.result = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId),
       type = Value(type),
       label = Value(label),
       status = Value(status),
       createdAt = Value(createdAt),
       data = Value(data);
  static Insertable<TaskQueueData> custom({
    Expression<String>? taskId,
    Expression<String>? type,
    Expression<int>? priority,
    Expression<String>? label,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<String>? data,
    Expression<int>? retryCount,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<String>? error,
    Expression<String>? result,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (type != null) 'type': type,
      if (priority != null) 'priority': priority,
      if (label != null) 'label': label,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (data != null) 'data': data,
      if (retryCount != null) 'retry_count': retryCount,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (error != null) 'error': error,
      if (result != null) 'result': result,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskQueueCompanion copyWith({
    Value<String>? taskId,
    Value<String>? type,
    Value<int>? priority,
    Value<String>? label,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<String>? data,
    Value<int>? retryCount,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<String?>? error,
    Value<String?>? result,
    Value<int>? rowid,
  }) {
    return TaskQueueCompanion(
      taskId: taskId ?? this.taskId,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      label: label ?? this.label,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
      retryCount: retryCount ?? this.retryCount,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      error: error ?? this.error,
      result: result ?? this.result,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskQueueCompanion(')
          ..write('taskId: $taskId, ')
          ..write('type: $type, ')
          ..write('priority: $priority, ')
          ..write('label: $label, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('data: $data, ')
          ..write('retryCount: $retryCount, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('error: $error, ')
          ..write('result: $result, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatsTable extends Chats with TableInfo<$ChatsTable, ChatData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
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
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    createdAt,
    updatedAt,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chats';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
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
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ChatsTable createAlias(String alias) {
    return $ChatsTable(attachedDatabase, alias);
  }
}

class ChatData extends DataClass implements Insertable<ChatData> {
  final int id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  const ChatData({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ChatsCompanion toCompanion(bool nullToAbsent) {
    return ChatsCompanion(
      id: Value(id),
      title: Value(title),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isActive: Value(isActive),
    );
  }

  factory ChatData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ChatData copyWith({
    int? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) => ChatData(
    id: id ?? this.id,
    title: title ?? this.title,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isActive: isActive ?? this.isActive,
  );
  ChatData copyWithCompanion(ChatsCompanion data) {
    return ChatData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, createdAt, updatedAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatData &&
          other.id == this.id &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isActive == this.isActive);
}

class ChatsCompanion extends UpdateCompanion<ChatData> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isActive;
  const ChatsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  ChatsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isActive = const Value.absent(),
  }) : title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ChatData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  ChatsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isActive,
  }) {
    return ChatsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<int> chatId = GeneratedColumn<int>(
    'chat_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chats (id)',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _attachmentsMeta = const VerificationMeta(
    'attachments',
  );
  @override
  late final GeneratedColumn<String> attachments = GeneratedColumn<String>(
    'attachments',
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
  static const VerificationMeta _isStreamingMeta = const VerificationMeta(
    'isStreaming',
  );
  @override
  late final GeneratedColumn<bool> isStreaming = GeneratedColumn<bool>(
    'is_streaming',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_streaming" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chatId,
    role,
    content,
    attachments,
    createdAt,
    isStreaming,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatMessageData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chat_id')) {
      context.handle(
        _chatIdMeta,
        chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('attachments')) {
      context.handle(
        _attachmentsMeta,
        attachments.isAcceptableOrUnknown(
          data['attachments']!,
          _attachmentsMeta,
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
    if (data.containsKey('is_streaming')) {
      context.handle(
        _isStreamingMeta,
        isStreaming.isAcceptableOrUnknown(
          data['is_streaming']!,
          _isStreamingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessageData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      chatId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chat_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      attachments: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachments'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isStreaming: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_streaming'],
      )!,
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }
}

class ChatMessageData extends DataClass implements Insertable<ChatMessageData> {
  final int id;
  final int chatId;
  final String role;
  final String content;
  final String? attachments;
  final DateTime createdAt;
  final bool isStreaming;
  const ChatMessageData({
    required this.id,
    required this.chatId,
    required this.role,
    required this.content,
    this.attachments,
    required this.createdAt,
    required this.isStreaming,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chat_id'] = Variable<int>(chatId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || attachments != null) {
      map['attachments'] = Variable<String>(attachments);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_streaming'] = Variable<bool>(isStreaming);
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      chatId: Value(chatId),
      role: Value(role),
      content: Value(content),
      attachments: attachments == null && nullToAbsent
          ? const Value.absent()
          : Value(attachments),
      createdAt: Value(createdAt),
      isStreaming: Value(isStreaming),
    );
  }

  factory ChatMessageData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessageData(
      id: serializer.fromJson<int>(json['id']),
      chatId: serializer.fromJson<int>(json['chatId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      attachments: serializer.fromJson<String?>(json['attachments']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isStreaming: serializer.fromJson<bool>(json['isStreaming']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chatId': serializer.toJson<int>(chatId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'attachments': serializer.toJson<String?>(attachments),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isStreaming': serializer.toJson<bool>(isStreaming),
    };
  }

  ChatMessageData copyWith({
    int? id,
    int? chatId,
    String? role,
    String? content,
    Value<String?> attachments = const Value.absent(),
    DateTime? createdAt,
    bool? isStreaming,
  }) => ChatMessageData(
    id: id ?? this.id,
    chatId: chatId ?? this.chatId,
    role: role ?? this.role,
    content: content ?? this.content,
    attachments: attachments.present ? attachments.value : this.attachments,
    createdAt: createdAt ?? this.createdAt,
    isStreaming: isStreaming ?? this.isStreaming,
  );
  ChatMessageData copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessageData(
      id: data.id.present ? data.id.value : this.id,
      chatId: data.chatId.present ? data.chatId.value : this.chatId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      attachments: data.attachments.present
          ? data.attachments.value
          : this.attachments,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isStreaming: data.isStreaming.present
          ? data.isStreaming.value
          : this.isStreaming,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessageData(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('attachments: $attachments, ')
          ..write('createdAt: $createdAt, ')
          ..write('isStreaming: $isStreaming')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    chatId,
    role,
    content,
    attachments,
    createdAt,
    isStreaming,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessageData &&
          other.id == this.id &&
          other.chatId == this.chatId &&
          other.role == this.role &&
          other.content == this.content &&
          other.attachments == this.attachments &&
          other.createdAt == this.createdAt &&
          other.isStreaming == this.isStreaming);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessageData> {
  final Value<int> id;
  final Value<int> chatId;
  final Value<String> role;
  final Value<String> content;
  final Value<String?> attachments;
  final Value<DateTime> createdAt;
  final Value<bool> isStreaming;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.chatId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.attachments = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isStreaming = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    this.id = const Value.absent(),
    required int chatId,
    required String role,
    required String content,
    this.attachments = const Value.absent(),
    required DateTime createdAt,
    this.isStreaming = const Value.absent(),
  }) : chatId = Value(chatId),
       role = Value(role),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<ChatMessageData> custom({
    Expression<int>? id,
    Expression<int>? chatId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<String>? attachments,
    Expression<DateTime>? createdAt,
    Expression<bool>? isStreaming,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chatId != null) 'chat_id': chatId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (attachments != null) 'attachments': attachments,
      if (createdAt != null) 'created_at': createdAt,
      if (isStreaming != null) 'is_streaming': isStreaming,
    });
  }

  ChatMessagesCompanion copyWith({
    Value<int>? id,
    Value<int>? chatId,
    Value<String>? role,
    Value<String>? content,
    Value<String?>? attachments,
    Value<DateTime>? createdAt,
    Value<bool>? isStreaming,
  }) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      role: role ?? this.role,
      content: content ?? this.content,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<int>(chatId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (attachments.present) {
      map['attachments'] = Variable<String>(attachments.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isStreaming.present) {
      map['is_streaming'] = Variable<bool>(isStreaming.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('attachments: $attachments, ')
          ..write('createdAt: $createdAt, ')
          ..write('isStreaming: $isStreaming')
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
  late final $MomentTagsTable momentTags = $MomentTagsTable(this);
  late final $MomentMoodsTable momentMoods = $MomentMoodsTable(this);
  late final $KeyValuesTable keyValues = $KeyValuesTable(this);
  late final $TaskQueueTable taskQueue = $TaskQueueTable(this);
  late final $ChatsTable chats = $ChatsTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  late final Index idxTaskQueueStatusPriority = Index(
    'idx_task_queue_status_priority',
    'CREATE INDEX idx_task_queue_status_priority ON task_queue (status, priority, created_at)',
  );
  late final Index idxTaskQueueType = Index(
    'idx_task_queue_type',
    'CREATE INDEX idx_task_queue_type ON task_queue (type)',
  );
  late final Index idxTaskQueueCompletedAt = Index(
    'idx_task_queue_completed_at',
    'CREATE INDEX idx_task_queue_completed_at ON task_queue (completed_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    moments,
    mediaAttachments,
    momentTags,
    momentMoods,
    keyValues,
    taskQueue,
    chats,
    chatMessages,
    idxTaskQueueStatusPriority,
    idxTaskQueueType,
    idxTaskQueueCompletedAt,
  ];
}

typedef $$MomentsTableCreateCompanionBuilder =
    MomentsCompanion Function({
      Value<int> id,
      required String content,
      Value<String?> aiSummary,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> aiProcessed,
    });
typedef $$MomentsTableUpdateCompanionBuilder =
    MomentsCompanion Function({
      Value<int> id,
      Value<String> content,
      Value<String?> aiSummary,
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

  static MultiTypedResultKey<$MomentMoodsTable, List<MomentMoodData>>
  _momentMoodsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.momentMoods,
    aliasName: $_aliasNameGenerator(db.moments.id, db.momentMoods.momentId),
  );

  $$MomentMoodsTableProcessedTableManager get momentMoodsRefs {
    final manager = $$MomentMoodsTableTableManager(
      $_db,
      $_db.momentMoods,
    ).filter((f) => f.momentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_momentMoodsRefsTable($_db));
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

  ColumnFilters<String> get aiSummary => $composableBuilder(
    column: $table.aiSummary,
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

  Expression<bool> momentMoodsRefs(
    Expression<bool> Function($$MomentMoodsTableFilterComposer f) f,
  ) {
    final $$MomentMoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.momentMoods,
      getReferencedColumn: (t) => t.momentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentMoodsTableFilterComposer(
            $db: $db,
            $table: $db.momentMoods,
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

  ColumnOrderings<String> get aiSummary => $composableBuilder(
    column: $table.aiSummary,
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

  GeneratedColumn<String> get aiSummary =>
      $composableBuilder(column: $table.aiSummary, builder: (column) => column);

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

  Expression<T> momentMoodsRefs<T extends Object>(
    Expression<T> Function($$MomentMoodsTableAnnotationComposer a) f,
  ) {
    final $$MomentMoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.momentMoods,
      getReferencedColumn: (t) => t.momentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MomentMoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.momentMoods,
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
            bool momentMoodsRefs,
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
                Value<String?> aiSummary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> aiProcessed = const Value.absent(),
              }) => MomentsCompanion(
                id: id,
                content: content,
                aiSummary: aiSummary,
                createdAt: createdAt,
                updatedAt: updatedAt,
                aiProcessed: aiProcessed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String content,
                Value<String?> aiSummary = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> aiProcessed = const Value.absent(),
              }) => MomentsCompanion.insert(
                id: id,
                content: content,
                aiSummary: aiSummary,
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
                momentMoodsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (mediaAttachmentsRefs) db.mediaAttachments,
                    if (momentTagsRefs) db.momentTags,
                    if (momentMoodsRefs) db.momentMoods,
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
                      if (momentMoodsRefs)
                        await $_getPrefetchedData<
                          MomentData,
                          $MomentsTable,
                          MomentMoodData
                        >(
                          currentTable: table,
                          referencedTable: $$MomentsTableReferences
                              ._momentMoodsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MomentsTableReferences(
                                db,
                                table,
                                p0,
                              ).momentMoodsRefs,
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
        bool momentMoodsRefs,
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
      Value<String?> aiSummary,
      Value<bool> aiProcessed,
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
      Value<String?> aiSummary,
      Value<bool> aiProcessed,
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

  ColumnFilters<String> get aiSummary => $composableBuilder(
    column: $table.aiSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get aiProcessed => $composableBuilder(
    column: $table.aiProcessed,
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

  ColumnOrderings<String> get aiSummary => $composableBuilder(
    column: $table.aiSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get aiProcessed => $composableBuilder(
    column: $table.aiProcessed,
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

  GeneratedColumn<String> get aiSummary =>
      $composableBuilder(column: $table.aiSummary, builder: (column) => column);

  GeneratedColumn<bool> get aiProcessed => $composableBuilder(
    column: $table.aiProcessed,
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
                Value<String?> aiSummary = const Value.absent(),
                Value<bool> aiProcessed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MediaAttachmentsCompanion(
                id: id,
                momentId: momentId,
                filePath: filePath,
                mediaType: mediaType,
                fileSize: fileSize,
                duration: duration,
                thumbnailPath: thumbnailPath,
                aiSummary: aiSummary,
                aiProcessed: aiProcessed,
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
                Value<String?> aiSummary = const Value.absent(),
                Value<bool> aiProcessed = const Value.absent(),
                required DateTime createdAt,
              }) => MediaAttachmentsCompanion.insert(
                id: id,
                momentId: momentId,
                filePath: filePath,
                mediaType: mediaType,
                fileSize: fileSize,
                duration: duration,
                thumbnailPath: thumbnailPath,
                aiSummary: aiSummary,
                aiProcessed: aiProcessed,
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
typedef $$MomentTagsTableCreateCompanionBuilder =
    MomentTagsCompanion Function({
      required int momentId,
      required String tag,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$MomentTagsTableUpdateCompanionBuilder =
    MomentTagsCompanion Function({
      Value<int> momentId,
      Value<String> tag,
      Value<DateTime> createdAt,
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
  ColumnFilters<String> get tag => $composableBuilder(
    column: $table.tag,
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

class $$MomentTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $MomentTagsTable> {
  $$MomentTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tag => $composableBuilder(
    column: $table.tag,
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

class $$MomentTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MomentTagsTable> {
  $$MomentTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);

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
          PrefetchHooks Function({bool momentId})
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
                Value<String> tag = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MomentTagsCompanion(
                momentId: momentId,
                tag: tag,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int momentId,
                required String tag,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MomentTagsCompanion.insert(
                momentId: momentId,
                tag: tag,
                createdAt: createdAt,
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
                                referencedTable: $$MomentTagsTableReferences
                                    ._momentIdTable(db),
                                referencedColumn: $$MomentTagsTableReferences
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
      PrefetchHooks Function({bool momentId})
    >;
typedef $$MomentMoodsTableCreateCompanionBuilder =
    MomentMoodsCompanion Function({
      required int momentId,
      required String mood,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$MomentMoodsTableUpdateCompanionBuilder =
    MomentMoodsCompanion Function({
      Value<int> momentId,
      Value<String> mood,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$MomentMoodsTableReferences
    extends BaseReferences<_$AppDatabase, $MomentMoodsTable, MomentMoodData> {
  $$MomentMoodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MomentsTable _momentIdTable(_$AppDatabase db) =>
      db.moments.createAlias(
        $_aliasNameGenerator(db.momentMoods.momentId, db.moments.id),
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

class $$MomentMoodsTableFilterComposer
    extends Composer<_$AppDatabase, $MomentMoodsTable> {
  $$MomentMoodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mood => $composableBuilder(
    column: $table.mood,
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

class $$MomentMoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $MomentMoodsTable> {
  $$MomentMoodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mood => $composableBuilder(
    column: $table.mood,
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

class $$MomentMoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MomentMoodsTable> {
  $$MomentMoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

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

class $$MomentMoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MomentMoodsTable,
          MomentMoodData,
          $$MomentMoodsTableFilterComposer,
          $$MomentMoodsTableOrderingComposer,
          $$MomentMoodsTableAnnotationComposer,
          $$MomentMoodsTableCreateCompanionBuilder,
          $$MomentMoodsTableUpdateCompanionBuilder,
          (MomentMoodData, $$MomentMoodsTableReferences),
          MomentMoodData,
          PrefetchHooks Function({bool momentId})
        > {
  $$MomentMoodsTableTableManager(_$AppDatabase db, $MomentMoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MomentMoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MomentMoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MomentMoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> momentId = const Value.absent(),
                Value<String> mood = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MomentMoodsCompanion(
                momentId: momentId,
                mood: mood,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int momentId,
                required String mood,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MomentMoodsCompanion.insert(
                momentId: momentId,
                mood: mood,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MomentMoodsTableReferences(db, table, e),
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
                                referencedTable: $$MomentMoodsTableReferences
                                    ._momentIdTable(db),
                                referencedColumn: $$MomentMoodsTableReferences
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

typedef $$MomentMoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MomentMoodsTable,
      MomentMoodData,
      $$MomentMoodsTableFilterComposer,
      $$MomentMoodsTableOrderingComposer,
      $$MomentMoodsTableAnnotationComposer,
      $$MomentMoodsTableCreateCompanionBuilder,
      $$MomentMoodsTableUpdateCompanionBuilder,
      (MomentMoodData, $$MomentMoodsTableReferences),
      MomentMoodData,
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
typedef $$TaskQueueTableCreateCompanionBuilder =
    TaskQueueCompanion Function({
      required String taskId,
      required String type,
      Value<int> priority,
      required String label,
      required String status,
      required DateTime createdAt,
      required String data,
      Value<int> retryCount,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<String?> error,
      Value<String?> result,
      Value<int> rowid,
    });
typedef $$TaskQueueTableUpdateCompanionBuilder =
    TaskQueueCompanion Function({
      Value<String> taskId,
      Value<String> type,
      Value<int> priority,
      Value<String> label,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<String> data,
      Value<int> retryCount,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<String?> error,
      Value<String?> result,
      Value<int> rowid,
    });

class $$TaskQueueTableFilterComposer
    extends Composer<_$AppDatabase, $TaskQueueTable> {
  $$TaskQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskQueueTable> {
  $$TaskQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskQueueTable> {
  $$TaskQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);
}

class $$TaskQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskQueueTable,
          TaskQueueData,
          $$TaskQueueTableFilterComposer,
          $$TaskQueueTableOrderingComposer,
          $$TaskQueueTableAnnotationComposer,
          $$TaskQueueTableCreateCompanionBuilder,
          $$TaskQueueTableUpdateCompanionBuilder,
          (
            TaskQueueData,
            BaseReferences<_$AppDatabase, $TaskQueueTable, TaskQueueData>,
          ),
          TaskQueueData,
          PrefetchHooks Function()
        > {
  $$TaskQueueTableTableManager(_$AppDatabase db, $TaskQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> taskId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<String?> result = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskQueueCompanion(
                taskId: taskId,
                type: type,
                priority: priority,
                label: label,
                status: status,
                createdAt: createdAt,
                data: data,
                retryCount: retryCount,
                startedAt: startedAt,
                completedAt: completedAt,
                error: error,
                result: result,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String taskId,
                required String type,
                Value<int> priority = const Value.absent(),
                required String label,
                required String status,
                required DateTime createdAt,
                required String data,
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<String?> result = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskQueueCompanion.insert(
                taskId: taskId,
                type: type,
                priority: priority,
                label: label,
                status: status,
                createdAt: createdAt,
                data: data,
                retryCount: retryCount,
                startedAt: startedAt,
                completedAt: completedAt,
                error: error,
                result: result,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskQueueTable,
      TaskQueueData,
      $$TaskQueueTableFilterComposer,
      $$TaskQueueTableOrderingComposer,
      $$TaskQueueTableAnnotationComposer,
      $$TaskQueueTableCreateCompanionBuilder,
      $$TaskQueueTableUpdateCompanionBuilder,
      (
        TaskQueueData,
        BaseReferences<_$AppDatabase, $TaskQueueTable, TaskQueueData>,
      ),
      TaskQueueData,
      PrefetchHooks Function()
    >;
typedef $$ChatsTableCreateCompanionBuilder =
    ChatsCompanion Function({
      Value<int> id,
      required String title,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isActive,
    });
typedef $$ChatsTableUpdateCompanionBuilder =
    ChatsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isActive,
    });

final class $$ChatsTableReferences
    extends BaseReferences<_$AppDatabase, $ChatsTable, ChatData> {
  $$ChatsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChatMessagesTable, List<ChatMessageData>>
  _chatMessagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.chatMessages,
    aliasName: $_aliasNameGenerator(db.chats.id, db.chatMessages.chatId),
  );

  $$ChatMessagesTableProcessedTableManager get chatMessagesRefs {
    final manager = $$ChatMessagesTableTableManager(
      $_db,
      $_db.chatMessages,
    ).filter((f) => f.chatId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chatMessagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChatsTableFilterComposer extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
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

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> chatMessagesRefs(
    Expression<bool> Function($$ChatMessagesTableFilterComposer f) f,
  ) {
    final $$ChatMessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chatMessages,
      getReferencedColumn: (t) => t.chatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatMessagesTableFilterComposer(
            $db: $db,
            $table: $db.chatMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChatsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
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

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> chatMessagesRefs<T extends Object>(
    Expression<T> Function($$ChatMessagesTableAnnotationComposer a) f,
  ) {
    final $$ChatMessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chatMessages,
      getReferencedColumn: (t) => t.chatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatMessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.chatMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatsTable,
          ChatData,
          $$ChatsTableFilterComposer,
          $$ChatsTableOrderingComposer,
          $$ChatsTableAnnotationComposer,
          $$ChatsTableCreateCompanionBuilder,
          $$ChatsTableUpdateCompanionBuilder,
          (ChatData, $$ChatsTableReferences),
          ChatData,
          PrefetchHooks Function({bool chatMessagesRefs})
        > {
  $$ChatsTableTableManager(_$AppDatabase db, $ChatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => ChatsCompanion(
                id: id,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isActive = const Value.absent(),
              }) => ChatsCompanion.insert(
                id: id,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ChatsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({chatMessagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (chatMessagesRefs) db.chatMessages],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chatMessagesRefs)
                    await $_getPrefetchedData<
                      ChatData,
                      $ChatsTable,
                      ChatMessageData
                    >(
                      currentTable: table,
                      referencedTable: $$ChatsTableReferences
                          ._chatMessagesRefsTable(db),
                      managerFromTypedResult: (p0) => $$ChatsTableReferences(
                        db,
                        table,
                        p0,
                      ).chatMessagesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.chatId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ChatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatsTable,
      ChatData,
      $$ChatsTableFilterComposer,
      $$ChatsTableOrderingComposer,
      $$ChatsTableAnnotationComposer,
      $$ChatsTableCreateCompanionBuilder,
      $$ChatsTableUpdateCompanionBuilder,
      (ChatData, $$ChatsTableReferences),
      ChatData,
      PrefetchHooks Function({bool chatMessagesRefs})
    >;
typedef $$ChatMessagesTableCreateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<int> id,
      required int chatId,
      required String role,
      required String content,
      Value<String?> attachments,
      required DateTime createdAt,
      Value<bool> isStreaming,
    });
typedef $$ChatMessagesTableUpdateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<int> id,
      Value<int> chatId,
      Value<String> role,
      Value<String> content,
      Value<String?> attachments,
      Value<DateTime> createdAt,
      Value<bool> isStreaming,
    });

final class $$ChatMessagesTableReferences
    extends BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessageData> {
  $$ChatMessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChatsTable _chatIdTable(_$AppDatabase db) => db.chats.createAlias(
    $_aliasNameGenerator(db.chatMessages.chatId, db.chats.id),
  );

  $$ChatsTableProcessedTableManager get chatId {
    final $_column = $_itemColumn<int>('chat_id')!;

    final manager = $$ChatsTableTableManager(
      $_db,
      $_db.chats,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chatIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
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

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStreaming => $composableBuilder(
    column: $table.isStreaming,
    builder: (column) => ColumnFilters(column),
  );

  $$ChatsTableFilterComposer get chatId {
    final $$ChatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableFilterComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
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

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStreaming => $composableBuilder(
    column: $table.isStreaming,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChatsTableOrderingComposer get chatId {
    final $$ChatsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableOrderingComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isStreaming => $composableBuilder(
    column: $table.isStreaming,
    builder: (column) => column,
  );

  $$ChatsTableAnnotationComposer get chatId {
    final $$ChatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableAnnotationComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChatMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatMessagesTable,
          ChatMessageData,
          $$ChatMessagesTableFilterComposer,
          $$ChatMessagesTableOrderingComposer,
          $$ChatMessagesTableAnnotationComposer,
          $$ChatMessagesTableCreateCompanionBuilder,
          $$ChatMessagesTableUpdateCompanionBuilder,
          (ChatMessageData, $$ChatMessagesTableReferences),
          ChatMessageData,
          PrefetchHooks Function({bool chatId})
        > {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> chatId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> attachments = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isStreaming = const Value.absent(),
              }) => ChatMessagesCompanion(
                id: id,
                chatId: chatId,
                role: role,
                content: content,
                attachments: attachments,
                createdAt: createdAt,
                isStreaming: isStreaming,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int chatId,
                required String role,
                required String content,
                Value<String?> attachments = const Value.absent(),
                required DateTime createdAt,
                Value<bool> isStreaming = const Value.absent(),
              }) => ChatMessagesCompanion.insert(
                id: id,
                chatId: chatId,
                role: role,
                content: content,
                attachments: attachments,
                createdAt: createdAt,
                isStreaming: isStreaming,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChatMessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chatId = false}) {
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
                    if (chatId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chatId,
                                referencedTable: $$ChatMessagesTableReferences
                                    ._chatIdTable(db),
                                referencedColumn: $$ChatMessagesTableReferences
                                    ._chatIdTable(db)
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

typedef $$ChatMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatMessagesTable,
      ChatMessageData,
      $$ChatMessagesTableFilterComposer,
      $$ChatMessagesTableOrderingComposer,
      $$ChatMessagesTableAnnotationComposer,
      $$ChatMessagesTableCreateCompanionBuilder,
      $$ChatMessagesTableUpdateCompanionBuilder,
      (ChatMessageData, $$ChatMessagesTableReferences),
      ChatMessageData,
      PrefetchHooks Function({bool chatId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MomentsTableTableManager get moments =>
      $$MomentsTableTableManager(_db, _db.moments);
  $$MediaAttachmentsTableTableManager get mediaAttachments =>
      $$MediaAttachmentsTableTableManager(_db, _db.mediaAttachments);
  $$MomentTagsTableTableManager get momentTags =>
      $$MomentTagsTableTableManager(_db, _db.momentTags);
  $$MomentMoodsTableTableManager get momentMoods =>
      $$MomentMoodsTableTableManager(_db, _db.momentMoods);
  $$KeyValuesTableTableManager get keyValues =>
      $$KeyValuesTableTableManager(_db, _db.keyValues);
  $$TaskQueueTableTableManager get taskQueue =>
      $$TaskQueueTableTableManager(_db, _db.taskQueue);
  $$ChatsTableTableManager get chats =>
      $$ChatsTableTableManager(_db, _db.chats);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
}
