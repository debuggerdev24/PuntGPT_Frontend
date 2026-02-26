class TipSlipModel {

    factory TipSlipModel.fromJson(Map<String, dynamic> json) => TipSlipModel(
        id: json["id"],
        selection: Selection.fromJson(json["selection"]),
        addedAt: DateTime.parse(json["added_at"]),
    );

    TipSlipModel({
        required this.id,
        required this.selection,
        required this.addedAt,
    });
    int id;
    Selection selection;
    DateTime addedAt;
}

class Selection {
    String horseName;
    String jockeyName;
    String trainerName;
    String trackName;
    String raceName;
    String raceNumber;
    DateTime startTimeUtc;
    int selectionId;
    int number;
    String silksImage;
    String unibetFixedOddsWin;

    Selection({
        required this.horseName,
        required this.jockeyName,
        required this.trainerName,
        required this.trackName,
        required this.raceName,
        required this.raceNumber,
        required this.startTimeUtc,
        required this.selectionId,
        required this.number,
        required this.silksImage,
        required this.unibetFixedOddsWin,
    });

    factory Selection.fromJson(Map<String, dynamic> json) => Selection(
        horseName: json["horse_name"] ?? "",
        jockeyName: json["jockey_name"] ?? "",
        trainerName: json["trainer_name"] ?? "" ,
        trackName: json["track_name"] ?? "",
        raceName: json["race_name"] ?? "",
        raceNumber: json["race_number"] ?? "",
        startTimeUtc: DateTime.parse(json["start_time_utc"] ?? ""),
        selectionId: json["selectionId"] ?? 0,
        number: json["number"] ?? 0,
        silksImage: json["silks_image"] ?? "",
        unibetFixedOddsWin: json["unibet_fixed_odds_win"] ?? "",
    );
}
