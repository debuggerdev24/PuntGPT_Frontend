import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:puntgpt_nick/punt_gpt_app.dart';
import 'package:puntgpt_nick/services/storage/locale_storage_service.dart';
import 'package:toastification/toastification.dart';

ValueNotifier<bool> isNetworkConnected = ValueNotifier(true);
bool isGuest = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Future.wait([LocaleStorageService.init()]);
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     systemStatusBarContrastEnforced: false,
  //     statusBarIconBrightness: Brightness.light,
  //     statusBarBrightness: Brightness.dark,
  //   ),
  // );
  runApp(ToastificationWrapper(child: const PuntGPTApp()));
}
/*
-> Worked on creating custom widgets and imoprove code efficiency.
-> Worked on upgrade the stats list.
-> Worked on fix the country selection regarding issue.
-> Worked on fix the status bar's UI regardingissue and show the icons proeprly.
-> Worked on 
-> Worked on 
-> Worked on 
-> Worked on 
*/