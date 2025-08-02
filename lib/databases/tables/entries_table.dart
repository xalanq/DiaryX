import 'package:drift/drift.dart';
import '../../models/entry.dart';

// Entries table
@DataClassName('EntryData')
class Entries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  TextColumn get contentType => textEnum<ContentType>()();
  TextColumn get mood => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get aiProcessed => boolean().withDefault(const Constant(false))();
}
