class RaceDetailsModel {
  factory RaceDetailsModel.fromJson(Map<String, dynamic> json) =>
      RaceDetailsModel(
        race: Race.fromJson(json["race"] as Map<String, dynamic>? ?? {}),
        selections: List<Selection>.from(
          ((json["selections"] as List?) ??
                  ((json["race"] as Map<String, dynamic>?)?["selections"]
                      as List?))
              ?.map(
                (x) => Selection.fromJson((x ?? {}) as Map<String, dynamic>),
              ) ??
              [],
        ),
      );

  RaceDetailsModel({required this.race, required this.selections});
  Race race;
  List<Selection> selections;
}

class Race {
  Race({
    required this.raceId,
    required this.number,
    required this.name,
    required this.distance,
    required this.startTimeUtc,
    required this.trackCondition,
    required this.tipAnalysisText,
    required this.tipsSourceBrand,
    required this.tipsSourceName,
    required this.tipsSourceImage,
    required this.selections,
  });

  factory Race.fromJson(Map<String, dynamic> json) => Race(
    raceId: json["raceId"] as int? ?? 0,
    number: json["number"] as int? ?? 0,
    name: json["name"] as String? ?? '',
    distance: json["distance"] as int? ?? 0,
    startTimeUtc: json["startTimeUtc"] != null
        ? DateTime.parse(json["startTimeUtc"].toString())
        : DateTime.now(),
    trackCondition:
        trackConditionValues.map[json["track_condition"]] ??
        TrackCondition.GOOD,
    tipAnalysisText: json["tip_analysis_text"] as String? ?? '',
    tipsSourceBrand: json["tips_source_brand"] as String? ?? '',
    tipsSourceName: json["tips_source_name"] as String? ?? '',
    tipsSourceImage: json["tips_source_image"] as String? ?? '',
    selections: List<Selection>.from(
      (json["selections"] as List?)?.map(
            (x) => Selection.fromJson((x ?? {}) as Map<String, dynamic>),
          ) ??
          [],
    ),
  );
  int raceId;
  int number;
  String name;
  int distance;
  DateTime startTimeUtc;
  TrackCondition trackCondition;
  String tipAnalysisText;
  String tipsSourceBrand;
  String tipsSourceName;
  String tipsSourceImage;
  List<Selection> selections;
}

class Selection {
  Selection({
    required this.selectionId,
    required this.trackName,
    required this.number,
    required this.barrier,
    required this.horseName,
    required this.jockeyName,
    required this.trainerName,
    required this.silksImage,
    required this.weight,
    required this.oddsWin,
    required this.isScratched,
    required this.tipPosition,
    required this.horseStats,
    required this.formHistory,
  });

  factory Selection.fromJson(Map<String, dynamic> json) => Selection(
    selectionId: json["selectionId"] as int? ?? 0,
    trackName: trackNameValues.map[json["track_name"]] ?? TrackName.GOULBURN,
    number: json["number"] as int? ?? 0,
    barrier: json["barrier"] as int? ?? 0,
    horseName: json["horse_name"] as String? ?? '',
    jockeyName: json["jockey_name"] as String? ?? '',
    trainerName:
        trainerNameValues.map[json["trainer_name"]] ??
        TrainerName.DANNY_WILLIAMS,
    silksImage: json["silks_image"] as String? ?? '',
    weight: (json["weight"] as num?)?.toDouble() ?? 0.0,
    oddsWin: json["odds_win"],
    isScratched: json["isScratched"] as bool? ?? false,
    tipPosition: json["tip_position"] as int?,
    horseStats: HorseStats.fromJson(
      (json["horse_stats"] ?? json["horseStats"]) as Map<String, dynamic>? ??
          {},
    ),
    formHistory: List<FormHistory>.from(
      (json["form_history"] as List?)?.map(
            (x) => FormHistory.fromJson((x ?? {}) as Map<String, dynamic>),
          ) ??
          [],
    ),
  );
  int selectionId, number, barrier;
  TrackName trackName;
  String jockeyName, silksImage, horseName;
  TrainerName trainerName;

  double weight;
  dynamic oddsWin;
  bool isScratched;
  int? tipPosition;
  HorseStats horseStats;
  List<FormHistory> formHistory;
}

class FormHistory {
  FormHistory({
    required this.date,
    required this.meetingName,
    required this.trackName,
    required this.trackState,
    required this.raceNumber,
    required this.raceName,
    required this.distance,
    required this.trackCondition,
    required this.trackType,
    required this.prizeMoney,
    required this.resultPosition,
    required this.totalStarters,
    required this.margin,
    required this.weightCarried,
    required this.startingPrice,
    required this.jockeyName,
    required this.trainerName,
    required this.barrier,
    required this.winnerHorseName,
    required this.secondHorseName,
    required this.thirdHorseName,
    required this.isTrial,
  });

  factory FormHistory.fromJson(Map<String, dynamic> json) => FormHistory(
    date: json["date"] != null
        ? DateTime.parse(json["date"].toString())
        : DateTime.now(),
    meetingName: json["meeting_name"] as String? ?? '',
    trackName: json["track_name"] as String? ?? '',
    trackState: trackStateValues.map[json["track_state"]] ?? TrackState.ACT,
    raceNumber: json["race_number"] as int? ?? 0,
    raceName: json["race_name"] as String? ?? '',
    distance: json["distance"] as int? ?? 0,
    trackCondition:
        trackConditionValues.map[json["track_condition"]] ??
        TrackCondition.GOOD,
    trackType: trackTypeValues.map[json["track_type"]] ?? TrackType.TURF,
    prizeMoney: json["prize_money"],
    resultPosition: json["result_position"] as int? ?? 0,
    totalStarters: json["total_starters"] as int? ?? 0,
    margin: json["margin"],
    weightCarried: json["weight_carried"],
    startingPrice: json["starting_price"],
    jockeyName: json["jockey_name"] as String? ?? '',
    trainerName:
        trainerNameValues.map[json["trainer_name"]] ??
        TrainerName.DANNY_WILLIAMS,
    barrier: json["barrier"] as int?,
    winnerHorseName: json["winner_horse_name"] as String? ?? '',
    secondHorseName: json["second_horse_name"] as String? ?? '',
    thirdHorseName: json["third_horse_name"] as String? ?? '',
    isTrial: json["is_trial"] as bool? ?? false,
  );
  DateTime date;
  String meetingName;
  String trackName;
  TrackState trackState;
  int raceNumber;
  String raceName;
  int distance;
  TrackCondition trackCondition;
  TrackType trackType;
  String? prizeMoney;
  int resultPosition;
  int totalStarters;
  String? margin;
  String? weightCarried;
  String? startingPrice;
  String jockeyName;
  TrainerName trainerName;
  int? barrier;
  String winnerHorseName;
  String secondHorseName;
  String thirdHorseName;
  bool isTrial;

  Map<String, dynamic> toJson() => {
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "meeting_name": meetingName,
    "track_name": trackName,
    "track_state": trackStateValues.reverse[trackState],
    "race_number": raceNumber,
    "race_name": raceName,
    "distance": distance,
    "track_condition": trackConditionValues.reverse[trackCondition],
    "track_type": trackTypeValues.reverse[trackType],
    "prize_money": prizeMoney,
    "result_position": resultPosition,
    "total_starters": totalStarters,
    "margin": margin,
    "weight_carried": weightCarried,
    "starting_price": startingPrice,
    "jockey_name": jockeyName,
    "trainer_name": trainerNameValues.reverse[trainerName],
    "barrier": barrier,
    "winner_horse_name": winnerHorseName,
    "second_horse_name": secondHorseName,
    "third_horse_name": thirdHorseName,
    "is_trial": isTrial,
  };
}

enum TrackCondition { GOOD, HEAVY, SOFT, SYNTHETIC }

final trackConditionValues = EnumValues({
  "Good": TrackCondition.GOOD,
  "Heavy": TrackCondition.HEAVY,
  "Soft": TrackCondition.SOFT,
  "Synthetic": TrackCondition.SYNTHETIC,
});

enum TrackState { ACT, NSW }

final trackStateValues = EnumValues({
  "ACT": TrackState.ACT,
  "NSW": TrackState.NSW,
});

enum TrackType { AWT, TURF }

final trackTypeValues = EnumValues({
  "AWT": TrackType.AWT,
  "Turf": TrackType.TURF,
});

enum TrainerName {
  DANNY_WILLIAMS,
  GRATZ_VELLA,
  JOHN_ROLFE,
  ROB_POTTER,
  SCOTT_COLLINGS,
  STEPHEN_HILL,
}

final trainerNameValues = EnumValues({
  "Danny Williams": TrainerName.DANNY_WILLIAMS,
  "Gratz Vella": TrainerName.GRATZ_VELLA,
  "John Rolfe": TrainerName.JOHN_ROLFE,
  "Rob Potter": TrainerName.ROB_POTTER,
  "Scott Collings": TrainerName.SCOTT_COLLINGS,
  "Stephen Hill": TrainerName.STEPHEN_HILL,
});

class HorseStats {
  HorseStats({
    required this.career,
    required this.firstUp,
    required this.secondUp,
    required this.thirdUp,
    required this.firm,
    required this.good,
    required this.soft,
    required this.heavy,
  });

  factory HorseStats.fromJson(Map<String, dynamic> json) {
    HorseStatsDetails _parse(Map<String, dynamic>? m) =>
        HorseStatsDetails.fromJson(m ?? {});
    return HorseStats(
      career: _parse(json["career"] as Map<String, dynamic>?),
      firstUp: _parse(json["first_up"] as Map<String, dynamic>?),
      secondUp: _parse(json["second_up"] as Map<String, dynamic>?),
      thirdUp: _parse(json["third_up"] as Map<String, dynamic>?),
      firm: _parse(json["firm"] as Map<String, dynamic>?),
      good: _parse(json["good"] as Map<String, dynamic>?),
      soft: _parse(json["soft"] as Map<String, dynamic>?),
      heavy: _parse(json["heavy"] as Map<String, dynamic>?),
    );
  }
  HorseStatsDetails career, firstUp, secondUp, thirdUp, firm, good, soft, heavy;
}

class HorseStatsDetails {
  factory HorseStatsDetails.fromJson(Map<String, dynamic> json) =>
      HorseStatsDetails(
        runs: json["runs"] as int? ?? 0,
        wins: json["wins"] as int? ?? 0,
        seconds: json["seconds"] as int? ?? 0,
        thirds: json["thirds"] as int? ?? 0,
        winPercentage:
            (json["win_percentage"] ?? json["winPercentage"])?.toDouble() ??
            0.0,
        placePercentage:
            (json["place_percentage"] ?? json["placePercentage"])?.toDouble() ??
            0.0,
        roi: (json["roi"] as num?)?.toDouble() ?? 0.0,
      );

  HorseStatsDetails({
    required this.runs,
    required this.wins,
    required this.seconds,
    required this.thirds,
    required this.winPercentage,
    required this.placePercentage,
    required this.roi,
  });
  int runs, wins, seconds, thirds;
  double placePercentage, winPercentage, roi;
}

enum TrackName { GOULBURN }

final trackNameValues = EnumValues({"Goulburn": TrackName.GOULBURN});

class EnumValues<T> {
  EnumValues(this.map);
  Map<String, T> map;
  late Map<T, String> reverseMap;

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
