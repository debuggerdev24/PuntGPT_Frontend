import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/account/subscription_plan_model.dart';
import 'package:puntgpt_nick/screens/dashboard/mobile/dashboard.dart'
    show indexOfTab;
import 'package:puntgpt_nick/screens/dashboard/web/web_dashboard.dart'
    show indexOfWebTab;
import 'package:puntgpt_nick/services/app_startup/app_startup_coordinator.dart';
import 'package:puntgpt_nick/services/subscription/subscription_api_service.dart';
import 'package:puntgpt_nick/services/subscription/subscription_platform_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  SubscriptionPlanModel? currentPlan;
  SubscriptionEnum? tier;
  final Set<SubscriptionEnum> _activeSubscriptions = {
    // SubscriptionEnum.monthlyPlan,
  };

  bool _isSubscriptionProcessing = false;
  bool get isSubscriptionProcessing => _isSubscriptionProcessing;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  List<SubscriptionPlanModel> plans = [];
  int selectedPlanId = 0;
  bool _isShowCurrentPlan = false;
  bool _isShowSelectedPlan = false;

  bool get showCurrentPlan => _isShowCurrentPlan;
  bool get showSelectedPlan => _isShowSelectedPlan;

  void setIsShowSelectedPlan({required bool showSelectedPlan, int? planIndex}) {
    _isShowSelectedPlan = showSelectedPlan;
    if (planIndex != null) selectedPlanId = planIndex;
    notifyListeners();
  }

  set setIsShowCurrentPlan(bool value) {
    _isShowCurrentPlan = value;
    notifyListeners();
  }

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
      onError: (e) {
        Logger.error("Subscription purchase stream error: ${e.toString()}");
        setSubscriptionProcessStatus(status: false);
      },
    );
  }

  //* Handles the purchase statuses.
  void _handlePurchases(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
          _handlePurchaseStatusPurchased(purchase);
        case PurchaseStatus.restored:
          _handlePurchaseStatusRestored(purchase);
        case PurchaseStatus.canceled:
          _handlePurchaseStatusCanceled(purchase);
        case PurchaseStatus.error:
          _handlePurchaseStatusError(purchase);
        case PurchaseStatus.pending:
          _handlePurchaseStatusPending(purchase);
      }
    }
  }

  void _handlePurchaseStatusPurchased(PurchaseDetails purchase) {
    _processSuccessfulPurchase(purchase);
  }

  void _handlePurchaseStatusRestored(PurchaseDetails purchase) {
    _processSuccessfulPurchase(purchase);
  }

  //* Buy a subscription plan
  Future<void> buy({
    required SubscriptionEnum tier,
    required BuildContext context,
  }) async {
    final ok = await SubscriptionService.instance.buy(tier: tier);
    if (!ok) {
      setSubscriptionProcessStatus(status: false);
    }
  }

  void _processSuccessfulPurchase(PurchaseDetails purchase) {
    final tier = SubscriptionService.instance.getTierFromProductId(
      purchase.productID,
    );
    if (tier != null) {
      final localData = purchase.verificationData.localVerificationData;
      final serverData = purchase.verificationData.serverVerificationData;
      Logger.info("serverVerificationData : $serverData");
      String? backendValidationToken;
      //* Process the verification data based on the platform.
      switch (Platform.operatingSystem) {
        case "android":
          //* Android localVerificationData is a JSON string.

          try {
            final decoded = jsonDecode(localData);
            Logger.info("Decode data : $decoded");
            backendValidationToken = decoded["purchaseToken"] as String?;
            Logger.info(
              "\nPurchase Token For Android: ${backendValidationToken.toString()}\n",
            );
          } catch (e) {
            Logger.error("Android localVerificationData decode failed: $e");
          }
        case "ios":
          //* iOS localVerificationData can be a receipt string (not JSON).
          try {
            final decoded = jsonDecode(localData);
            Logger.info("Decode data : $decoded");
            if (decoded is Map) {
              backendValidationToken = decoded["transactionId"]?.toString();
            }
          } catch (_) {
            Logger.error("iOS localVerificationData decode failed");
          }

          Logger.info("Transaction Id For iOS: \n$backendValidationToken");
        default:
          break;
      }

      final tokenForValidation = switch (backendValidationToken) {
        final t? when t.isNotEmpty => t,
        _ => '',
      };

      validateSubscription(token: tokenForValidation);

      if (purchase.pendingCompletePurchase) {
        SubscriptionService.instance.completePurchase(purchase);
      }
    } else {
      Logger.error("Subscription tier not found");
    }
  }

  void _handlePurchaseStatusCanceled(PurchaseDetails purchase) {
    setSubscriptionProcessStatus(status: false);
    final ctx = AppRouter.rootNavigatorKey.currentContext;
    if (ctx != null && ctx.mounted) {
      AppToast.info(context: ctx, message: "Purchase canceled");
    }
  }

  void _handlePurchaseStatusError(PurchaseDetails purchase) {
    Logger.error("Purchase error: ${purchase.error}");
    
    setSubscriptionProcessStatus(status: false);
  }

  void _handlePurchaseStatusPending(PurchaseDetails purchase) {
    // Purchase still processing; no action until status updates.
  }

  //*------------- Subscriptions APIs functions --------------------------------
  Future<void> getSubscriptionPlans() async {
    final result = await SubscriptionApiService.instance.getSubscriptionPlans();
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        final data = r["data"] as List;
        plans = data.map((e) => SubscriptionPlanModel.fromJson(e)).toList();
        getCurrentSubscription();
        notifyListeners();
      },
    );
  }

  Future<void> getCurrentSubscription() async {
    currentPlan = null;
    final result = await SubscriptionApiService.instance
        .getCurrentSubscription();
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        final data = r["data"];
        if (data is Map && data["product_id"] != null) {
          final plan = _planById(data["plan_id"]);
          final tier = SubscriptionService.instance.getTierFromProductId(
            data["product_id"] as String,
          );
          if (plan != null && tier != null) {
            currentPlan = plan;
            addSubscription(tier);
            notifyListeners();
          }
        }
      },
    );
  }

  SubscriptionPlanModel? _planById(dynamic id) {
    if (id == null) return null;
    for (final p in plans) {
      if (p.id == id) return p;
    }
    return null;
  }

  BuildContext? _shellContextForStartup() {
    final shell = kIsWeb
        ? WebRouter.indexedStackNavigationShell
        : AppRouter.indexedStackNavigationShell;
    return shell?.shellRouteContext.navigatorKey.currentContext ??
        (kIsWeb ? WebRouter.rootNavigatorKey : AppRouter.rootNavigatorKey)
            .currentContext;
  }

  Future<void> _afterSubscriptionValidatedSuccess({
    required Map<String, dynamic> response,
  }) async {
    setSubscriptionProcessStatus(status: false);

    final data = response['data'];
    final Map<String, dynamic> dataMap = data is Map<String, dynamic>
        ? data
        : <String, dynamic>{};

    final hasShell = kIsWeb
        ? WebRouter.indexedStackNavigationShell != null
        : AppRouter.indexedStackNavigationShell != null;

    if (hasShell) {
      if (kIsWeb) {
        // Web [WebRouter] shell: index 2 = home / search (0=bookies, 1=punter club).
        indexOfWebTab.value = 2;
        WebRouter.indexedStackNavigationShell?.goBranch(
          2,
          initialLocation: true,
        );
      } else {
        indexOfTab.value = 0;
        AppRouter.indexedStackNavigationShell?.goBranch(
          0,
          initialLocation: true,
        );
      }
    } else {
      final rootKey = kIsWeb
          ? WebRouter.rootNavigatorKey
          : AppRouter.rootNavigatorKey;
      final ctx = rootKey.currentContext;
      if (ctx != null && ctx.mounted) {
        ctx.goNamed(
          kIsWeb ? WebRoutes.homeScreen.name : AppRoutes.homeScreen.name,
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ctx = _shellContextForStartup();
      if (ctx == null || !ctx.mounted) return;

      try {
        await AppStartupCoordinator.run(context: ctx);
      } catch (e, st) {
        Logger.error('AppStartupCoordinator.run failed: $e\n$st');
      }

      if (!ctx.mounted) return;

      AppToast.success(
        context: ctx,
        message: '${dataMap["plan"]} subscribed successfully',
      );
    });
    setSubscriptionProcessStatus(status: false);

  }

  //*Initiate a subscription
  Future<void> initiateSubscription({
    required int planId,
    required Function(String error) onFailed,
    required VoidCallback onSuccess,
  }) async {
    setSubscriptionProcessStatus(status: true);
    final data = {
      "target_plan_id": planId,
      "platform": Platform.isAndroid ? "android" : "ios",
    };
    final result = await SubscriptionApiService.instance.initiateSubscription(
      data: data,
    );
    result.fold(
      (l) {
        final msg = l.errorMsg.toLowerCase();
        if (msg.contains('already subscribed')) {
          onSuccess();
        } else {
          setSubscriptionProcessStatus(status: false);
          onFailed(l.errorMsg);
          Logger.error(l.errorMsg);
        }
      },
      (r) {
        onSuccess();
      },
    );
  }

  Future<void> validateSubscription({required String token}) async {
    final platform = switch (Platform.operatingSystem) {
      "android" => "android",
      _ => "ios",
    };
    final tokenKey = switch (platform) {
      "android" => "purchase_token",
      _ => "transaction_id",
    };

    final data = {"platform": platform, tokenKey: token};
    final result = await SubscriptionApiService.instance.validateSubscription(
      data: data,
    );
    await result.fold<Future<void>>(
      (l) async {
        Logger.error(l.errorMsg);
        setSubscriptionProcessStatus(status: false);
      },
      (r) async {
        final ok = r['success'] == true;
        if (!ok) {
          Logger.error('validateSubscription: success flag is false');
          setSubscriptionProcessStatus(status: false);
          return;
        }
        await _afterSubscriptionValidatedSuccess(response: r);
      },
    );
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
