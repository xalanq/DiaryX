import 'package:drift/drift.dart';
import '../../models/moment.dart';

// Moments table
@DataClassName('MomentData')
class Moments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  TextColumn get contentType => textEnum<ContentType>()();
  TextColumn get mood => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get aiProcessed => boolean().withDefault(const Constant(false))();
}
