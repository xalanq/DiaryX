import 'package:drift/drift.dart';
import 'moments_table.dart';

// Moment-tag association table (storing tag as string directly)
@DataClassName('MomentTagData')
class MomentTags extends Table {
  /// Foreign key referencing the moment
  IntColumn get momentId => integer().references(Moments, #id)();

  /// Tag name as string (no separate table needed)
  TextColumn get tag => text()();

  /// When this tag association was created
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {momentId, tag};
}
