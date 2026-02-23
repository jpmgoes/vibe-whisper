import 'package:flutter/foundation.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/groq_service.dart';

class SettingsProvider with ChangeNotifier {
  final StorageService _storageService;
  final GroqService _groqService;

  SettingsProvider(this._storageService, this._groqService);

  String? _groqApiKey;
  String _llmModel = 'moonshotai/kimi-k2-instruct-0905';
  String _whisperModel = 'whisper-large-v3-turbo';
  bool _autoPaste = true;
  String _appLanguage = 'en';
  String _themeMode = 'system';
  String _globalShortcut = 'Meta+Shift+Space';

  List<String> _availableLlmModels = [];
  List<String> _availableWhisperModels = [];

  String? get groqApiKey => _groqApiKey;
  String get llmModel => _llmModel;
  String get whisperModel => _whisperModel;
  bool get autoPaste => _autoPaste;
  String get appLanguage => _appLanguage;
  String get themeMode => _themeMode;
  String get globalShortcut => _globalShortcut;
  List<String> get availableLlmModels => _availableLlmModels;
  List<String> get availableWhisperModels => _availableWhisperModels;

  Future<void> init() async {
    _groqApiKey = await _storageService.getGroqApiKey();
    _llmModel = _storageService.llmModel;
    _whisperModel = _storageService.whisperModel;
    _autoPaste = _storageService.autoPaste;
    _appLanguage = _storageService.appLanguage;
    _themeMode = _storageService.themeMode;
    _globalShortcut = _storageService.globalShortcut;
    notifyListeners();
    await fetchModels();
  }

  Future<void> fetchModels() async {
    if (_groqApiKey == null || _groqApiKey!.isEmpty) return;
    try {
      final models = await _groqService.getAvailableModels(_groqApiKey!);
      _availableWhisperModels = models.where((m) => m.toLowerCase().contains('whisper')).toList();
      _availableLlmModels = models.where((m) => !m.toLowerCase().contains('whisper')).toList();
      
      // Auto-select logic
      if (!_availableWhisperModels.contains(_whisperModel) && _availableWhisperModels.isNotEmpty) {
        _whisperModel = _availableWhisperModels.first;
        await _storageService.setWhisperModel(_whisperModel);
      }

      if (!_availableLlmModels.contains(_llmModel) && _availableLlmModels.isNotEmpty) {
        final kimiModel = _availableLlmModels.where((m) => m.toLowerCase().contains('kimi')).firstOrNull;
        _llmModel = kimiModel ?? _availableLlmModels.first;
        await _storageService.setLlmModel(_llmModel);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching models: $e');
    }
  }

  Future<void> setGroqApiKey(String key) async {
    _groqApiKey = key;
    await _storageService.saveGroqApiKey(key);
    notifyListeners();
    await fetchModels();
  }

  Future<void> setLlmModel(String model) async {
    _llmModel = model;
    await _storageService.setLlmModel(model);
    notifyListeners();
  }

  Future<void> setWhisperModel(String model) async {
    _whisperModel = model;
    await _storageService.setWhisperModel(model);
    notifyListeners();
  }

  Future<void> setAutoPaste(bool value) async {
    _autoPaste = value;
    await _storageService.setAutoPaste(value);
    notifyListeners();
  }

  Future<void> setAppLanguage(String code) async {
    _appLanguage = code;
    await _storageService.setAppLanguage(code);
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    _themeMode = mode;
    await _storageService.setThemeMode(mode);
    notifyListeners();
  }

  Future<void> setGlobalShortcut(String shortcut) async {
    _globalShortcut = shortcut;
    await _storageService.setGlobalShortcut(shortcut);
    notifyListeners();
  }
}
