// To parse this JSON data, do
//
//     final jobCategoryModel = jobCategoryModelFromJson(jsonString);

import 'dart:convert';

List<JobCategoryModel> jobCategoryModelFromJson(String str) => List<JobCategoryModel>.from(json.decode(str).map((x) => JobCategoryModel.fromJson(x)));

String jobCategoryModelToJson(List<JobCategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JobCategoryModel {
  JobCategoryModel({
    required this.id,
    required this.name,
    required this.iconSrc,
    required this.status,
  });

  String id;
  String name;
  String iconSrc;
  String status;

  factory JobCategoryModel.fromJson(Map<String, dynamic> json) => JobCategoryModel(
    id: json["id"],
    name: json["name"],
    iconSrc: json["icon_src"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon_src": iconSrc,
    "status": status,
  };
}
