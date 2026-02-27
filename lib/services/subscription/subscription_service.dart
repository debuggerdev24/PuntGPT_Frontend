import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';

class SubscriptionService {
  SubscriptionService._();
  static final SubscriptionService instance = SubscriptionService._();

  final InAppPurchase _iap = InAppPurchase.instance;

  // todo Mock product IDs for now
  static const Map<AppEnum, String> productIds = {
    AppEnum.monthlyPlan: "com.monthlyPlan",
    AppEnum.yearlyPlan: "com.yearlyPlan",
    // AppEnum.yearlyPlan: "mock.tier3.monthly",
  };

  List<ProductDetails> _products = [];
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  // ---------------------------------------------------------------------------
  // INITIALIZE
  // ---------------------------------------------------------------------------
  Future<void> initialize({
    required SubscriptionProvider provider,
    required BuildContext context,
  }) async {
    Logger.info("initializing subscription");
    final available = await _iap.isAvailable();
    Logger.info(available.toString());
    if (!available) {
      Logger.info("Store not available");
      return;
    }
    if (!context.mounted) return;

    await _loadProducts(context: context);

    _purchaseSub = _iap.purchaseStream.listen(
      (purchases) => _handlePurchases(purchases, provider),
      onError: (e) => Logger.error("Error inside the listener ${e.toString()}"),
    );
  }

  Future<void> _loadProducts({required BuildContext context}) async {
    final response = await _iap.queryProductDetails(productIds.values.toSet());

    Logger.info("load products");

    try {
      _products = response.productDetails;
    } catch (e) {
      Logger.error(e.toString());
    }

    Logger.info("I am here");

    for (var product in _products) {
      if (!context.mounted) return;

      AppToast.success(
        context: context,
        message: "Product is ${product.title}",
      );
      Logger.info("Products loaded: ${product.id}");
      Logger.info("Products loaded: ${product.title}");
      Logger.info("Products loaded: ${product.price}");
    }
  }

  // ---------------------------------------------------------------------------
  // BUY (CALLED BY PROVIDER)
  // ---------------------------------------------------------------------------
  Future<bool> buy({
    required AppEnum tier,
    required BuildContext context,
  }) async {
    try {
      final productId = productIds[tier];
      final product = _products.firstWhere(
        (p) => p.id == productId,
        orElse: () => throw Exception("Product not found"),
      );

      final param = PurchaseParam(productDetails: product);

      await _iap.buyNonConsumable(purchaseParam: param);
      return true;
    } catch (e, s) {
      if (context.mounted) {
        AppToast.error(context: context, message: "Buy error: $e\n$s");
      }

      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // HANDLE STORE CALLBACKS (NOTIFY PROVIDER)
  // ---------------------------------------------------------------------------
  Future<void> _handlePurchases(
    List<PurchaseDetails> purchases,
    SubscriptionProvider provider,
  ) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        final tier = _mapProductToTier(purchase.productID);
        if (tier != null) {
          String serverVerificationData = "";
          final localData = purchase.verificationData.localVerificationData;
          final serverData = purchase.verificationData.serverVerificationData;
          final localDecodedData = jsonDecode(localData);
          Logger.info("Decode data : $localDecodedData");
          Logger.info("serverVerificationData : $serverData");
          if (Platform.isAndroid) {
            serverVerificationData = localDecodedData["purchaseToken"];
            Logger.info(
              "Purchase Token For Android: \n$serverVerificationData",
            );
          } else if (Platform.isIOS) {
            serverVerificationData = localDecodedData["transactionId"];
            Logger.info("Transaction Id For iOS: \n$serverVerificationData");
          }
          // provider.addSubscription(tier);
        }
        _iap.completePurchase(purchase);
      }

      if (purchase.status == PurchaseStatus.canceled) {
        provider.setSubscriptionProcessStatus(status: false);
      }

      if (purchase.status == PurchaseStatus.error) {
        Logger.error("Purchase error: ${purchase.error}");
      }
    }
  }

  AppEnum? _mapProductToTier(String id) {
    try {
      return productIds.entries.firstWhere((e) => e.value == id).key;
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // CANCEL (CALLED BY PROVIDER)
  // ---------------------------------------------------------------------------
  Future<bool> cancel({required AppEnum tier}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  void dispose() {
    _purchaseSub?.cancel();
  }
}
