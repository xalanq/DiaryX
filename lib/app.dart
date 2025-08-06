import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'themes/app_theme.dart';
import 'stores/moment_store.dart';
import 'stores/auth_store.dart';

import 'stores/chat_store.dart';
import 'stores/theme_store.dart';
import 'stores/navigation_store.dart';
import 'routes.dart';
import 'consts/env_config.dart';

/// Custom scroll behavior to unify iOS and Android scroll effects
class CustomScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // Use bouncing physics on all platforms to avoid Android over-stretch deformation
    return const BouncingScrollPhysics();
  }
}

class DiaryXApp extends StatelessWidget {
  const DiaryXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthStore()),
        ChangeNotifierProvider(create: (_) => MomentStore()),
        ChangeNotifierProvider(create: (_) => ChatStore()),
        ChangeNotifierProvider(create: (_) => ThemeStore()..initTheme()),
        ChangeNotifierProvider(create: (_) => NavigationStore()),
      ],
      child: Consumer2<AuthStore, ThemeStore>(
        builder: (context, authStore, themeStore, child) {
          return MaterialApp(
            title: EnvConfig.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeStore.themeMode,
            debugShowCheckedModeBanner: false,
            scrollBehavior:
                CustomScrollBehavior(), // Set global scroll behavior
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
            onGenerateRoute: AppRoutes.onGenerateRoute,
          );
        },
      ),
    );
  }
}
