class SubscriptionPlansResponse {
  final bool success;
  final String message;
  final List<SubscriptionPlan> data;

  SubscriptionPlansResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SubscriptionPlansResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlansResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
                .map((plan) => SubscriptionPlan.fromJson(plan))
                .toList()
          : [],
    );
  }
}

class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final int price; // price in cents
  final String currency;
  final String interval;
  final String stripeProductId;
  final String stripePriceId;
  final int trialDays;
  final bool isActive;
  final List<String> features;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.interval,
    required this.stripeProductId,
    required this.stripePriceId,
    required this.trialDays,
    required this.isActive,
    required this.features,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Get formatted price for display
  String get formattedPrice {
    if (price == 0) return 'Free';
    final priceInDollars = price / 100;
    return '\$${priceInDollars.toStringAsFixed(2)}/$intervalLabel';
  }

  String get intervalLabel {
    switch (interval.toUpperCase()) {
      case 'WEEK':
        return 'week';
      case 'MONTH':
        return 'month';
      case 'YEAR':
        return 'year';
      default:
        return interval.toLowerCase();
    }
  }

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      currency: json['currency'] ?? 'usd',
      interval: json['interval'] ?? 'MONTH',
      stripeProductId: json['stripeProductId'] ?? '',
      stripePriceId: json['stripePriceId'] ?? '',
      trialDays: json['trialDays'] ?? 0,
      isActive: json['isActive'] ?? false,
      features: json['features'] != null
          ? (json['features'] as List)
                .map(
                  (feature) => feature is Map
                      ? (feature['title'] as String?)
                      : (feature as String?),
                )
                .whereType<String>()
                .toList()
          : [],
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}

class UserResponse {
  final bool success;
  final String message;
  final UserData data;

  UserResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: UserData.fromJson(json['data'] ?? {}),
    );
  }
}

class UserData {
  final String id;
  final String email;
  final bool isSubscribed;
  final String? plan;
  final UserSubscriptions? subscriptions;

  UserData({
    required this.id,
    required this.email,
    required this.isSubscribed,
    this.plan,
    this.subscriptions,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      isSubscribed: json['isSubscribed'] ?? false,
      plan: json['plan'],
      subscriptions: json['subscriptions'] != null
          ? UserSubscriptions.fromJson(json['subscriptions'])
          : null,
    );
  }
}

class UserSubscriptions {
  final SubscriptionPlan? plan;

  UserSubscriptions({this.plan});

  factory UserSubscriptions.fromJson(Map<String, dynamic> json) {
    return UserSubscriptions(
      plan: json['plan'] != null
          ? SubscriptionPlan.fromJson(json['plan'])
          : null,
    );
  }
}

class CheckoutResponse {
  final bool success;
  final String message;
  final CheckoutData data;

  CheckoutResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: CheckoutData.fromJson(json['data'] ?? {}),
    );
  }
}

class CheckoutData {
  final String url;

  CheckoutData({required this.url});

  factory CheckoutData.fromJson(Map<String, dynamic> json) {
    return CheckoutData(url: json['url'] ?? '');
  }
}
