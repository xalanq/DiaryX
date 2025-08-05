import 'package:drift/drift.dart';

import 'chats_table.dart';

/// Chat messages table for individual chat messages
@DataClassName('ChatMessageData')
class ChatMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get chatId => integer().references(Chats, #id)();
  TextColumn get role => text()(); // 'user' or 'assistant'
  TextColumn get content => text()();
  TextColumn get attachments =>
      text().nullable()(); // JSON format for image attachments
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isStreaming => boolean().withDefault(const Constant(false))();
}
