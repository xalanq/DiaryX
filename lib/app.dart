import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'themes/app_theme.dart';
import 'stores/entry_store.dart';
import 'stores/auth_store.dart';
import 'stores/search_store.dart';
import 'stores/theme_store.dart';
import 'routes.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/home/home_screen.dart';
import 'consts/env_config.dart';
import 'utils/app_logger.dart';

class DiaryXApp extends StatelessWidget {
  const DiaryXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthStore()),
        ChangeNotifierProvider(create: (_) => EntryStore()),
        ChangeNotifierProvider(create: (_) => SearchStore()),
        ChangeNotifierProvider(create: (_) => ThemeStore()..initTheme()),
      ],
      child: Consumer2<AuthStore, ThemeStore>(
        builder: (context, authStore, themeStore, child) {
          return MaterialApp(
            title: EnvConfig.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeStore.themeMode,
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.splash,
            routes: {
              AppRoutes.splash: (context) => const SplashScreen(),
              AppRoutes.auth: (context) => const AuthScreen(),
              AppRoutes.home: (context) => const HomeScreen(),
            },
            onGenerateRoute: (settings) {
              AppLogger.navigation(
                'Unknown route',
                settings.name ?? 'null',
                settings.arguments as Map<String, dynamic>?,
              );
              return null;
            },
          );
        },
      ),
    );
  }
}
