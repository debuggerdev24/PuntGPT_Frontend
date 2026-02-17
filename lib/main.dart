import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puntgpt_nick/core/constants/constants.dart';
import 'package:puntgpt_nick/core/router/web/web_router.dart';
import 'package:puntgpt_nick/provider/account/account_provider.dart';
import 'package:puntgpt_nick/provider/auth/auth_provider.dart';
import 'package:puntgpt_nick/provider/punt_club/punter_club_provider.dart';
import 'package:puntgpt_nick/provider/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';
import 'package:puntgpt_nick/service/network/network_service.dart';
import 'package:puntgpt_nick/service/storage/locale_storage_service.dart';
import 'package:toastification/toastification.dart';

import 'core/router/app/app_router.dart';

ValueNotifier<bool> isNetworkConnected = ValueNotifier(true);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Future.wait([LocaleStorageService.init()]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemStatusBarContrastEnforced: false,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(ToastificationWrapper(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    checkConnectivity(context: context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => SearchEngineProvider()),
          ChangeNotifierProvider(create: (context) => AccountProvider()),
          ChangeNotifierProvider(create: (context) => PunterClubProvider()),
          ChangeNotifierProvider(create: (context) => SubscriptionProvider()),
        ],
        
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: AppColors.primary, // Your desired color
            systemStatusBarContrastEnforced: false, // Critical for Android 13+
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.black,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child: ScreenUtilInit(
            minTextAdapt: true,
            splitScreenMode: true,
            designSize: (context.isPhysicalMobile)
                ? Size(430, 932)
                : Size(1440, 824),
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.appThemeData,
              routerConfig: (kIsWeb) ? WebRouter.router : AppRouter.router,
            ),
          ),
        ),
      ),
    );
  }
}

// eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzY3MDgxNDUzLCJpYXQiOjE3NjcwMDk0NTMsImp0aSI6IjRmYWI1NzYzYTk2YjRkZWQ4YzUwOTgwZDQ1YTZjNmFmIiwidXNlcl9pZCI6IjMifQ.CngkGuLvXKSJPf0iMxqIb86Mp4aortWuZ-x8Ko3Ci8s

/*

todo Joseph


todo Nick


name: "Custom Name 3",
filters: {
track: Flemington
placed_last_start: true
placed_at_distance: 0 - 1000m
placed_at_track: 0 - 1000m
odds_range: 2
wins_at_track: Adaminaby
win_at_distance:0 - 1000m
won_last_start: true
won_last_12_months: true
jockey_horse_wins: 1
barrier: 1 - 3
jockey_strike_rate_last_12_months: ""
},
"comment": Custom comment
}


//! NOTE: top bar        // Blue
//? QUESTION: why here  // Green

//* IMPORTANT           // Yellow
// TODO: refactor       // Default todo
// FIXME: crash issue   // Red


 */


 */
// eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzcwMzQyNjI0LCJpYXQiOjE3NzAyNzA2MjQsImp0aSI6IjZiZTNjZDk4MWJmZTQ1ZmNiOWYzNzFjYzFjZWI4NTg2IiwidXNlcl9pZCI6IjEyIn0.tGc7GDTFWzOYOOf_osADeFAC3oN0bYbay9fFPi7a3P4
// flutter run --release -d web-server --web-port=5000 --web-hostname=0.0.0.0
// http://192.168.1.94:5000/
