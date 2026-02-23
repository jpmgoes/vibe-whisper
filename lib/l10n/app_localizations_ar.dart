// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Whisper';

  @override
  String get recordingIndicator => 'جاري الاستماع...';

  @override
  String get settings => 'الإعدادات';

  @override
  String get apiSettings => 'إعدادات API';

  @override
  String get groqApiKey => 'مفتاح API الخاص بـ Groq';

  @override
  String get llmModel => 'نموذج المعالجة (LLM)';

  @override
  String get whisperModel => 'نموذج Whisper';

  @override
  String get generalSettings => 'عام';

  @override
  String get themeMode => 'المظهر';

  @override
  String get language => 'اللغة';

  @override
  String get autoPaste => 'لصق تلقائي في الحقل النشط';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get globalShortcut => 'اختصار عام';

  @override
  String get save => 'حفظ';

  @override
  String get success => 'نجاح';

  @override
  String get error => 'خطأ';

  @override
  String get textCopied => 'تم نسخ النص إلى الحافظة';

  @override
  String get enterApiKey => 'الرجاء إدخال مفتاح API الخاص بك';

  @override
  String get processing => 'جاري المعالجة';

  @override
  String get errorTryAgain => 'خطأ. حاول مرة أخرى.';

  @override
  String get invalidApiKey => 'مفتاح API غير صالح أو لم يتم العثور على نماذج.';

  @override
  String get setupWorkspace => 'قم بإعداد مساحة العمل الخاصة بك';

  @override
  String get configureVoice =>
      'قم بتهيئة إعدادات الصوت واتصال الذكاء الاصطناعي الخاص بك لفتح ميزات تحويل الصوت إلى نص.';

  @override
  String get primaryLanguage => 'اللغة الأساسية';

  @override
  String get getStarted => 'البدء';

  @override
  String get keyStoredLocally => 'يتم تخزين مفتاحك محليًا وتشفيره.';

  @override
  String get toggleRecording => 'تبديل التسجيل';

  @override
  String get fillActiveField => 'تعبئة الحقل النشط';

  @override
  String get settingsSaved => 'تم حفظ الإعدادات تلقائيًا.';

  @override
  String get saveChanges => 'حفظ التغييرات';
}
