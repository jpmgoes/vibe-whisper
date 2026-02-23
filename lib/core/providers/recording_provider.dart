import 'package:flutter/foundation.dart';
import 'package:local_notifier/local_notifier.dart';
import 'dart:async';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../services/groq_service.dart';
import '../services/clipboard_service.dart';
import '../services/audio_player_service.dart';
import 'settings_provider.dart';

enum RecordingState { idle, recording, processing, success, error }

class RecordingProvider with ChangeNotifier {
  final AudioService _audioService;
  final GroqService _groqService;
  final ClipboardService _clipboardService;
  final AudioPlayerService _audioPlayerService;
  final SettingsProvider _settings;

  RecordingProvider(this._audioService, this._groqService, this._clipboardService, this._audioPlayerService, this._settings);

  RecordingState _state = RecordingState.idle;
  String? _errorMessage;
  String? _lastResult;
  double _currentVolume = 0.0;
  StreamSubscription<Amplitude>? _amplitudeSubscription;

  RecordingState get state => _state;
  String? get errorMessage => _errorMessage;
  String? get lastResult => _lastResult;
  double get currentVolume => _currentVolume;

  Future<void> toggleRecording() async {
    debugPrint('[RecordingProvider] toggleRecording called. Current state: $_state');
    if (_state == RecordingState.idle || _state == RecordingState.success || _state == RecordingState.error) {
      await _startRecording();
    } else if (_state == RecordingState.recording) {
      await _stopAndProcessRecording();
    } else {
      debugPrint('[RecordingProvider] Cannot toggle recording while in $_state state');
    }
  }

  Future<void> _startRecording() async {
    try {
      debugPrint('[RecordingProvider] Validating constraints for starting...');
      if (_settings.groqApiKey == null || _settings.groqApiKey!.isEmpty) {
        throw Exception('Groq API Key is missing. Please configure it in settings.');
      }
      
      debugPrint('[RecordingProvider] Saving currently focused application...');
      await _clipboardService.saveCurrentFocusedApp();

      debugPrint('[RecordingProvider] Invoking audioService.startRecording()');
      await _audioService.startRecording();
      _state = RecordingState.recording;
      _errorMessage = null;

      _amplitudeSubscription?.cancel();
      _amplitudeSubscription = _audioService.onAmplitudeChanged(const Duration(milliseconds: 50)).listen((amplitude) {
        // Assume silence below -45 dB
        final minDb = -45.0; 
        double volume = (amplitude.current - minDb) / -minDb; 
        if (volume < 0.0) volume = 0.0;
        if (volume > 1.0) volume = 1.0;
        
        _currentVolume = volume;
        notifyListeners();
      });
      _audioPlayerService.playStart();
      _showNotification('Whisper', 'Listening...');
      notifyListeners();
      debugPrint('[RecordingProvider] Started successfully.');
    } catch (e, stack) {
      debugPrint('[RecordingProvider] Exception in _startRecording: $e\n$stack');
      _audioPlayerService.playCancel();
      _handleError('Failed to start recording: ${e.toString()}');
    }
  }

  Future<void> _stopAndProcessRecording() async {
    try {
      debugPrint('[RecordingProvider] _stopAndProcessRecording called. Updating state to processing...');
      _amplitudeSubscription?.cancel();
      _currentVolume = 0.0;
      _state = RecordingState.processing;
      _audioPlayerService.startLoadingLoop();
      _showNotification('Whisper', 'Processing audio...');
      notifyListeners();

      debugPrint('[RecordingProvider] Awaiting audioService.stopRecording()...');
      final audioPath = await _audioService.stopRecording();
      debugPrint('[RecordingProvider] Audio record path returned: $audioPath');
      
      if (audioPath == null) throw Exception('Audio file path is null');

      // 1. Transcription
      debugPrint('[RecordingProvider] Starting transcription step via GroqService...');
      final transcription = await _groqService.transcribeAudio(
        _settings.groqApiKey!, 
        audioPath, 
        _settings.whisperModel
      );
      debugPrint('[RecordingProvider] Transcription complete: $transcription');

      if (transcription.trim().isEmpty) {
        debugPrint('[RecordingProvider] Transcription is empty. Canceling process.');
        _state = RecordingState.idle;
        _audioPlayerService.stopLoadingLoop();
        _audioPlayerService.playCancel();
        _showNotification('Whisper', 'No speech detected. Cancelled.');
        notifyListeners();
        return;
      }

      // 2. Intent Detection
      _state = RecordingState.processing;
      debugPrint('[RecordingProvider] Checking user intent for translation...');
      final intentData = await _groqService.determineIntent(
        _settings.groqApiKey!, 
        transcription,
        _settings.intentModel
      );
      
      final action = intentData['action'] as String;
      final targetLanguage = intentData['target_language'] as String?;
      
      debugPrint('[RecordingProvider] Detected Intent - Action: $action, Target: $targetLanguage');

      // 3. Treatment & Translation 
      debugPrint('[RecordingProvider] Treating/translating text...');
      final cleanedText = await _groqService.treatText(
        _settings.groqApiKey!, 
        transcription, 
        _settings.llmModel,
        targetLanguage: action == 'translate' ? targetLanguage : null,
      );
      debugPrint('[RecordingProvider] Treatment complete: $cleanedText');

      // 4. Clipboard copy
      debugPrint('[RecordingProvider] Copying to clipboard...');
      await _clipboardService.copyToClipboard(cleanedText);

      // Save to history
      final historyItem = HistoryItem(
        id: const Uuid().v4(),
        timestamp: DateTime.now(),
        originalText: transcription,
        finalText: cleanedText,
      );
      await _settings.addHistoryRecord(historyItem);

      _lastResult = cleanedText;
      _state = RecordingState.idle;
      _audioPlayerService.stopLoadingLoop();
      _audioPlayerService.playDone();
      _showNotification('Success', 'Text copied to clipboard');
      debugPrint('[RecordingProvider] Processing flow completed successfully.');
      
      // Notify listeners first (this triggers the window to hide in main.dart)
      notifyListeners();

      // Wait slightly to ensure macOS hides the window
      await Future.delayed(const Duration(milliseconds: 200));

      // 4. Auto Paste (After hiding)
      if (_settings.autoPaste) {
        debugPrint('[RecordingProvider] Restoring previous application focus...');
        await _clipboardService.restorePreviousApp();

        debugPrint('[RecordingProvider] Simulating auto-paste...');
        await _clipboardService.simulatePaste();
      }
    } catch (e, stack) {
      debugPrint('[RecordingProvider] Exception in _stopAndProcessRecording: $e\n$stack');
      _audioPlayerService.stopLoadingLoop();
      _audioPlayerService.playCancel();
      _handleError(e.toString());
    }
  }

  void _handleError(String message) {
    _amplitudeSubscription?.cancel();
    _currentVolume = 0.0;
    _state = RecordingState.idle;
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
