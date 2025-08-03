import 'package:drift/drift.dart';

/// Table for storing key-value pairs (replaces SharedPreferences)
@DataClassName('KeyValue')
class KeyValues extends Table {
  /// Unique key identifier
  TextColumn get key => text().withLength(min: 1, max: 255)();

  /// Value stored as text (can be JSON for complex data)
  TextColumn get value => text()();

  /// When this key-value pair was created
  DateTimeColumn get createdAt => dateTime()();

  /// When this key-value pair was last updated
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}
