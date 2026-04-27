import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/provider/account/account_provider.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/provider/home/story/story_provider.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';

class AppStartupCoordinator {
  AppStartupCoordinator._();

  /// Subscription init + plans, then subscription restore flow, then parallel content loads.
  /// Call from mobile and web dashboard after first frame; **do not reorder** these awaits.
  static Future<void> startup({required BuildContext context}) async {
    final subsProvider = context.read<SubscriptionProvider>();

    //* IAP listener must run before restore; plans must load before productId → planId mapping.
    await subsProvider.initialize(context: context);
    await subsProvider.getSubscriptionPlans();

    await checkSubscriptionStatus(context: context);
    await loadContent(context: context);
  }

  static Future<void> loadContent({required BuildContext context}) async {
    final accountProvider = context.read<AccountProvider>();
    final searchEngineProvider = context.read<SearchEngineProvider>();
    final puntClubProvider = context.read<PuntClubProvider>();
    final storyProvider = context.read<StoryProvider>();

    await Future.wait(<Future<dynamic>>[
      if (!isGuest) accountProvider.getProfile(),
      searchEngineProvider.getTrackList(),
      searchEngineProvider.getDistanceDetails(),
      searchEngineProvider.getBarrierDetails(),
      puntClubProvider.getNotifications(),
      puntClubProvider.getChatGroups(),
      searchEngineProvider.getAllTipSlips(),
      storyProvider.getStories(),
    ]);
  }

  static Future<void> checkSubscriptionStatus({
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
