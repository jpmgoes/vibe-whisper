import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/services/storage_service.dart';
import 'package:uuid/uuid.dart';
import '../../l10n/app_localizations.dart';

class SnippetsScreen extends StatefulWidget {
  const SnippetsScreen({super.key});

  @override
  State<SnippetsScreen> createState() => _SnippetsScreenState();
}

class _SnippetsScreenState extends State<SnippetsScreen> {

  void _showSnippetDialog({SnippetItem? snippet}) {
    final isEditing = snippet != null;
    final keyController = TextEditingController(text: snippet?.key ?? '');
    final valueController = TextEditingController(text: snippet?.value ?? '');

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final l10n = AppLocalizations.of(context)!;
        final isDark = theme.brightness == Brightness.dark;
        final borderColor = isDark ? const Color(0xFF3f3f46) : const Color(0xFFe5e7eb);
        final cardBgColor = isDark ? const Color(0xFF18181b).withValues(alpha: 0.5) : const Color(0xFFf9fafb);

        return AlertDialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: borderColor),
          ),
          title: Text(
            isEditing ? l10n.editSnippet : l10n.newSnippet,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          content: Container(
            width: 500, // Make modal larger
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.snippetCommandLabel, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: keyController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: cardBgColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(l10n.snippetValueLabel, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: valueController,
                  maxLines: 8, // Make text area larger
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: cardBgColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                final key = keyController.text.trim().toLowerCase();
                final value = valueController.text.trim();
                
                if (key.isEmpty || value.isEmpty) return;

                final settings = context.read<SettingsProvider>();
                if (isEditing) {
                  settings.updateSnippet(SnippetItem(
                    id: snippet.id,
                    key: key,
                    value: value,
                  ));
                } else {
                  settings.addSnippet(SnippetItem(
                    id: const Uuid().v4(),
                    key: key,
                    value: value,
                  ));
                }
                Navigator.pop(context);
              },
              child: Text(l10n.save, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF27272a) : const Color(0xFFe5e7eb);

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
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 48), // Balance the add button width
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.code, color: theme.colorScheme.primary, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          l10n.snippets,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: l10n.addSnippet,
                    onPressed: () => _showSnippetDialog(),
                  )
                ],
              ),
            ),
          ),
          
          Expanded(
            child: settings.snippets.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notes, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(l10n.noSnippetsYet, style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: settings.snippets.length,
                    itemBuilder: (context, index) {
                      final snippet = settings.snippets[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF18181b) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          title: Text(
                            snippet.key,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              snippet.value,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                                fontFamily: 'monospace'
                              ),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                color: Colors.grey,
                                onPressed: () => _showSnippetDialog(snippet: snippet),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20),
                                color: Colors.red.shade400,
                                onPressed: () {
                                  settings.removeSnippet(snippet.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
