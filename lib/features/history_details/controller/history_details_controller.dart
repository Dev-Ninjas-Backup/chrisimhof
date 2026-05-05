import 'package:chrisimhof/features/history_details/model/history_details_model.dart';
import 'package:chrisimhof/features/history_details/service/history_details_service.dart';
import 'package:get/get.dart';

class HistoryDetailsController extends GetxController {
  final Rxn<HistoryDetailsResponse> resultData = Rxn<HistoryDetailsResponse>();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  late String historyId;
  late final HistoryDetailsService _service;

  final List<String> analyticPeriodOptions = [
    'Last 7 Days',
    'Last 30 Days',
    'Last Month',
  ];
  final RxString selectedPeriod = 'Last 7 Days'.obs;

  @override
  void onInit() {
    super.onInit();
    _service = HistoryDetailsService();
    // Get historyId from arguments passed when navigating to this screen
    historyId = Get.arguments ?? '';
    if (historyId.isNotEmpty) {
      loadHistoryDetailsData();
    }
  }

  void updateSelectedPeriod(String? newValue) {
    if (newValue != null) {
      selectedPeriod.value = newValue;
    }
  }

  void setResults(HistoryDetailsResponse data) {
    resultData.value = data;
  }

  Future<void> loadHistoryDetailsData() async {
    if (historyId.isEmpty) {
      error.value = 'History ID not provided';
      return;
    }

    isLoading.value = true;
    error.value = '';
    try {
      final data = await _service.fetchHistoryDetails(historyId);
      resultData.value = data;
    } catch (e) {
      error.value = 'Failed to load history details: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  String getLabelForScore(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Improvement';
  }
}
