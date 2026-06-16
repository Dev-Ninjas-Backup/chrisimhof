import 'package:flutter/material.dart';

class SleepLog {
  final String id;
  final DateTime date;
  final TimeOfDay bedtime;
  final TimeOfDay wakeupTime;
  final int quality;

  SleepLog({
    required this.id,
    required this.date,
    required this.bedtime,
    required this.wakeupTime,
    required this.quality,
  });

  String get durationString {
    final bedMinutes = bedtime.hour * 60 + bedtime.minute;
    final wakeupMinutes = wakeupTime.hour * 60 + wakeupTime.minute;
    
    int diffMinutes = wakeupMinutes - bedMinutes;
    if (diffMinutes < 0) {
      diffMinutes += 1440; // 24 hours in minutes
    }
    
    final hours = diffMinutes ~/ 60;
    final minutes = diffMinutes % 60;
    
    return '${hours}h ${minutes}m';
  }
}
