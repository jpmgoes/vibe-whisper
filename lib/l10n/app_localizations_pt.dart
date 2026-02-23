// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Whisper';

  @override
  String get recordingIndicator => 'Ouvindo...';

  @override
  String get settings => 'Configurações';

  @override
  String get apiSettings => 'Configurações da API';

  @override
  String get groqApiKey => 'Chave de API do Groq';

  @override
  String get llmModel => 'Modelo de Tratamento (LLM)';

  @override
  String get whisperModel => 'Modelo Whisper';

  @override
  String get generalSettings => 'Geral';

  @override
  String get themeMode => 'Tema';

  @override
  String get language => 'Idioma';

  @override
  String get autoPaste => 'Colar automaticamente no campo ativo';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Escuro';

  @override
  String get globalShortcut => 'Atalho Global';

  @override
  String get save => 'Salvar';

  @override
  String get success => 'Sucesso';

  @override
  String get error => 'Erro';

  @override
  String get textCopied => 'Texto copiado para a área de transferência';

  @override
  String get enterApiKey => 'Por favor, insira sua Chave de API';

  @override
  String get processing => 'Processando';

  @override
  String get errorTryAgain => 'Erro. Tente novamente.';

  @override
  String get invalidApiKey => 'Chave API inválida ou nenhum modelo encontrado.';

  @override
  String get setupWorkspace => 'Configure seu workspace';

  @override
  String get configureVoice =>
      'Configure suas opções de voz e conexão de IA para habilitar a transcrição de áudio.';

  @override
  String get primaryLanguage => 'Idioma Principal';

  @override
  String get getStarted => 'Começar';

  @override
  String get keyStoredLocally =>
      'Sua chave é armazenada localmente e criptografada.';

  @override
  String get toggleRecording => 'Gravar / Parar';

  @override
  String get fillActiveField => 'Preencher campo ativo';

  @override
  String get settingsSaved => 'Configurações salvas automaticamente.';

  @override
  String get saveChanges => 'Salvar Alterações';
}
