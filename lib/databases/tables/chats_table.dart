import 'package:drift/drift.dart';

/// Chat sessions table for managing chat conversations
@DataClassName('ChatData')
class Chats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()(); // Chat title generated from first message
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
