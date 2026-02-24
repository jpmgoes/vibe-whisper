import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
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

import 'core/services/window_service.dart';
import 'ui/sub_app.dart';

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

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (args.firstOrNull == 'multi_window') {
    final windowId = args[1];
    final argument = args[2].isEmpty
        ? const <String, dynamic>{}
        : Map<String, dynamic>.from(jsonDecode(args[2]) as Map);
        
    await startSubWindow(windowId, argument);
    return;
  }

  await windowManager.ensureInitialized();
  await windowManager.setPreventClose(true);
  
  await hotKeyManager.unregisterAll();
  await localNotifier.setup(appName: 'VibeWhisper');

  launchAtStartup.setup(
    appName: 'VibeWhisper',
    appPath: Platform.resolvedExecutable,
    packageName: 'com.vibewhisper',
  );
  await launchAtStartup.enable();

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
      await windowManager.hide();
    }
  });

  // Register Shortcut
  await shortcutService.init(savedShortcutJson: settingsProvider.globalShortcut, () async {
    // If not currently recording, we are ABOUT to start recording.
    bool wasFocused = await windowManager.isFocused();
    
    // If we are in the background, ensure we don't open the settings window when done.
    if (!wasFocused) {
      router.go('/hidden');
    }

    // Window is permanently sized; just ensure it's at the bottom center and on top
    await windowManager.setAlignment(Alignment.bottomCenter);
    await windowManager.setAlwaysOnTop(true);
    
    if (!await windowManager.isVisible()) {
      await windowManager.show(inactive: true);
    }
    
    recordingProvider.toggleRecording();
  });

  String lastShortcut = settingsProvider.globalShortcut;
  settingsProvider.addListener(() {
    if (settingsProvider.globalShortcut != lastShortcut) {
      lastShortcut = settingsProvider.globalShortcut;
      shortcutService.updateShortcut(lastShortcut);
    }
  });

  // If no API key, open settings automatically
  if (settingsProvider.groqApiKey == null || settingsProvider.groqApiKey!.isEmpty) {
    WindowService.openSubWindow('settings');
  }
  
  // Main whisper widget shouldn't have shadow and shouldn't be full size
  WindowOptions windowOptions = const WindowOptions(
    size: Size(200, 100),
    backgroundColor: Colors.transparent,
    skipTaskbar: true,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );
  
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setHasShadow(false);
    await windowManager.setAlignment(Alignment.bottomCenter);
    await windowManager.setAlwaysOnTop(true);
    await windowManager.hide();
  });

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: shortcutService),
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: recordingProvider),
      ],
      child: VibeWhisperApp(router: router),
    ),
  );
}

class VibeWhisperApp extends StatelessWidget {
  final GoRouter router;
  
  const VibeWhisperApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    ThemeMode themeMode = ThemeMode.system;
    if (settings.themeMode == 'light') themeMode = ThemeMode.light;
    if (settings.themeMode == 'dark') themeMode = ThemeMode.dark;

    return MaterialApp.router(
      title: 'VibeWhisper',
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
      supportedLocales: AppLocalizations.supportedLocales,
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
