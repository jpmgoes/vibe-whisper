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
import 'core/providers/settings_provider.dart';
import 'core/providers/recording_provider.dart';
import 'core/theme/app_theme.dart';
import 'ui/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await windowManager.ensureInitialized();
  await hotKeyManager.unregisterAll();
  await localNotifier.setup(appName: 'OwnWhisper');

  // Init services
  final storageService = StorageService();
  await storageService.init();

  final audioService = AudioService();
  final groqService = GroqService();
  final clipboardService = ClipboardService();
  final shortcutService = ShortcutService();

  final settingsProvider = SettingsProvider(storageService, groqService);
  await settingsProvider.init();

  final recordingProvider = RecordingProvider(
    audioService,
    groqService,
    clipboardService,
    settingsProvider,
  );

  // Register Shortcut
  await shortcutService.init(() {
    recordingProvider.toggleRecording();
  });

  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 700),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  final router = AppRouter.createRouter(settingsProvider);

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
  
  const OwnWhisperApp({Key? key, required this.router}) : super(key: key);

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
    );
  }
}
