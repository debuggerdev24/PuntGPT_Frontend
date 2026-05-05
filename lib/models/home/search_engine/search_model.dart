class SaveSearchModel {

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
  int id;
  String name;
  Filters filters;
  String comment;
  DateTime createdAt;
  DateTime updatedAt;
}

class Filters {

  Filters({
    this.track,
    this.jockey,
    this.trainer,
    this.placedAtTrack,
    this.placedLastStart,
    this.placedAtDistance,
    this.barrierMin,
    this.barrierMax,
    this.oddsMin,
    this.oddsMax,
    this.oddsRange,
    this.winsAtTrack,
    this.wonLastStart,
    this.winAtDistance,
    this.jockeyHorseWinsMin,
    this.jockeyHorseWinsMax,
    this.wonLast12Months,
    this.jockeyStrikeRateLast12Months,
  });

  factory Filters.fromJson(Map<String, dynamic> json) => Filters(
    track: json["track"],
    jockey: _commaFieldFromJson(json["jockey"]),
    trainer: _commaFieldFromJson(json["trainer"]),
    placedAtTrack: _parseNullableBool(json["placed_at_track"]),
    placedLastStart: json["placed_last_start"] as bool? ?? false,
    placedAtDistance: json["placed_at_distance"] as bool? ?? false,
    barrierMin: json["barrier_min"]?.toString(),
    barrierMax: json["barrier_max"]?.toString(),
    oddsMin: json["odds_min"]?.toString(),
    oddsMax: json["odds_max"]?.toString(),
    oddsRange: json["odds_range"],
    winsAtTrack: _parseNullableBool(json["wins_at_track"]),
    wonLastStart: json["won_last_start"] as bool? ?? false,
    winAtDistance: json["win_at_distance"] as bool? ?? false,
    jockeyHorseWinsMin: json["jockey_horse_wins_min"]?.toString(),
    jockeyHorseWinsMax: json["jockey_horse_wins_max"]?.toString(),
    wonLast12Months: json["won_last_12_months"] as bool? ?? false,
    jockeyStrikeRateLast12Months: json["jockey_strike_rate_last_12_months"],
  );
  bool? placedLastStart,
      wonLastStart,
      wonLast12Months,
      placedAtTrack,
      winsAtTrack;
  String? track,
      jockey,
      trainer,
      barrierMin,
      barrierMax,
      oddsMin,
      oddsMax,
      oddsRange,
      jockeyHorseWinsMin,
      jockeyHorseWinsMax,
      jockeyStrikeRateLast12Months;
  bool? placedAtDistance, winAtDistance;

  /// Converts Filters to a map of filter keys and their values
  /// Only includes filters that have non-null values
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    if (track != null && track!.isNotEmpty) {
      map["track"] = track;
    }
    if (jockey != null && jockey!.isNotEmpty) {
      map["jockey"] = jockey;
    }
    if (trainer != null && trainer!.isNotEmpty) {
      map["trainer"] = trainer;
    }
    if (placedAtTrack != null) {
      map["placed_at_track"] = placedAtTrack;
    }
    if (placedLastStart != null) {
      map["placed_last_start"] = placedLastStart;
    }
    if (placedAtDistance == true) {
      map["placed_at_distance"] = true;
    }
    if (barrierMin != null && barrierMin!.isNotEmpty) {
      map["barrier_min"] = barrierMin;
    }
    if (barrierMax != null && barrierMax!.isNotEmpty) {
      map["barrier_max"] = barrierMax;
    }
    if (oddsMin != null && oddsMin!.isNotEmpty) {
      map["odds_min"] = oddsMin;
    }
    if (oddsMax != null && oddsMax!.isNotEmpty) {
      map["odds_max"] = oddsMax;
    }
    if (winsAtTrack != null) {
      map["wins_at_track"] = winsAtTrack;
    }
    if (wonLastStart != null) {
      map["won_last_start"] = wonLastStart;
    }
    if (winAtDistance == true) {
      map["win_at_distance"] = true;
    }
    if (jockeyHorseWinsMin != null && jockeyHorseWinsMin!.isNotEmpty) {
      map["jockey_horse_wins_min"] = jockeyHorseWinsMin;
    }
    if (jockeyHorseWinsMax != null && jockeyHorseWinsMax!.isNotEmpty) {
      map["jockey_horse_wins_max"] = jockeyHorseWinsMax;
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

  static String? _commaFieldFromJson(dynamic raw) {
    if (raw == null) return null;
    if (raw is List) {
      final parts = raw
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
      if (parts.isEmpty) return null;
      return parts.join(', ');
    }
    final s = raw.toString().trim();
    return s.isEmpty ? null : s;
  }

  static bool? _parseNullableBool(dynamic value) {
    if (value == null) return null;
    if (value is String && value.trim().isEmpty) return null;
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value is String) {
      final v = value.trim().toLowerCase();
      if (v == "true" || v == "1" || v == "yes") return true;
      if (v == "false" || v == "0" || v == "no") return false;
    }
    return null;
  }
}
