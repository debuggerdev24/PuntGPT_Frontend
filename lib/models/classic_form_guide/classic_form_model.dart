class ClassicFormModel {
  ClassicFormModel({
    required this.meetingId,
    required this.meetingName,
    required this.trackName,
    required this.meetingDate,
    required this.races,
  });

  factory ClassicFormModel.fromJson(Map<String, dynamic> json) =>
      ClassicFormModel(
        meetingId: json["meeting_id"],
        meetingName: json["meeting_name"],
        trackName: json["track_name"],
        meetingDate: json["meeting_date"],
        races: List<Race>.from(json["races"].map((x) => Race.fromJson(x))),
      );
  int meetingId;
  String meetingName, trackName, meetingDate;
  List<Race> races;
}

class Race {
  Race({
    required this.raceId,
    required this.raceName,
    required this.raceNumber,
    required this.raceTimeUtc,
    required this.raceAustralianTime,
  });

  factory Race.fromJson(Map<String, dynamic> json) => Race(
    raceId: json["raceId"],
    raceName: json["race_name"],
    raceNumber: json["race_number"],
    raceTimeUtc: DateTime.parse(json["race_time_utc"]),
    raceAustralianTime: json["race_australian_time"],
  );
  int raceId;
  String raceName;
  int raceNumber;
  DateTime raceTimeUtc;
  String raceAustralianTime;

  Map<String, dynamic> toJson() => {
    "raceId": raceId,
    "race_name": raceName,
    "race_number": raceNumber,
    "race_time_utc": raceTimeUtc.toIso8601String(),
    "race_australian_time": raceAustralianTime,
  };
}
