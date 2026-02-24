// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Whisper';

  @override
  String get recordingIndicator => 'Đang nghe...';

  @override
  String get settings => 'Cài đặt';

  @override
  String get apiSettings => 'Cài đặt API';

  @override
  String get groqApiKey => 'Khóa API Groq';

  @override
  String get llmModel => 'Mô hình Xử lý (LLM)';

  @override
  String get whisperModel => 'Mô hình Whisper';

  @override
  String get generalSettings => 'Chung';

  @override
  String get themeMode => 'Chủ đề';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get autoPaste => 'Tự động dán vào trường hoạt động';

  @override
  String get system => 'Hệ thống';

  @override
  String get light => 'Sáng';

  @override
  String get dark => 'Tối';

  @override
  String get globalShortcut => 'Phím tắt toàn cầu';

  @override
  String get save => 'Lưu';

  @override
  String get success => 'Thành công';

  @override
  String get error => 'Lỗi';

  @override
  String get textCopied => 'Đã sao chép văn bản vào clipboard';

  @override
  String get enterApiKey => 'Vui lòng nhập khóa API của bạn';

  @override
  String get processing => 'Đang xử lý';

  @override
  String get errorTryAgain => 'Lỗi. Thử lại.';

  @override
  String get invalidApiKey =>
      'Khóa API không hợp lệ hoặc không tìm thấy mô hình.';

  @override
  String get setupWorkspace => 'Thiết lập không gian làm việc của bạn';

  @override
  String get configureVoice =>
      'Cấu hình cài đặt giọng nói và kết nối AI để mở khóa các tính năng giọng nói thành văn bản.';

  @override
  String get primaryLanguage => 'Ngôn ngữ chính';

  @override
  String get getStarted => 'Bắt đầu';

  @override
  String get keyStoredLocally =>
      'Khóa của bạn được lưu trữ an toàn trên thiết bị và được mã hóa.';

  @override
  String get toggleRecording => 'Bật/Tắt Ghi âm';

  @override
  String get fillActiveField => 'Điền vào trường hoạt động';

  @override
  String get settingsSaved => 'Cài đặt đã tự động lưu.';

  @override
  String get saveChanges => 'Lưu thay đổi';

  @override
  String get history => 'Lịch sử';

  @override
  String get clearAll => 'Xóa tất cả';

  @override
  String get transcriptionHistory => 'Lịch sử phiên âm';

  @override
  String get noHistoryContent => 'Chưa có lịch sử phiên âm nào.';

  @override
  String get originalAudio => 'Âm thanh Gốc';

  @override
  String get processedOutput => 'Đầu ra đã xử lý';

  @override
  String get copiedOriginal => 'Đã sao chép bản gốc';

  @override
  String get copiedWhisper =>
      'Phiên âm Whisper đã được sao chép vào khay nhớ tạm.';

  @override
  String get copiedProcessed => 'Đã sao chép phần xử lý';

  @override
  String get copiedProcessedMsg =>
      'Văn bản đã xử lý được sao chép vào khay nhớ tạm.';

  @override
  String get clearHistoryTitle => 'Xóa lịch sử';

  @override
  String get clearHistoryMsg =>
      'Bạn có chắc chắn muốn xóa tất cả lịch sử phiên âm không? Không thể hoàn tác hành động này.';

  @override
  String get cancel => 'Hủy';

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

  @override
  String get eraseAllData => 'Erase All Data';

  @override
  String get eraseAllDataConfirm =>
      'Are you sure you want to erase all data and reset the app? This action cannot be undone.';

  @override
  String get globalShortcutsAndGeneral => 'Global Shortcuts & General';

  @override
  String get pressShortcut => 'Press a shortcut combination...';

  @override
  String get dangerZone => 'Danger Zone';
}
