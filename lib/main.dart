import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:puntgpt_nick/punt_gpt_app.dart';
import 'package:puntgpt_nick/services/storage/locale_storage_service.dart';
import 'package:toastification/toastification.dart';

ValueNotifier<bool> isNetworkConnected = ValueNotifier(true);
bool isGuest = false;

Future<void> main() async {
  print("STEP 1");
  WidgetsFlutterBinding.ensureInitialized();
  print("STEP 2");
  await dotenv.load(fileName: ".env");
  print("STEP 3");
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  print("STEP 4");
  await Future.wait([LocaleStorageService.init()]);
  print("STEP 5");
  runApp(ToastificationWrapper(child: const PuntGPT()));
}
/*
http://192.168.1.100:5000
flutter run --release -d web-server --web-port=5000 --web-hostname=0.0.0.0

*/