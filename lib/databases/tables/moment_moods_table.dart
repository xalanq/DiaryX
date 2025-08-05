import 'package:drift/drift.dart';
import 'moments_table.dart';

// Moment-mood association table
@DataClassName('MomentMoodData')
class MomentMoods extends Table {
  /// Foreign key referencing the moment
  IntColumn get momentId => integer().references(Moments, #id)();

  /// Mood name (string value from MoodType enum)
  TextColumn get mood => text()();

  /// When this mood association was created
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {momentId, mood};
}
