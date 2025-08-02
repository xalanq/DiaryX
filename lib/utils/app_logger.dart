import 'package:logger/logger.dart';
import '../consts/env_config.dart';

/// Application logger for DiaryX
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 80, // Width of the output
      noBoxingByDefault: true,
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: EnvConfig.isDebugMode ? Level.debug : Level.info,
  );

  /// Private constructor to prevent instantiation
  AppLogger._();

  /// Get the logger instance
  static Logger get instance => _logger;

  /// Log debug message
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log info message
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning message
  static void warn(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log verbose message
  static void verbose(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal error message
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Log API request
  static void apiRequest(
    String method,
    String url, [
    Map<String, dynamic>? body,
  ]) {
    info('API Request: $method $url${body != null ? ' Body: $body' : ''}');
  }

  /// Log API response
  static void apiResponse(String url, int statusCode, [dynamic response]) {
    info(
      'API Response: $url Status: $statusCode${response != null ? ' Response: $response' : ''}',
    );
  }

  /// Log database operation
  static void database(
    String operation,
    String table, [
    Map<String, dynamic>? data,
  ]) {
    debug(
      'Database: $operation on $table${data != null ? ' Data: $data' : ''}',
    );
  }

  /// Log AI processing
  static void aiProcessing(
    String operation,
    String status, [
    Map<String, dynamic>? metadata,
  ]) {
    info(
      'AI Processing: $operation Status: $status${metadata != null ? ' Metadata: $metadata' : ''}',
    );
  }

  /// Log user action
  static void userAction(String action, [Map<String, dynamic>? context]) {
    info('User Action: $action${context != null ? ' Context: $context' : ''}');
  }

  /// Log performance metrics
  static void performance(
    String operation,
    Duration duration, [
    Map<String, dynamic>? metrics,
  ]) {
    info(
      'Performance: $operation took ${duration.inMilliseconds}ms${metrics != null ? ' Metrics: $metrics' : ''}',
    );
  }

  /// Log file operation
  static void fileOperation(
    String operation,
    String filePath, [
    bool success = true,
  ]) {
    if (success) {
      debug('File Operation: $operation on $filePath - Success');
    } else {
      warn('File Operation: $operation on $filePath - Failed');
    }
  }

  /// Log authentication event
  static void auth(String event, [bool success = true, String? reason]) {
    if (success) {
      info('Auth: $event - Success');
    } else {
      warn('Auth: $event - Failed${reason != null ? ' Reason: $reason' : ''}');
    }
  }

  /// Log navigation event
  static void navigation(
    String from,
    String to, [
    Map<String, dynamic>? arguments,
  ]) {
    debug(
      'Navigation: $from -> $to${arguments != null ? ' Args: $arguments' : ''}',
    );
  }
}
