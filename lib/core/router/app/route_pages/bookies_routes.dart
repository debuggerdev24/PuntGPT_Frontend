import 'package:go_router/go_router.dart';
import 'package:puntgpt_nick/core/router/app/app_routes.dart';
import 'package:puntgpt_nick/screens/bookies/mobile/bookies_screen.dart';

class BookiesRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.bookies.path,
      name: AppRoutes.bookies.name,
      builder: (context, state) => BookiesScreen(),
    ),
  ];
}
