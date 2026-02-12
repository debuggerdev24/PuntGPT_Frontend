import 'package:flutter/foundation.dart';
import 'package:puntgpt_nick/core/enum/app_enums.dart';
import 'package:puntgpt_nick/core/helper/log_helper.dart';
import 'package:puntgpt_nick/core/utils/de_bouncing.dart';
import 'package:puntgpt_nick/models/classic_form_guide/classic_form_model.dart';
import 'package:puntgpt_nick/models/classic_form_guide/next_race_model.dart';
import 'package:puntgpt_nick/service/classic_form/classic_form_api_service.dart';

class ClassicFormGuideProvider extends ChangeNotifier {
  List<NextRaceModel>? _nextRaceList;
  int selectedDay = 1;
  List<ClassicFormModel>? _classicFormGuideList;
  List<MeetingRaceModel>? _meetingRaceList;
  List<ClassicFormDay> days = [
    ClassicFormDay.yesterday,
    ClassicFormDay.today,
    ClassicFormDay.tomorrow,
    ClassicFormDay.day_after_tomorrow,
  ];

  List<ClassicFormModel> get classicFormGuide => _classicFormGuideList!;

  List<NextRaceModel> get nextRaceList => _nextRaceList ?? [];


  set changeSelectedDay(int value) {
    selectedDay = value;
    deBouncer.run(() {
      getClassicFormGuide();
    });
    notifyListeners();
  }

  //* Get classic form guide
  Future<void> getClassicFormGuide() async {
    final response = await ClassicFormAPIService.instance.getClassicForm(
      jumpFilter: days[selectedDay].name,
    );
    response.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        final data = r["data"];
        _classicFormGuideList = (data as List)
            .map((e) => ClassicFormModel.fromJson(e))
            .toList();
      },
    );
    notifyListeners();
  }

  //* Get next to go
  Future<void> getNextToGo() async {
    final response = await ClassicFormAPIService.instance.getNextRace();
    response.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        final data = r["data"] as List;
        _nextRaceList = data.map((e) => NextRaceModel.fromJson(e)).toList();
      },
    );
    notifyListeners();
  }

  //* Get meeting race list
  Future<void> getMeetingRaceList({required String meetingId}) async {
    final response = await ClassicFormAPIService.instance.getMeetingRaceList(
      meetingId: meetingId,
    );
    response.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        final data = r["data"] as List;
        _meetingRaceList = data.map((e) => MeetingRaceModel.fromJson(e)).toList();
      },
    );
    notifyListeners();
  }
}
