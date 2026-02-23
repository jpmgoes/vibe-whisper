import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/settings_provider.dart';
import '../../l10n/app_localizations.dart';
import 'package:another_flushbar/flushbar.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _apiKeyController = TextEditingController();
  bool _isLoading = false;

  void _getStarted() async {
    final key = _apiKeyController.text.trim();
    if (key.isEmpty) return;

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
    });

    final settings = context.read<SettingsProvider>();
    await settings.setGroqApiKey(key);
    
    if (mounted) {
      if (settings.availableLlmModels.isNotEmpty) {
        context.go('/settings');
      } else {
        setState(() {
          _isLoading = false;
        });
        Flushbar(
          message: l10n.invalidApiKey,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red.shade800,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background blurs
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(isDark ? 30 : 15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -50,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(isDark ? 15 : 10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 520),
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                color: theme.colorScheme.surface.withAlpha(isDark ? 150 : 255),
                border: Border.all(
                  color: isDark ? Colors.white.withAlpha(15) : Colors.grey.withAlpha(50),
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 30, offset: Offset(0, 10)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 40, 32, 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [theme.colorScheme.primary, Colors.blue.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withAlpha(50),
                            blurRadius: 15,
                          )
                        ],
                      ),
                      child: const Icon(Icons.graphic_eq, color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.setupWorkspace,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyMedium?.color,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.configureVoice,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? const Color(0xFF92adc9) : Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Theme Switcher Placeholder logic (for complete alignment with mock)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ThemeButton(label: l10n.light, icon: Icons.light_mode, mode: 'light', current: settings.themeMode, onTap: () => settings.setThemeMode('light')),
                        _ThemeButton(label: l10n.dark, icon: Icons.dark_mode, mode: 'dark', current: settings.themeMode, onTap: () => settings.setThemeMode('dark')),
                        _ThemeButton(label: l10n.system, icon: Icons.settings_system_daydream, mode: 'system', current: settings.themeMode, onTap: () => settings.setThemeMode('system')),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Language
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 8),
                          child: Text(l10n.primaryLanguage, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.language),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: isDark ? const Color(0xFF324d67) : Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: isDark ? const Color(0xFF324d67) : Colors.grey.shade300),
                            ),
                            filled: true,
                            fillColor: isDark ? const Color(0xFF111a22) : Colors.grey.shade50,
                          ),
                          initialValue: settings.appLanguage,
                          items: const [
                            DropdownMenuItem(value: 'en', child: Text('🇺🇸 English')),
                            DropdownMenuItem(value: 'pt', child: Text('🇧🇷 Português')),
                            DropdownMenuItem(value: 'es', child: Text('🇪🇸 Español')),
                          ],
                          onChanged: (v) {
                            if (v != null) settings.setAppLanguage(v);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // API Key
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 8),
                          child: Text(l10n.groqApiKey, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                        ),
                        TextFormField(
                          controller: _apiKeyController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.key),
                            hintText: 'gsk_...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: isDark ? const Color(0xFF324d67) : Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: isDark ? const Color(0xFF324d67) : Colors.grey.shade300),
                            ),
                            filled: true,
                            fillColor: isDark ? const Color(0xFF111a22) : Colors.grey.shade50,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Get Started Btn
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                        ),
                        onPressed: _isLoading ? null : _getStarted,
                        child: _isLoading 
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(l10n.getStarted, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward),
                              ],
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
           ),
          ),
        ],
      ),
    );
  }
}

class _ThemeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String mode;
  final String current;
  final VoidCallback onTap;

  const _ThemeButton({
    required this.label,
    required this.icon,
    required this.mode,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = mode == current;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? (isDark ? const Color(0xFF324d67) : Colors.white) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected && !isDark ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? (isDark ? Colors.white : Colors.black87) : Colors.grey),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? (isDark ? Colors.white : Colors.black87) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
