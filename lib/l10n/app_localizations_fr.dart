// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Whisper';

  @override
  String get recordingIndicator => 'Écoute...';

  @override
  String get settings => 'Paramètres';

  @override
  String get apiSettings => 'Paramètres API';

  @override
  String get groqApiKey => 'Clé API Groq';

  @override
  String get llmModel => 'Modèle de traitement (LLM)';

  @override
  String get whisperModel => 'Modèle Whisper';

  @override
  String get generalSettings => 'Général';

  @override
  String get themeMode => 'Thème';

  @override
  String get language => 'Langue';

  @override
  String get autoPaste => 'Coller automatiquement dans le champ actif';

  @override
  String get system => 'Système';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get globalShortcut => 'Raccourci global';

  @override
  String get save => 'Enregistrer';

  @override
  String get success => 'Succès';

  @override
  String get error => 'Erreur';

  @override
  String get textCopied => 'Texte copié dans le presse-papiers';

  @override
  String get enterApiKey => 'Veuillez entrer votre clé API';

  @override
  String get processing => 'Traitement en cours';

  @override
  String get errorTryAgain => 'Erreur. Veuillez réessayer.';

  @override
  String get invalidApiKey => 'Clé API invalide ou aucun modèle trouvé.';

  @override
  String get setupWorkspace => 'Configurez votre espace de travail';

  @override
  String get configureVoice =>
      'Configurez vos paramètres vocaux et votre connexion IA pour débloquer les fonctionnalités.';

  @override
  String get primaryLanguage => 'Langue principale';

  @override
  String get getStarted => 'Commencer';

  @override
  String get keyStoredLocally =>
      'Votre clé est stockée localement et chiffrée.';

  @override
  String get toggleRecording => 'Basculer l\'enregistrement';

  @override
  String get fillActiveField => 'Remplir le champ actif';

  @override
  String get settingsSaved => 'Paramètres enregistrés automatiquement.';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get history => 'Historique';

  @override
  String get clearAll => 'Tout Effacer';

  @override
  String get transcriptionHistory => 'Historique des Transcriptions';

  @override
  String get noHistoryContent =>
      'Aucun historique de transcription pour le moment.';

  @override
  String get originalAudio => 'Audio Original';

  @override
  String get processedOutput => 'Sortie Traitée';

  @override
  String get copiedOriginal => 'Original Copié';

  @override
  String get copiedWhisper =>
      'Transcription Whisper copiée dans le presse-papiers.';

  @override
  String get copiedProcessed => 'Traité Copié';

  @override
  String get copiedProcessedMsg => 'Texte traité copié dans le presse-papiers.';

  @override
  String get clearHistoryTitle => 'Effacer l\'historique';

  @override
  String get clearHistoryMsg =>
      'Êtes-vous sûr de vouloir supprimer tout l\'historique des transcriptions ? Cette action est irréversible.';

  @override
  String get cancel => 'Annuler';

  @override
  String get intentModel => 'Intent Model (Router)';

  @override
  String get snippets => 'Voice Snippets';

  @override
  String get addSnippet => 'Add Snippet';

  @override
  String get editSnippet => 'Edit Snippet';

  @override
  String get newSnippet => 'New Snippet';

  @override
  String get snippetCommandLabel => 'Command/Key (e.g., \"my email\")';

  @override
  String get snippetValueLabel => 'Value to paste';

  @override
  String get noSnippetsYet => 'No snippets yet.';

  @override
  String get eraseAllData => 'Erase All Data';

  @override
  String get eraseAllDataConfirm =>
      'Are you sure you want to erase all data and reset the app? This action cannot be undone.';

  @override
  String get globalShortcutsAndGeneral => 'Global Shortcuts & General';

  @override
  String get pressShortcut => 'Press a shortcut combination...';

  @override
  String get dangerZone => 'Danger Zone';
}
