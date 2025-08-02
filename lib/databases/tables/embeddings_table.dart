import 'package:drift/drift.dart';
import 'moments_table.dart';

// Enum definitions for embeddings
enum EmbeddingType { text, image, audio }

// Vector embedding storage table
@DataClassName('EmbeddingData')
class Embeddings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get momentId => integer().references(Moments, #id)();
  BlobColumn get embeddingData => blob()();
  TextColumn get embeddingType => textEnum<EmbeddingType>()();
  DateTimeColumn get createdAt => dateTime()();
}
