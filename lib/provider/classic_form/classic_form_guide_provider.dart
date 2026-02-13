import 'package:flutter/foundation.dart';
import 'package:puntgpt_nick/core/enum/app_enums.dart';
import 'package:puntgpt_nick/core/helper/log_helper.dart';
import 'package:puntgpt_nick/core/utils/de_bouncing.dart';
import 'package:puntgpt_nick/models/classic_form_guide/classic_form_model.dart';
import 'package:puntgpt_nick/models/classic_form_guide/meeting_race_model.dart';
import 'package:puntgpt_nick/models/classic_form_guide/next_race_model.dart';
import 'package:puntgpt_nick/models/classic_form_guide/race_details_model.dart';
import 'package:puntgpt_nick/service/classic_form/classic_form_api_service.dart';

class ClassicFormGuideProvider extends ChangeNotifier {
  List<NextRaceModel>? _nextRaceList;
  int selectedDay = 1;
  int selectedRace = 0;
  List<ClassicFormModel>? _classicFormGuideList;
  MeetingDetailsModel? _meetingRaceList;
  RaceDetailsModel? _raceFieldDetail;
  List<ClassicFormDay> days = [
    ClassicFormDay.yesterday,
    ClassicFormDay.today,
    ClassicFormDay.tomorrow,
    ClassicFormDay.day_after_tomorrow,
  ];

  List<ClassicFormModel> get classicFormGuide => _classicFormGuideList!;
  MeetingDetailsModel? get meetingRace => _meetingRaceList;
  List<NextRaceModel> get nextRaceList => _nextRaceList ?? [];
  RaceDetailsModel? get raceFieldDetail => _raceFieldDetail;

  set changeSelectedRace(int value) {
    selectedRace = value;
    notifyListeners();
  }

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
    _meetingRaceList = null;

    final response = await ClassicFormAPIService.instance.getMeetingRaceList(
      meetingId: meetingId,
    );
    response.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        final data = r["data"];
        _meetingRaceList = data is Map<String, dynamic>
            ? MeetingDetailsModel.fromJson(data)
            : null;
        final racesLength = _meetingRaceList?.races.length ?? 0;
        if (racesLength > 0 && selectedRace >= racesLength) {
          selectedRace = racesLength - 1;
        }
      },
    );
    notifyListeners();
  }

  //* Get race field detail
  Future<void> getRaceFieldDetail({required String id}) async {
    _raceFieldDetail = null;
    notifyListeners();
    final response = await ClassicFormAPIService.instance.getRaceFieldDetail(
      id: id,
    );
    response.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        final data = r["data"];
        _raceFieldDetail = data is Map<String, dynamic>
            ? RaceDetailsModel.fromJson(data)
            : null;
      },
    );
    notifyListeners();
  }
}
