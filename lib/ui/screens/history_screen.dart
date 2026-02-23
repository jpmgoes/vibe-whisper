import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/services/storage_service.dart';
import '../../l10n/app_localizations.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  void _showCopiedNotification(BuildContext context, String title, String body) {
    Flushbar(
      title: title,
      message: body,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green.shade800,
      icon: const Icon(Icons.check, color: Colors.white),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.BOTTOM,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF3f3f46) : const Color(0xFFe5e7eb);
    final cardBgColor = isDark ? const Color(0xFF18181b).withValues(alpha: 0.5) : const Color(0xFFf9fafb);
    final l10n = AppLocalizations.of(context)!;

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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 80), // Balance the clear button width
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, color: theme.colorScheme.primary, size: 22),
                        const SizedBox(width: 12),
                        Text(
                          l10n.transcriptionHistory,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey.shade200 : Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Consumer<SettingsProvider>(
                    builder: (context, settings, _) {
                      if (settings.history.isEmpty) return const SizedBox(width: 80);
                      return TextButton.icon(
                        icon: const Icon(Icons.delete_sweep, size: 18, color: Colors.redAccent),
                        label: Text(l10n.clearAll, style: const TextStyle(color: Colors.redAccent)),
                        onPressed: () => _confirmClearHistory(context, settings, l10n),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // History List
          Expanded(
            child: Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                final history = settings.history;

                if (history.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history_toggle_off, size: 48, color: Colors.grey.shade600),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noHistoryContent,
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  itemCount: history.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return _HistoryItemCard(
                      item: item,
                      cardBgColor: cardBgColor,
                      borderColor: borderColor,
                      isDark: isDark,
                      onDelete: () => settings.removeHistoryRecord(item.id),
                      onCopyOriginal: () {
                        Clipboard.setData(ClipboardData(text: item.originalText));
                        _showCopiedNotification(context, l10n.copiedOriginal, l10n.copiedWhisper);
                      },
                      onCopyFinal: () {
                        Clipboard.setData(ClipboardData(text: item.finalText));
                        _showCopiedNotification(context, l10n.copiedProcessed, l10n.copiedProcessedMsg);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmClearHistory(BuildContext context, SettingsProvider settings, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.clearHistoryTitle),
        content: Text(l10n.clearHistoryMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () {
              settings.clearHistory();
              Navigator.pop(ctx);
            },
            child: Text(l10n.clearAll),
          ),
        ],
      ),
    );
  }
}

class _HistoryItemCard extends StatelessWidget {
  final HistoryItem item;
  final Color cardBgColor;
  final Color borderColor;
  final bool isDark;
  final VoidCallback onDelete;
  final VoidCallback onCopyOriginal;
  final VoidCallback onCopyFinal;

  const _HistoryItemCard({
    required this.item,
    required this.cardBgColor,
    required this.borderColor,
    required this.isDark,
    required this.onDelete,
    required this.onCopyOriginal,
    required this.onCopyFinal,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, y • h:mm a');
    final textColor = isDark ? Colors.grey.shade300 : Colors.grey.shade800;
    final hintColor = isDark ? Colors.grey.shade500 : Colors.grey.shade600;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor, width: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: hintColor),
                    const SizedBox(width: 8),
                    Text(
                      dateFormat.format(item.timestamp),
                      style: TextStyle(fontSize: 12, color: hintColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(16),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.close, size: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Final Processed Text
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.processedOutput, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)),
                          const SizedBox(height: 6),
                          SelectableText(
                            item.finalText,
                            style: TextStyle(fontSize: 14, color: textColor, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      color: hintColor,
                      tooltip: l10n.copiedProcessed,
                      onPressed: onCopyFinal,
                    )
                  ],
                ),

                if (item.originalText != item.finalText) ...[
                  const SizedBox(height: 16),
                  Divider(color: borderColor, height: 1),
                  const SizedBox(height: 16),
                  
                  // Original Whisper Text
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(l10n.originalAudio, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: hintColor)),
                             const SizedBox(height: 6),
                             SelectableText(
                               item.originalText,
                               style: TextStyle(fontSize: 13, color: hintColor, height: 1.4, fontStyle: FontStyle.italic),
                             ),
                           ],
                         ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        color: hintColor,
                        tooltip: l10n.copiedOriginal,
                        onPressed: onCopyOriginal,
                      )
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
