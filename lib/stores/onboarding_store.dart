import 'package:flutter/foundation.dart';
import '../utils/app_logger.dart';
import '../utils/secure_storage_helper.dart';

/// Store for managing onboarding state and completion
class OnboardingStore extends ChangeNotifier {
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _passwordSkippedKey = 'password_skipped';
  static const String _aiSkippedKey = 'ai_skipped';

  final SecureStorageHelper _secureStorage = const SecureStorageHelper();

  bool _isOnboardingCompleted = false;
  bool _isPasswordSkipped = false;
  bool _isAISkipped = false;
  bool _isLoading = false;

  // Getters
  bool get isOnboardingCompleted => _isOnboardingCompleted;
  bool get isPasswordSkipped => _isPasswordSkipped;
  bool get isAISkipped => _isAISkipped;
  bool get isLoading => _isLoading;

  /// Initialize onboarding state
  Future<void> initialize() async {
    _setLoading(true);

    try {
      AppLogger.info('Initializing onboarding state');

      // Check if onboarding is completed
      final completedStatus = await _secureStorage.read(
        key: _onboardingCompletedKey,
      );
      _isOnboardingCompleted = completedStatus == 'true';

      // Check if password was skipped
      final passwordSkippedStatus = await _secureStorage.read(
        key: _passwordSkippedKey,
      );
      _isPasswordSkipped = passwordSkippedStatus == 'true';

      // Check if AI was skipped
      final aiSkippedStatus = await _secureStorage.read(key: _aiSkippedKey);
      _isAISkipped = aiSkippedStatus == 'true';

      AppLogger.info(
        'Onboarding state initialized - '
        'Completed: $_isOnboardingCompleted, '
        'Password skipped: $_isPasswordSkipped, '
        'AI skipped: $_isAISkipped',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize onboarding state', e, stackTrace);
    } finally {
      _setLoading(false);
    }
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    try {
      AppLogger.info('Marking onboarding as completed');

      await _secureStorage.write(key: _onboardingCompletedKey, value: 'true');
      _isOnboardingCompleted = true;

      notifyListeners();
      AppLogger.info('Onboarding marked as completed');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to mark onboarding as completed', e, stackTrace);
    }
  }

  /// Mark password setup as skipped
  Future<void> skipPasswordSetup() async {
    try {
      AppLogger.info('Marking password setup as skipped');

      await _secureStorage.write(key: _passwordSkippedKey, value: 'true');
      _isPasswordSkipped = true;

      notifyListeners();
      AppLogger.info('Password setup marked as skipped');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to mark password setup as skipped',
        e,
        stackTrace,
      );
    }
  }

  /// Mark AI setup as skipped
  Future<void> skipAISetup() async {
    try {
      AppLogger.info('Marking AI setup as skipped');

      await _secureStorage.write(key: _aiSkippedKey, value: 'true');
      _isAISkipped = true;

      notifyListeners();
      AppLogger.info('AI setup marked as skipped');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to mark AI setup as skipped', e, stackTrace);
    }
  }

  /// Clear password skipped status (when user later sets up password)
  Future<void> clearPasswordSkipped() async {
    try {
      AppLogger.info('Clearing password skipped status');

      await _secureStorage.delete(key: _passwordSkippedKey);
      _isPasswordSkipped = false;

      notifyListeners();
      AppLogger.info('Password skipped status cleared');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear password skipped status', e, stackTrace);
    }
  }

  /// Clear AI skipped status (when user later sets up AI)
  Future<void> clearAISkipped() async {
    try {
      AppLogger.info('Clearing AI skipped status');

      await _secureStorage.delete(key: _aiSkippedKey);
      _isAISkipped = false;

      notifyListeners();
      AppLogger.info('AI skipped status cleared');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear AI skipped status', e, stackTrace);
    }
  }

  /// Reset onboarding state (for testing/development)
  Future<void> resetOnboarding() async {
    try {
      AppLogger.info('Resetting onboarding state');

      await _secureStorage.delete(key: _onboardingCompletedKey);
      await _secureStorage.delete(key: _passwordSkippedKey);
      await _secureStorage.delete(key: _aiSkippedKey);

      _isOnboardingCompleted = false;
      _isPasswordSkipped = false;
      _isAISkipped = false;

      notifyListeners();
      AppLogger.info('Onboarding state reset');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to reset onboarding state', e, stackTrace);
    }
  }

  /// Check if user should be shown reminders for skipped setup
  bool shouldShowPasswordReminder() {
    return _isPasswordSkipped && _isOnboardingCompleted;
  }

  bool shouldShowAIReminder() {
    return _isAISkipped && _isOnboardingCompleted;
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    AppLogger.debug('OnboardingStore disposed');
    super.dispose();
  }
}
