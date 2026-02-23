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

  @override
  String get processing => 'Processing';

  @override
  String get errorTryAgain => 'Error. Try again.';

  @override
  String get invalidApiKey => 'Invalid API Key or no models found.';

  @override
  String get setupWorkspace => 'Set up your workspace';

  @override
  String get configureVoice =>
      'Configure your voice settings and AI connection to unlock powerful voice-to-text features.';

  @override
  String get primaryLanguage => 'Primary Language';

  @override
  String get getStarted => 'Get Started';

  @override
  String get keyStoredLocally => 'Your key is stored locally and encrypted.';

  @override
  String get toggleRecording => 'Toggle Recording';

  @override
  String get fillActiveField => 'Fill active field';

  @override
  String get settingsSaved => 'Settings saved automatically.';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get history => 'History';

  @override
  String get clearAll => 'Clear All';

  @override
  String get transcriptionHistory => 'Transcription History';

  @override
  String get noHistoryContent => 'No transcription history yet.';

  @override
  String get originalAudio => 'Original Audio';

  @override
  String get processedOutput => 'Processed Output';

  @override
  String get copiedOriginal => 'Copied Original';

  @override
  String get copiedWhisper => 'Whisper transcription copied to clipboard.';

  @override
  String get copiedProcessed => 'Copied Processed';

  @override
  String get copiedProcessedMsg => 'Processed text copied to clipboard.';

  @override
  String get clearHistoryTitle => 'Clear History';

  @override
  String get clearHistoryMsg =>
      'Are you sure you want to delete all transcription history? This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get intentModel => 'Intent Model (Router)';

  @override
  String get snippets => 'Voice Snippets';

  @override
  String get addSnippet => 'Add Snippet';

  @override
  String get editSnippet => 'Edit Snippet';

  @override
  String get newSnippet => 'New Snippet';

  @override
  String get snippetCommandLabel => 'Command/Key (e.g., \"my email\")';

  @override
  String get snippetValueLabel => 'Value to paste';

  @override
  String get noSnippetsYet => 'No snippets yet.';
}
