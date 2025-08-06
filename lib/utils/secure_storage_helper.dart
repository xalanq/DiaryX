import '../databases/app_database.dart';
import '../utils/app_logger.dart';

/// Helper class that provides the same interface as FlutterSecureStorage
/// but uses AppDatabase keyValues table for storage
class SecureStorageHelper {
  const SecureStorageHelper();

  /// Read a value by key
  Future<String?> read({required String key}) async {
    try {
      return await AppDatabase.instance.getValue(key);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to read secure storage key: $key', e, stackTrace);
      return null;
    }
  }

  /// Write a key-value pair
  Future<void> write({required String key, required String value}) async {
    try {
      await AppDatabase.instance.setValue(key, value);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to write secure storage key: $key',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Delete a key
  Future<void> delete({required String key}) async {
    try {
      await AppDatabase.instance.deleteValue(key);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete secure storage key: $key',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Delete all keys
  Future<void> deleteAll() async {
    try {
      final allKeys = await AppDatabase.instance.getAllKeyValues();
      for (final key in allKeys.keys) {
        await AppDatabase.instance.deleteValue(key);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete all secure storage keys',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Read all key-value pairs
  Future<Map<String, String>> readAll() async {
    try {
      return await AppDatabase.instance.getAllKeyValues();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to read all secure storage keys', e, stackTrace);
      return {};
    }
  }
}
