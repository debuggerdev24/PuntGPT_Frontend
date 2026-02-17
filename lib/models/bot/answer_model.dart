class AnswerModel {

  factory AnswerModel.fromJson(Map<String, dynamic> json) => AnswerModel(
    answer: json["answer"],
    sessionId: json["session_id"],
  );

  AnswerModel({required this.answer, required this.sessionId});
  final String answer,sessionId;
}