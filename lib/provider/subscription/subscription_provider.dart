import 'package:flutter/cupertino.dart';
import 'package:puntgpt_nick/services/subscription/subscription_service.dart';

import '../../core/enum/app_enums.dart';

class SubscriptionProvider extends ChangeNotifier {
  /// Store all active subscriptions
  final Set<AppEnum> _activeSubscriptions = {};

  bool _isSubscriptionProcessing = false;

  bool get isSubscriptionProcessing => _isSubscriptionProcessing;

  bool get isTier1Subscribed =>
      _activeSubscriptions.contains(AppEnum.monthlyPlan);
  bool get isTier2Subscribed =>
      _activeSubscriptions.contains(AppEnum.yearlyPlan);
  bool get isTier3Subscribed =>
      _activeSubscriptions.contains(AppEnum.lifeTimePlan);

  //todo Expose active set read-only
  Set<AppEnum> get activeSubscriptions => {..._activeSubscriptions};

  //todo set
  void setSubscriptionProcessStatus({required bool status}) {
    _isSubscriptionProcessing = status;
    notifyListeners();
  }

  //todo add subscription
  void addSubscription(AppEnum tier) {
    _activeSubscriptions.add(tier);
    notifyListeners();
  }

  //todo remove subscription
  void removeSubscription(AppEnum tier) {
    _activeSubscriptions.remove(tier);
    notifyListeners();
  }

  //todo buy subscription
  Future<void> buy({
    required AppEnum tier,
    required BuildContext context,
  }) async {
    await SubscriptionService.instance.buy(tier: tier, context: context);
    notifyListeners();
  }

  //todo Mock Cancel
  Future<void> cancel(AppEnum tier) async {
    // await Future.delayed(const Duration(milliseconds: 500));

    _activeSubscriptions.remove(tier);
    notifyListeners();
  }
}
