class NotificationPreferencesModel {
  bool shiftReminders;
  int shiftReminderMinutes;
  bool bedtimeAlerts;
  int bedtimeReminderMinutes;
  bool caffeineCutoff;
  int caffeineReminderMinutes;
  bool hydrationReminders;
  bool circadianTransitions;
  bool weeklySportReport;

  NotificationPreferencesModel({
    this.shiftReminders = true,
    this.shiftReminderMinutes = 30,
    this.bedtimeAlerts = true,
    this.bedtimeReminderMinutes = 60,
    this.caffeineCutoff = true,
    this.caffeineReminderMinutes = 30,
    this.hydrationReminders = true,
    this.circadianTransitions = true,
    this.weeklySportReport = true,
  });

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesModel(
      shiftReminders: json['shiftReminders'] ?? true,
      shiftReminderMinutes: (json['shiftReminderMinutes'] as num?)?.toInt() ?? 30,
      bedtimeAlerts: json['bedtimeAlerts'] ?? true,
      bedtimeReminderMinutes: (json['bedtimeReminderMinutes'] as num?)?.toInt() ?? 60,
      caffeineCutoff: json['caffeineCutoff'] ?? true,
      caffeineReminderMinutes: (json['caffeineReminderMinutes'] as num?)?.toInt() ?? 30,
      hydrationReminders: json['hydrationReminders'] ?? true,
      circadianTransitions: json['circadianTransitions'] ?? true,
      weeklySportReport: json['weeklySportReport'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shiftReminders': shiftReminders,
      'shiftReminderMinutes': shiftReminderMinutes,
      'bedtimeAlerts': bedtimeAlerts,
      'bedtimeReminderMinutes': bedtimeReminderMinutes,
      'caffeineCutoff': caffeineCutoff,
      'caffeineReminderMinutes': caffeineReminderMinutes,
      'hydrationReminders': hydrationReminders,
      'circadianTransitions': circadianTransitions,
      'weeklySportReport': weeklySportReport,
    };
  }
}
