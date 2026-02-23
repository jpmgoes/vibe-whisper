import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:keypress_sim/keypress_sim.dart' as kps;

class ClipboardService {
  String? _previousAppPID;

  Future<void> saveCurrentFocusedApp() async {
    if (Platform.isMacOS) {
      try {
        // Agora, em vez de pegar o nome, pegamos o ID numérico do processo (PID)
        final result = await Process.run('osascript', [
          '-e',
          'tell application "System Events" to get unix id of first application process whose frontmost is true'
        ]);
        
        if (result.exitCode == 0 && result.stdout != null) {
          _previousAppPID = result.stdout.toString().trim();
          debugPrint('[ClipboardService] Saved previous app PID: "$_previousAppPID"');
        } else {
          debugPrint('[ClipboardService] Failed to save previous app PID. Exit code: ${result.exitCode}, Error: ${result.stderr}');
        }
      } catch (e) {
        debugPrint('[ClipboardService] Error saving previous app PID: $e');
      }
    }
  }

  Future<void> restorePreviousApp() async {
    if (Platform.isMacOS && _previousAppPID != null && _previousAppPID!.isNotEmpty) {
      try {
        debugPrint('[ClipboardService] Activating previous app via PID: "$_previousAppPID"');
        
        // Usamos um shell script nativo para forçar a janela com aquele PID a vir para a frente
        final result = await Process.run('sh', [
          '-c',
          '''
          osascript -e '
            tell application "System Events"
              set frontmost of (first process whose unix id is $_previousAppPID) to true
            end tell
          '
          '''
        ]);
        
        if (result.exitCode != 0) {
           debugPrint('[ClipboardService] Failed to activate app via PID. Exit code: ${result.exitCode}, Error: ${result.stderr}');
        } else {
           debugPrint('[ClipboardService] Successfully activated app via PID.');
        }
        
        // Atraso para dar tempo da janela ser desenhada na frente e receber o input
        await Future.delayed(const Duration(milliseconds: 400));
        
      } catch (e) {
        debugPrint('[ClipboardService] Error restoring previous app via PID: $e');
      }
    }
  }

  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> simulatePaste() async {
    debugPrint('[ClipboardService] Simulating paste keystroke...');
    final emulator = kps.KeyEmulator();
    try {
      if (Platform.isMacOS) {
        debugPrint('[ClipboardService] Sending Cmd+V...');
        await emulator.sendShortcut(kps.Key.keyV, [kps.Key.commandLeft]);
      } else if (Platform.isWindows || Platform.isLinux) {
        debugPrint('[ClipboardService] Sending Ctrl+V...');
        await emulator.sendShortcut(kps.Key.keyV, [kps.Key.controlLeft]);
      }
      debugPrint('[ClipboardService] Paste keystroke sent successfully.');
    } catch (e) {
      debugPrint('[ClipboardService] Error simulating paste: $e');
    }
  }
}