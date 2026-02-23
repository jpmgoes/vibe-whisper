// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Whisper';

  @override
  String get recordingIndicator => '正在聆听...';

  @override
  String get settings => '设置';

  @override
  String get apiSettings => 'API 设置';

  @override
  String get groqApiKey => 'Groq API 密钥';

  @override
  String get llmModel => '处理模型 (LLM)';

  @override
  String get whisperModel => 'Whisper 模型';

  @override
  String get generalSettings => '常规';

  @override
  String get themeMode => '主题模式';

  @override
  String get language => '语言';

  @override
  String get autoPaste => '自动粘贴到活动字段';

  @override
  String get system => '系统';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get globalShortcut => '全局快捷键';

  @override
  String get save => '保存';

  @override
  String get success => '成功';

  @override
  String get error => '错误';

  @override
  String get textCopied => '文本已复制到剪贴板';

  @override
  String get enterApiKey => '请输入您的 API 密钥';

  @override
  String get processing => '处理中';

  @override
  String get errorTryAgain => '错误，请重试。';

  @override
  String get invalidApiKey => 'API 密钥无效或未找到模型。';

  @override
  String get setupWorkspace => '设置您的工作区';

  @override
  String get configureVoice => '配置您的语音设置和 AI 连接，以解锁强大的语音转文本功能。';

  @override
  String get primaryLanguage => '主要语言';

  @override
  String get getStarted => '开始使用';

  @override
  String get keyStoredLocally => '您的密钥安全存储在本地并已加密。';

  @override
  String get toggleRecording => '切换录音';

  @override
  String get fillActiveField => '填充活动字段';

  @override
  String get settingsSaved => '设置已自动保存。';

  @override
  String get saveChanges => '保存更改';
}
