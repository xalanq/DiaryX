import 'package:drift/drift.dart';
import '../../models/media_attachment.dart';
import 'moments_table.dart';

// Media attachments table
@DataClassName('MediaAttachmentData')
class MediaAttachments extends Table {
  /// Primary key, auto-incrementing unique identifier
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key referencing the associated moment
  IntColumn get momentId => integer().references(Moments, #id)();

  /// Local file path where the media is stored
  TextColumn get filePath => text()();

  /// Type of media (image, video, audio)
  TextColumn get mediaType => textEnum<MediaType>()();

  /// Size of the media file in bytes
  IntColumn get fileSize => integer().nullable()();

  /// Duration in seconds for video/audio files
  RealColumn get duration => real().nullable()();

  /// Path to generated thumbnail for video/image files
  TextColumn get thumbnailPath => text().nullable()();

  /// AI-generated summary of media content
  TextColumn get aiSummary => text().nullable()();

  /// Whether AI has processed this media
  BoolColumn get aiProcessed => boolean().withDefault(const Constant(false))();

  /// When this media attachment was created
  DateTimeColumn get createdAt => dateTime()();
}
