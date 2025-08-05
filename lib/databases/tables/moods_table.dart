import 'package:drift/drift.dart';
import 'moments_table.dart';

// Moment-mood association table
@DataClassName('MomentMoodData')
class MomentMoods extends Table {
  /// Foreign key referencing the moment
  IntColumn get momentId => integer().references(Moments, #id)();

  /// Mood name (string value from MoodType enum)
  TextColumn get mood => text()();

  @override
  Set<Column> get primaryKey => {momentId, mood};
}
