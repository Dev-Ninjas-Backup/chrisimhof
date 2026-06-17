class DashboardModel {
  final DateTime date;
  final String userName;
  final String optimalBedtime;
  final String timeUntilBedtime;
  final int rhythmScore;

  // Quick Add values
  final double waterLiters;
  final int caffeineMg;
  final int mealsLogged;
  final int mealsTarget;
  final int sportMinutes;

  // Today progress metrics (0.0 to 1.0)
  final double sleepProgress;
  final double hydrationProgress;
  final double caffeineProgress;
  final double recoveryProgress;

  // Work card
  final String workShift;
  final String workShiftCountdown;
  final double workProgress;

  // Last Sleep card
  final String lastSleepDuration;
  final String sleepDebtText;
  final List<double> lastSleepWeekBars;

  // State flags for sleep wellness card
  final bool isSleepLogged;
  final bool isSleepPrep;
  final bool isMissedBedtime;

  // Signed minutes to bedtime (negative = past bedtime)
  final int minutesToBedtime;

  DashboardModel({
    required this.date,
    required this.userName,
    required this.optimalBedtime,
    required this.timeUntilBedtime,
    required this.rhythmScore,
    required this.waterLiters,
    required this.caffeineMg,
    required this.mealsLogged,
    required this.mealsTarget,
    required this.sportMinutes,
    required this.sleepProgress,
    required this.hydrationProgress,
    required this.caffeineProgress,
    required this.recoveryProgress,
    required this.workShift,
    required this.workShiftCountdown,
    required this.workProgress,
    required this.lastSleepDuration,
    required this.sleepDebtText,
    required this.lastSleepWeekBars,
    this.isSleepLogged = false,
    this.isSleepPrep = false,
    this.isMissedBedtime = false,
    this.minutesToBedtime = 120,
  });

  DashboardModel copyWith({
    DateTime? date,
    String? userName,
    String? optimalBedtime,
    String? timeUntilBedtime,
    int? rhythmScore,
    double? waterLiters,
    int? caffeineMg,
    int? mealsLogged,
    int? mealsTarget,
    int? sportMinutes,
    double? sleepProgress,
    double? hydrationProgress,
    double? caffeineProgress,
    double? recoveryProgress,
    String? workShift,
    String? workShiftCountdown,
    double? workProgress,
    String? lastSleepDuration,
    String? sleepDebtText,
    List<double>? lastSleepWeekBars,
    bool? isSleepLogged,
    bool? isSleepPrep,
    bool? isMissedBedtime,
    int? minutesToBedtime,
  }) {
    return DashboardModel(
      date: date ?? this.date,
      userName: userName ?? this.userName,
      optimalBedtime: optimalBedtime ?? this.optimalBedtime,
      timeUntilBedtime: timeUntilBedtime ?? this.timeUntilBedtime,
      rhythmScore: rhythmScore ?? this.rhythmScore,
      waterLiters: waterLiters ?? this.waterLiters,
      caffeineMg: caffeineMg ?? this.caffeineMg,
      mealsLogged: mealsLogged ?? this.mealsLogged,
      mealsTarget: mealsTarget ?? this.mealsTarget,
      sportMinutes: sportMinutes ?? this.sportMinutes,
      sleepProgress: sleepProgress ?? this.sleepProgress,
      hydrationProgress: hydrationProgress ?? this.hydrationProgress,
      caffeineProgress: caffeineProgress ?? this.caffeineProgress,
      recoveryProgress: recoveryProgress ?? this.recoveryProgress,
      workShift: workShift ?? this.workShift,
      workShiftCountdown: workShiftCountdown ?? this.workShiftCountdown,
      workProgress: workProgress ?? this.workProgress,
      lastSleepDuration: lastSleepDuration ?? this.lastSleepDuration,
      sleepDebtText: sleepDebtText ?? this.sleepDebtText,
      lastSleepWeekBars: lastSleepWeekBars ?? this.lastSleepWeekBars,
      isSleepLogged: isSleepLogged ?? this.isSleepLogged,
      isSleepPrep: isSleepPrep ?? this.isSleepPrep,
      isMissedBedtime: isMissedBedtime ?? this.isMissedBedtime,
      minutesToBedtime: minutesToBedtime ?? this.minutesToBedtime,
    );
  }
}
