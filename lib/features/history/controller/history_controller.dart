import 'package:chrisimhof/features/history/model/history_model.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final selectedTab = 0.obs;

  final recentList = <HistoryModel>[
    HistoryModel(
      dateTime: 'Apr 8, 2025 · 10:30 AM',
      details: 'Night shift • 7 hours of sleep • Low fatigue',
      score: '92%',
      scoreDetails: 'Excellent performance',
    ),
    HistoryModel(
      dateTime: 'Apr 7, 2025 · 09:15 AM',
      details: 'Cardio Session',
      score: '85%',
      scoreDetails: 'Night shift • 7 hours of sleep • Low fatigue',
    ),
    HistoryModel(
      dateTime: 'Apr 6, 2025 · 08:00 AM',
      details: 'Strength Training',
      score: '78%',
      scoreDetails: 'Good progress',
    ),
  ];

  final pastList = <HistoryModel>[
    HistoryModel(
      dateTime: 'Mar 15, 2025 · 07:45 AM',
      details: 'Yoga Session',
      score: '88%',
      scoreDetails: 'Very relaxing',
    ),
    HistoryModel(
      dateTime: 'Mar 10, 2025 · 06:30 AM',
      details: 'HIIT Workout',
      score: '95%',
      scoreDetails: 'Night shift • 7 hours of sleep • Low fatigue',
    ),
    HistoryModel(
      dateTime: 'Mar 5, 2025 · 11:00 AM',
      details: 'Swimming',
      score: '80%',
      scoreDetails: 'Solid session',
    ),
    HistoryModel(
      dateTime: 'Feb 28, 2025 · 08:00 AM',
      details: 'Cycling',
      score: '74%',
      scoreDetails: 'Keep going',
    ),
  ];

  List<HistoryModel> get currentList =>
      selectedTab.value == 0 ? recentList : pastList;

  void selectTab(int index) => selectedTab.value = index;
}
