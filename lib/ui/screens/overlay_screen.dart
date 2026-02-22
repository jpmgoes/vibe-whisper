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
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state == RecordingState.recording) ...[
                      // Waveform
                      _buildWaveBars(),
                    ] else if (state == RecordingState.processing) ...[
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      ),
                      const SizedBox(width: 8),
                      const Text('Processing', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
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

  Widget _buildWaveBars() {
    final heights = [6.0, 10.0, 16.0, 12.0, 20.0, 16.0, 10.0, 6.0];
    final delays = [400, 200, 600, 100, 500, 300, 700, 200];
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(8, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
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
}
