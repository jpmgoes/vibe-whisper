import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class ShortcutService {
  Future<void> init(VoidCallback onShortcutPressed) async {
    await hotKeyManager.unregisterAll();
    
    // Default shortcut (e.g., cmd+shift+space or ctrl+shift+space)
    HotKey hotKey = HotKey(
      key: PhysicalKeyboardKey.space,
      modifiers: [HotKeyModifier.meta, HotKeyModifier.shift], // meta is Cmd on Mac, Windows on Win
      scope: HotKeyScope.system,
    );
    
    await hotKeyManager.register(
      hotKey,
      keyDownHandler: (hotKey) {
        onShortcutPressed();
      },
    );
  }

  Future<void> updateShortcut(String shortcutString) async {
    // Logic to parse string like "Meta+Shift+Space" and register new hotkey
    // Keeping simple for MVP
  }
}
