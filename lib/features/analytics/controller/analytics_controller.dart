import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class AnalyticsController extends GetxController {
  final selectedPeriod = 'Last 7 Days'.obs;

  final periods = const [
    'Last 7 Days',
    'Last 14 Days',
    'Last 30 Days',
    'Last 90 Days',
  ];

  final days = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final Map<String, List<FlSpot>> periodSpots = {
    'Last 7 Days': const [
      FlSpot(0, 5),
      FlSpot(1, 10),
      FlSpot(2, 25),
      FlSpot(3, 42),
      FlSpot(4, 30),
      FlSpot(5, 55),
      FlSpot(6, 94),
    ],
    'Last 14 Days': const [
      FlSpot(0, 12),
      FlSpot(1, 20),
      FlSpot(2, 18),
      FlSpot(3, 35),
      FlSpot(4, 50),
      FlSpot(5, 46),
      FlSpot(6, 70),
    ],
    'Last 30 Days': const [
      FlSpot(0, 8),
      FlSpot(1, 16),
      FlSpot(2, 28),
      FlSpot(3, 22),
      FlSpot(4, 40),
      FlSpot(5, 60),
      FlSpot(6, 78),
    ],
    'Last 90 Days': const [
      FlSpot(0, 15),
      FlSpot(1, 30),
      FlSpot(2, 20),
      FlSpot(3, 45),
      FlSpot(4, 38),
      FlSpot(5, 72),
      FlSpot(6, 88),
    ],
  };

  List<FlSpot> get currentSpots =>
      periodSpots[selectedPeriod.value] ?? periodSpots['Last 7 Days']!;

  void changePeriod(String value) {
    selectedPeriod.value = value;
  }
}
