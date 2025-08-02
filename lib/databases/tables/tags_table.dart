import 'package:drift/drift.dart';
import 'moments_table.dart';

// Tags table
@DataClassName('TagData')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get color => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

// Moment-tag association table
@DataClassName('MomentTagData')
class MomentTags extends Table {
  IntColumn get momentId => integer().references(Moments, #id)();
  IntColumn get tagId => integer().references(Tags, #id)();

  @override
  Set<Column> get primaryKey => {momentId, tagId};
}
