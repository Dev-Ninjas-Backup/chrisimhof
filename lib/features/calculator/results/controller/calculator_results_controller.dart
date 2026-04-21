import 'package:chrisimhof/features/calculator/results/model/calculator_results_model.dart';
import 'package:get/get.dart';

class CalculatorResultsController extends GetxController {
  CalculatorResultsController({CalculatorResultsData? initialData}) {
    if (initialData != null) {
      resultData.value = initialData;
    }
  }

  final Rxn<CalculatorResultsData> resultData = Rxn<CalculatorResultsData>();
  final RxBool isLoading = false.obs;

  void setResults(CalculatorResultsData data) {
    resultData.value = data;
  }

  Future<void> loadResults(
    Future<CalculatorResultsData> Function() loader,
  ) async {
    isLoading.value = true;
    try {
      resultData.value = await loader();
    } finally {
      isLoading.value = false;
    }
  }
}
