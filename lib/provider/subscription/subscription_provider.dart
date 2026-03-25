import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/models/account/subscription_plan_model.dart';
import 'package:puntgpt_nick/screens/dashboard/mobile/dashboard.dart'
    show indexOfTab;
import 'package:puntgpt_nick/screens/dashboard/web/web_dashboard.dart'
    show indexOfWebTab;
import 'package:puntgpt_nick/services/app_startup/app_startup_coordinator.dart';
import 'package:puntgpt_nick/services/subscription/subscription_api_service.dart';
import 'package:puntgpt_nick/services/subscription/subscription_platform_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionProvider extends ChangeNotifier {
  SubscriptionPlanModel? currentPlan;
  SubscriptionEnum? tier;
  final Set<SubscriptionEnum> activeSubscriptions = {};

  bool _isSubscriptionProcessing = false;
  bool get isSubscriptionProcessing => _isSubscriptionProcessing;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;
  String _appAccountToken = "";

  //* When true, [initiateSubscription] does not toggle [isSubscriptionProcessing] (used during startup restore).
  bool _silentSubscriptionFlow = false;

  List<SubscriptionPlanModel> plans = [];
  int selectedPlanId = 0;
  bool _isShowCurrentPlan = false,
      _isShowSelectedPlan = false,
      _showPurchaseSuccessToast = true;

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

  /*
  bool get isMonthlyPlanSubscribed =>
      _activeSubscriptions.contains(SubscriptionEnum.monthlyPlan);
  bool get isAnnualPlanSubscribed =>
      _activeSubscriptions.contains(SubscriptionEnum.annualPlan);
  bool get isLifeTimePlanSubscribed =>
      _activeSubscriptions.contains(SubscriptionEnum.lifeTimePlan);
  */
  bool get isSubscribed => activeSubscriptions.isNotEmpty;

  // Set<SubscriptionEnum> get activeSubscriptions => {..._activeSubscriptions};

  void setSubscriptionProcessStatus({required bool status}) {
    _isSubscriptionProcessing = status;
    notifyListeners();
  }

  void addSubscription(SubscriptionEnum tier) {
    activeSubscriptions.add(tier);
    notifyListeners();
  }

  void removeSubscription(SubscriptionEnum tier) {
    activeSubscriptions.remove(tier);
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
    if (purchases.isNotEmpty) {
      Logger.info(
        "Purchase stream: ${purchases.length} update(s), "
        "ids=${purchases.map((p) => '${p.productID}:${p.status.name}').join(', ')}",
      );
    }
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

  //* Purchased purchase
  void _handlePurchaseStatusPurchased(PurchaseDetails purchase) {
    _processSuccessfulPurchase(purchase);
  }

  //* Restored purchase
  void _handlePurchaseStatusRestored(PurchaseDetails purchase) {
    Logger.info(
      "_handlePurchaseStatusRestored: Purchase restored: ${purchase.productID}",
    );

    final planId = planIdFromProductId(purchase.productID);
    if (planId == null) {
      Logger.error(
        "Restore: planId missing for ${purchase.productID}; check plans loaded.",
      );
      return;
    }

    _showPurchaseSuccessToast = false;
    initiateSubscription(
      planId: planId,
      silent: _silentSubscriptionFlow,
      onSuccess: (appAccountToken) => _processSuccessfulPurchase(purchase),
      onFailed: (error) {
        Logger.error("initiateSubscription on restore failed: $error");

        // removeSubscription(tier);
      },
    );
  }

  //* Called after getSubscriptionPlans so [planByProductId] works. No loading overlay / toasts.
  Future<void> restorePurchasesAtStartup({
    required BuildContext context,
  }) async {
    if (isGuest) return;
    try {
      _silentSubscriptionFlow = true;
      Logger.info("Start up restore: querying store");
      await SubscriptionService.instance.restorePurchases();
    } catch (e, st) {
      Logger.error("restorePurchasesAtStartup : $e\n$st");
    } finally {
      _silentSubscriptionFlow = false;
    }
  }

  //* Buy a subscription plan
  Future<void> buy({
    required SubscriptionEnum tier,
    required BuildContext context,
    required String appAccountToken,
  }) async {
    final ok = await SubscriptionService.instance.buy(
      tier: tier,
      appAccountToken: appAccountToken,
    );
    if (!ok) {
      setSubscriptionProcessStatus(status: false);
    }
  }

  //* Triggers store restore; purchases arrive on [purchaseStream] and are handled like new purchases.
  Future<void> restore({required BuildContext context}) async {
    setSubscriptionProcessStatus(status: true);
    notifyListeners();

    try {
      await SubscriptionService.instance.restorePurchases();
    } catch (e, st) {
      Logger.error("restorePurchases failed: $e\n$st");
      setSubscriptionProcessStatus(status: false);
      notifyListeners();
      if (context.mounted) {
        AppToast.error(
          context: context,
          message:
              "Could not contact the store. Check Play Billing / network and try again.",
        );
      }
    }
  }

  void _processSuccessfulPurchase(PurchaseDetails purchase) {
    final tier = SubscriptionService.instance.getTierFromProductId(
      purchase.productID,
    );
    if (tier != null) {
      final localData = purchase.verificationData.localVerificationData;
      final serverData = purchase.verificationData.serverVerificationData;
      final decoded = jsonDecode(localData);
      // final decodedServer = jsonDecode(serverData);

      Logger.info("serverVerificationData : $serverData");
      Logger.info("Decode data : $decoded");

      String? backendValidationToken;
      //* Process the verification data based on the platform.
      switch (Platform.operatingSystem) {
        case "android":
          //* Android localVerificationData is a JSON string.
          try {
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

      //* Validate the subscription in the backend
      validateSubscription(token: tokenForValidation);

      if (purchase.pendingCompletePurchase) {
        SubscriptionService.instance.completePurchase(purchase);
      }
    } else {
      Logger.error(
        "Subscription tier not found for productID=${purchase.productID}",
      );
      setSubscriptionProcessStatus(status: false);
      notifyListeners();
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
    //* Purchase still processing; no action until status updates.
  }

  //*------------- Subscriptions APIs functions --------------------------------
  Future<void> getSubscriptionPlans() async {
    plans = [];
    final result = await SubscriptionApiService.instance.getSubscriptionPlans();
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        final data = r["data"] as List;
        plans = data.map((e) => SubscriptionPlanModel.fromJson(e)).toList();
        //*removing mug punter account according to the client requirement
        plans.removeAt(0);
        notifyListeners();
      },
    );
  }

  Future<bool> getCurrentSubscription() async {
    currentPlan = null;
    activeSubscriptions.clear();
    bool hasActiveSubscription = false;
    final result = await SubscriptionApiService.instance
        .getCurrentSubscription();
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        final data = r["data"];
        if (data is Map && data["product_id"] != null) {
          hasActiveSubscription = true;
          final plan = _planById(data["plan_id"]);
          final tier = SubscriptionService.instance.getTierFromProductId(
            data["product_id"] as String,
          );
          if (plan != null && tier != null) {
            currentPlan = plan;
            addSubscription(tier);
            notifyListeners();
          }
        } else {
          Logger.error("Current subscription not found");
        }
      },
    );
    return hasActiveSubscription;
  }

  SubscriptionPlanModel? _planById(dynamic id) {
    if (id == null) return null;
    for (final p in plans) {
      if (p.id == id) return p;
    }
    return null;
  }

  SubscriptionPlanModel? planByProductId(String productId) {
    if (productId.isEmpty) return null;
    for (final p in plans) {
      if (p.productIdAndroid == productId || p.productIdIos == productId) {
        return p;
      }
    }
    return null;
  }

  //* Backend `plan_id` for APIs such as [initiateSubscription].
  int? planIdFromProductId(String productId) => planByProductId(productId)?.id;

  //* Build context for startup.
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
      //* If the shell is available, navigate to the home screen.
      if (kIsWeb) {
        //* Web [WebRouter] shell: index 2 = home / search (0=bookies, 1=punter club).
        indexOfWebTab.value = 2;
        WebRouter.indexedStackNavigationShell?.goBranch(
          2,
          initialLocation: true,
        );
      } else {
        //* Mobile [AppRouter] shell: index 0 = home.
        indexOfTab.value = 0;
        AppRouter.indexedStackNavigationShell?.goBranch(
          0,
          initialLocation: true,
        );
      }
    } else {
      //* If the shell is not available, navigate to the home screen.
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

      await AppStartupCoordinator.run(
        context: ctx,
        callRestore: false,
        shouldCallAllContent: !_silentSubscriptionFlow,
      );

      if (!ctx.mounted) return;

      if (_showPurchaseSuccessToast) {
        AppToast.success(
          context: ctx,
          message: '${dataMap["plan"]} subscribed successfully.',
        );
      }
      _showPurchaseSuccessToast = true;
    });
    setSubscriptionProcessStatus(status: false);
  }

  //* Initiate a subscription
  Future<void> initiateSubscription({
    required int planId,
    Function(String error)? onFailed,
    Function(String appAccountToken)? onSuccess,
    bool silent = false,
  }) async {
    if (!silent) {
      setSubscriptionProcessStatus(status: true);
      Logger.info("Subscription restored successfully.");
    }

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
        if (msg.contains("already subscribed")) {
          onFailed?.call(l.errorMsg);
        } else {
          Logger.error(l.errorMsg);
        }
        if (!silent) setSubscriptionProcessStatus(status: false);
      },
      (r) {
        _appAccountToken = r["data"]["app_account_token"] as String? ?? "";
        // Logger.info("appAccountToken: $_appAccountToken");
        onSuccess?.call(_appAccountToken);
      },
    );
  }

  //* Validate the subscription
  Future<void> validateSubscription({
    required String token,
    SubscriptionEnum? rollbackTierOnFailure,
  }) async {
    void rollbackIfNeeded() {
      final t = rollbackTierOnFailure;
      if (t != null) removeSubscription(t);
    }

    if (token.isEmpty) {
      Logger.error("validateSubscription: empty token");
      setSubscriptionProcessStatus(status: false);
      rollbackIfNeeded();
      notifyListeners();
      return;
    }

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
        rollbackIfNeeded();
        notifyListeners();
      },
      (r) async {
        final ok = r['success'] == true;
        if (!ok) {
          Logger.error('validateSubscription: success flag is false');
          setSubscriptionProcessStatus(status: false);
          rollbackIfNeeded();
          final ctx = AppRouter.rootNavigatorKey.currentContext;
          if (ctx != null && ctx.mounted) {
            AppToast.error(
              context: ctx,
              message: "Subscription could not be validated. Please try again.",
            );
          }
          notifyListeners();
          return;
        }
        await _afterSubscriptionValidatedSuccess(response: r);
      },
    );
  }

  //* Cancel the subscription
  bool isCancelSubscriptionLoading = false;
  Future<void> cnacelSubcripton({
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    if (Platform.isIOS) {
      final url = Uri.parse("https://apps.apple.com/account/subscriptions");
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        AppToast.error(
          context: context,
          message: "Could not open App Store subscription management.",
        );
      }
      return;
    }

    if (!Platform.isAndroid) return;

    isCancelSubscriptionLoading = true;
    notifyListeners();

    final result = await SubscriptionApiService.instance.cancelSubscription();
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        // final success = r["success"] == true;
        // if (!success) {
        //   final msg =
        //       r["message"]?.toString() ??
        //       "Could not cancel subscription. Please try again.";
        //   if (context.mounted) {
        //     AppToast.error(context: context, message: msg);
        //   }
        //   return;
        // }

        // currentPlan = null;
        // notifyListeners();
        onSuccess.call();
      },
    );

    isCancelSubscriptionLoading = false;
    notifyListeners();
  }

  // Future<void> cancel(SubscriptionEnum tier) async {
  //   _activeSubscriptions.remove(tier);
  //   notifyListeners();
  // }

  @override
  void dispose() {
    _purchaseSub?.cancel();
    super.dispose();
  }
}
