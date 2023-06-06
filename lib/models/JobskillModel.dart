// To parse this JSON data, do
//
//     final jobskillModel = jobskillModelFromJson(jsonString);

import 'dart:convert';

List<JobskillModel> jobskillModelFromJson(String str) => List<JobskillModel>.from(json.decode(str).map((x) => JobskillModel.fromJson(x)));

String jobskillModelToJson(List<JobskillModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JobskillModel {
  JobskillModel({
    required this.id,
    required this.jobCatId,
    required this.name,
  });

  String id;
  String jobCatId;
  String name;

  factory JobskillModel.fromJson(Map<String, dynamic> json) => JobskillModel(
    id: json["id"],
    jobCatId: json["job_title_id"]==null?json["job_cat_id"]:json["job_title_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "job_cat_id": jobCatId,
    "name": name,
  };
}
