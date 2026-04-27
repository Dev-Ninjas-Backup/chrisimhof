import 'package:chrisimhof/features/history_details/model/history_details_model.dart';
import 'package:get/get.dart';

class HistoryDetailsController extends GetxController {
  final Rxn<HistoryDetailsResponse> resultData =
      Rxn<HistoryDetailsResponse>();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with static mock data
    loadHistoryDetailsData();
  }

  void setResults(HistoryDetailsResponse data) {
    resultData.value = data;
  }

  Future<void> loadHistoryDetailsData() async {
    isLoading.value = true;
    error.value = '';

    try {
      // For now, using static mock data
      // This will be replaced with API call later
      resultData.value = mockHistoryDetailsData;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Placeholder for future API integration
  Future<void> fetchHistoryDetailsFromAPI(String historyId) async {
    isLoading.value = true;
    error.value = '';

    try {
      // TODO: Replace with actual API call
      // final response = await _historyDetailsService.fetchDetails(historyId);
      // resultData.value = response;

      // For now, using mock data
      resultData.value = mockHistoryDetailsData;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  String getLabelForScore(int score) {
    if (score >= 80) {
      return 'Excellent';
    } else if (score >= 60) {
      return 'Good';
    } else if (score >= 40) {
      return 'Fair';
    } else {
      return 'Needs Improvement';
    }
  }
}
