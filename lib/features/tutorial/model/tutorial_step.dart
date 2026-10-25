enum TutorialTargetId {
  bedtimeCard,
  quickAddSection,
  dailyIndicators,
  workCard,
  thisWeekCard,
  rotationsListCard,
  rotationNameField,
  lastSleepCard,
  forYouSection,
  navStatsButton,
  historyTabs,
  basicProfileCard,
}

class TutorialStep {
  final int stepIndex; // 1 to 12
  final TutorialTargetId targetId;
  final String titleFr;
  final String titleEn;
  final String messageFr;
  final String messageEn;
  final String actionLabelFr;
  final String actionLabelEn;
  final bool isAboveTarget; // whether the bubble prefers being above or below target

  const TutorialStep({
    required this.stepIndex,
    required this.targetId,
    required this.titleFr,
    required this.titleEn,
    required this.messageFr,
    required this.messageEn,
    required this.actionLabelFr,
    required this.actionLabelEn,
    this.isAboveTarget = true,
  });
}

class TutorialData {
  static const List<TutorialStep> steps = [
    // Step 01: Welcome
    TutorialStep(
      stepIndex: 1,
      targetId: TutorialTargetId.bedtimeCard,
      titleFr: 'Bienvenue',
      titleEn: 'Welcome',
      messageFr: 'Bienvenue sur RYVENZA ! Fais le tour de l’essentiel, puis avance à ton rythme.',
      messageEn: 'Welcome to RYVENZA! Explore the essentials, then go at your own pace.',
      actionLabelFr: 'Commencer',
      actionLabelEn: 'Start',
      isAboveTarget: true,
    ),
    // Step 02: Quick Add
    TutorialStep(
      stepIndex: 2,
      targetId: TutorialTargetId.quickAddSection,
      titleFr: 'Les quatre ajouts rapides',
      titleEn: 'Four Quick Add cards',
      messageFr: 'Ajoute ton eau, ta caféine, tes repas et tes séances de sport en quelques gestes.',
      messageEn: 'Log your water, caffeine, meals and workouts in just a few taps.',
      actionLabelFr: 'Suivant',
      actionLabelEn: 'Next',
      isAboveTarget: true,
    ),
    // Step 03: Daily indicators
    TutorialStep(
      stepIndex: 3,
      targetId: TutorialTargetId.dailyIndicators,
      titleFr: 'Repères du jour',
      titleEn: 'Daily indicators',
      messageFr: 'Sommeil, hydratation, caféine et récupération, en un coup d’œil.',
      messageEn: 'Sleep, hydration, caffeine and recovery: your day at a glance.',
      actionLabelFr: 'Suivant',
      actionLabelEn: 'Next',
      isAboveTarget: true,
    ),
    // Step 04: Work schedule
    TutorialStep(
      stepIndex: 4,
      targetId: TutorialTargetId.workCard,
      titleFr: 'Horaires de travail',
      titleEn: 'Work schedule',
      messageFr: 'Jour, soir, nuit ou repos : retrouve tes horaires de travail et tes rotations.',
      messageEn: 'Day, evening, night or rest: find your work schedule and shift rotations.',
      actionLabelFr: 'Suivant',
      actionLabelEn: 'Next',
      isAboveTarget: true,
    ),
    // Step 05: Change rotation
    TutorialStep(
      stepIndex: 5,
      targetId: TutorialTargetId.thisWeekCard,
      titleFr: 'Modifier son tournus',
      titleEn: 'Change your rotation',
      messageFr: 'Ta semaine et l’accès aux réglages de ton tournus.',
      messageEn: 'Your week, plus access to your shift rotation settings.',
      actionLabelFr: 'Suivant',
      actionLabelEn: 'Next',
      isAboveTarget: true,
    ),
    // Step 06: Templates and rotations
    TutorialStep(
      stepIndex: 6,
      targetId: TutorialTargetId.rotationsListCard,
      titleFr: 'Modèles et rotations',
      titleEn: 'Templates and rotations',
      messageFr: 'Choisis un modèle de rotation ou prépare un tournus personnalisé.',
      messageEn: 'Choose a rotation template or build your own shift pattern.',
      actionLabelFr: 'Suivant',
      actionLabelEn: 'Next',
      isAboveTarget: true,
    ),
    // Step 07: Rotation name and settings
    TutorialStep(
      stepIndex: 7,
      targetId: TutorialTargetId.rotationNameField,
      titleFr: 'Nom et paramètres du tournus',
      titleEn: 'Rotation name and settings',
      messageFr: 'Donne un nom à ton tournus, choisis sa durée et définis tes horaires.',
      messageEn: 'Name your rotation, choose its length and set your working hours.',
      actionLabelFr: 'Suivant',
      actionLabelEn: 'Next',
      isAboveTarget: false, // below name field so form remains visible
    ),
    // Step 08: Sleep and naps
    TutorialStep(
      stepIndex: 8,
      targetId: TutorialTargetId.lastSleepCard,
      titleFr: 'Sommeil et siestes',
      titleEn: 'Sleep and naps',
      messageFr: 'Retrouve ton dernier sommeil. Le suivi du sommeil te permet aussi d’enregistrer tes siestes.',
      messageEn: 'See your latest sleep. Your sleep log also lets you record naps.',
      actionLabelFr: 'Suivant',
      actionLabelEn: 'Next',
      isAboveTarget: true,
    ),
    // Step 09: Recommendations
    TutorialStep(
      stepIndex: 9,
      targetId: TutorialTargetId.forYouSection,
      titleFr: 'Recommandations',
      titleEn: 'Recommendations',
      messageFr: 'Des recommandations pour préparer la suite de ta journée.',
      messageEn: 'Recommendations to help you plan the rest of your day.',
      actionLabelFr: 'Suivant',
      actionLabelEn: 'Next',
      isAboveTarget: true,
    ),
    // Step 10: Open statistics
    TutorialStep(
      stepIndex: 10,
      targetId: TutorialTargetId.navStatsButton,
      titleFr: 'Accès aux statistiques',
      titleEn: 'Open statistics',
      messageFr: 'Ouvre Stats pour retrouver tes journées et suivre ton évolution.',
      messageEn: 'Open Stats to review your days and track your progress.',
      actionLabelFr: 'Suivant',
      actionLabelEn: 'Next',
      isAboveTarget: true,
    ),
    // Step 11: History: two views
    TutorialStep(
      stepIndex: 11,
      targetId: TutorialTargetId.historyTabs,
      titleFr: 'Historique : deux vues',
      titleEn: 'History: two views',
      messageFr: 'Ma journée rassemble tes événements. Vue d’ensemble montre l’évolution de ton rythme.',
      messageEn: 'My Day brings your daily events together. Overview shows how your rhythm changes over time.',
      actionLabelFr: 'Suivant',
      actionLabelEn: 'Next',
      isAboveTarget: false, // tabs are at top of screen, so bubble goes below
    ),
    // Step 12: Basic profile
    TutorialStep(
      stepIndex: 12,
      targetId: TutorialTargetId.basicProfileCard,
      titleFr: 'Profil de base',
      titleEn: 'Basic profile',
      messageFr: 'Sommeil, chronotype, objectifs : ajuste ton profil de base pour personnaliser RYVENZA.',
      messageEn: 'Sleep, chronotype, goals: adjust your basic profile to personalise RYVENZA.',
      actionLabelFr: 'Terminer',
      actionLabelEn: 'Finish',
      isAboveTarget: true,
    ),
  ];
}
