import 'package:drift/drift.dart';

// Task queue table for storing background tasks
@TableIndex(
  name: 'idx_task_queue_status_priority',
  columns: {#status, #priority, #createdAt},
)
@TableIndex(name: 'idx_task_queue_type', columns: {#type})
@TableIndex(name: 'idx_task_queue_completed_at', columns: {#completedAt})
@DataClassName('TaskQueueData')
class TaskQueue extends Table {
  /// Unique task identifier
  TextColumn get taskId => text()();

  /// Task type as string (e.g., 'audio_transcription', 'image_analysis')
  TextColumn get type => text()();

  /// Task priority (higher number = higher priority)
  IntColumn get priority => integer().withDefault(const Constant(0))();

  /// Human-readable task label for display
  TextColumn get label => text()();

  /// Task status (pending, running, completed, failed, cancelled, retrying)
  TextColumn get status => text()();

  /// Task creation timestamp
  DateTimeColumn get createdAt => dateTime()();

  /// Task data as JSON string
  TextColumn get data => text()();

  /// Number of retry attempts
  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  /// Task start timestamp (nullable)
  DateTimeColumn get startedAt => dateTime().nullable()();

  /// Task completion timestamp (nullable)
  DateTimeColumn get completedAt => dateTime().nullable()();

  /// Error message if task failed (nullable)
  TextColumn get error => text().nullable()();

  /// Task result as JSON string (nullable)
  TextColumn get result => text().nullable()();

  @override
  Set<Column> get primaryKey => {taskId};
}
