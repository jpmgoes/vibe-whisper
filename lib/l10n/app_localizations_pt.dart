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

  @override
  String get history => 'Histórico';

  @override
  String get clearAll => 'Limpar Tudo';

  @override
  String get transcriptionHistory => 'Histórico de Transcrições';

  @override
  String get noHistoryContent => 'Nenhum histórico de transcrição ainda.';

  @override
  String get originalAudio => 'Áudio Original';

  @override
  String get processedOutput => 'Saída Processada';

  @override
  String get copiedOriginal => 'Original Copiado';

  @override
  String get copiedWhisper =>
      'Transcrição do Whisper copiada para a área de transferência.';

  @override
  String get copiedProcessed => 'Processado Copiado';

  @override
  String get copiedProcessedMsg =>
      'Texto processado copiado para a área de transferência.';

  @override
  String get clearHistoryTitle => 'Limpar Histórico';

  @override
  String get clearHistoryMsg =>
      'Tem certeza de que deseja excluir todo o histórico de transcrições? Esta ação não pode ser desfeita.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get intentModel => 'Intent Model (Router)';

  @override
  String get snippets => 'Snippets de Voz';

  @override
  String get addSnippet => 'Adicionar Snippet';

  @override
  String get editSnippet => 'Editar Snippet';

  @override
  String get newSnippet => 'Novo Snippet';

  @override
  String get snippetCommandLabel => 'Comando/Chave (ex: \"meu email\")';

  @override
  String get snippetValueLabel => 'Valor para colar';

  @override
  String get noSnippetsYet => 'Nenhum snippet ainda.';

  @override
  String get eraseAllData => 'Apagar Tudo';

  @override
  String get eraseAllDataConfirm =>
      'Tem certeza que deseja apagar todos os dados e restaurar o aplicativo? Esta ação não pode ser desfeita.';

  @override
  String get globalShortcutsAndGeneral => 'Atalhos Globais e Geral';

  @override
  String get pressShortcut => 'Pressione uma combinação de atalhos...';

  @override
  String get dangerZone => 'Zona de Perigo';
}
