import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../l10n/app_localizations.dart';
import 'package:window_manager/window_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  bool _obscureKey = true;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>();
    _apiKeyController.text = settings.groqApiKey ?? '';
  }

  @override
  void dispose() {
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
          // Drag To Move Window Title Bar
          GestureDetector(
            onPanStart: (details) {
              windowManager.startDragging();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
            ),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black : Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: isDark ? const Color(0xFF27272a) : Colors.grey.shade200),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(8, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              width: 4,
                              height: index % 2 == 0 ? 12 : 18,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          }),
                        ),
                      ),
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
                      onChanged: (val) => settings.setGroqApiKey(val),
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
                        if (val != null) settings.setLlmModel(val);
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
                        if (val != null) settings.setWhisperModel(val);
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    _KeyboardKey(label: 'Cmd/Win', isDark: isDark),
                                    const SizedBox(width: 6),
                                    _KeyboardKey(label: 'Shift', isDark: isDark),
                                    const SizedBox(width: 6),
                                    _KeyboardKey(label: 'Space', isDark: isDark),
                                  ],
                                ),
                                const Icon(Icons.edit, size: 16, color: Colors.grey),
                              ],
                            )
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
                                  onChanged: (val) => settings.setAutoPaste(val),
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
              ],
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF18181b).withValues(alpha: 0.5) : Colors.grey.shade50,
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.settingsSaved)));
                  },
                  icon: const Icon(Icons.save, size: 18),
                  label: Text(l10n.saveChanges),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 4,
                  ),
                )
              ],
            ),
          )
        ],
      ),
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
