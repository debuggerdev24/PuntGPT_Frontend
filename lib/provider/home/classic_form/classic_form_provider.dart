import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/classic_form_guide/classic_form_model.dart';
import 'package:puntgpt_nick/models/home/classic_form_guide/meeting_race_model.dart';
import 'package:puntgpt_nick/models/home/classic_form_guide/next_race_model.dart';
import 'package:puntgpt_nick/models/home/classic_form_guide/race_details_model.dart';
import 'package:puntgpt_nick/models/home/classic_form_guide/speed_maps_model.dart';
import 'package:puntgpt_nick/models/home/classic_form_guide/tips_analysis_model.dart';
import 'package:puntgpt_nick/service/home/classic_form/classic_form_api_service.dart';

class ClassicFormProvider extends ChangeNotifier {
  List<NextRaceModel>? _nextRaceList;
  int selectedDay = 1;
  int selectedRace = 0;
  // int selectedSubNavIndex = 0;
  List<ClassicFormModel>? _classicFormGuideList;
  MeetingDetailsModel? _meetingRaceList;
  RaceDetailsModel? _raceFieldDetail;
  TipsAnalysisModel? _tipsAndAnalysis;
  SpeedMapsModel? _speedMaps;
  List<ClassicFormDay> days = [
    ClassicFormDay.yesterday,
    ClassicFormDay.today,
    ClassicFormDay.tomorrow,
    // ClassicFormDay.day_after_tomorrow,
  ];

  List<ClassicFormModel>? get classicFormGuide => _classicFormGuideList;
  MeetingDetailsModel? get meetingRace => _meetingRaceList;
  List<NextRaceModel> get nextRaceList => _nextRaceList ?? [];
  RaceDetailsModel? get raceFieldDetail => _raceFieldDetail;
  TipsAnalysisModel? get tipsAndAnalysis => _tipsAndAnalysis;
  SpeedMapsModel? get speedMaps => _speedMaps;

  /// Parses [tip_analysis_html] and returns a list of text segments with bold
  /// markers for content inside &lt;strong&gt; tags.
  List<TipAnalysisTextSegment> get tipAnalysisSegments {
    final html = _tipsAndAnalysis?.tipAnalysisHtml ?? '';
    if (html.isEmpty) return [];
    return _parseTipAnalysisHtml(html);
  }

  static List<TipAnalysisTextSegment> _parseTipAnalysisHtml(String html) {
    final segments = <TipAnalysisTextSegment>[];
    const openTag = '<strong>';
    const closeTag = '</strong>';
    int pos = 0;
    while (pos < html.length) {
      final strongStart = html.indexOf(openTag, pos);
      if (strongStart == -1) {
        segments.add(
          TipAnalysisTextSegment(text: html.substring(pos), isBold: false),
        );
        break;
      }
      if (strongStart > pos) {
        segments.add(
          TipAnalysisTextSegment(
            text: html.substring(pos, strongStart),
            isBold: false,
          ),
        );
      }
      final contentStart = strongStart + openTag.length;
      final contentEnd = html.indexOf(closeTag, contentStart);
      if (contentEnd == -1) {
        segments.add(
          TipAnalysisTextSegment(
            text: html.substring(contentStart),
            isBold: true,
          ),
        );
        break;
      }
      segments.add(
        TipAnalysisTextSegment(
          text: html.substring(contentStart, contentEnd),
          isBold: true,
        ),
      );
      pos = contentEnd + closeTag.length;
    }
    return segments;
  }

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

  // set changeSelectedSubNavIndex(int value) {
  //   selectedSubNavIndex = value;
  //   notifyListeners();
  // }

  //* Get classic form guide
  Future<void> getClassicFormGuide() async {
    _classicFormGuideList = null;
    notifyListeners();
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

  //* Get tips and analysis
  Future<void> getTipsAndAnalysis({required String raceId}) async {
    _tipsAndAnalysis = null;
    notifyListeners();
    final response = await ClassicFormAPIService.instance.getTipsAndAnalysis(
      raceId: raceId,
    );
    response.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        final data = r["data"];
        _tipsAndAnalysis = data is Map<String, dynamic>
            ? TipsAnalysisModel.fromJson(data)
            : null;
      },
    );
    notifyListeners();
  }

  //* Get speed maps
  Future<void> getSpeedMaps({
    required String meetingId,
    required String raceId,
  }) async {
    _speedMaps = null;
    notifyListeners();
    final response = await ClassicFormAPIService.instance.getSpeedMaps(
      meetingId: meetingId,
      raceId: raceId,
    );
    response.fold(
      (l) {
        Logger.error(l.errorMsg);
        // On error or empty response: set empty model so UI shows "No speed maps found"
        _speedMaps = SpeedMapsModel.fromJson({});
      },
      (r) {
        final data = r["data"];
        _speedMaps = data is Map<String, dynamic>
            ? SpeedMapsModel.fromJson(data)
            : SpeedMapsModel.fromJson({});
      },
    );
    notifyListeners();
  }
}

/// Represents a segment of tip analysis text with optional bold styling.
class TipAnalysisTextSegment {
  const TipAnalysisTextSegment({required this.text, required this.isBold});
  final String text;
  final bool isBold;
}
