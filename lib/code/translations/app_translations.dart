import 'package:get/get.dart';

class AppTranslations extends Translations {
  static const Map<String, String> _en = {
    // Navigation
    'tune': 'Tune',
    'tools': 'Tools',

    // Common
    'settings': 'Settings',
    'about': 'About',
    'ok': 'OK',
    'cancel': 'Cancel',
    'reset': 'Reset',
    'stop': 'Stop',

    // Home toolbar
    'switch_to_light_mode': 'Switch to light mode',
    'switch_to_dark_mode': 'Switch to dark mode',
    'use_system_theme': 'Use system theme',
    'using_system_theme': 'Using system theme',

    // Tools home
    'metronome': 'Metronome',
    'chords': 'Chords',

    // Metronome
    'time_signature': 'Time Signature',
    'tap_to_start': 'Tap to start',
    'tap_to_stop': 'Tap to stop',
    'decrease_by_10': 'Decrease by 10',
    'decrease_by_1': 'Decrease by 1',
    'increase_by_1': 'Increase by 1',
    'increase_by_10': 'Increase by 10',

    // Chord library
    'chord_library': 'Chord Library',
    'select_your_chord': 'Select Your Chord',
    'chord_shape': 'Chord shape @current of @total',

    // About
    'about_intune': 'About InTune',
    'version': 'Version 1.0.0',
    'features': 'Features',
    'developer': 'Developer',
    'about_description':
        'InTune is a professional guitar tuning and music tool app designed for musicians of all levels. '
        'It features a precision guitar tuner with multiple tuning options, a metronome, and chord library to enhance your playing experience.',
    'features_list':
        '• Guitar tuner with multiple tuning options\n'
        '• Metronome with custom BPM settings\n'
        '• Comprehensive chord library\n'
        '• Dark and light theme support\n'
        '• Simple and intuitive interface',
    'developer_credit': 'Created with ♥ by DAKTARI DEV',
    'copyright': '© @year InTune - All Rights Reserved',
    'privacy_policy': 'Privacy Policy',

    // Settings
    'guitar_visualization': 'Guitar Visualization',
    'guitar_type': 'Guitar Type',
    'guitar_type_desc': 'Choose which guitar type to display in the tuner',
    'acoustic': 'Acoustic',
    'electric': 'Electric',
    'metronome_sounds': 'Metronome Sounds',
    'metronome_sounds_desc':
        'Choose metronome sounds for the first and other beats respectively',
    'audio_settings': 'Audio Settings',
    'silence_threshold': 'Silence Threshold',
    'silence_threshold_desc': 'Adjust the sensitivity of note detection',
    'more_sensitive': 'More sensitive',
    'less_sensitive': 'Less sensitive',
    'reset_all_settings': 'Reset All Settings',
    'reset_settings_title': 'Reset Settings',
    'reset_settings_confirm':
        'Are you sure you want to reset all settings to default values?',
    'settings_reset_message': 'Settings reset to defaults',

    // Tuner
    'stop_tuning_title': 'Stop Tuning?',
    'stop_tuning_prompt': 'Would you like to continue tuning?',
    'continue_tuning': 'Continue Tuning',
    'start_tuning_hint': 'Start tuning by playing any string',
    'tuner_on': 'ON',
    'tuner_off': 'OFF',

    // Welcome / onboarding
    'welcome_title': 'Welcome to InTune',
    'welcome_subtitle': 'Your complete guitar companion',
    'welcome_feature_1_title': 'Precision Tuner',
    'welcome_feature_1_desc': 'Tune your guitar accurately with real-time pitch detection. Supports standard, open, and alternate tunings.',
    'welcome_feature_2_title': 'Metronome',
    'welcome_feature_2_desc': 'Keep perfect time with a customizable metronome. Set your BPM and choose from multiple beat sounds.',
    'welcome_feature_3_title': 'Chord Library',
    'welcome_feature_3_desc': 'Browse hundreds of chord diagrams. From basic open chords to advanced jazz voicings.',
    'welcome_get_started': 'Get Started',
    'welcome_next': 'Next',
    'welcome_skip': 'Skip',

    // Tuner status values (controller sets these as raw keys)
    'tuned': 'Tuned',
    'too low': 'Too Low',
    'too high': 'Too High',
    'low': 'Low',
    'high': 'High',
    'Play something': 'Play something',
  };

  // ─── French ───────────────────────────────────────────────────────────────
  static const Map<String, String> _fr = {
    'tune': 'Accorder',
    'tools': 'Outils',
    'settings': 'Paramètres',
    'about': 'À propos',
    'ok': 'OK',
    'cancel': 'Annuler',
    'reset': 'Réinitialiser',
    'stop': 'Arrêter',
    'switch_to_light_mode': 'Passer au mode clair',
    'switch_to_dark_mode': 'Passer au mode sombre',
    'use_system_theme': 'Utiliser le thème système',
    'using_system_theme': 'Utilisation du thème système',
    'metronome': 'Métronome',
    'chords': 'Accords',
    'time_signature': 'Mesure',
    'tap_to_start': 'Appuyez pour démarrer',
    'tap_to_stop': 'Appuyez pour arrêter',
    'decrease_by_10': 'Diminuer de 10',
    'decrease_by_1': 'Diminuer de 1',
    'increase_by_1': 'Augmenter de 1',
    'increase_by_10': 'Augmenter de 10',
    'chord_library': "Bibliothèque d'accords",
    'select_your_chord': 'Sélectionnez votre accord',
    'chord_shape': "Forme d'accord @current sur @total",
    'about_intune': "À propos d'InTune",
    'version': 'Version 1.0.0',
    'features': 'Fonctionnalités',
    'developer': 'Développeur',
    'about_description':
        "InTune est une application professionnelle d'accordage de guitare et d'outils musicaux "
        'conçue pour les musiciens de tous niveaux. Elle comprend un accordeur de précision avec '
        "plusieurs options d'accordage, un métronome et une bibliothèque d'accords.",
    'features_list':
        "• Accordeur de guitare avec plusieurs options d'accordage\n"
        '• Métronome avec réglage BPM personnalisé\n'
        "• Bibliothèque d'accords complète\n"
        '• Support des thèmes sombre et clair\n'
        '• Interface simple et intuitive',
    'developer_credit': 'Créé avec ♥ par DAKTARI DEV',
    'copyright': '© @year InTune - Tous droits réservés',
    'privacy_policy': 'Politique de confidentialité',
    'guitar_visualization': 'Visualisation de la guitare',
    'guitar_type': 'Type de guitare',
    'guitar_type_desc': "Choisissez le type de guitare à afficher dans l'accordeur",
    'acoustic': 'Acoustique',
    'electric': 'Électrique',
    'metronome_sounds': 'Sons du métronome',
    'metronome_sounds_desc':
        'Choisissez les sons du métronome pour le premier et les autres temps',
    'audio_settings': 'Paramètres audio',
    'silence_threshold': 'Seuil de silence',
    'silence_threshold_desc': 'Ajustez la sensibilité de la détection des notes',
    'more_sensitive': 'Plus sensible',
    'less_sensitive': 'Moins sensible',
    'reset_all_settings': 'Réinitialiser tous les paramètres',
    'reset_settings_title': 'Réinitialiser les paramètres',
    'reset_settings_confirm':
        'Êtes-vous sûr de vouloir réinitialiser tous les paramètres aux valeurs par défaut ?',
    'settings_reset_message': 'Paramètres réinitialisés',
    'welcome_title': 'Bienvenue sur InTune',
    'welcome_subtitle': 'Votre compagnon guitare complet',
    'welcome_feature_1_title': 'Accordeur de précision',
    'welcome_feature_1_desc': 'Accordez votre guitare avec précision grâce à la détection de hauteur en temps réel. Supporte les accordages standard, open et alternatifs.',
    'welcome_feature_2_title': 'Métronome',
    'welcome_feature_2_desc': 'Gardez un tempo parfait avec un métronome personnalisable. Réglez votre BPM et choisissez parmi plusieurs sons de battement.',
    'welcome_feature_3_title': "Bibliothèque d'accords",
    'welcome_feature_3_desc': "Parcourez des centaines de diagrammes d'accords. Des accords ouverts de base aux voicings jazz avancés.",
    'welcome_get_started': 'Commencer',
    'welcome_next': 'Suivant',
    'welcome_skip': 'Ignorer',
    'stop_tuning_title': "Arrêter l'accordage ?",
    'stop_tuning_prompt': "Voulez-vous continuer l'accordage ?",
    'continue_tuning': "Continuer l'accordage",
    'start_tuning_hint': "Commencez l'accordage en jouant une corde",
    'tuner_on': 'ON',
    'tuner_off': 'OFF',
    'tuned': 'Accordé',
    'too low': 'Trop bas',
    'too high': 'Trop haut',
    'low': 'Bas',
    'high': 'Haut',
    'Play something': 'Jouez quelque chose',
  };

  // ─── German ───────────────────────────────────────────────────────────────
  static const Map<String, String> _de = {
    'tune': 'Stimmen',
    'tools': 'Werkzeuge',
    'settings': 'Einstellungen',
    'about': 'Über',
    'ok': 'OK',
    'cancel': 'Abbrechen',
    'reset': 'Zurücksetzen',
    'stop': 'Beenden',
    'switch_to_light_mode': 'Zum hellen Modus wechseln',
    'switch_to_dark_mode': 'Zum dunklen Modus wechseln',
    'use_system_theme': 'Systemdesign verwenden',
    'using_system_theme': 'Systemdesign wird verwendet',
    'metronome': 'Metronom',
    'chords': 'Akkorde',
    'time_signature': 'Taktart',
    'tap_to_start': 'Tippen zum Starten',
    'tap_to_stop': 'Tippen zum Stoppen',
    'decrease_by_10': 'Um 10 verringern',
    'decrease_by_1': 'Um 1 verringern',
    'increase_by_1': 'Um 1 erhöhen',
    'increase_by_10': 'Um 10 erhöhen',
    'chord_library': 'Akkord-Bibliothek',
    'select_your_chord': 'Akkord auswählen',
    'chord_shape': 'Akkordform @current von @total',
    'about_intune': 'Über InTune',
    'version': 'Version 1.0.0',
    'features': 'Funktionen',
    'developer': 'Entwickler',
    'about_description':
        'InTune ist eine professionelle Gitarren-Stimm- und Musikwerkzeug-App für Musiker aller Niveaus. '
        'Sie bietet einen präzisen Gitarrenstimmer mit mehreren Stimmoptionen, ein Metronom und eine Akkord-Bibliothek.',
    'features_list':
        '• Gitarrenstimmer mit mehreren Stimmoptionen\n'
        '• Metronom mit anpassbaren BPM-Einstellungen\n'
        '• Umfangreiche Akkord-Bibliothek\n'
        '• Unterstützung für dunkles und helles Design\n'
        '• Einfache und intuitive Oberfläche',
    'developer_credit': 'Erstellt mit ♥ von DAKTARI DEV',
    'copyright': '© @year InTune - Alle Rechte vorbehalten',
    'privacy_policy': 'Datenschutzrichtlinie',
    'guitar_visualization': 'Gitarren-Visualisierung',
    'guitar_type': 'Gitarrentyp',
    'guitar_type_desc': 'Wählen Sie den Gitarrentyp für die Stimmgerät-Ansicht',
    'acoustic': 'Akustisch',
    'electric': 'Elektrisch',
    'metronome_sounds': 'Metronom-Klänge',
    'metronome_sounds_desc':
        'Wählen Sie Klänge für den ersten und andere Schläge',
    'audio_settings': 'Audio-Einstellungen',
    'silence_threshold': 'Schweigegrenzwert',
    'silence_threshold_desc':
        'Passen Sie die Empfindlichkeit der Tonerkennung an',
    'more_sensitive': 'Empfindlicher',
    'less_sensitive': 'Weniger empfindlich',
    'reset_all_settings': 'Alle Einstellungen zurücksetzen',
    'reset_settings_title': 'Einstellungen zurücksetzen',
    'reset_settings_confirm':
        'Möchten Sie alle Einstellungen auf die Standardwerte zurücksetzen?',
    'settings_reset_message': 'Einstellungen zurückgesetzt',
    'welcome_title': 'Willkommen bei InTune',
    'welcome_subtitle': 'Ihr kompletter Gitarren-Begleiter',
    'welcome_feature_1_title': 'Präzisionsstimmer',
    'welcome_feature_1_desc': 'Stimmen Sie Ihre Gitarre genau mit Echtzeit-Tonerkennung. Unterstützt Standard-, Open- und alternative Stimmungen.',
    'welcome_feature_2_title': 'Metronom',
    'welcome_feature_2_desc': 'Halten Sie perfektes Tempo mit einem anpassbaren Metronom. Stellen Sie Ihr BPM ein und wählen Sie aus mehreren Beat-Klängen.',
    'welcome_feature_3_title': 'Akkord-Bibliothek',
    'welcome_feature_3_desc': 'Durchsuchen Sie Hunderte von Akkord-Diagrammen. Von einfachen offenen Akkorden bis zu fortgeschrittenen Jazz-Voicings.',
    'welcome_get_started': 'Loslegen',
    'welcome_next': 'Weiter',
    'welcome_skip': 'Überspringen',
    'stop_tuning_title': 'Stimmen beenden?',
    'stop_tuning_prompt': 'Möchten Sie mit dem Stimmen fortfahren?',
    'continue_tuning': 'Weiter stimmen',
    'start_tuning_hint': 'Beginnen Sie mit dem Stimmen, indem Sie eine Saite spielen',
    'tuner_on': 'AN',
    'tuner_off': 'AUS',
    'tuned': 'Gestimmt',
    'too low': 'Zu tief',
    'too high': 'Zu hoch',
    'low': 'Tief',
    'high': 'Hoch',
    'Play something': 'Spielen Sie etwas',
  };

  // ─── Spanish ──────────────────────────────────────────────────────────────
  static const Map<String, String> _es = {
    'tune': 'Afinar',
    'tools': 'Herramientas',
    'settings': 'Ajustes',
    'about': 'Acerca de',
    'ok': 'OK',
    'cancel': 'Cancelar',
    'reset': 'Restablecer',
    'stop': 'Detener',
    'switch_to_light_mode': 'Cambiar a modo claro',
    'switch_to_dark_mode': 'Cambiar a modo oscuro',
    'use_system_theme': 'Usar tema del sistema',
    'using_system_theme': 'Usando tema del sistema',
    'metronome': 'Metrónomo',
    'chords': 'Acordes',
    'time_signature': 'Compás',
    'tap_to_start': 'Toca para iniciar',
    'tap_to_stop': 'Toca para detener',
    'decrease_by_10': 'Reducir en 10',
    'decrease_by_1': 'Reducir en 1',
    'increase_by_1': 'Aumentar en 1',
    'increase_by_10': 'Aumentar en 10',
    'chord_library': 'Biblioteca de Acordes',
    'select_your_chord': 'Selecciona tu acorde',
    'chord_shape': 'Forma de acorde @current de @total',
    'about_intune': 'Acerca de InTune',
    'version': 'Versión 1.0.0',
    'features': 'Características',
    'developer': 'Desarrollador',
    'about_description':
        'InTune es una aplicación profesional de afinación de guitarra y herramientas musicales '
        'diseñada para músicos de todos los niveles. Incluye un afinador de precisión con múltiples '
        'opciones de afinación, un metrónomo y una biblioteca de acordes.',
    'features_list':
        '• Afinador de guitarra con múltiples opciones\n'
        '• Metrónomo con configuración personalizada de BPM\n'
        '• Biblioteca de acordes completa\n'
        '• Soporte para temas oscuro y claro\n'
        '• Interfaz sencilla e intuitiva',
    'developer_credit': 'Creado con ♥ por DAKTARI DEV',
    'copyright': '© @year InTune - Todos los derechos reservados',
    'privacy_policy': 'Política de privacidad',
    'guitar_visualization': 'Visualización de la guitarra',
    'guitar_type': 'Tipo de guitarra',
    'guitar_type_desc': 'Elige qué tipo de guitarra mostrar en el afinador',
    'acoustic': 'Acústica',
    'electric': 'Eléctrica',
    'metronome_sounds': 'Sonidos del Metrónomo',
    'metronome_sounds_desc':
        'Elige los sonidos del metrónomo para el primer y otros tiempos',
    'audio_settings': 'Configuración de Audio',
    'silence_threshold': 'Umbral de Silencio',
    'silence_threshold_desc': 'Ajusta la sensibilidad de la detección de notas',
    'more_sensitive': 'Más sensible',
    'less_sensitive': 'Menos sensible',
    'reset_all_settings': 'Restablecer todos los ajustes',
    'reset_settings_title': 'Restablecer Ajustes',
    'reset_settings_confirm':
        '¿Estás seguro de que deseas restablecer todos los ajustes a los valores predeterminados?',
    'settings_reset_message': 'Ajustes restablecidos',
    'welcome_title': 'Bienvenido a InTune',
    'welcome_subtitle': 'Tu compañero de guitarra completo',
    'welcome_feature_1_title': 'Afinador de precisión',
    'welcome_feature_1_desc': 'Afina tu guitarra con precisión mediante detección de tono en tiempo real. Compatible con afinaciones estándar, open y alternativas.',
    'welcome_feature_2_title': 'Metrónomo',
    'welcome_feature_2_desc': 'Mantén el tiempo perfecto con un metrónomo personalizable. Configura tu BPM y elige entre múltiples sonidos de compás.',
    'welcome_feature_3_title': 'Biblioteca de Acordes',
    'welcome_feature_3_desc': 'Explora cientos de diagramas de acordes. Desde acordes abiertos básicos hasta voicings de jazz avanzados.',
    'welcome_get_started': 'Comenzar',
    'welcome_next': 'Siguiente',
    'welcome_skip': 'Omitir',
    'stop_tuning_title': '¿Detener la afinación?',
    'stop_tuning_prompt': '¿Deseas continuar afinando?',
    'continue_tuning': 'Continuar Afinando',
    'start_tuning_hint': 'Comienza a afinar tocando cualquier cuerda',
    'tuner_on': 'ON',
    'tuner_off': 'OFF',
    'tuned': 'Afinado',
    'too low': 'Demasiado bajo',
    'too high': 'Demasiado alto',
    'low': 'Bajo',
    'high': 'Alto',
    'Play something': 'Toca algo',
  };

  // ─── Portuguese ───────────────────────────────────────────────────────────
  static const Map<String, String> _pt = {
    'tune': 'Afinar',
    'tools': 'Ferramentas',
    'settings': 'Configurações',
    'about': 'Sobre',
    'ok': 'OK',
    'cancel': 'Cancelar',
    'reset': 'Redefinir',
    'stop': 'Parar',
    'switch_to_light_mode': 'Mudar para modo claro',
    'switch_to_dark_mode': 'Mudar para modo escuro',
    'use_system_theme': 'Usar tema do sistema',
    'using_system_theme': 'Usando tema do sistema',
    'metronome': 'Metrônomo',
    'chords': 'Acordes',
    'time_signature': 'Compasso',
    'tap_to_start': 'Toque para iniciar',
    'tap_to_stop': 'Toque para parar',
    'decrease_by_10': 'Diminuir 10',
    'decrease_by_1': 'Diminuir 1',
    'increase_by_1': 'Aumentar 1',
    'increase_by_10': 'Aumentar 10',
    'chord_library': 'Biblioteca de Acordes',
    'select_your_chord': 'Selecione seu acorde',
    'chord_shape': 'Forma de acorde @current de @total',
    'about_intune': 'Sobre o InTune',
    'version': 'Versão 1.0.0',
    'features': 'Funcionalidades',
    'developer': 'Desenvolvedor',
    'about_description':
        'InTune é um aplicativo profissional de afinação de guitarra e ferramentas musicais '
        'para músicos de todos os níveis. Apresenta um afinador preciso com múltiplas opções '
        'de afinação, metrônomo e biblioteca de acordes.',
    'features_list':
        '• Afinador de guitarra com múltiplas opções\n'
        '• Metrônomo com configurações personalizadas de BPM\n'
        '• Biblioteca de acordes abrangente\n'
        '• Suporte a temas escuro e claro\n'
        '• Interface simples e intuitiva',
    'developer_credit': 'Criado com ♥ por DAKTARI DEV',
    'copyright': '© @year InTune - Todos os direitos reservados',
    'privacy_policy': 'Política de privacidade',
    'guitar_visualization': 'Visualização da guitarra',
    'guitar_type': 'Tipo de guitarra',
    'guitar_type_desc': 'Escolha o tipo de guitarra para exibir no afinador',
    'acoustic': 'Acústica',
    'electric': 'Elétrica',
    'metronome_sounds': 'Sons do Metrônomo',
    'metronome_sounds_desc':
        'Escolha os sons do metrônomo para o primeiro e outros tempos',
    'audio_settings': 'Configurações de Áudio',
    'silence_threshold': 'Limiar de Silêncio',
    'silence_threshold_desc': 'Ajuste a sensibilidade da detecção de notas',
    'more_sensitive': 'Mais sensível',
    'less_sensitive': 'Menos sensível',
    'reset_all_settings': 'Redefinir todas as configurações',
    'reset_settings_title': 'Redefinir Configurações',
    'reset_settings_confirm':
        'Tem certeza de que deseja redefinir todas as configurações para os valores padrão?',
    'settings_reset_message': 'Configurações redefinidas',
    'welcome_title': 'Bem-vindo ao InTune',
    'welcome_subtitle': 'Seu companheiro completo de guitarra',
    'welcome_feature_1_title': 'Afinador de Precisão',
    'welcome_feature_1_desc': 'Afine sua guitarra com precisão usando detecção de tom em tempo real. Suporta afinações padrão, abertas e alternativas.',
    'welcome_feature_2_title': 'Metrônomo',
    'welcome_feature_2_desc': 'Mantenha o tempo perfeito com um metrônomo personalizável. Defina seu BPM e escolha entre vários sons de batida.',
    'welcome_feature_3_title': 'Biblioteca de Acordes',
    'welcome_feature_3_desc': 'Navegue por centenas de diagramas de acordes. De acordes abertos básicos a voicings avançados de jazz.',
    'welcome_get_started': 'Começar',
    'welcome_next': 'Próximo',
    'welcome_skip': 'Pular',
    'stop_tuning_title': 'Parar afinação?',
    'stop_tuning_prompt': 'Deseja continuar afinando?',
    'continue_tuning': 'Continuar Afinando',
    'start_tuning_hint': 'Comece a afinar tocando qualquer corda',
    'tuner_on': 'LIGADO',
    'tuner_off': 'DESLIG.',
    'tuned': 'Afinado',
    'too low': 'Muito baixo',
    'too high': 'Muito alto',
    'low': 'Baixo',
    'high': 'Alto',
    'Play something': 'Toque algo',
  };

  // ─── Swahili ──────────────────────────────────────────────────────────────
  static const Map<String, String> _sw = {
    'tune': 'Rekebisha',
    'tools': 'Zana',
    'settings': 'Mipangilio',
    'about': 'Kuhusu',
    'ok': 'Sawa',
    'cancel': 'Ghairi',
    'reset': 'Weka upya',
    'stop': 'Simamisha',
    'switch_to_light_mode': 'Badilisha hadi hali ya mwanga',
    'switch_to_dark_mode': 'Badilisha hadi hali ya giza',
    'use_system_theme': 'Tumia mandhari ya mfumo',
    'using_system_theme': 'Inatumia mandhari ya mfumo',
    'metronome': 'Metronomi',
    'chords': 'Akodi',
    'time_signature': 'Ishara ya Wakati',
    'tap_to_start': 'Gusa kuanza',
    'tap_to_stop': 'Gusa kusimama',
    'decrease_by_10': 'Punguza kwa 10',
    'decrease_by_1': 'Punguza kwa 1',
    'increase_by_1': 'Ongeza kwa 1',
    'increase_by_10': 'Ongeza kwa 10',
    'chord_library': 'Maktaba ya Akodi',
    'select_your_chord': 'Chagua akodi yako',
    'chord_shape': 'Umbo la akodi @current kati ya @total',
    'about_intune': 'Kuhusu InTune',
    'version': 'Toleo 1.0.0',
    'features': 'Vipengele',
    'developer': 'Msanidi',
    'about_description':
        'InTune ni programu ya kitaalamu ya urekebishaji wa gitaa na zana za muziki '
        'iliyoundwa kwa wanamuziki wa viwango vyote. Inajumuisha kirekebishaji sahihi cha gitaa '
        'chenye chaguzi nyingi, metronomi na maktaba ya akodi.',
    'features_list':
        '• Kirekebishaji cha gitaa chenye chaguzi nyingi\n'
        '• Metronomi na mipangilio ya BPM ya kibinafsi\n'
        '• Maktaba kamili ya akodi\n'
        '• Msaada wa mandhari za giza na mwanga\n'
        '• Kiolesura rahisi na cha kuvutia',
    'developer_credit': 'Imeundwa kwa ♥ na DAKTARI DEV',
    'copyright': '© @year InTune - Haki zote zimehifadhiwa',
    'privacy_policy': 'Sera ya Faragha',
    'guitar_visualization': 'Mwonekano wa Gitaa',
    'guitar_type': 'Aina ya Gitaa',
    'guitar_type_desc': 'Chagua aina ya gitaa kuonyesha katika kirekebishaji',
    'acoustic': 'Akustiki',
    'electric': 'Umeme',
    'metronome_sounds': 'Sauti za Metronomi',
    'metronome_sounds_desc':
        'Chagua sauti za metronomi kwa mstari wa kwanza na mingine',
    'audio_settings': 'Mipangilio ya Sauti',
    'silence_threshold': 'Kiwango cha Ukimya',
    'silence_threshold_desc': 'Rekebisha unyeti wa utambuzi wa noti',
    'more_sensitive': 'Nyeti zaidi',
    'less_sensitive': 'Nyeti kidogo',
    'reset_all_settings': 'Weka upya mipangilio yote',
    'reset_settings_title': 'Weka Upya Mipangilio',
    'reset_settings_confirm':
        'Je, una uhakika unataka kuweka upya mipangilio yote hadi maadili ya msingi?',
    'settings_reset_message': 'Mipangilio imewekwa upya',
    'welcome_title': 'Karibu InTune',
    'welcome_subtitle': 'Msaidizi wako kamili wa gitaa',
    'welcome_feature_1_title': 'Kirekebishaji Sahihi',
    'welcome_feature_1_desc': 'Rekebisha gitaa lako kwa usahihi kwa kutumia utambuzi wa sauti wa wakati halisi. Inasaidia urekebishaji wa kawaida, wazi na mbadala.',
    'welcome_feature_2_title': 'Metronomi',
    'welcome_feature_2_desc': 'Dumisha muda kamili na metronomi inayoweza kubadilishwa. Weka BPM yako na chagua kati ya sauti mbalimbali za mdundo.',
    'welcome_feature_3_title': 'Maktaba ya Akodi',
    'welcome_feature_3_desc': 'Vinjari mamia ya michoro ya akodi. Kuanzia akodi za msingi hadi voicings za jazz za hali ya juu.',
    'welcome_get_started': 'Anza',
    'welcome_next': 'Inayofuata',
    'welcome_skip': 'Ruka',
    'stop_tuning_title': 'Simamisha urekebishaji?',
    'stop_tuning_prompt': 'Je, unataka kuendelea na urekebishaji?',
    'continue_tuning': 'Endelea Kurekebisha',
    'start_tuning_hint': 'Anza urekebishaji kwa kupiga kamba yoyote',
    'tuner_on': 'WASHA',
    'tuner_off': 'ZIMA',
    'tuned': 'Imewekwa',
    'too low': 'Chini sana',
    'too high': 'Juu sana',
    'low': 'Chini',
    'high': 'Juu',
    'Play something': 'Piga kitu',
  };

  @override
  Map<String, Map<String, String>> get keys => {
    'en': _en,
    'fr': _fr,
    'de': _de,
    'es': _es,
    'pt': _pt,
    'sw': _sw,
  };
}
