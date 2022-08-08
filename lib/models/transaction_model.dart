import 'dart:convert';

class TransactonModel {
  String? id;
  String? userId, activity, reward, date, type, status, beneficiary;
  TransactonModel(
      {required this.id,
      required this.userId,
      required this.activity,
      required this.reward,
      required this.type,
      required this.status,
      required this.date,
      required this.beneficiary});

  factory TransactonModel.fromjson(Map<String, dynamic> json) {
    return TransactonModel(
        id: json['id'],
        userId: json['userId'],
        activity: json['activity'],
        reward: json['reward'],
        type: json['type'],
        status: json['status'],
        date: json['date'],
        beneficiary: json['beneficiary']);
  }
}
