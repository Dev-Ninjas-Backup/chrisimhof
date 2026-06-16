// import 'package:chrisimhof/features/recomendations/model/recomendation_model.dart';
// import 'package:get/get.dart';

// class RecomendationsController extends GetxController {
//   final RxList<RecomendationModel> recomendationsList = <RecomendationModel>[].obs;
//   final RxBool isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadMockRecomendations();
//   }

//   void loadMockRecomendations() {
//     isLoading.value = true;
//     try {
//       recomendationsList.assignAll([
//         RecomendationModel(
//           title: 'Sleep',
//           description: 'Aim for bed by 22:48 — your circadian window opens then.',
//           count: 3,
//         ),
//         RecomendationModel(
//           title: 'Caffeine',
//           description: 'Last coffee before 16:30. You\'re still at 110mg active.',
//           count: 2,
//         ),
//         RecomendationModel(
//           title: 'Hydration',
//           description: '900ml left for today — drink 200ml every hour until 21:00.',
//           count: 2,
//         ),
//         RecomendationModel(
//           title: 'Nutrition',
//           description: 'Pre-shift meal: prioritise complex carbs + protein, low...',
//           count: 2,
//         ),
//         RecomendationModel(
//           title: 'Sport',
//           description: 'Skip intense training today recovery is at 64%.',
//           count: 1,
//         ),
//         RecomendationModel(
//           title: 'Work',
//           description: 'Bright light first 30 min of shift. dim screens after 04:00.',
//           count: 2,
//         ),
//         RecomendationModel(
//           title: 'Fatigue',
//           description: '20-min nap window 14:00-14:30 will lift afternoon energy.',
//           count: 1,
//         ),
//       ]);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Future method for actual API integration
//   Future<void> fetchRecomendationsFromApi() async {
//     // API logic will go here
//   }
// }

import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/recomendations/model/recomendation_api_model.dart';
import 'package:chrisimhof/features/recomendations/service/recomendation_service.dart';
import 'package:get/get.dart';

class RecommendationController extends GetxController {
  final RecommendationService _service = RecommendationService();

  final isLoading = false.obs;
  final recommendationResponse = Rxn<RecommendationResponse>();
  final expandedCategories = <String>[].obs;

  void toggleCategoryExpansion(String? category) {
    if (category == null) return;
    final normalized = category.toLowerCase();
    if (expandedCategories.contains(normalized)) {
      expandedCategories.remove(normalized);
    } else {
      expandedCategories.add(normalized);
    }
  }

  bool isCategoryExpanded(String? category) {
    if (category == null) return false;
    return expandedCategories.contains(category.toLowerCase());
  }

  @override
  void onInit() {
    super.onInit();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    final currentLocale = Get.locale?.languageCode ?? 'en';
    final localeCode = currentLocale.toLowerCase() == 'fr' ? 'fr' : 'en';
    final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';

    getRecommendations(
      sessionId: sessionId,
      locale: localeCode,
    );
  }

  Future<void> getRecommendations({
    required String sessionId,
    String locale = 'en',
  }) async {
    try {
      isLoading.value = true;

      recommendationResponse.value = await _service.getRecommendations(
        sessionId: sessionId,
        locale: locale,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
