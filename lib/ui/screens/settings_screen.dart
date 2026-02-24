import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/constants/app_languages.dart';
import '../../l10n/app_localizations.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import '../../core/services/shortcut_service.dart';
import '../widgets/custom_title_bar.dart';
import 'dart:math' as math;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  bool _obscureKey = true;
  Timer? _debounce;
  bool _isRecordingShortcut = false;
  HotKey? _tempHotKey;

  void _showSavedNotification() {
    final l10n = AppLocalizations.of(context)!;
    Flushbar(
      message: l10n.settingsSaved,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green.shade800,
    ).show(context);
  }

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>();
    _apiKeyController.text = settings.groqApiKey ?? '';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = isDark ? const Color(0xFF3f3f46) : const Color(0xFFe5e7eb);
    final cardBgColor = isDark ? const Color(0xFF18181b).withValues(alpha: 0.5) : const Color(0xFFf9fafb);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Window Title Bar
          CustomTitleBar(
            title: l10n.settings,
            icon: Icons.settings,
          ),

          // Main Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              children: [
                // "Ready to Listen" Indicator
                Center(
                  child: Column(
                    children: [
                      AnimatedSoundWave(isDark: isDark),
                      const SizedBox(height: 12),
                      Text(
                        'READY TO LISTEN',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // API Configuration
                Row(
                  children: [
                    Icon(Icons.api, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.apiSettings.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.groqApiKey, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _apiKeyController,
                      obscureText: _obscureKey,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'gsk_...',
                        filled: true,
                        fillColor: cardBgColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureKey ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 18),
                          onPressed: () => setState(() => _obscureKey = !_obscureKey),
                        ),
                      ),
                      onChanged: (val) {
                        settings.setGroqApiKey(val);
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce = Timer(const Duration(milliseconds: 1000), () {
                          if (mounted) _showSavedNotification();
                        });
                      },
                    ),
                    const SizedBox(height: 6),
                    Text(l10n.keyStoredLocally, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                    
                    const SizedBox(height: 16),
                    Text(l10n.llmModel, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: settings.availableLlmModels.contains(settings.llmModel) ? settings.llmModel : (settings.availableLlmModels.isNotEmpty ? settings.availableLlmModels.first : null),
                      items: settings.availableLlmModels.map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 13)))).toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: cardBgColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                      ),
                      onChanged: (val) {
                        if (val != null) {
                          settings.setLlmModel(val);
                          _showSavedNotification();
                        }
                      },
                      icon: const Icon(Icons.expand_more, color: Colors.grey),
                    ),

                    const SizedBox(height: 16),
                    Text(l10n.intentModel, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: settings.availableLlmModels.contains(settings.intentModel) ? settings.intentModel : (settings.availableLlmModels.isNotEmpty ? settings.availableLlmModels.first : null),
                      items: settings.availableLlmModels.map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 13)))).toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: cardBgColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                      ),
                      onChanged: (val) {
                        if (val != null) {
                          settings.setIntentModel(val);
                          _showSavedNotification();
                        }
                      },
                      icon: const Icon(Icons.expand_more, color: Colors.grey),
                    ),

                    const SizedBox(height: 16),
                    Text(l10n.whisperModel, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: settings.availableWhisperModels.contains(settings.whisperModel) ? settings.whisperModel : (settings.availableWhisperModels.isNotEmpty ? settings.availableWhisperModels.first : null),
                      items: settings.availableWhisperModels.map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 13)))).toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: cardBgColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                      ),
                      onChanged: (val) {
                        if (val != null) {
                          settings.setWhisperModel(val);
                          _showSavedNotification();
                        }
                      },
                      icon: const Icon(Icons.expand_more, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                Divider(color: borderColor),
                const SizedBox(height: 24),

                // Global Shortcuts & General Settings
                Row(
                  children: [
                    Icon(Icons.keyboard, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'GLOBAL SHORTCUTS & GENERAL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.toggleRecording, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? Colors.grey.shade300 : Colors.grey.shade600)),
                            const SizedBox(height: 12),
                            Consumer<SettingsProvider>(
                              builder: (context, settings, child) {
                                if (_isRecordingShortcut) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Press a shortcut combination...',
                                        style: TextStyle(fontSize: 11, color: theme.colorScheme.primary, fontStyle: FontStyle.italic),
                                      ),
                                      const SizedBox(height: 8),
                                      HotKeyRecorder(
                                        initalHotKey: _tempHotKey ?? _parseHotKey(settings.globalShortcut),
                                        onHotKeyRecorded: (HotKey hotKey) {
                                          setState(() {
                                            _tempHotKey = hotKey;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _isRecordingShortcut = false;
                                                _tempHotKey = null;
                                              });
                                            },
                                            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (_tempHotKey != null) {
                                                final jsonStr = jsonEncode(_tempHotKey!.toJson());
                                                final shortcutService = context.read<ShortcutService>();
                                                await settings.setGlobalShortcut(jsonStr);
                                                await shortcutService.updateShortcut(jsonStr);
                                                setState(() {
                                                  _isRecordingShortcut = false;
                                                  _tempHotKey = null;
                                                });
                                                if (mounted) {
                                                  _showSavedNotification();
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: theme.colorScheme.primary,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            ),
                                            child: const Text('Save', style: TextStyle(fontSize: 13)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }

                                final hotKey = _parseHotKey(settings.globalShortcut);
                                return _ShortcutDisplay(
                                  hotKey: hotKey!,
                                  isDark: isDark,
                                  onEdit: () {
                                    setState(() {
                                      _isRecordingShortcut = true;
                                    });
                                  },
                                );
                              }
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.autoPaste, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? Colors.grey.shade300 : Colors.grey.shade600)),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(l10n.fillActiveField, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                                Switch(
                                  value: settings.autoPaste,
                                  onChanged: (val) {
                                    settings.setAutoPaste(val);
                                    _showSavedNotification();
                                  },
                                  activeThumbColor: theme.colorScheme.primary,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Language Selection
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.primaryLanguage, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? Colors.grey.shade300 : Colors.grey.shade600)),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.language, size: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                filled: true,
                                fillColor: isDark ? const Color(0xFF111a22) : Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              initialValue: settings.appLanguage,
                              items: appLanguages.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value, style: const TextStyle(fontSize: 13)))).toList(),
                              onChanged: (v) {
                                if (v != null) {
                                    settings.setAppLanguage(v);
                                    _showSavedNotification();
                                }
                              },
                              icon: const Icon(Icons.expand_more, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Erase All Data Section
                const SizedBox(height: 32),
                Divider(color: borderColor),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'DANGER ZONE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                      foregroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.redAccent),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => _confirmEraseAllData(context, settings, l10n),
                    child: Text(
                      l10n.eraseAllData,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmEraseAllData(BuildContext context, SettingsProvider settings, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.redAccent),
            const SizedBox(width: 8),
            Text(l10n.eraseAllData),
          ],
        ),
        content: Text(l10n.eraseAllDataConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await settings.clearAllSettings();
              // When groqApiKey becomes null, settings screen natively acts as the onboard screen,
              // so it will just reload to the onboard state.
            },
            child: Text(l10n.eraseAllData),
          ),
        ],
      ),
    );
  }

  HotKey? _parseHotKey(String hotKeyJsonStr) {
    if (hotKeyJsonStr.isEmpty || hotKeyJsonStr == 'Meta+Shift+Space') {
      return HotKey(
        key: PhysicalKeyboardKey.space,
        modifiers: [HotKeyModifier.meta, HotKeyModifier.shift],
        scope: HotKeyScope.system,
      );
    }
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(hotKeyJsonStr);
      return HotKey.fromJson(jsonMap);
    } catch (e) {
      debugPrint('[SettingsScreen] Failed to parse HotKey JSON ($hotKeyJsonStr): $e');
      return HotKey(
        key: PhysicalKeyboardKey.space,
        modifiers: [HotKeyModifier.meta, HotKeyModifier.shift],
        scope: HotKeyScope.system,
      );
    }
  }
}

class _ShortcutDisplay extends StatelessWidget {
  final HotKey hotKey;
  final bool isDark;
  final VoidCallback onEdit;

  const _ShortcutDisplay({required this.hotKey, required this.isDark, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (hotKey.modifiers != null)
              ...hotKey.modifiers!.map((mod) {
                String label = '';
                switch (mod) {
                  case HotKeyModifier.meta:
                    label = 'Cmd/Win';
                    break;
                  case HotKeyModifier.shift:
                    label = 'Shift';
                    break;
                  case HotKeyModifier.alt:
                    label = 'Alt';
                    break;
                  case HotKeyModifier.control:
                    label = 'Ctrl';
                    break;
                  default:
                    label = mod.name.toUpperCase();
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: _KeyboardKey(label: label, isDark: isDark),
                );
              }),
            _KeyboardKey(label: hotKey.key.keyLabel.toUpperCase(), isDark: isDark),
          ],
        ),
        InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(4),
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(Icons.edit, size: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

class _KeyboardKey extends StatelessWidget {
  final String label;
  final bool isDark;

  const _KeyboardKey({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF27272a) : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: isDark ? const Color(0xFF3f3f46) : Colors.grey.shade300),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
      ),
    );
  }
}

class AnimatedSoundWave extends StatefulWidget {
  final bool isDark;
  const AnimatedSoundWave({super.key, required this.isDark});

  @override
  State<AnimatedSoundWave> createState() => _AnimatedSoundWaveState();
}

class _AnimatedSoundWaveState extends State<AnimatedSoundWave> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: widget.isDark ? Colors.black : Colors.grey.shade900,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: widget.isDark ? const Color(0xFF27272a) : Colors.grey.shade200),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SizedBox(
            height: 24,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(8, (index) {
              // Creating a natural wave using combined sine functions
              final t = _controller.value * 2 * math.pi;
              final phase = index * (math.pi / 4);
              final wave1 = math.sin(t + phase);
              final wave2 = math.sin(2 * t - phase);
              
              final combined = wave1 + wave2 * 0.5; // range: ~[-1.5, 1.5]
              final height = 14.0 + (combined * 6.0); // range: ~[5, 23]

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 4,
                height: height.clamp(4.0, 24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        );
        },
      ),
    );
  }
}
