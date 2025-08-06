import 'package:flutter/material.dart';

// Import all screen widgets
import 'screens/splash/splash_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/capture/capture_screen.dart';
import 'screens/capture/voice_moment/voice_moment_screen.dart';
import 'screens/capture/text_moment/text_moment_screen.dart';
import 'screens/capture/camera_moment/camera_moment_screen.dart';
import 'screens/timeline/timeline_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/chat/chat_conversation_screen.dart';
import 'screens/chat/chat_conversations_screen.dart';
import 'screens/insight/insight_screen.dart';
import 'screens/profile/change_password_screen.dart';

import 'models/moment.dart';
import 'utils/app_logger.dart';

/// Route constants and navigation methods for DiaryX application
class AppRoutes {
  // Main app routes
  static const String splash = '/';
  static const String home = '/home';
  static const String capture = '/capture';
  static const String timeline = '/timeline';
  static const String profile = '/profile';
  static const String chat = '/chat';
  static const String chatConversation = '/chat/conversation';
  static const String chatConversations = '/chat/conversations';
  static const String report = '/report';
  static const String changePassword = '/change-password';

  // Moment creation routes
  static const String voiceMoment = '/voice-moment';
  static const String textMoment = '/text-moment';
  static const String cameraMoment = '/camera-moment';

  /// Private constructor to prevent instantiation
  AppRoutes._();

  // Business navigation methods

  /// Navigate to voice moment screen
  static Future<T?> toVoiceMoment<T extends Object?>(
    BuildContext context, {
    bool isFromTextMoment = false,
    bool isEditingMode = false,
  }) async {
    AppLogger.info('Navigating to voice moment');

    return await Navigator.of(context).push(
      _createCustomRoute(
        VoiceMomentScreen(
          isFromTextMoment: isFromTextMoment,
          isEditingMode: isEditingMode,
        ),
        slideDirection: SlideDirection.up,
        transitionType: TransitionType.slideWithFade,
      ),
    );
  }

  /// Navigate to text moment screen
  static Future<T?> toTextMoment<T extends Object?>(
    BuildContext context, {
    Moment? existingMoment,
  }) async {
    AppLogger.info('Navigating to text moment');

    return await Navigator.of(context).push(
      _createCustomRoute(
        TextMomentScreen(existingMoment: existingMoment),
        slideDirection: SlideDirection.up,
        transitionType: TransitionType.slideWithFade,
      ),
    );
  }

  /// Navigate to text moment with transition to home
  static Future<T?> toTextMomentAndReplace<T extends Object?>(
    BuildContext context, {
    Moment? existingMoment,
  }) async {
    AppLogger.info('Navigating to text moment then home');

    return await Navigator.of(context).pushReplacement(
      _createCustomRoute(
        TextMomentScreen(existingMoment: existingMoment),
        slideDirection: SlideDirection.up,
        transitionType: TransitionType.slideWithFade,
      ),
    );
  }

  /// Navigate to camera moment screen
  static Future<T?> toCameraMoment<T extends Object?>(
    BuildContext context, {
    bool isFromTextMoment = false,
    bool isEditingMode = false,
  }) async {
    AppLogger.info('Navigating to camera moment');

    return await Navigator.of(context).push(
      _createCustomRoute(
        CameraMomentScreen(
          isFromTextMoment: isFromTextMoment,
          isEditingMode: isEditingMode,
        ),
        slideDirection: SlideDirection.up,
        transitionType: TransitionType.slideWithFade,
      ),
    );
  }

  /// Navigate to capture screen
  static Future<T?> toCapture<T extends Object?>(
    BuildContext context, {
    bool isFromSplash = false,
  }) async {
    AppLogger.info('Navigating to capture screen');

    if (isFromSplash) {
      return await Navigator.of(context).pushReplacementNamed(
        AppRoutes.capture,
        arguments: {'isFromSplash': isFromSplash},
      );
    } else {
      return await Navigator.of(
        context,
      ).pushNamed(AppRoutes.capture, arguments: {'isFromSplash': isFromSplash});
    }
  }

  /// Navigate to home screen
  static Future<T?> toHome<T extends Object?>(BuildContext context) async {
    AppLogger.info('Navigating to home screen');

    return await Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  /// Navigate to chat conversation screen
  static Future<T?> toChatConversation<T extends Object?>(
    BuildContext context, {
    required int chatId,
  }) async {
    AppLogger.info('Navigating to chat conversation', {'chatId': chatId});

    return await Navigator.of(
      context,
    ).pushNamed(AppRoutes.chatConversation, arguments: {'chatId': chatId});
  }

  /// Navigate to chat conversations screen
  static Future<T?> toChatConversations<T extends Object?>(
    BuildContext context,
  ) async {
    AppLogger.info('Navigating to chat conversations');

    return await Navigator.of(context).pushNamed(AppRoutes.chatConversations);
  }

  /// Navigate to change password screen
  static Future<T?> toChangePassword<T extends Object?>(
    BuildContext context,
  ) async {
    AppLogger.info('Navigating to change password');

    return await Navigator.of(context).push(
      _createCustomRoute(
        const ChangePasswordScreen(),
        slideDirection: SlideDirection.right,
        transitionType: TransitionType.slideWithFade,
      ),
    );
  }

  /// Push named route with logging
  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) async {
    AppLogger.info('Navigating to: $routeName');
    return await Navigator.of(
      context,
    ).pushNamed(routeName, arguments: arguments);
  }

  /// Pop current route
  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }

  /// Check if can pop
  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  /// Create custom route with specified transition
  static PageRoute<T> _createCustomRoute<T extends Object?>(
    Widget page, {
    SlideDirection slideDirection = SlideDirection.right,
    TransitionType transitionType = TransitionType.slideWithFade,
    Duration transitionDuration = const Duration(milliseconds: 400),
    Duration reverseTransitionDuration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, _) => page,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _buildTransition(
          animation,
          secondaryAnimation,
          child,
          slideDirection,
          transitionType,
        );
      },
    );
  }

  /// Build transition animation based on type and direction
  static Widget _buildTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    SlideDirection slideDirection,
    TransitionType transitionType,
  ) {
    switch (transitionType) {
      case TransitionType.slide:
        return _buildSlideTransition(animation, child, slideDirection);
      case TransitionType.fade:
        return _buildFadeTransition(animation, child);
      case TransitionType.scale:
        return _buildScaleTransition(animation, child);
      case TransitionType.slideWithFade:
        return _buildSlideWithFadeTransition(animation, child, slideDirection);
      case TransitionType.slideWithScale:
        return _buildSlideWithScaleTransition(animation, child, slideDirection);
    }
  }

  /// Build slide transition
  static Widget _buildSlideTransition(
    Animation<double> animation,
    Widget child,
    SlideDirection direction,
  ) {
    Offset beginOffset;
    switch (direction) {
      case SlideDirection.up:
        beginOffset = const Offset(0.0, 1.0);
        break;
      case SlideDirection.down:
        beginOffset = const Offset(0.0, -1.0);
        break;
      case SlideDirection.left:
        beginOffset = const Offset(-1.0, 0.0);
        break;
      case SlideDirection.right:
        beginOffset = const Offset(1.0, 0.0);
        break;
    }

    final slideAnimation = Tween<Offset>(begin: beginOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    return SlideTransition(position: slideAnimation, child: child);
  }

  /// Build fade transition
  static Widget _buildFadeTransition(
    Animation<double> animation,
    Widget child,
  ) {
    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    return FadeTransition(opacity: fadeAnimation, child: child);
  }

  /// Build scale transition
  static Widget _buildScaleTransition(
    Animation<double> animation,
    Widget child,
  ) {
    final scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

    return ScaleTransition(scale: scaleAnimation, child: child);
  }

  /// Build slide with fade transition
  static Widget _buildSlideWithFadeTransition(
    Animation<double> animation,
    Widget child,
    SlideDirection direction,
  ) {
    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: _buildSlideTransition(animation, child, direction),
    );
  }

  /// Build slide with scale transition
  static Widget _buildSlideWithScaleTransition(
    Animation<double> animation,
    Widget child,
    SlideDirection direction,
  ) {
    final scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

    return ScaleTransition(
      scale: scaleAnimation,
      child: _buildSlideTransition(animation, child, direction),
    );
  }

  /// Generate route configurations for MaterialApp
  static Map<String, WidgetBuilder> get routes => {
    AppRoutes.splash: (context) => const SplashScreen(),
    AppRoutes.home: (context) => const HomeScreen(),
    AppRoutes.timeline: (context) => const TimelineScreen(),
    AppRoutes.profile: (context) => const ProfileScreen(),
    AppRoutes.chat: (context) => const ChatScreen(),
    AppRoutes.chatConversations: (context) => const ChatConversationsScreen(),
    AppRoutes.report: (context) => const InsightScreen(),
  };

  /// Generate route with arguments for MaterialApp.onGenerateRoute
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    AppLogger.info(
      'Generating route: ${settings.name} with args: ${settings.arguments}',
    );

    switch (settings.name) {
      case AppRoutes.capture:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final isFromSplash = args['isFromSplash'] as bool? ?? false;
        return AppRoutes._createCustomRoute(
          CaptureScreen(isFromSplash: isFromSplash),
          slideDirection: SlideDirection.up,
          transitionType: TransitionType.slideWithFade,
        );

      case AppRoutes.voiceMoment:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final isFromTextMoment = args['isFromTextMoment'] as bool? ?? false;
        final isEditingMode = args['isEditingMode'] as bool? ?? false;
        return AppRoutes._createCustomRoute(
          VoiceMomentScreen(
            isFromTextMoment: isFromTextMoment,
            isEditingMode: isEditingMode,
          ),
          slideDirection: SlideDirection.up,
          transitionType: TransitionType.slideWithFade,
        );

      case AppRoutes.textMoment:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final existingMoment = args['existingMoment'] as Moment?;
        return AppRoutes._createCustomRoute(
          TextMomentScreen(existingMoment: existingMoment),
          slideDirection: SlideDirection.up,
          transitionType: TransitionType.slideWithFade,
        );

      case AppRoutes.cameraMoment:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final isFromTextMoment = args['isFromTextMoment'] as bool? ?? false;
        final isEditingMode = args['isEditingMode'] as bool? ?? false;
        return AppRoutes._createCustomRoute(
          CameraMomentScreen(
            isFromTextMoment: isFromTextMoment,
            isEditingMode: isEditingMode,
          ),
          slideDirection: SlideDirection.up,
          transitionType: TransitionType.slideWithFade,
        );

      case AppRoutes.chatConversation:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final chatId = args['chatId'] as int?;
        if (chatId == null) {
          AppLogger.error('Chat conversation route requires chatId parameter');
          return null;
        }
        return AppRoutes._createCustomRoute(
          ChatConversationScreen(chatId: chatId),
          slideDirection: SlideDirection.up,
          transitionType: TransitionType.slideWithFade,
        );

      case AppRoutes.chatConversations:
        return AppRoutes._createCustomRoute(
          const ChatConversationsScreen(),
          slideDirection: SlideDirection.up,
          transitionType: TransitionType.slideWithFade,
        );

      case AppRoutes.changePassword:
        return AppRoutes._createCustomRoute(
          const ChangePasswordScreen(),
          slideDirection: SlideDirection.right,
          transitionType: TransitionType.slideWithFade,
        );

      default:
        AppLogger.warn('Unknown route: ${settings.name}');
        return null;
    }
  }
}

/// Slide direction for page transitions
enum SlideDirection { up, down, left, right }

/// Transition type for different navigation scenarios
enum TransitionType { slide, fade, scale, slideWithFade, slideWithScale }
