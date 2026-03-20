import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/account/account_provider.dart';
import 'package:puntgpt_nick/provider/home/classic_form/classic_form_provider.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';

class AppStartupCoordinator {
  AppStartupCoordinator._();

  static Future<void> run({required BuildContext context}) async {
    final accountProvider = context.read<AccountProvider>();
    final searchEngineProvider = context.read<SearchEngineProvider>();
    final classicFormGuideProvider = context.read<ClassicFormProvider>();
    final puntClubProvider = context.read<PuntClubProvider>();
    final subsProvider = context.read<SubscriptionProvider>();

    final futures = <Future<dynamic>>[
      subsProvider.initialize(context: context),
      // subsProvider.getCurrentSubscription(),
      accountProvider.getProfile(),
      subsProvider.getSubscriptionPlans(),
      searchEngineProvider.getTrackDetails(),
      searchEngineProvider.getDistanceDetails(),
      searchEngineProvider.getBarrierDetails(),
      classicFormGuideProvider.getClassicFormGuide(),
      classicFormGuideProvider.getNextToGo(),
      puntClubProvider.getNotifications(),
      searchEngineProvider.getAllTipSlips(),
    ];

    await Future.wait(futures);
  }
}
