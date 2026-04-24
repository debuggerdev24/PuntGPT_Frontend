import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/screens/home/classic_form_guide/mobile/speed_maps_screen.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/ask_puntgpt_screen.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/home_screen.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/manage_saved_search.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/saved_search_screen.dart';
import 'package:puntgpt_nick/screens/home/classic_form_guide/mobile/selected_meeting_screen.dart';
import 'package:puntgpt_nick/screens/home/classic_form_guide/mobile/tips_and_analysis_screen.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/upcoming_runners_screen.dart';
import 'package:puntgpt_nick/screens/home/story/create_new_story_section.dart';
import 'package:puntgpt_nick/screens/home/story/edit_option_screen.dart';
import 'package:puntgpt_nick/screens/home/story/bookie_selection_screen.dart';
import 'package:puntgpt_nick/screens/home/story/delete_story_content.dart';
import 'package:puntgpt_nick/screens/home/story/upload_story_content.dart';
import 'package:puntgpt_nick/screens/home/story/update_story_data.dart';

class HomeRoutes {
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
    GoRoute(
      name: AppRoutes.bookieSelection.name,
      path: AppRoutes.bookieSelection.path,
      builder: (BuildContext context, GoRouterState state) {
        return BookieSelectionScreen();
      },
    ),
    GoRoute(
      name: AppRoutes.editStoryOption.name,
      path: AppRoutes.editStoryOption.path,
      builder: (BuildContext context, GoRouterState state) {
        return EditStoryOptionScreen();
      },
    ),
    GoRoute(
      name: AppRoutes.uploadStoryContent.name,
      path: AppRoutes.uploadStoryContent.path,
      builder: (BuildContext context, GoRouterState state) {
        return UploadStoryContent();
      },
    ),
    GoRoute(
      name: AppRoutes.uploadStoryData.name,
      path: AppRoutes.uploadStoryData.path,
      builder: (BuildContext context, GoRouterState state) {
        return UploadStoryData();
      },
    ),
    GoRoute(
      name: AppRoutes.deleteStoryContent.name,
      path: AppRoutes.deleteStoryContent.path,
      builder: (BuildContext context, GoRouterState state) {
        return const DeleteStoryContent();
      },
    ),
    GoRoute(
      name: AppRoutes.createNewStorySection.name,
      path: AppRoutes.createNewStorySection.path,
      builder: (BuildContext context, GoRouterState state) {
        return CreateNewStorySection();
      },
    ),
  ];
}
