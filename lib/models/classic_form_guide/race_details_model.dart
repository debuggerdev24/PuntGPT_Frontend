class RaceDetailsModel {
  factory RaceDetailsModel.fromJson(Map<String, dynamic> json) =>
      RaceDetailsModel(
        race: Race.fromJson(json["race"]),
        selections: List<Selection>.from(
          json["selections"].map((x) => Selection.fromJson(x)),
        ),
      );

  RaceDetailsModel({required this.race, required this.selections});
  Race race;
  List<Selection> selections;
}

class Race {
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
    raceId: json["raceId"],
    number: json["number"],
    name: json["name"],
    distance: json["distance"],
    startTimeUtc: DateTime.parse(json["startTimeUtc"]),
    trackCondition: trackConditionValues.map[json["track_condition"]]!,
    tipAnalysisText: json["tip_analysis_text"],
    tipsSourceBrand: json["tips_source_brand"],
    tipsSourceName: json["tips_source_name"],
    tipsSourceImage: json["tips_source_image"],
    selections: List<Selection>.from(
      json["selections"].map((x) => Selection.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "raceId": raceId,
    "number": number,
    "name": name,
    "distance": distance,
    "startTimeUtc": startTimeUtc.toIso8601String(),
    "track_condition": trackConditionValues.reverse[trackCondition],
    "tip_analysis_text": tipAnalysisText,
    "tips_source_brand": tipsSourceBrand,
    "tips_source_name": tipsSourceName,
    "tips_source_image": tipsSourceImage,
    "selections": List<dynamic>.from(selections.map((x) => x.toJson())),
  };
}

class Selection {
  int selectionId;
  TrackName trackName;
  int number;
  int barrier;
  String horseName;
  String jockeyName;
  TrainerName trainerName;
  String silksImage;
  double weight;
  dynamic oddsWin;
  bool isScratched;
  int? tipPosition;
  HorseStats horseStats;
  List<FormHistory> formHistory;

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
    selectionId: json["selectionId"],
    trackName: trackNameValues.map[json["track_name"]]!,
    number: json["number"],
    barrier: json["barrier"],
    horseName: json["horse_name"],
    jockeyName: json["jockey_name"],
    trainerName: trainerNameValues.map[json["trainer_name"]]!,
    silksImage: json["silks_image"],
    weight: json["weight"]?.toDouble(),
    oddsWin: json["odds_win"],
    isScratched: json["isScratched"],
    tipPosition: json["tip_position"],
    horseStats: HorseStats.fromJson(json["horse_stats"]),
    formHistory: List<FormHistory>.from(
      json["form_history"].map((x) => FormHistory.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "selectionId": selectionId,
    "track_name": trackNameValues.reverse[trackName],
    "number": number,
    "barrier": barrier,
    "horse_name": horseName,
    "jockey_name": jockeyName,
    "trainer_name": trainerNameValues.reverse[trainerName],
    "silks_image": silksImage,
    "weight": weight,
    "odds_win": oddsWin,
    "isScratched": isScratched,
    "tip_position": tipPosition,
    "horse_stats": horseStats.toJson(),
    "form_history": List<dynamic>.from(formHistory.map((x) => x.toJson())),
  };
}

class FormHistory {
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
    date: DateTime.parse(json["date"]),
    meetingName: json["meeting_name"],
    trackName: json["track_name"],
    trackState: trackStateValues.map[json["track_state"]]!,
    raceNumber: json["race_number"],
    raceName: json["race_name"],
    distance: json["distance"],
    trackCondition: trackConditionValues.map[json["track_condition"]]!,
    trackType: trackTypeValues.map[json["track_type"]]!,
    prizeMoney: json["prize_money"],
    resultPosition: json["result_position"],
    totalStarters: json["total_starters"],
    margin: json["margin"],
    weightCarried: json["weight_carried"],
    startingPrice: json["starting_price"],
    jockeyName: json["jockey_name"],
    trainerName: trainerNameValues.map[json["trainer_name"]]!,
    barrier: json["barrier"],
    winnerHorseName: json["winner_horse_name"],
    secondHorseName: json["second_horse_name"],
    thirdHorseName: json["third_horse_name"],
    isTrial: json["is_trial"],
  );

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
  dynamic career;
  dynamic firstUp;
  dynamic secondUp;
  dynamic thirdUp;
  dynamic firm;
  dynamic good;
  dynamic soft;
  dynamic heavy;

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

  factory HorseStats.fromJson(Map<String, dynamic> json) => HorseStats(
    career: json["career"],
    firstUp: json["first_up"],
    secondUp: json["second_up"],
    thirdUp: json["third_up"],
    firm: json["firm"],
    good: json["good"],
    soft: json["soft"],
    heavy: json["heavy"],
  );

  Map<String, dynamic> toJson() => {
    "career": career,
    "first_up": firstUp,
    "second_up": secondUp,
    "third_up": thirdUp,
    "firm": firm,
    "good": good,
    "soft": soft,
    "heavy": heavy,
  };
}

enum TrackName { GOULBURN }

final trackNameValues = EnumValues({"Goulburn": TrackName.GOULBURN});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
