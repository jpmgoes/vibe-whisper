import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;

class AudioService {
  final AudioRecorder _record = AudioRecorder();
  String? _currentPath;

  Future<void> startRecording() async {
    debugPrint('[AudioService] Requesting microphone permission...');
    if (await _record.hasPermission()) {
      debugPrint('[AudioService] Permission granted.');
      final dir = await getTemporaryDirectory();

      if (!await dir.exists()) {
        debugPrint('[AudioService] Creating missing directory at ${dir.path}');
        await dir.create(recursive: true);
      }

      _currentPath = p.join(dir.path, 'whisper_audio.m4a');
      debugPrint('[AudioService] Scheduled save path: $_currentPath');

      // Delete old file if exists
      final file = File(_currentPath!);
      if (await file.exists()) {
        debugPrint('[AudioService] Deleting old audio file at $_currentPath');
        await file.delete();
      }

      debugPrint('[AudioService] Starting recorder...');
      await _record.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
          numChannels: 1,
        ),
        path: _currentPath!,
      );
      debugPrint('[AudioService] Recorder started successfully.');
    } else {
      debugPrint('[AudioService] Microphone permission not granted.');
      throw Exception('Microphone permission not granted.');
    }
  }

  Future<String?> stopRecording() async {
    debugPrint('[AudioService] Stopping recorder...');
    final path = await _record.stop();
    debugPrint('[AudioService] Recorder stopped. Returned path: $path');

    final finalPath = path ?? _currentPath;
    if (finalPath != null) {
      final file = File(finalPath);
      final exists = await file.exists();
      debugPrint('[AudioService] Verifying file exists at $finalPath: $exists');
      if (exists) {
        final length = await file.length();
        debugPrint('[AudioService] File size: $length bytes');
        if (length == 0) {
          debugPrint('[AudioService] WARNING: Audio file is 0 bytes!');
        }
      }
    }

    return finalPath;
  }

  void dispose() {
    debugPrint('[AudioService] Disposing recorder');
    _record.dispose();
  }
}
