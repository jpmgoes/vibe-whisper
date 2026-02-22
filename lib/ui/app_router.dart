import 'package:go_router/go_router.dart';
import '../../core/providers/settings_provider.dart';
import 'screens/overlay_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/onboarding_screen.dart';

class AppRouter {
  static GoRouter createRouter(SettingsProvider settings) {
    final initialLocation = (settings.groqApiKey == null || settings.groqApiKey!.isEmpty) 
      ? '/onboarding' 
      : '/settings';

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
          path: '/overlay',
          builder: (context, state) => const OverlayScreen(),
        ),
      ],
    );
  }
}
