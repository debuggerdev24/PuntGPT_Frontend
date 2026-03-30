import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/provider/account/account_provider.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';

class AppStartupCoordinator {
  AppStartupCoordinator._();

  static Future<void> loadContent({required BuildContext context}) async {
    final accountProvider = context.read<AccountProvider>();
    final searchEngineProvider = context.read<SearchEngineProvider>();
    final puntClubProvider = context.read<PuntClubProvider>();

    await Future.wait(<Future<dynamic>>[
      if (!isGuest) accountProvider.getProfile(),
      searchEngineProvider.getTrackList(),
      searchEngineProvider.getDistanceDetails(),
      searchEngineProvider.getBarrierDetails(),
      puntClubProvider.getNotifications(),
      searchEngineProvider.getAllTipSlips(),
    ]);
  }

  static Future<void> run({
    required BuildContext context,
    bool? callRestore,
    bool? shouldCallAllContent,
  }) async {
    if (shouldCallAllContent ?? true) {
      final subsProvider = context.read<SubscriptionProvider>();

      //* Get the current subscription
      final hasActiveSubscription = await subsProvider.getCurrentSubscription();

      if (!isGuest && (callRestore ?? true)) {
        if (!hasActiveSubscription) {
          await subsProvider.restorePurchasesAtStartup(context: context);
        }
      }
    }
  }
}
