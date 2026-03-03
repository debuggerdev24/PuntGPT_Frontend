import 'package:flutter/cupertino.dart';
import 'package:puntgpt_nick/services/subscription/subscription_service.dart';

import '../../core/enum/app_enums.dart';

class SubscriptionProvider extends ChangeNotifier {
  /// Store all active subscriptions
  final Set<AppEnum> _activeSubscriptions = {
    AppEnum.monthlyPlan,
  };

  bool _isSubscriptionProcessing = false;
  
  bool get isSubscriptionProcessing => _isSubscriptionProcessing;
  bool get isMonthlyPlanSubscribed =>
      _activeSubscriptions.contains(AppEnum.monthlyPlan);
  bool get isAnnualPlanSubscribed =>
      _activeSubscriptions.contains(AppEnum.annualPlan);
  bool get isLifeTimePlanSubscribed =>
      _activeSubscriptions.contains(AppEnum.lifeTimePlan);

  bool get isSubscribed => _activeSubscriptions.isNotEmpty;

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
