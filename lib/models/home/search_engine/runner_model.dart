class RunnerDataModel {
  factory RunnerDataModel.fromJson(Map<String, dynamic> json) {
    final runnersList =
        (json["runners"] as List?)
            ?.map((x) => RunnerModel.fromJson(x as Map<String, dynamic>))
            .toList() ??
        [];

    return RunnerDataModel(
      runnerCount: json["runner_count"],
      runnersList: runnersList,
    );
  }

  RunnerDataModel({this.runnerCount, this.runnersList = const []});
  int? runnerCount;
  List<RunnerModel> runnersList;
}

class RunnerModel {
  RunnerModel({
    this.selectionId,
    this.selectionNumber,
    this.horseName,
    this.jockeyName,
    this.trainerName,
    this.track,
    this.raceId,
    this.raceNumber,
    this.jumpTimeAu,
    this.silksImage,
    this.odds,
    this.barrier,
    this.distance,
  });

  factory RunnerModel.fromJson(Map<String, dynamic> json) => RunnerModel(
    selectionId: json["selection_id"],
    selectionNumber: json["selection_number"],
    horseName: json["horse_name"],
    jockeyName: json["jockey_name"] ?? "Jockey Name",
    trainerName: json["trainer_name"],
    track: json["track"],
    raceId: json["race_id"],
    raceNumber: json["race_number"],
    jumpTimeAu: json["jump_time_au"],
    silksImage: json["silks_image"],
    barrier: json["barrier"],
    distance: json["race_distance"],
    odds: json["odds"] != null
        ? (json["odds"] is num
              ? (json["odds"] as num).toDouble()
              : double.tryParse(json["odds"].toString()))
        : null,
  );

  int? selectionId, selectionNumber, raceId, raceNumber, barrier,distance;
  String? horseName, jockeyName, trainerName, track, jumpTimeAu, silksImage;
  double? odds;
}
