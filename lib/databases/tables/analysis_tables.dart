import 'package:drift/drift.dart';
import 'entries_table.dart';

// Enum definitions for analysis
enum AnalysisType { emotion, summary, expansion, searchInsight }

// Emotion analysis results table
@DataClassName('EmotionAnalysisData')
class EmotionAnalysisTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId => integer().references(Entries, #id)();
  RealColumn get emotionScore => real().nullable()();
  TextColumn get primaryEmotion => text().nullable()();
  RealColumn get confidenceScore => real().nullable()();
  TextColumn get emotionKeywords => text().nullable()();
  DateTimeColumn get analysisTimestamp => dateTime()();
}

// LLM analysis records table
@DataClassName('LLMAnalysisData')
class LlmAnalysisTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId => integer().references(Entries, #id)();
  TextColumn get analysisType => textEnum<AnalysisType>()();
  TextColumn get analysisContent => text()();
  RealColumn get confidenceScore => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
