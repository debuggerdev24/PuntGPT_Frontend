import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/services/subscription/subscription_service.dart';


class SubscriptionProvider extends ChangeNotifier {
  /// Store all active subscriptions
  final Set<SubscriptionEnum> _activeSubscriptions = {
    SubscriptionEnum.monthlyPlan,
  };

  bool _isSubscriptionProcessing = false;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  bool get isSubscriptionProcessing => _isSubscriptionProcessing;
  bool get isMonthlyPlanSubscribed =>
      _activeSubscriptions.contains(SubscriptionEnum.monthlyPlan);
  bool get isAnnualPlanSubscribed =>
      _activeSubscriptions.contains(SubscriptionEnum.annualPlan);
  bool get isLifeTimePlanSubscribed =>
      _activeSubscriptions.contains(SubscriptionEnum.lifeTimePlan);

  bool get isSubscribed => _activeSubscriptions.isNotEmpty;

  Set<SubscriptionEnum> get activeSubscriptions => {..._activeSubscriptions};

  void setSubscriptionProcessStatus({required bool status}) {
    _isSubscriptionProcessing = status;
    notifyListeners();
  }

  void addSubscription(SubscriptionEnum tier) {
    _activeSubscriptions.add(tier);
    notifyListeners();
  }

  void removeSubscription(SubscriptionEnum tier) {
    _activeSubscriptions.remove(tier);
    notifyListeners();
  }

  Future<void> initialize({required BuildContext context}) async {
    await SubscriptionService.instance.initialize(context: context);
    startPurchaseListener();
  }
  
  //* Starts listening to the purchase stream. Call after [SubscriptionService.initialize].
  void startPurchaseListener() {
    _purchaseSub?.cancel();
    _purchaseSub = SubscriptionService.instance.purchaseStream.listen(
      _handlePurchases,
      onError: (e) =>
          Logger.error("Subscription purchase stream error: ${e.toString()}"),
    );
  }

  void _handlePurchases(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        final tier =
            SubscriptionService.instance.getTierFromProductId(purchase.productID);
        if (tier != null) {
          final localData = purchase.verificationData.localVerificationData;
          final serverData = purchase.verificationData.serverVerificationData;
          Logger.info("serverVerificationData : $serverData");

          if (Platform.isAndroid) {
            try {
              final decoded = jsonDecode(localData);
              Logger.info("Decode data : $decoded");
              final token = decoded["purchaseToken"] as String?;
              Logger.info("\nPurchase Token For Android: ${token.toString()}\n");
            } catch (e) {
              Logger.error("Android localVerificationData decode failed: $e");
            }
          } else if (Platform.isIOS) {
            // iOS localVerificationData can be a receipt string (not JSON).
            String? transactionId;
            try {
              final decoded = jsonDecode(localData);
              Logger.info("Decode data : $decoded");
              if (decoded is Map) {
                transactionId = decoded["transactionId"]?.toString();
              }
            } catch (_) {
              // ignore - not JSON
            }
            transactionId ??= purchase.purchaseID;
            Logger.info("Transaction Id For iOS: \n$transactionId");
          }
          addSubscription(tier);
        }
        if (purchase.pendingCompletePurchase) {
          SubscriptionService.instance.completePurchase(purchase);
        }
      }

      if (purchase.status == PurchaseStatus.canceled) {
        setSubscriptionProcessStatus(status: false);
      }

      if (purchase.status == PurchaseStatus.error) {
        Logger.error("Purchase error: ${purchase.error}");
      }
    }
  }

  Future<void> buy({
    required SubscriptionEnum tier,
    required BuildContext context,
  }) async {
    await SubscriptionService.instance.buy(tier: tier, context: context);
    notifyListeners();
  }

  Future<void> cancel(SubscriptionEnum tier) async {
    _activeSubscriptions.remove(tier);
    notifyListeners();
  }

  @override
  void dispose() {
    _purchaseSub?.cancel();
    super.dispose();
  }
}
