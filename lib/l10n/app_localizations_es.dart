// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Whisper';

  @override
  String get recordingIndicator => 'Escuchando...';

  @override
  String get settings => 'Configuración';

  @override
  String get apiSettings => 'Configuración de API';

  @override
  String get groqApiKey => 'Clave API de Groq';

  @override
  String get llmModel => 'Modelo de Tratamiento (LLM)';

  @override
  String get whisperModel => 'Modelo Whisper';

  @override
  String get generalSettings => 'General';

  @override
  String get themeMode => 'Tema';

  @override
  String get language => 'Idioma';

  @override
  String get autoPaste => 'Pegar automáticamente en el campo activo';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get globalShortcut => 'Atajo Global';

  @override
  String get save => 'Guardar';

  @override
  String get success => 'Éxito';

  @override
  String get error => 'Error';

  @override
  String get textCopied => 'Texto copiado al portapapeles';

  @override
  String get enterApiKey => 'Por favor, introduzca su Clave API';

  @override
  String get processing => 'Procesando';

  @override
  String get errorTryAgain => 'Error. Inténtalo de nuevo.';

  @override
  String get invalidApiKey => 'Clave API inválida o no se encontraron modelos.';

  @override
  String get setupWorkspace => 'Configura tu espacio de trabajo';

  @override
  String get configureVoice =>
      'Configura tus opciones de voz y conexión a IA para habilitar la transcripción de audio.';

  @override
  String get primaryLanguage => 'Idioma Principal';

  @override
  String get getStarted => 'Empezar';

  @override
  String get keyStoredLocally =>
      'Su clave se almacena localmente y está encriptada.';

  @override
  String get toggleRecording => 'Grabar / Detener';

  @override
  String get fillActiveField => 'Rellenar campo activo';

  @override
  String get settingsSaved => 'Configuraciones guardadas automáticamente.';

  @override
  String get saveChanges => 'Guardar Cambios';
}
