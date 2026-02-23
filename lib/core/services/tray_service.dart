import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';

class SystemTrayService with TrayListener {
  final GoRouter router;

  SystemTrayService(this.router);

  Future<void> init() async {
    if (Platform.isMacOS) {
      await trayManager.setIcon('assets/images/tray_icon.png', isTemplate: true);
      await trayManager.setTitle('');
    } else {
      // For Windows/Linux, you normally need an icon file, but we'll try a fallback text or ignore
    }
    
    Menu menu = Menu(
      items: [
        MenuItem(
          key: 'history',
          label: 'History',
        ),
        MenuItem(
          key: 'settings',
          label: 'Settings',
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'exit',
          label: 'Exit',
        ),
      ],
    );
    await trayManager.setContextMenu(menu);
    trayManager.addListener(this);
  }

  @override
  void onTrayIconMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    if (menuItem.key == 'history') {
      await _openWindow('/history');
    } else if (menuItem.key == 'settings') {
      await _openWindow('/settings');
    } else if (menuItem.key == 'exit') {
      await windowManager.destroy(); // properly kill the app
    }
  }

  Future<void> _openWindow(String route) async {
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden, windowButtonVisibility: true);
    await windowManager.setHasShadow(true);
    await windowManager.setIgnoreMouseEvents(false);
    await windowManager.setSize(const Size(800, 700));
    await windowManager.center();
    await windowManager.setAlwaysOnTop(false);
    await windowManager.show();
    await windowManager.focus();
    router.go(route);
  }

  void dispose() {
    trayManager.removeListener(this);
  }
}
