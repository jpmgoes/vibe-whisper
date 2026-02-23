// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Whisper';

  @override
  String get recordingIndicator => 'Слушаю...';

  @override
  String get settings => 'Настройки';

  @override
  String get apiSettings => 'Настройки API';

  @override
  String get groqApiKey => 'Ключ API Groq';

  @override
  String get llmModel => 'Модель обработки (LLM)';

  @override
  String get whisperModel => 'Модель Whisper';

  @override
  String get generalSettings => 'Общие';

  @override
  String get themeMode => 'Тема';

  @override
  String get language => 'Язык';

  @override
  String get autoPaste => 'Автоматическая вставка в активное поле';

  @override
  String get system => 'Система';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Темная';

  @override
  String get globalShortcut => 'Глобальная комбинация клавиш';

  @override
  String get save => 'Сохранить';

  @override
  String get success => 'Успех';

  @override
  String get error => 'Ошибка';

  @override
  String get textCopied => 'Текст скопирован в буфер обмена';

  @override
  String get enterApiKey => 'Пожалуйста, введите ваш API-ключ';

  @override
  String get processing => 'Обработка';

  @override
  String get errorTryAgain => 'Ошибка. Попробуйте еще раз.';

  @override
  String get invalidApiKey => 'Неверный API-ключ или модели не найдены.';

  @override
  String get setupWorkspace => 'Настройка рабочего пространства';

  @override
  String get configureVoice =>
      'Настройте параметры голоса и подключение к ИИ, чтобы открыть новые возможности.';

  @override
  String get primaryLanguage => 'Основной язык';

  @override
  String get getStarted => 'Начать';

  @override
  String get keyStoredLocally =>
      'Ваш ключ надежно хранится на устройстве в зашифрованном виде.';

  @override
  String get toggleRecording => 'Переключить запись';

  @override
  String get fillActiveField => 'Заполнить активное поле';

  @override
  String get settingsSaved => 'Настройки сохранены автоматически.';

  @override
  String get saveChanges => 'Сохранить изменения';

  @override
  String get history => 'История';

  @override
  String get clearAll => 'Очистить все';

  @override
  String get transcriptionHistory => 'История транскрипций';

  @override
  String get noHistoryContent => 'Пока нет истории транскрипций.';

  @override
  String get originalAudio => 'Оригинальное аудио';

  @override
  String get processedOutput => 'Обработанный вывод';

  @override
  String get copiedOriginal => 'Оригинал скопирован';

  @override
  String get copiedWhisper =>
      'Транскрипция Whisper скопирована в буфер обмена.';

  @override
  String get copiedProcessed => 'Обработанный текст скопирован';

  @override
  String get copiedProcessedMsg =>
      'Обработанный текст скопирован в буфер обмена.';

  @override
  String get clearHistoryTitle => 'Очистить историю';

  @override
  String get clearHistoryMsg =>
      'Вы уверены, что хотите удалить всю историю транскрипций? Это действие нельзя отменить.';

  @override
  String get cancel => 'Отмена';

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
