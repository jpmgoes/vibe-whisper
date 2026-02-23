// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Whisper';

  @override
  String get recordingIndicator => 'In ascolto...';

  @override
  String get settings => 'Impostazioni';

  @override
  String get apiSettings => 'Impostazioni API';

  @override
  String get groqApiKey => 'Chiave API Groq';

  @override
  String get llmModel => 'Modello di Trattamento (LLM)';

  @override
  String get whisperModel => 'Modello Whisper';

  @override
  String get generalSettings => 'Generale';

  @override
  String get themeMode => 'Tema';

  @override
  String get language => 'Lingua';

  @override
  String get autoPaste => 'Incolla automaticamente nel campo attivo';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Chiaro';

  @override
  String get dark => 'Scuro';

  @override
  String get globalShortcut => 'Scorciatoia globale';

  @override
  String get save => 'Salva';

  @override
  String get success => 'Successo';

  @override
  String get error => 'Errore';

  @override
  String get textCopied => 'Testo copiato negli appunti';

  @override
  String get enterApiKey => 'Inserisci la tua chiave API';

  @override
  String get processing => 'Elaborazione';

  @override
  String get errorTryAgain => 'Errore. Riprova.';

  @override
  String get invalidApiKey => 'Chiave API non valida o nessun modello trovato.';

  @override
  String get setupWorkspace => 'Configura il tuo spazio di lavoro';

  @override
  String get configureVoice =>
      'Configura le impostazioni vocali e la connessione AI per sbloccare le funzionalità di trascrizione.';

  @override
  String get primaryLanguage => 'Lingua principale';

  @override
  String get getStarted => 'Inizia';

  @override
  String get keyStoredLocally =>
      'La tua chiave è archiviata localmente ed crittografata.';

  @override
  String get toggleRecording => 'Attiva/Disattiva registrazione';

  @override
  String get fillActiveField => 'Riempi il campo attivo';

  @override
  String get settingsSaved => 'Impostazioni salvate automaticamente.';

  @override
  String get saveChanges => 'Salva modifiche';

  @override
  String get history => 'Cronologia';

  @override
  String get clearAll => 'Cancella Tutto';

  @override
  String get transcriptionHistory => 'Cronologia Trascrizioni';

  @override
  String get noHistoryContent => 'Nessuna cronologia di trascrizione ancora.';

  @override
  String get originalAudio => 'Audio Originale';

  @override
  String get processedOutput => 'Output Elaborato';

  @override
  String get copiedOriginal => 'Originale Copiato';

  @override
  String get copiedWhisper => 'Trascrizione Whisper copiata negli appunti.';

  @override
  String get copiedProcessed => 'Elaborato Copiato';

  @override
  String get copiedProcessedMsg => 'Testo elaborato copiato negli appunti.';

  @override
  String get clearHistoryTitle => 'Cancella Cronologia';

  @override
  String get clearHistoryMsg =>
      'Sei sicuro di voler eliminare tutta la cronologia delle trascrizioni? Questa azione non può essere annullata.';

  @override
  String get cancel => 'Annulla';

  @override
  String get intentModel => 'Intent Model (Router)';
}
