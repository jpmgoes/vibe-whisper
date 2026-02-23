// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Whisper';

  @override
  String get recordingIndicator => '듣는 중...';

  @override
  String get settings => '설정';

  @override
  String get apiSettings => 'API 설정';

  @override
  String get groqApiKey => 'Groq API 키';

  @override
  String get llmModel => '처리 모델 (LLM)';

  @override
  String get whisperModel => 'Whisper 모델';

  @override
  String get generalSettings => '일반';

  @override
  String get themeMode => '테마 모드';

  @override
  String get language => '언어';

  @override
  String get autoPaste => '활성 필드에 자동 붙여넣기';

  @override
  String get system => '시스템';

  @override
  String get light => '라이트';

  @override
  String get dark => '다크';

  @override
  String get globalShortcut => '글로벌 단축키';

  @override
  String get save => '저장';

  @override
  String get success => '성공';

  @override
  String get error => '오류';

  @override
  String get textCopied => '텍스트가 클립보드에 복사되었습니다';

  @override
  String get enterApiKey => 'API 키를 입력하세요';

  @override
  String get processing => '처리 중';

  @override
  String get errorTryAgain => '오류. 다시 시도하세요.';

  @override
  String get invalidApiKey => 'API 키가 잘못되었거나 모델이 없습니다.';

  @override
  String get setupWorkspace => '작업 공간 설정';

  @override
  String get configureVoice => '음성 설정 및 AI 연결을 구성하여 강력한 음성 텍스트 변환 기능을 활용하세요.';

  @override
  String get primaryLanguage => '주 언어';

  @override
  String get getStarted => '시작하기';

  @override
  String get keyStoredLocally => '키는 로컬에 안전하게 저장되고 암호화됩니다.';

  @override
  String get toggleRecording => '녹음 전환';

  @override
  String get fillActiveField => '활성 필드 채우기';

  @override
  String get settingsSaved => '설정이 자동으로 저장되었습니다.';

  @override
  String get saveChanges => '변경 사항 저장';
}
