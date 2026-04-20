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
          ? List<String>.from(json['features'] as List)
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
