import 'package:flutter/material.dart';
import 'package:puntgpt_nick/core/helper/log_helper.dart';
import 'package:puntgpt_nick/service/bot/bot_api_service.dart';

class BotProvider extends ChangeNotifier {
  

  Future<void> getBotResponse() async {
    final result = await BotApiService.instance.getBotResponse(data: {});
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        final data = r["data"];

      },
    );
    notifyListeners();
  }
}