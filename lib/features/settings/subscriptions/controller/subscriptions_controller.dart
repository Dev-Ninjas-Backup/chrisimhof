import 'package:chrisimhof/features/settings/subscriptions/model/subscription_plan_model.dart';
import 'package:chrisimhof/features/settings/subscriptions/service/subscriptions_service.dart';
import 'package:get/get.dart';

class SubscriptionsController extends GetxController {
  final SubscriptionsService _service = SubscriptionsService();

  final Rx<List<SubscriptionPlan>> subscriptionPlans = Rx([]);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubscriptionPlans();
  }

  Future<void> fetchSubscriptionPlans() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _service.getSubscriptionPlans();

      if (response.success) {
        subscriptionPlans.value = response.data;
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void handleSubscription(SubscriptionPlan plan) {
    // This will handle payment processing with Stripe
  }
}
