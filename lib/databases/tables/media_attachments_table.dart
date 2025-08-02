import 'package:drift/drift.dart';
import '../../models/media_attachment.dart';
import 'entries_table.dart';

// Media attachments table
@DataClassName('MediaAttachmentData')
class MediaAttachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId => integer().references(Entries, #id)();
  TextColumn get filePath => text()();
  TextColumn get mediaType => textEnum<MediaType>()();
  IntColumn get fileSize => integer().nullable()();
  RealColumn get duration => real().nullable()();
  TextColumn get thumbnailPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
