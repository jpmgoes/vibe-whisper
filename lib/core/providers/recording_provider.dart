import 'package:flutter/foundation.dart';
import 'package:local_notifier/local_notifier.dart';
import '../services/audio_service.dart';
import '../services/groq_service.dart';
import '../services/clipboard_service.dart';
import 'settings_provider.dart';

enum RecordingState { idle, recording, processing, success, error }

class RecordingProvider with ChangeNotifier {
  final AudioService _audioService;
  final GroqService _groqService;
  final ClipboardService _clipboardService;
  final SettingsProvider _settings;

  RecordingProvider(this._audioService, this._groqService, this._clipboardService, this._settings);

  RecordingState _state = RecordingState.idle;
  String? _errorMessage;
  String? _lastResult;

  RecordingState get state => _state;
  String? get errorMessage => _errorMessage;
  String? get lastResult => _lastResult;

  Future<void> toggleRecording() async {
    if (_state == RecordingState.idle || _state == RecordingState.success || _state == RecordingState.error) {
      await _startRecording();
    } else if (_state == RecordingState.recording) {
      await _stopAndProcessRecording();
    }
  }

  Future<void> _startRecording() async {
    try {
      if (_settings.groqApiKey == null || _settings.groqApiKey!.isEmpty) {
        throw Exception('Groq API Key is missing. Please configure it in settings.');
      }
      await _audioService.startRecording();
      _state = RecordingState.recording;
      _errorMessage = null;
      _showNotification('Whisper', 'Listening...');
      notifyListeners();
    } catch (e) {
      _handleError('Failed to start recording: ${e.toString()}');
    }
  }

  Future<void> _stopAndProcessRecording() async {
    try {
      _state = RecordingState.processing;
      _showNotification('Whisper', 'Processing audio...');
      notifyListeners();

      final audioPath = await _audioService.stopRecording();
      if (audioPath == null) throw Exception('Audio file path is null');

      // 1. Transcription
      final transcription = await _groqService.transcribeAudio(
        _settings.groqApiKey!, 
        audioPath, 
        _settings.whisperModel
      );

      // 2. Treatment
      final cleanedText = await _groqService.treatText(
        _settings.groqApiKey!, 
        transcription, 
        _settings.llmModel
      );

      // 3. Clipboard & Paste
      await _clipboardService.copyToClipboard(cleanedText);
      if (_settings.autoPaste) {
        await _clipboardService.simulatePaste();
      }

      _lastResult = cleanedText;
      _state = RecordingState.success;
      _showNotification('Success', 'Text copied to clipboard');
      notifyListeners();
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _handleError(String message) {
    _state = RecordingState.error;
    _errorMessage = message;
    _showNotification('Error', message);
    notifyListeners();
  }

  void _showNotification(String title, String body) {
    LocalNotification notification = LocalNotification(
      title: title,
      body: body,
    );
    notification.show();
  }
}
