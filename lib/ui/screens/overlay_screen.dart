import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/providers/recording_provider.dart';
import '../../l10n/app_localizations.dart';

class OverlayScreen extends StatelessWidget {
  const OverlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recordingProvider = context.watch<RecordingProvider>();
    final state = recordingProvider.state;
    final l10n = AppLocalizations.of(context)!;

    // Based on Stitch overlay: #111827 background with 30% opacity/blur
    // But since it's a Frameless window, we return a completely transparent scaffold
    // and draw our components.
    
    if (state == RecordingState.idle || state == RecordingState.success || state == RecordingState.error) {
      if (state == RecordingState.error) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.red.shade900.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.red.withValues(alpha: 0.3), blurRadius: 20)],
              ),
              child: Text(l10n.errorTryAgain, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ).animate().fadeIn().scale().then(delay: 2.seconds).fadeOut(),
          ),
        );
      }
      return const Scaffold(backgroundColor: Colors.transparent);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                width: 140,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF101922),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state == RecordingState.recording) ...[
                      // Waveform
                      _buildWaveBars(recordingProvider.currentVolume),
                    ] else if (state == RecordingState.processing) ...[
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      ),
                      const SizedBox(width: 8),
                      Text(l10n.processing, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                    ]
                  ],
                ),
              ).animate().scale(curve: Curves.easeOutBack, duration: 400.ms),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWaveBars(double volume) {
    // Base heights for the waveform visual envelope
    final heights = [6.0, 10.0, 16.0, 12.0, 20.0, 16.0, 10.0, 6.0];
    
    // Scale factor: minimum 0.2 height when silent, scales up with volume. 
    // Multiplied by 2.0 to make the volume changes more visible, capped at 2.5
    final scale = 0.2 + (volume * 4.0).clamp(0.0, 2.5);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(8, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 75),
          curve: Curves.easeOutCirc,
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          width: 3,
          height: heights[index] * scale,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
