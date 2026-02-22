import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late final FlutterSecureStorage _secureStorage;
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _secureStorage = const FlutterSecureStorage(
      wOptions: WindowsOptions(
        useBackwardCompatibility: false,
      ),
      mOptions: MacOsOptions(
        accountName: AppleOptions.defaultAccountName,
        synchronizable: false,
      ),
    );
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Secure Storage (API Keys) ---
  Future<void> saveGroqApiKey(String key) async {
    await _secureStorage.write(key: 'groq_api_key', value: key);
  }

  Future<String?> getGroqApiKey() async {
    return await _secureStorage.read(key: 'groq_api_key');
  }

  // --- Shared Preferences (Settings) ---
  String get llmModel => _prefs.getString('llm_model') ?? 'moonshotai/kimi-k2-instruct-0905';
  Future<void> setLlmModel(String model) async => await _prefs.setString('llm_model', model);

  String get whisperModel => _prefs.getString('whisper_model') ?? 'whisper-large-v3-turbo';
  Future<void> setWhisperModel(String model) async => await _prefs.setString('whisper_model', model);

  bool get autoPaste => _prefs.getBool('auto_paste') ?? false;
  Future<void> setAutoPaste(bool value) async => await _prefs.setBool('auto_paste', value);

  String get appLanguage => _prefs.getString('app_language') ?? 'en';
  Future<void> setAppLanguage(String code) async => await _prefs.setString('app_language', code);

  String get themeMode => _prefs.getString('theme_mode') ?? 'system';
  Future<void> setThemeMode(String mode) async => await _prefs.setString('theme_mode', mode);

  String get globalShortcut => _prefs.getString('global_shortcut') ?? 'Meta+Shift+Space';
  Future<void> setGlobalShortcut(String shortcut) async => await _prefs.setString('global_shortcut', shortcut);
}
