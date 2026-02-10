class SaveSearchModel {
  int id;
  String name;
  Filters filters;
  String comment;
  DateTime createdAt;
  DateTime updatedAt;

  SaveSearchModel({
    required this.id,
    required this.name,
    required this.filters,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SaveSearchModel.fromJson(Map<String, dynamic> json) =>
      SaveSearchModel(
        id: json["id"],
        name: json["name"],
        filters: Filters.fromJson(json["filters"]),
        comment: json["comment"] ?? "null",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );
}

class Filters {
  bool? placedLastStart,
      wonLastStart,
      wonLast12Months;
  String? track,
      placedAtTrack,
      placedAtDistance,
      barrier,
      oddsRange,
      winsAtTrack,
      winAtDistance,
      jockeyHorseWins,
      jockeyStrikeRateLast12Months;

  Filters({
    this.track,
    this.placedAtTrack,
    this.placedLastStart,
    this.placedAtDistance,
    this.barrier,
    this.oddsRange,
    this.winsAtTrack,
    this.wonLastStart,
    this.winAtDistance,
    this.jockeyHorseWins,
    this.wonLast12Months,
    this.jockeyStrikeRateLast12Months,
  });

  factory Filters.fromJson(Map<String, dynamic> json) => Filters(
    track: json["track"],
    placedAtTrack: json["placed_at_track"]?.toString(),
    placedLastStart: _parseBool(json["placed_last_start"]),
    placedAtDistance: json["placed_at_distance"]?.toString(),
    barrier: json["barrier"],
    oddsRange: json["odds_range"],
    winsAtTrack: json["wins_at_track"],
    wonLastStart: _parseBool(json["won_last_start"]),
    winAtDistance: json["win_at_distance"],
    jockeyHorseWins: json["jockey_horse_wins"],
    wonLast12Months: _parseBool(json["won_last_12_months"]),
    jockeyStrikeRateLast12Months: json["jockey_strike_rate_last_12_months"],
  );

  /// Helper method to parse boolean values from JSON
  /// Handles both string ("true"/"false") and boolean (true/false) values
  /// Returns null if the value is not present
  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == "true";
    }
    return null;
  }

  /// Converts Filters to a map of filter keys and their values
  /// Only includes filters that have non-null values
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    if (track != null && track!.isNotEmpty) {
      map["track"] = track;
    }
    if (placedAtTrack != null && placedAtTrack!.isNotEmpty) {
      map["placed_at_track"] = placedAtTrack;
    }
    if (placedLastStart != null) {
      map["placed_last_start"] = placedLastStart;
    }
    if (placedAtDistance != null) {
      map["placed_at_distance"] = placedAtDistance;
    }
    if (barrier != null && barrier!.isNotEmpty) {
      map["barrier"] = barrier;
    }
    if (oddsRange != null && oddsRange!.isNotEmpty) {
      map["odds_range"] = oddsRange;
    }
    if (winsAtTrack != null && winsAtTrack!.isNotEmpty) {
      map["wins_at_track"] = winsAtTrack;
    }
    if (wonLastStart != null) {
      map["won_last_start"] = wonLastStart;
    }
    if (winAtDistance != null && winAtDistance!.isNotEmpty) {
      map["win_at_distance"] = winAtDistance;
    }
    if (jockeyHorseWins != null && jockeyHorseWins!.isNotEmpty) {
      map["jockey_horse_wins"] = jockeyHorseWins;
    }
    if (wonLast12Months != null) {
      map["won_last_12_months"] = wonLast12Months;
    }
    if (jockeyStrikeRateLast12Months != null &&
        jockeyStrikeRateLast12Months!.isNotEmpty) {
      map["jockey_strike_rate_last_12_months"] = jockeyStrikeRateLast12Months;
    }
    return map;
  }
}
