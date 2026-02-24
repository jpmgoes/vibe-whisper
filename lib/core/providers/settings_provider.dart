import 'package:flutter/foundation.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/groq_service.dart';

class SettingsProvider with ChangeNotifier {
  final StorageService _storageService;
  final GroqService _groqService;

  SettingsProvider(this._storageService, this._groqService);

  String? _groqApiKey;
  String _llmModel = 'moonshotai/kimi-k2-instruct-0905';
  String _intentModel = 'llama3-8b-8192';
  String _whisperModel = 'whisper-large-v3-turbo';
  bool _autoPaste = true;
  String _appLanguage = 'en';
  String _themeMode = 'system';
  String _globalShortcut = 'Meta+Shift+Space';

  List<String> _availableLlmModels = [];
  List<String> _availableWhisperModels = [];
  List<HistoryItem> _history = [];
  List<SnippetItem> _snippets = [];

  String? get groqApiKey => _groqApiKey;
  String get llmModel => _llmModel;
  String get intentModel => _intentModel;
  String get whisperModel => _whisperModel;
  bool get autoPaste => _autoPaste;
  String get appLanguage => _appLanguage;
  String get themeMode => _themeMode;
  String get globalShortcut => _globalShortcut;
  List<String> get availableLlmModels => _availableLlmModels;
  List<String> get availableWhisperModels => _availableWhisperModels;
  List<HistoryItem> get history => _history;
  List<SnippetItem> get snippets => _snippets;

  Future<void> init() async {
    await _loadFromStorage();
    try {
      final controller = await WindowController.fromCurrentEngine();
      controller.setWindowMethodHandler((call) async {
        if (call.method == 'reload_settings') {
          await _storageService.reload();
          await _loadFromStorage();
        }
        return true;
      });
    } catch (_) {}
  }

  Future<void> _loadFromStorage() async {
    _groqApiKey = await _storageService.getGroqApiKey();
    _llmModel = _storageService.llmModel;
    _intentModel = _storageService.intentModel;
    _whisperModel = _storageService.whisperModel;
    _autoPaste = _storageService.autoPaste;
    _appLanguage = _storageService.appLanguage;
    _themeMode = _storageService.themeMode;
    _globalShortcut = _storageService.globalShortcut;
    _history = await _storageService.getHistory();
    _snippets = await _storageService.getSnippets();
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

      if (!_availableLlmModels.contains(_intentModel) && _availableLlmModels.isNotEmpty) {
        final llamaModel = _availableLlmModels.where((m) => m.toLowerCase().contains('llama') && m.toLowerCase().contains('8b')).firstOrNull;
        _intentModel = llamaModel ?? _availableLlmModels.first;
        await _storageService.setIntentModel(_intentModel);
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
    await _notifyOthers();
  }

  Future<void> setLlmModel(String model) async {
    _llmModel = model;
    await _storageService.setLlmModel(model);
    notifyListeners();
    await _notifyOthers();
  }

  Future<void> setIntentModel(String model) async {
    _intentModel = model;
    await _storageService.setIntentModel(model);
    notifyListeners();
    await _notifyOthers();
  }

  Future<void> setWhisperModel(String model) async {
    _whisperModel = model;
    await _storageService.setWhisperModel(model);
    notifyListeners();
    await _notifyOthers();
  }

  Future<void> setAutoPaste(bool value) async {
    _autoPaste = value;
    await _storageService.setAutoPaste(value);
    notifyListeners();
    await _notifyOthers();
  }

  Future<void> setAppLanguage(String code) async {
    _appLanguage = code;
    await _storageService.setAppLanguage(code);
    notifyListeners();
    await _notifyOthers();
  }

  Future<void> setThemeMode(String mode) async {
    _themeMode = mode;
    await _storageService.setThemeMode(mode);
    notifyListeners();
    await _notifyOthers();
  }

  Future<void> setGlobalShortcut(String shortcut) async {
    _globalShortcut = shortcut;
    await _storageService.setGlobalShortcut(shortcut);
    notifyListeners();
    await _notifyOthers();
  }

  Future<void> addHistoryRecord(HistoryItem item) async {
    _history.insert(0, item);
    await _storageService.saveHistory(_history);
    notifyListeners();
    await _notifyOthers();
  }

  Future<void> removeHistoryRecord(String id) async {
    _history.removeWhere((item) => item.id == id);
    await _storageService.saveHistory(_history);
    notifyListeners();
    await _notifyOthers();
  }

  Future<void> clearHistory() async {
    _history.clear();
    await _storageService.saveHistory(_history);
    notifyListeners();
    await _notifyOthers();
  }

  // --- Snippets ---
  Future<void> addSnippet(SnippetItem item) async {
    _snippets.add(item);
    await _storageService.saveSnippets(_snippets);
    notifyListeners();
    await _notifyOthers();
  }

  Future<void> updateSnippet(SnippetItem updatedItem) async {
    final index = _snippets.indexWhere((s) => s.id == updatedItem.id);
    if (index != -1) {
      _snippets[index] = updatedItem;
      await _storageService.saveSnippets(_snippets);
      notifyListeners();
      await _notifyOthers();
    }
  }

  Future<void> removeSnippet(String id) async {
    _snippets.removeWhere((item) => item.id == id);
    await _storageService.saveSnippets(_snippets);
    notifyListeners();
    await _notifyOthers();
  }

  Future<void> _notifyOthers() async {
    try {
      final windows = await WindowController.getAll();
      final current = await WindowController.fromCurrentEngine();
      for (var w in windows) {
        if (w.windowId != current.windowId) {
          await w.invokeMethod('reload_settings');
        }
      }
    } catch (_) {}
  }
}
