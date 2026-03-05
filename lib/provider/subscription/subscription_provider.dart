import 'package:flutter/cupertino.dart';
import 'package:puntgpt_nick/services/subscription/subscription_service.dart';

import '../../core/enum/app_enums.dart';

class SubscriptionProvider extends ChangeNotifier {
  /// Store all active subscriptions
  final Set<SubscriptionEnum> _activeSubscriptions = {
    SubscriptionEnum.monthlyPlan,
  };

  bool _isSubscriptionProcessing = false;
  
  bool get isSubscriptionProcessing => _isSubscriptionProcessing;
  bool get isMonthlyPlanSubscribed =>
      _activeSubscriptions.contains(SubscriptionEnum.monthlyPlan);
  bool get isAnnualPlanSubscribed =>
      _activeSubscriptions.contains(SubscriptionEnum.annualPlan);
  bool get isLifeTimePlanSubscribed =>
      _activeSubscriptions.contains(SubscriptionEnum.lifeTimePlan);

  bool get isSubscribed => _activeSubscriptions.isNotEmpty;

  //todo Expose active set read-only
  Set<SubscriptionEnum> get activeSubscriptions => {..._activeSubscriptions};

  //todo set
  void setSubscriptionProcessStatus({required bool status}) {
    _isSubscriptionProcessing = status;
    notifyListeners();
  }

  //todo add subscription
  void addSubscription(SubscriptionEnum tier) {
    _activeSubscriptions.add(tier);
    notifyListeners();
  }

  //todo remove subscription
  void removeSubscription(SubscriptionEnum tier) {
    _activeSubscriptions.remove(tier);
    notifyListeners();
  }

  //todo buy subscription
  Future<void> buy({
    required SubscriptionEnum tier,
    required BuildContext context,
  }) async {
    await SubscriptionService.instance.buy(tier: tier, context: context);
    notifyListeners();
  }

  //todo Mock Cancel
  Future<void> cancel(SubscriptionEnum tier) async {
    // await Future.delayed(const Duration(milliseconds: 500));

    _activeSubscriptions.remove(tier);
    notifyListeners();
  }
}
