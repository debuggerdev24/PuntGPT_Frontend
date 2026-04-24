class RaceDetails {
  RaceDetails({
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
    required this.australianTime,
    required this.trackType,
    required this.prizeMoney,
    required this.stage,
    required this.railPosition,
    required this.trackConditionRating,
    required this.weatherEmoji
  });

  factory RaceDetails.fromJson(Map<String, dynamic> json) => RaceDetails(
    raceId: json["raceId"] as int? ?? 0,
    number: json["number"] as int? ?? 0,
    name: json["name"] as String? ?? '',
    distance: json["distance"] as int? ?? 0,
    startTimeUtc: json["startTimeUtc"] != null
        ? DateTime.parse(json["startTimeUtc"].toString())
        : DateTime.now(),
    australianTime: json["australian_time"] as String? ?? '',
    trackType: json["track_type"] as String? ?? '',
    prizeMoney: json["prize_money"] as String? ?? '',
    stage: json["stage"] as String? ?? '',
    trackCondition: json["track_condition"] ?? "-",
    tipAnalysisText: json["tip_analysis_text"] as String? ?? '',
    tipsSourceBrand: json["tips_source_brand"] as String? ?? '',
    tipsSourceName: json["tips_source_name"] as String? ?? '',
    tipsSourceImage: json["tips_source_image"] as String? ?? '',
    railPosition: json["rail_position"],
    weatherEmoji: json["weather_emoji"],
    selections: List<Selection>.from(
      (json["selections"] as List?)?.map(
            (x) => Selection.fromJson((x ?? {}) as Map<String, dynamic>),
          ) ??
          [],
    ),
      trackConditionRating: json["track_condition_rating"] as int?
  );
  int raceId, distance, number;
  int? trackConditionRating;
  DateTime startTimeUtc;
  String name,
      trackCondition,
      weatherEmoji,
      tipAnalysisText,
      tipsSourceBrand,
      tipsSourceName,
      tipsSourceImage,
      australianTime,
      trackType,
      prizeMoney,
      stage,railPosition;
  List<Selection> selections;
}

class Selection {
  Selection({
    required this.selectionId,
    required this.trackName,
    required this.number,
    required this.barrier,
    required this.horseName,
    required this.horseSire,
    required this.horseDam,
    required this.horseAge,
    required this.horseSex,
    required this.horseColour,
    required this.horseTotalPrizeMoney,
    required this.horseLastWin,
    required this.jockeyName,
    required this.trainerName,
    required this.silksImage,
    required this.weight,
    required this.oddsWin,
    required this.isScratched,
    required this.tipPosition,
    required this.horseStats,
    required this.formHistory,
    required this.history,
    required this.previewComments,
  });

  factory Selection.fromJson(Map<String, dynamic> json) => Selection(
    selectionId: json["selectionId"] as int? ?? 0,
    trackName: json["track_name"] as String? ?? '',
    number: json["number"] as int? ?? 0,
    barrier: json["barrier"] as int? ?? 0,
    horseName: json["horse_name"] as String? ?? '',
    horseSire: json["horse_sire"] as String? ?? '',
    horseDam: json["horse_dam"] as String? ?? '',
    horseAge: json["horse_age"]?.toString() ?? '',
    horseSex: json["horse_sex"],
    horseColour: json["horse_colour"] as String? ?? '',
    horseTotalPrizeMoney: json["horse_total_prize_money"]?.toString() ?? '',
    horseLastWin: json["horse_last_win"] as String? ?? '',
    jockeyName: json["jockey_name"] as String? ?? '',
    trainerName: json["trainer_name"] as String? ?? '',
    silksImage: json["silks_image"] as String? ?? '',
    weight: (json["weight"] as num?)?.toDouble() ?? 0.0,
    oddsWin: (json["odds_win"] == null) ? "-" : json["odds_win"].toString(),
    isScratched: json["isScratched"] as bool? ?? false,
    tipPosition: json["tip_position"] as int?,
    horseStats: HorseStats.fromJson(
      (json["horse_stats"] ?? json["horseStats"]) as Map<String, dynamic>? ??
          {},
    ),
    formHistory: json["form_history"]?.toString() ?? '',
    history: (json["history"] as List).map((e) => History.fromJson(e)).toList(),
    previewComments: (json["preview_comments"] as List).map((e) => PreviewComments.fromJson(e)).toList(),
  );
  int selectionId, number, barrier;
  String trackName,
      jockeyName,
      silksImage,
      horseName,
      trainerName,
      formHistory,
      horseSire,
      horseDam,
      horseAge,
      horseSex,
      horseColour,
      horseTotalPrizeMoney,
      horseLastWin;
  double? weight;
  String? oddsWin;
  bool isScratched;
  int? tipPosition;
  HorseStats horseStats;
  List<History> history;
  List<PreviewComments> previewComments;

}

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
    required this.last12Months,
    required this.last10Months,
    required this.track,
    required this.distance,
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
      last12Months: _parse(json["last_12_months"]),
      last10Months: _parse(json["last_10_starts"]),
      track: _parse(json["track"]),
      distance: _parse(json["distance"]),
    );
  }
  HorseStatsDetails last12Months,last10Months,career, firstUp, secondUp, thirdUp, firm, good, soft, heavy,track,distance;
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

class History {
  factory History.fromJson(Map<String, dynamic> json) => History(
    date: DateTime.parse(json["date"]),
    meetingName: json["meeting_name"],
    trackName: json["track_name"],
    trackState: json["track_state"],
    raceNumber: json["race_number"],
    raceName: json["race_name"],
    distance: json["distance"],
    trackCondition: json["track_condition"],
    trackType: json["track_type"],
    prizeMoney: json["prize_money"],
    resultPosition: json["result_position"],
    totalStarters: json["total_starters"],
    margin: json["margin"],
    weightCarried: json["weight_carried"],
    startingPrice: json["starting_price"],
    jockeyName: json["jockey_name"],
    trainerName: json["trainer_name"],
    barrier: json["barrier"],
    winnerHorseName: json["winner_horse_name"],
    secondHorseName: json["second_horse_name"],
    thirdHorseName: json["third_horse_name"],
    isTrial: json["is_trial"],
    positionSummary: json["position_summary"],
  );

  History({
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
    required this.positionSummary,
  });
  DateTime date;
  String? meetingName,
      trackName,
      trackState,
      raceName,
      margin,
      weightCarried,
      startingPrice,
      jockeyName,
      trainerName,
      winnerHorseName,
      secondHorseName,
      thirdHorseName,
      positionSummary,
      trackCondition,
      trackType,
      prizeMoney;
  int? raceNumber, distance, resultPosition, totalStarters, barrier;

  bool isTrial;
}


class PreviewComments{

  factory PreviewComments.fromJson(Map<String, dynamic> json) => PreviewComments(
    comment: json["comment"] as String? ?? '',
    sourceBrand: json["source_brand"] as String? ?? '',
    sourceName: json["source_name"] as String? ?? '',
    sourceImage: json["source_image"] as String? ?? '',
    sourceId: json["source_id"] as String? ?? '',
    sourceType: json["source_type"] as String? ?? '',
  );
  PreviewComments({
    required this.comment,
    required this.sourceBrand,
    required this.sourceName,
    required this.sourceImage,
    required this.sourceId,
    required this.sourceType,
  });
  String comment, sourceBrand, sourceName, sourceImage, sourceId, sourceType;
}