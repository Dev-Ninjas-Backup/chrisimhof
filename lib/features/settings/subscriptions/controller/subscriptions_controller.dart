import 'package:chrisimhof/features/settings/subscriptions/model/subscription_plan_model.dart';
import 'package:chrisimhof/features/settings/subscriptions/service/subscriptions_service.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionsController extends GetxController {
  final SubscriptionsService _service = SubscriptionsService();

  final Rx<List<SubscriptionPlan>> subscriptionPlans = Rx([]);
  final RxString activePlanId = RxString('');
  final RxBool isLoading = true.obs;
  final RxBool isCheckingOut = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Fetch both subscription plans and current user info in parallel
      final plansResponse = await _service.getSubscriptionPlans();
      final userResponse = await _service.getCurrentUser();

      if (plansResponse.success) {
        subscriptionPlans.value = plansResponse.data;
      } else {
        errorMessage.value = plansResponse.message;
      }

      if (userResponse.success) {
        // Get the active plan ID from user's current subscription
        if (userResponse.data.subscriptions?.plan != null) {
          activePlanId.value = userResponse.data.subscriptions!.plan!.id;
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleSubscription(SubscriptionPlan plan) async {
    try {
      isCheckingOut.value = true;
      errorMessage.value = '';

      final checkoutResponse = await _service.initiateCheckout(plan.id);

      if (checkoutResponse.success && checkoutResponse.data.url.isNotEmpty) {
        // Launch the Stripe checkout URL
        final url = Uri.parse(checkoutResponse.data.url);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);

          // After returning from checkout, refresh user data to update active plan
          Future.delayed(const Duration(seconds: 2), () {
            _refreshUserData();
          });
        } else {
          // Try with inAppBrowserView as fallback
          try {
            await launchUrl(url, mode: LaunchMode.inAppBrowserView);

            // After returning from checkout, refresh user data to update active plan
            Future.delayed(const Duration(seconds: 2), () {
              _refreshUserData();
            });
          } catch (e) {
            errorMessage.value =
                'Could not launch checkout. URL available in logs.';
          }
        }
      } else {
        errorMessage.value = checkoutResponse.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isCheckingOut.value = false;
    }
  }

  Future<void> _refreshUserData() async {
    try {
      final userResponse = await _service.getCurrentUser();

      if (userResponse.success) {
        if (userResponse.data.subscriptions?.plan != null) {
          activePlanId.value = userResponse.data.subscriptions!.plan!.id;
        }
      }
    } catch (e) {
      // Silent fail on refresh
    }
  }
}
