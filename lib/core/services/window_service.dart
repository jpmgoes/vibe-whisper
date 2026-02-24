import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';

class WindowService {
  static Future<void> openSubWindow(String route) async {
    final windowId = await _createOrFocus(route);
    if (windowId != null) {
      final controller = WindowController.fromWindowId(windowId);
      await controller.show();
    }
  }

  static Future<String?> _createOrFocus(String route) async {
    final windows = await WindowController.getAll();
    for (var window in windows) {
      if (window.windowId != '0') {
         if (window.arguments.isNotEmpty) {
           try {
              final args = jsonDecode(window.arguments);
              if (args['route'] == route) {
                return window.windowId;
              }
           } catch (_) {}
         }
         // If it's another window, close it to enforce a single sub-window
         try {
           const channel = MethodChannel('mixin.one/desktop_multi_window');
           await channel.invokeMethod('window_close', {'windowId': window.windowId});
         } catch (_) {}
      }
    }

    // Create a new window
    final controller = await WindowController.create(
      WindowConfiguration(
        arguments: jsonEncode({'route': route}),
        hiddenAtLaunch: true,
      ),
    );
    
    // Position/sizing needs to be handled either here by method channels or in the sub window startup.
    // We will handle it in the sub window startup using window_manager.
    await controller.show();

    return controller.windowId;
  }
}

