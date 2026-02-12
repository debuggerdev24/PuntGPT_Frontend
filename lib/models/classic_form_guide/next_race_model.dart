class NextRaceModel {
  factory NextRaceModel.fromJson(Map<String, dynamic> json) => NextRaceModel(
    trackName: json["track_name"],
    raceId: json["raceId"],
    raceName: json["race_name"],
    raceNumber: json["race_number"],
    raceTimeUtc: DateTime.parse(json["race_time_utc"]),
    raceAustralianTime: json["race_australian_time"],
    meetingDate: DateTime.parse(json["meeting_date"]),
  );

  NextRaceModel({
    required this.trackName,
    required this.raceId,
    required this.raceName,
    required this.raceNumber,
    required this.raceTimeUtc,
    required this.raceAustralianTime,
    required this.meetingDate,
  });
  int raceId, raceNumber;
  String raceName, raceAustralianTime, trackName;

  DateTime raceTimeUtc, meetingDate;
}
