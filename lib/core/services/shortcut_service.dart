import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class ShortcutService {
  VoidCallback? _onShortcutPressed;

  Future<void> init(VoidCallback onShortcutPressed, {String? savedShortcutJson}) async {
    _onShortcutPressed = onShortcutPressed;
    await hotKeyManager.unregisterAll();
    
    HotKey hotKey;
    if (savedShortcutJson != null && savedShortcutJson.isNotEmpty && savedShortcutJson != 'Meta+Shift+Space') {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(savedShortcutJson);
        hotKey = HotKey.fromJson(jsonMap);
      } catch (e) {
        debugPrint('[ShortcutService] Failed to parse saved shortcut ($savedShortcutJson): $e');
        hotKey = _getDefaultHotKey();
      }
    } else {
      hotKey = _getDefaultHotKey();
    }
    
    await _registerHotKey(hotKey);
  }

  Future<void> updateShortcut(String shortcutJson) async {
    if (_onShortcutPressed == null) return;
    await hotKeyManager.unregisterAll();

    HotKey hotKey;
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(shortcutJson);
      hotKey = HotKey.fromJson(jsonMap);
    } catch (e) {
      debugPrint('[ShortcutService] Failed to parse new shortcut ($shortcutJson): $e');
      hotKey = _getDefaultHotKey();
    }

    await _registerHotKey(hotKey);
  }

  Future<void> _registerHotKey(HotKey hotKey) async {
    try {
      await hotKeyManager.register(
        hotKey,
        keyDownHandler: (hotKey) {
          _onShortcutPressed?.call();
        },
      );
      debugPrint('[ShortcutService] Registered global shortcut: ${hotKey.toString()}');
    } catch (e) {
      debugPrint('[ShortcutService] Error registering global shortcut: $e');
    }
  }

  HotKey _getDefaultHotKey() {
    return HotKey(
      key: PhysicalKeyboardKey.space,
      modifiers: [HotKeyModifier.meta, HotKeyModifier.shift], // meta is Cmd on Mac, Windows on Win
      scope: HotKeyScope.system,
    );
  }
}
