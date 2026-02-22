// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Whisper';

  @override
  String get recordingIndicator => 'Listening...';

  @override
  String get settings => 'Settings';

  @override
  String get apiSettings => 'API Settings';

  @override
  String get groqApiKey => 'Groq API Key';

  @override
  String get llmModel => 'Treatment Model (LLM)';

  @override
  String get whisperModel => 'Whisper Model';

  @override
  String get generalSettings => 'General';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get language => 'Language';

  @override
  String get autoPaste => 'Auto-Paste into Active Field';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get globalShortcut => 'Global Shortcut';

  @override
  String get save => 'Save';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get textCopied => 'Text copied to clipboard';

  @override
  String get enterApiKey => 'Please enter your API Key';
}
