

class RunnerDataModel {

    factory RunnerDataModel.fromJson(Map<String, dynamic> json) => RunnerDataModel(
        runnerCount: json["runner_count"],
        runnersList: List<Runner>.from(json["runners"].map((x) => Runner.fromJson(x))),
    );

    RunnerDataModel({
        required this.runnerCount,
        required this.runnersList,
    });
    int runnerCount;
    List<Runner> runnersList;
}

class Runner {

    Runner({
        required this.selectionId,
        required this.selectionNumber,
        required this.horseName,
        required this.jockeyName,
        required this.trainerName,
        required this.track,
        required this.raceId,
        required this.raceNumber,
        required this.jumpTimeAu,
        required this.silksImage,
        required this.odds,
    });

    factory Runner.fromJson(Map<String, dynamic> json) => Runner(
        selectionId: json["selection_id"],
        selectionNumber: json["selection_number"],
        horseName: json["horse_name"],
        jockeyName: json["jockey_name"],
        trainerName: json["trainer_name"],
        track: json["track"],
        raceId: json["race_id"],
        raceNumber: json["race_number"],
        jumpTimeAu: json["jump_time_au"],
        silksImage: json["silks_image"],
        odds: json["odds"]?.toDouble(),
    );
    int selectionId;
    int selectionNumber;
    String horseName;
    String jockeyName;
    String trainerName;
    String track;
    int raceId;
    int raceNumber;
    String jumpTimeAu;
    String silksImage;
    double odds;

}
