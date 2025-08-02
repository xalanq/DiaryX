import 'package:drift/drift.dart';
import 'entries_table.dart';

// Enum definitions for AI processing
enum TaskType { speechToText, imageAnalysis, textExpansion }

enum ProcessingStatus { pending, processing, completed, failed }

// AI processing queue table
@DataClassName('ProcessingTaskData')
class AiProcessingQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId => integer().references(Entries, #id)();
  TextColumn get taskType => textEnum<TaskType>()();
  TextColumn get status => textEnum<ProcessingStatus>()();
  IntColumn get priority => integer().withDefault(const Constant(1))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get processedAt => dateTime().nullable()();
}
