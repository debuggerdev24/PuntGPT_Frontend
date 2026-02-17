import 'package:go_router/go_router.dart';
import 'package:puntgpt_nick/core/router/app/app_routes.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/club_chat_screen.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/punt_club_screen.dart';

class PuntClubRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.puntGptClub.path,
      name: AppRoutes.puntGptClub.name,
      builder: (context, state) => PunterClubScreen(),
    ),
    GoRoute(
      path: AppRoutes.punterClubChatScreen.path,
      name: AppRoutes.punterClubChatScreen.name,
      builder: (context, state) =>
          PuntClubChatScreen(title: state.extra as String),
    ),
  ];
}
