// To parse this JSON data, do
//
//     final jobTitleModel = jobTitleModelFromJson(jsonString);

import 'dart:convert';

List<JobTitleModel> jobTitleModelFromJson(String str) => List<JobTitleModel>.from(json.decode(str).map((x) => JobTitleModel.fromJson(x)));

String jobTitleModelToJson(List<JobTitleModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JobTitleModel {
  JobTitleModel({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory JobTitleModel.fromJson(Map<String, dynamic> json) => JobTitleModel(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
