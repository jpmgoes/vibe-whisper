import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';

import 'package:window_manager/window_manager.dart';

import '../core/services/storage_service.dart';
import '../core/services/audio_service.dart';
import '../core/services/groq_service.dart';
import '../core/services/clipboard_service.dart';
import '../core/services/shortcut_service.dart';
import '../core/services/audio_player_service.dart';
import '../core/providers/settings_provider.dart';
import '../core/providers/recording_provider.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';

import 'screens/settings_screen.dart';
import 'screens/history_screen.dart';
import 'screens/snippets_screen.dart';
import 'screens/onboarding_screen.dart';

Future<void> startSubWindow(String windowId, Map<String, dynamic> arguments) async {
  await windowManager.ensureInitialized();
  
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 700),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setAsFrameless(); // Forces hiding macOS native traffic lights
    await windowManager.setHasShadow(true);
    await windowManager.show();
    await windowManager.focus();
  });


  // Re-initialize core services for this isolate
  final storageService = StorageService();
  await storageService.init();

  final audioService = AudioService();
  final groqService = GroqService();
  final clipboardService = ClipboardService();
  final shortcutService = ShortcutService(); // Do not register the callback here!
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

  final route = arguments['route'] as String? ?? 'settings';
  
  runApp(
    MultiProvider(
       providers: [
        Provider.value(value: shortcutService),
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: recordingProvider),
      ],
      child: SubVibeWhisperApp(
        route: route,
        windowController: WindowController.fromWindowId(windowId),
      ),
    ),
  );
}

class SubVibeWhisperApp extends StatelessWidget {
  final String route;
  final WindowController windowController;
  
  const SubVibeWhisperApp({super.key, required this.route, required this.windowController});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    ThemeMode themeMode = ThemeMode.system;
    if (settings.themeMode == 'light') themeMode = ThemeMode.light;
    if (settings.themeMode == 'dark') themeMode = ThemeMode.dark;

    Widget homeWidget;
    if (route == 'history') {
      homeWidget = const HistoryScreen();
    } else if (route == 'snippets') {
      homeWidget = const SnippetsScreen();
    } else {
      if (settings.groqApiKey == null || settings.groqApiKey!.isEmpty) {
        homeWidget = const OnboardingScreen();
      } else {
        homeWidget = const SettingsScreen();
      }
    }

    return MaterialApp(
      onGenerateTitle: (context) {
        final l10n = AppLocalizations.of(context)!;
        if (route == 'history') return l10n.transcriptionHistory;
        if (route == 'snippets') return l10n.snippets;
        return l10n.settings;
      },
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: Locale(settings.appLanguage),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        return Container(
          color: Colors.transparent,
          child: child ?? const SizedBox(),
        );
      },
      home: homeWidget,
    );
  }
}
