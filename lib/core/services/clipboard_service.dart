import 'dart:io';
import 'package:flutter/services.dart';

class ClipboardService {
  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> simulatePaste() async {
    if (Platform.isMacOS) {
      await Process.run('osascript', [
        '-e',
        'tell application "System Events" to keystroke "v" using command down'
      ]);
    } else if (Platform.isWindows) {
      // Basic fallback for Windows using PowerShell
      await Process.run('powershell', ['-c', r'(New-Object -ComObject wscript.shell).SendKeys("^v")']);
    } else if (Platform.isLinux) {
      await Process.run('xdotool', ['key', 'ctrl+v']);
    }
  }
}
