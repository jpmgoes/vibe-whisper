import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;

class AudioService {
  final AudioRecorder _record = AudioRecorder();
  String? _currentPath;

  Future<void> startRecording() async {
    if (await _record.hasPermission()) {
      final dir = await getTemporaryDirectory();
      _currentPath = p.join(dir.path, 'whisper_audio.m4a');
      
      // Delete old file if exists
      final file = File(_currentPath!);
      if (await file.exists()) {
        await file.delete();
      }

      await _record.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _currentPath!,
      );
    } else {
      throw Exception('Microphone permission not granted.');
    }
  }

  Future<String?> stopRecording() async {
    final path = await _record.stop();
    return path ?? _currentPath;
  }
  
  void dispose() {
    _record.dispose();
  }
}
