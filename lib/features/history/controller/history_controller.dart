import 'package:chrisimhof/features/history/model/history_model.dart';
import 'package:chrisimhof/features/history/service/history_service.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final selectedTab = 0.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final recentList = <HistoryModel>[].obs;
  final pastList = <HistoryModel>[].obs;

  // Pagination
  final currentPage = 1.obs;
  final pageSize = 10.obs;
  final hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecentHistory();
  }

  Future<void> fetchRecentHistory() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await HistoryService.fetchHistory(
        page: currentPage.value,
        limit: pageSize.value,
        filter: 'recent',
      );

      recentList.assignAll(data);
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  Future<void> fetchPastHistory() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await HistoryService.fetchHistory(
        page: 1,
        limit: pageSize.value,
        filter: 'past',
      );

      pastList.assignAll(data);
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  List<HistoryModel> get currentList =>
      selectedTab.value == 0 ? recentList : pastList;

  void selectTab(int index) {
    selectedTab.value = index;
    if (index == 0 && recentList.isEmpty) {
      fetchRecentHistory();
    } else if (index == 1 && pastList.isEmpty) {
      fetchPastHistory();
    }
  }

  Future<void> loadMore() async {
    if (!hasMoreData.value || isLoading.value) return;

    currentPage.value++;
    try {
      final filter = selectedTab.value == 0 ? 'recent' : 'past';
      final data = await HistoryService.fetchHistory(
        page: currentPage.value,
        limit: pageSize.value,
        filter: filter,
      );

      if (data.isEmpty) {
        hasMoreData.value = false;
      } else {
        if (selectedTab.value == 0) {
          recentList.addAll(data);
        } else {
          pastList.addAll(data);
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  void refreshHistory() {
    currentPage.value = 1;
    hasMoreData.value = true;
    recentList.clear();
    pastList.clear();
    errorMessage.value = '';
    fetchRecentHistory();
  }
}
