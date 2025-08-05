import 'package:drift/drift.dart';

// Moments table
@DataClassName('MomentData')
class Moments extends Table {
  /// Primary key, auto-incrementing unique identifier
  IntColumn get id => integer().autoIncrement()();

  /// Main content of the diary moment
  TextColumn get content => text()();

  /// AI-generated summary of the moment
  TextColumn get aiSummary => text().nullable()();

  /// When this moment was originally created
  DateTimeColumn get createdAt => dateTime()();

  /// When this moment was last updated
  DateTimeColumn get updatedAt => dateTime()();

  /// Whether AI has processed this moment
  BoolColumn get aiProcessed => boolean().withDefault(const Constant(false))();
}
