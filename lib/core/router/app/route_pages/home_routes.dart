import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/screens/home/classic_form_guide/mobile/speed_maps_screen.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/ask_puntgpt_screen.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/home_screen.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/manage_saved_search.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/saved_search_screen.dart';
import 'package:puntgpt_nick/screens/home/classic_form_guide/mobile/selected_meeting_screen.dart';
import 'package:puntgpt_nick/screens/home/classic_form_guide/mobile/tips_and_analysis_screen.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/runners_screen.dart';

class DashBoardRoutes {
  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      name: AppRoutes.homeScreen.name,
      path: AppRoutes.homeScreen.path,
      builder: (BuildContext context, GoRouterState state) {
        return HomeScreen();
      },
    ),
    GoRoute(
      name: AppRoutes.savedSearchedScreen.name,
      path: AppRoutes.savedSearchedScreen.path,
      builder: (context, state) {
        return SavedSearchScreen();
      },
    ),
    GoRoute(
      name: AppRoutes.searchDetails.name,
      path: AppRoutes.searchDetails.path,
      builder: (BuildContext context, GoRouterState state) {
        return SearchDetailScreen();
      },
    ),
    GoRoute(
      name: AppRoutes.askPuntGpt.name,
      path: AppRoutes.askPuntGpt.path,
      builder: (BuildContext context, GoRouterState state) {
        return AskPuntGptScreen();
      },
    ),
    GoRoute(
      name: AppRoutes.selectedRace.name,
      path: AppRoutes.selectedRace.path,
      builder: (BuildContext context, GoRouterState state) {
        return SelectedMeetingScreen();
      },
    ),
    GoRoute(
      name: AppRoutes.runnersScreen.name,
      path: AppRoutes.runnersScreen.path,
      builder: (BuildContext context, GoRouterState state) {
        // final runnerData = state.extra != null
        //     ? state.extra as RunnerDataModel
        //     : null;
        return RunnersListScreen();
      },
    ),
    GoRoute(
      name: AppRoutes.tipsAndAnalysis.name,
      path: AppRoutes.tipsAndAnalysis.path,
      builder: (BuildContext context, GoRouterState state) {
        return TipAndAnalysisScreen();
      },
    ),
    GoRoute(
      name: AppRoutes.speedMaps.name,
      path: AppRoutes.speedMaps.path,
      builder: (BuildContext context, GoRouterState state) {
        return SpeedMapsScreen();
      },
    ),
  ];
}
