import 'package:drift/drift.dart';
import 'moments_table.dart';

// Enum definitions for analysis
enum AnalysisType { mood, summary, expansion, searchInsight }

// Mood analysis results table
@DataClassName('MoodAnalysisData')
class MoodAnalysisTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get momentId => integer().references(Moments, #id)();
  RealColumn get moodScore => real().nullable()();
  TextColumn get primaryMood => text().nullable()();
  RealColumn get confidenceScore => real().nullable()();
  TextColumn get moodKeywords => text().nullable()();
  DateTimeColumn get analysisTimestamp => dateTime()();
}

// LLM analysis records table
@DataClassName('LLMAnalysisData')
class LlmAnalysisTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get momentId => integer().references(Moments, #id)();
  TextColumn get analysisType => textEnum<AnalysisType>()();
  TextColumn get analysisContent => text()();
  RealColumn get confidenceScore => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
