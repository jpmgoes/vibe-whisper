import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/settings_provider.dart';
import 'screens/overlay_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/history_screen.dart';
import 'screens/onboarding_screen.dart';

class AppRouter {
  static GoRouter createRouter(SettingsProvider settings) {
    final initialLocation = (settings.groqApiKey == null || settings.groqApiKey!.isEmpty) 
      ? '/onboarding' 
      : '/hidden';

    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) => const HistoryScreen(),
        ),
        GoRoute(
          path: '/overlay',
          builder: (context, state) => const OverlayScreen(),
        ),
        GoRoute(
          path: '/hidden',
          builder: (context, state) => const Scaffold(backgroundColor: Colors.transparent),
        ),
      ],
    );
  }
}
