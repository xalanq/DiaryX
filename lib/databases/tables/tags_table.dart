import 'package:drift/drift.dart';
import 'moments_table.dart';

// Tags table
@DataClassName('TagData')
class Tags extends Table {
  /// Primary key, auto-incrementing unique identifier
  IntColumn get id => integer().autoIncrement()();

  /// Unique tag name
  TextColumn get name => text().unique()();

  /// Optional color for the tag (hex color code)
  TextColumn get color => text().nullable()();

  /// When this tag was created
  DateTimeColumn get createdAt => dateTime()();
}

// Moment-tag association table
@DataClassName('MomentTagData')
class MomentTags extends Table {
  /// Foreign key referencing the moment
  IntColumn get momentId => integer().references(Moments, #id)();

  /// Foreign key referencing the tag
  IntColumn get tagId => integer().references(Tags, #id)();

  @override
  Set<Column> get primaryKey => {momentId, tagId};
}
