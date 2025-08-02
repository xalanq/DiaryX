import 'package:drift/drift.dart';
import 'entries_table.dart';

// Tags table
@DataClassName('TagData')
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get color => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

// Entry-tag association table
@DataClassName('EntryTagData')
class EntryTags extends Table {
  IntColumn get entryId => integer().references(Entries, #id)();
  IntColumn get tagId => integer().references(Tags, #id)();

  @override
  Set<Column> get primaryKey => {entryId, tagId};
}
