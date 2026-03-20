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
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemStatusBarContrastEnforced: false,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(ToastificationWrapper(child: const PuntGPTApp()));
}
/*

eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzcwMzQyNjI0LCJpYXQiOjE3NzAyNzA2MjQsImp0aSI6IjZiZTNjZDk4MWJmZTQ1ZmNiOWYzNzFjYzFjZWI4NTg2IiwidXNlcl9pZCI6IjEyIn0.tGc7GDTFWzOYOOf_osADeFAC3oN0bYbay9fFPi7a3P4
flutter run --release -d web-server --web-port=5000 --web-hostname=0.0.0.0
http://192.168.1.94:5000/

*/