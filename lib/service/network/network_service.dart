import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/main.dart';

Future<void> checkConnectivity({required BuildContext context}) async {
  Connectivity().onConnectivityChanged.listen((
    List<ConnectivityResult> results,
  ) {
    if (results.contains(ConnectivityResult.none)) {
      isNetworkConnected.value = false;
    } else {
      isNetworkConnected.value = true;
    }
    Logger.info("Network Connection : ${isNetworkConnected.value}");
  });
}
