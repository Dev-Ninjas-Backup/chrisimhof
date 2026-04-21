import 'package:chrisimhof/features/calculator/results/model/calculate_result_model.dart';
import 'package:chrisimhof/features/calculator/service/calculator_service.dart';
import 'package:get/get.dart';

class CalculatorResultsController extends GetxController {
  final String? sessionId;
  final CalculatorService _calculatorService = CalculatorService();

  CalculatorResultsController({
    CalculateResultResponse? initialData,
    this.sessionId,
  }) {
    if (initialData != null) {
      resultData.value = initialData;
    }
  }

  final Rxn<CalculateResultResponse> resultData =
      Rxn<CalculateResultResponse>();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  void setResults(CalculateResultResponse data) {
    resultData.value = data;
  }

  Future<void> loadResults(
    Future<CalculateResultResponse> Function() loader,
  ) async {
    isLoading.value = true;
    try {
      resultData.value = await loader();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> calculateResultsFromAPI() async {
    if (sessionId == null) {
      error.value = 'Session ID not available';
      return;
    }

    isLoading.value = true;
    error.value = '';

    try {
      final response = await _calculatorService.calculateResult(sessionId!);

      resultData.value = response;
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
      return 'Poor';
    }
  }
}
