class MeetingRaceModel {
  factory MeetingRaceModel.fromJson(Map<String, dynamic> json) =>
      MeetingRaceModel(
        meeting: Meeting.fromJson(json["meeting"]),
        races: List<Race>.from(json["races"].map((x) => Race.fromJson(x))),
        raceCount: json["race_count"],
        meetingDate: DateTime.parse(json["meeting_date"]),
      );

  MeetingRaceModel({
    required this.meeting,
    required this.races,
    required this.raceCount,
    required this.meetingDate,
  });
  Meeting meeting;
  List<Race> races;
  int raceCount;
  DateTime meetingDate;

}

class Meeting {

  factory Meeting.fromJson(Map<String, dynamic> json) => Meeting(
    meetingId: json["meetingId"],
    date: DateTime.parse(json["date"]),
    trackName: json["track_name"],
    trackCountry: json["track_country"],
    name: json["name"],
  );

  Meeting({
    required this.meetingId,
    required this.date,
    required this.trackName,
    required this.trackCountry,
    required this.name,
  });
  int meetingId;
  DateTime date;
  String trackName;
  String trackCountry;
  String name;

  Map<String, dynamic> toJson() => {
    "meetingId": meetingId,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "track_name": trackName,
    "track_country": trackCountry,
    "name": name,
  };
}

class Race {
  int number;
  int raceId;
  String name;
  int distance;
  String distanceUnits;

  Race({
    required this.number,
    required this.raceId,
    required this.name,
    required this.distance,
    required this.distanceUnits,
  });

  factory Race.fromJson(Map<String, dynamic> json) => Race(
    number: json["number"],
    raceId: json["raceId"],
    name: json["name"],
    distance: json["distance"],
    distanceUnits: json["distance_units"],
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "raceId": raceId,
    "name": name,
    "distance": distance,
    "distance_units": distanceUnits,
  };
}
