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

  runApp(ToastificationWrapper(child: const PuntGPTApp()));
}
/*
-> Worked on update the lay out for the default question in the chat with AI screen.
-> Worked on modify the track list based on jump type.
-> Worked on added the logic to remove unnecessary API calls for the track list.
-> Worked on modify the lay out of the runner box and make it as per reqiurements.
-> Worked on update the tipslip model and added new attributes and display them.
-> Worked on display the user friendly color combination in the chat bubble.
-> Worked on update the lay out of the chat bubble and and make it like other platform.
-> Worked on 
*/