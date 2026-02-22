import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/providers/recording_provider.dart';

class OverlayScreen extends StatelessWidget {
  const OverlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recordingProvider = context.watch<RecordingProvider>();
    final state = recordingProvider.state;

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
                color: Colors.red.shade900.withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 20)],
              ),
              child: const Text('Error. Try again.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          // Semi-transparent backdrop
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated glow behind the pill
                Container(
                  width: 240,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: state == RecordingState.recording ? 5 : 0,
                      )
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // The Pill
                      Container(
                        width: 240,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.grey.shade800),
                          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, 10))],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (state == RecordingState.recording) ...[
                              // Waveform
                              _buildWaveBars(),
                            ] else if (state == RecordingState.processing) ...[
                              const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              ),
                              const SizedBox(width: 16),
                              const Text('Processing...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                            ]
                          ],
                        ),
                      ).animate().scale(curve: Curves.easeOutBack, duration: 400.ms),

                      // Stop button (visible only when recording)
                      if (state == RecordingState.recording)
                        Positioned(
                          right: 12,
                          child: IconButton(
                            icon: const Icon(Icons.stop, color: Colors.grey),
                            hoverColor: Colors.grey.shade800,
                            splashRadius: 20,
                            onPressed: () {
                              recordingProvider.toggleRecording();
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Shortcut hints (similar to Stitch HTML)
                if (state == RecordingState.recording)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHintKey('ESC', 'to cancel'),
                      const SizedBox(width: 16),
                      _buildHintKey('Shortcut', 'to finish'), // Using shortcut instead of return as that's the current behavior
                    ],
                  ).animate().fadeIn(delay: 500.ms),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWaveBars() {
    final heights = [8.0, 12.0, 20.0, 16.0, 24.0, 32.0, 28.0, 20.0, 16.0, 12.0, 8.0, 4.0];
    final delays = [400, 200, 600, 800, 100, 500, 300, 700, 200, 600, 400, 100];
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(12, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          width: 3,
          height: heights[index],
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ).animate(onPlay: (controller) => controller.repeat(reverse: true))
         .scaleY(
           begin: 0.3, 
           end: 1.0, 
           duration: 600.ms, 
           delay: delays[index].ms,
           curve: Curves.easeInOut,
         );
      }),
    );
  }

  Widget _buildHintKey(String key, String action) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Text(key, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 6),
        Text(action, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
      ],
    );
  }
}
