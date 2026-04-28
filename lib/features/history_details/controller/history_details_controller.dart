import 'package:chrisimhof/features/history_details/model/history_details_model.dart';
import 'package:get/get.dart';
class HistoryDetailsController extends GetxController {
  final Rxn<HistoryDetailsResponse> resultData = Rxn<HistoryDetailsResponse>();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Add these for the dropdown
  final List<String> analyticPeriodOptions = ['Last 7 Days', 'Last 30 Days', 'Last Month'];
  final RxString selectedPeriod = 'Last 7 Days'.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistoryDetailsData();
  }

  // Update selection logic
  void updateSelectedPeriod(String? newValue) {
    if (newValue != null) {
      selectedPeriod.value = newValue;
      // You can add logic here to fetch new data based on the period
    }
  }

  void setResults(HistoryDetailsResponse data) {
    resultData.value = data;
  }

  Future<void> loadHistoryDetailsData() async {
    isLoading.value = true;
    error.value = '';
    try {
      resultData.value = mockHistoryDetailsData;
    } catch (e) {
      error.value = e.toString();
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