import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:puntgpt_nick/core/app_imports.dart';

class SubscriptionService {
  SubscriptionService._();
  static final SubscriptionService instance = SubscriptionService._();

  final InAppPurchase _iap = InAppPurchase.instance;

  // todo Mock product IDs for now
  static const Map<SubscriptionEnum, String> productIds = {
    SubscriptionEnum.monthlyPlan: "com.puntgpt.propunter.monthly",
    SubscriptionEnum.annualPlan: "com.puntgpt.propunter.yearly",
    // AppEnum.yearlyPlan: "mock.tier3.monthly",
  };

  List<ProductDetails> _products = [];

  /// Purchase stream for the provider to listen to.
  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  // ---------------------------------------------------------------------------
  // INITIALIZE
  // ---------------------------------------------------------------------------
  Future<void> initialize({required BuildContext context}) async {
    Logger.info("initializing subscription");
    final available = await _iap.isAvailable();
    Logger.info(available.toString());
    if (!available) {
      Logger.info("Store not available");
      return;
    }
    if (!context.mounted) return;

    await loadProducts(context: context);
  }

  /// Maps a store product ID to [SubscriptionEnum]. Used by the provider when handling purchases.
  SubscriptionEnum? getTierFromProductId(String productId) {
    try {
      return productIds.entries.firstWhere((e) => e.value == productId).key;
    } catch (_) {
      return null;
    }
  }

  /// Completes a purchase on the store. Call from provider after handling the purchase.
  void completePurchase(PurchaseDetails purchase) {
    _iap.completePurchase(purchase);
  }

  Future<void> loadProducts({required BuildContext context}) async {
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
      Logger.info("Products loaded: ${product.id}");
      Logger.info("Products loaded: ${product.title}");
      Logger.info("Products loaded: ${product.price}");
    }
  }

  //* BUY (CALLED BY PROVIDER)

  Future<bool> buy({
    required SubscriptionEnum tier,
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
  // CANCEL (CALLED BY PROVIDER)
  // ---------------------------------------------------------------------------
  Future<bool> cancel({required SubscriptionEnum tier}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
