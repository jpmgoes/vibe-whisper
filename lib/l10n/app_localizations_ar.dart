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

  @override
  String get history => 'السجل';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get transcriptionHistory => 'سجل النسخ';

  @override
  String get noHistoryContent => 'لا يوجد سجل نسخ بعد.';

  @override
  String get originalAudio => 'الصوت الأصلي';

  @override
  String get processedOutput => 'المخرجات المعالجة';

  @override
  String get copiedOriginal => 'تم نسخ الأصل';

  @override
  String get copiedWhisper => 'تم نسخ نسخ Whisper إلى الحافظة.';

  @override
  String get copiedProcessed => 'تم نسخ المعالج';

  @override
  String get copiedProcessedMsg => 'تم نسخ النص المعالج إلى الحافظة.';

  @override
  String get clearHistoryTitle => 'مسح السجل';

  @override
  String get clearHistoryMsg =>
      'هل أنت متأكد أنك تريد حذف كل سجل النسخ؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get cancel => 'إلغاء';
}
