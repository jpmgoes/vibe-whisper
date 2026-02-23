import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'core/services/storage_service.dart';
import 'core/services/audio_service.dart';
import 'core/services/groq_service.dart';
import 'core/services/clipboard_service.dart';
import 'core/services/shortcut_service.dart';
import 'core/services/audio_player_service.dart';
import 'core/services/tray_service.dart';
import 'core/providers/settings_provider.dart';
import 'core/providers/recording_provider.dart';
import 'core/theme/app_theme.dart';
import 'ui/app_router.dart';
import 'ui/screens/overlay_screen.dart';

class AppWindowListener extends WindowListener {
  final GoRouter router;

  AppWindowListener(this.router);

  @override
  void onWindowClose() async {
    // Reset the route so the app forgets it was on settings
    router.go('/hidden');
    await windowManager.hide();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await windowManager.ensureInitialized();
  await windowManager.setPreventClose(true);
  
  await hotKeyManager.unregisterAll();
  await localNotifier.setup(appName: 'OwnWhisper');

  // Init services
  final storageService = StorageService();
  await storageService.init();

  final audioService = AudioService();
  final groqService = GroqService();
  final clipboardService = ClipboardService();
  final shortcutService = ShortcutService();
  final audioPlayerService = AudioPlayerService();
  await audioPlayerService.prefetchAll();

  final settingsProvider = SettingsProvider(storageService, groqService);
  await settingsProvider.init();

  final recordingProvider = RecordingProvider(
    audioService,
    groqService,
    clipboardService,
    audioPlayerService,
    settingsProvider,
  );

  final router = AppRouter.createRouter(settingsProvider);
  
  windowManager.addListener(AppWindowListener(router));
  
  final trayService = SystemTrayService(router);
  await trayService.init();

  recordingProvider.addListener(() async {
    if (recordingProvider.state == RecordingState.idle) {
      // If we are not on the settings page or onboarding, hide the window when done
      final currentRoute = router.routerDelegate.currentConfiguration.uri.toString();
      if (currentRoute == '/hidden') {
        await windowManager.hide();
      } else if (currentRoute == '/settings' || currentRoute == '/') {
        await windowManager.setTitleBarStyle(TitleBarStyle.hidden, windowButtonVisibility: true);
        await windowManager.setHasShadow(true);
        await windowManager.setSize(const Size(800, 700));
        await windowManager.center();
        await windowManager.setAlwaysOnTop(false);
      }
    }
  });

  // Register Shortcut
  await shortcutService.init(() async {
    // If not currently recording, we are ABOUT to start recording.
    // Resize window to small pill format before ensuring it's visible.
    if (recordingProvider.state == RecordingState.idle || 
        recordingProvider.state == RecordingState.success || 
        recordingProvider.state == RecordingState.error) {
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden, windowButtonVisibility: false);
      await windowManager.setBackgroundColor(Colors.transparent);
      await windowManager.setHasShadow(false);
      await windowManager.setSize(const Size(200, 100));
      await windowManager.setAlignment(Alignment.bottomCenter);
      await windowManager.setAlwaysOnTop(true);
    }
    
    if (!await windowManager.isVisible()) {
      await windowManager.show();
    }
    await windowManager.focus();
    recordingProvider.toggleRecording();
  });

  // If no API key, start in Onboarding (800x700). Otherwise, start hidden in Tray.
  final startHidden = (settingsProvider.groqApiKey != null && settingsProvider.groqApiKey!.isNotEmpty);
  
  WindowOptions windowOptions = WindowOptions(
    size: const Size(800, 700),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: true,
    titleBarStyle: TitleBarStyle.hidden,
  );
  
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    if (!startHidden) {
      await windowManager.show();
      await windowManager.focus();
    } else {
      await windowManager.hide();
    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: recordingProvider),
      ],
      child: OwnWhisperApp(router: router),
    ),
  );
}

class OwnWhisperApp extends StatelessWidget {
  final GoRouter router;
  
  const OwnWhisperApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    ThemeMode themeMode = ThemeMode.system;
    if (settings.themeMode == 'light') themeMode = ThemeMode.light;
    if (settings.themeMode == 'dark') themeMode = ThemeMode.dark;

    return MaterialApp.router(
      title: 'Own Whisper',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: Locale(settings.appLanguage),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('pt', ''),
        Locale('es', ''),
      ],
      routerConfig: router,
      builder: (context, child) {
        return Consumer<RecordingProvider>(
          builder: (context, provider, _) {
            if (provider.state != RecordingState.idle) {
              // Completely hide the underlying route to ensure transparent background around pill
              return const Scaffold(
                backgroundColor: Colors.transparent,
                body: OverlayScreen(),
              );
            }
            return child!;
          },
        );
      },
    );
  }
}
