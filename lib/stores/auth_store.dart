import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../consts/env_config.dart';
import '../utils/app_logger.dart';

/// Store for managing authentication state
class AuthStore extends ChangeNotifier {
  static const String _passwordKey = 'user_password';
  static const String _isSetupKey = 'password_setup';
  static const String _failedAttemptsKey = 'failed_attempts';
  static const String _lastFailedAttemptKey = 'last_failed_attempt';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _isAuthenticated = false;
  bool _isPasswordSetup = false;
  bool _isLoading = false;
  String? _error;
  int _failedAttempts = 0;
  DateTime? _lastFailedAttempt;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isPasswordSetup => _isPasswordSetup;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get failedAttempts => _failedAttempts;
  bool get isBlocked => _isCurrentlyBlocked();

  /// Initialize authentication state
  Future<void> initialize() async {
    _setLoading(true);

    try {
      AppLogger.info('Initializing authentication');

      // Check if password is already setup
      final setupStatus = await _secureStorage.read(key: _isSetupKey);
      _isPasswordSetup = setupStatus == 'true';

      // Load failed attempts data
      await _loadFailedAttemptsData();

      AppLogger.info(
        'Authentication initialized - Setup: $_isPasswordSetup, Failed attempts: $_failedAttempts',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize authentication', e, stackTrace);
      _setError('Failed to initialize authentication');
    } finally {
      _setLoading(false);
    }
  }

  /// Set up password for first time
  Future<bool> setupPassword(String password) async {
    if (!_isValidPassword(password)) {
      _setError(
        'Password must be ${EnvConfig.minPasswordLength}-${EnvConfig.maxPasswordLength} digits',
      );
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      AppLogger.auth('Setting up password');

      await _secureStorage.write(key: _passwordKey, value: password);
      await _secureStorage.write(key: _isSetupKey, value: 'true');

      _isPasswordSetup = true;
      _isAuthenticated = true;

      AppLogger.auth('Password setup successful');
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to setup password', e, stackTrace);
      _setError('Failed to setup password');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Authenticate with password
  Future<bool> authenticate(String password) async {
    if (_isCurrentlyBlocked()) {
      final remainingTime = _getRemainingBlockTime();
      _setError(
        'Too many failed attempts. Try again in ${remainingTime.inMinutes + 1} minutes',
      );
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      AppLogger.auth('Attempting authentication');

      final storedPassword = await _secureStorage.read(key: _passwordKey);

      if (storedPassword == null) {
        _setError('No password found. Please setup password first');
        return false;
      }

      if (password == storedPassword) {
        _isAuthenticated = true;
        await _resetFailedAttempts();
        AppLogger.auth('Authentication successful');
        notifyListeners();
        return true;
      } else {
        await _recordFailedAttempt();
        final remaining = EnvConfig.maxLoginAttempts - _failedAttempts;
        if (remaining > 0) {
          _setError('Invalid password. $remaining attempts remaining');
        } else {
          _setError(
            'Too many failed attempts. Account blocked for ${EnvConfig.loginCooldownDuration.inMinutes} minutes',
          );
        }
        AppLogger.auth('Authentication failed', false, 'Invalid password');
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Authentication error', e, stackTrace);
      _setError('Authentication error occurred');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Change password
  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    if (!_isValidPassword(newPassword)) {
      _setError(
        'New password must be ${EnvConfig.minPasswordLength}-${EnvConfig.maxPasswordLength} digits',
      );
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      AppLogger.auth('Changing password');

      final storedPassword = await _secureStorage.read(key: _passwordKey);

      if (currentPassword != storedPassword) {
        _setError('Current password is incorrect');
        return false;
      }

      await _secureStorage.write(key: _passwordKey, value: newPassword);
      AppLogger.auth('Password changed successfully');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to change password', e, stackTrace);
      _setError('Failed to change password');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Logout user
  void logout() {
    _isAuthenticated = false;
    AppLogger.auth('User logged out');
    notifyListeners();
  }

  /// Reset authentication (for testing/development)
  Future<void> resetAuth() async {
    try {
      await _secureStorage.deleteAll();
      _isAuthenticated = false;
      _isPasswordSetup = false;
      _failedAttempts = 0;
      _lastFailedAttempt = null;
      AppLogger.auth('Authentication reset');
      notifyListeners();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to reset authentication', e, stackTrace);
    }
  }

  // Private helper methods
  bool _isValidPassword(String password) {
    if (password.length < EnvConfig.minPasswordLength ||
        password.length > EnvConfig.maxPasswordLength) {
      return false;
    }

    // Check if password contains only digits
    return RegExp(r'^[0-9]+$').hasMatch(password);
  }

  bool _isCurrentlyBlocked() {
    if (_failedAttempts < EnvConfig.maxLoginAttempts) return false;
    if (_lastFailedAttempt == null) return false;

    final timeSinceLastAttempt = DateTime.now().difference(_lastFailedAttempt!);
    return timeSinceLastAttempt < EnvConfig.loginCooldownDuration;
  }

  Duration _getRemainingBlockTime() {
    if (_lastFailedAttempt == null) return Duration.zero;

    final timeSinceLastAttempt = DateTime.now().difference(_lastFailedAttempt!);
    final remaining = EnvConfig.loginCooldownDuration - timeSinceLastAttempt;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  Future<void> _loadFailedAttemptsData() async {
    try {
      final attemptsStr = await _secureStorage.read(key: _failedAttemptsKey);
      _failedAttempts = int.tryParse(attemptsStr ?? '0') ?? 0;

      final lastAttemptStr = await _secureStorage.read(
        key: _lastFailedAttemptKey,
      );
      if (lastAttemptStr != null) {
        _lastFailedAttempt = DateTime.tryParse(lastAttemptStr);
      }

      // Reset failed attempts if cooldown period has passed
      if (_isCurrentlyBlocked() && !_isCurrentlyBlocked()) {
        await _resetFailedAttempts();
      }
    } catch (e) {
      AppLogger.error('Failed to load failed attempts data', e);
    }
  }

  Future<void> _recordFailedAttempt() async {
    try {
      _failedAttempts++;
      _lastFailedAttempt = DateTime.now();

      await _secureStorage.write(
        key: _failedAttemptsKey,
        value: _failedAttempts.toString(),
      );
      await _secureStorage.write(
        key: _lastFailedAttemptKey,
        value: _lastFailedAttempt!.toIso8601String(),
      );
    } catch (e) {
      AppLogger.error('Failed to record failed attempt', e);
    }
  }

  Future<void> _resetFailedAttempts() async {
    try {
      _failedAttempts = 0;
      _lastFailedAttempt = null;

      await _secureStorage.delete(key: _failedAttemptsKey);
      await _secureStorage.delete(key: _lastFailedAttemptKey);
    } catch (e) {
      AppLogger.error('Failed to reset failed attempts', e);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  @override
  void dispose() {
    AppLogger.debug('AuthStore disposed');
    super.dispose();
  }
}
