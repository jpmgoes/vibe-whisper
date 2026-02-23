// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Whisper';

  @override
  String get recordingIndicator => '録音中...';

  @override
  String get settings => '設定';

  @override
  String get apiSettings => 'API設定';

  @override
  String get groqApiKey => 'Groq APIキー';

  @override
  String get llmModel => '処理モデル (LLM)';

  @override
  String get whisperModel => 'Whisperモデル';

  @override
  String get generalSettings => '一般';

  @override
  String get themeMode => 'テーマ';

  @override
  String get language => '言語';

  @override
  String get autoPaste => 'アクティブなフィールドに自動貼り付け';

  @override
  String get system => 'システム';

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String get globalShortcut => 'グローバルショートカット';

  @override
  String get save => '保存';

  @override
  String get success => '成功';

  @override
  String get error => 'エラー';

  @override
  String get textCopied => 'テキストをクリップボードにコピーしました';

  @override
  String get enterApiKey => 'APIキーを入力してください';

  @override
  String get processing => '処理中';

  @override
  String get errorTryAgain => 'エラー。再試行してください。';

  @override
  String get invalidApiKey => 'APIキーが無効、またはモデルが見つかりません。';

  @override
  String get setupWorkspace => 'ワークスペースの設定';

  @override
  String get configureVoice => '音声設定とAIの接続を設定して、強力な音声読み上げ機能を有効にします。';

  @override
  String get primaryLanguage => '主要言語';

  @override
  String get getStarted => '始める';

  @override
  String get keyStoredLocally => 'キーはローカルに保存され、暗号化されます。';

  @override
  String get toggleRecording => '録音の切り替え';

  @override
  String get fillActiveField => 'アクティブなフィールドに入力';

  @override
  String get settingsSaved => '設定が自動的に保存されました。';

  @override
  String get saveChanges => '変更を保存';
}
