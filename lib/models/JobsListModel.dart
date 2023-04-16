
import 'dart:convert';

List<JobsListModel> jobsModelFromJson(String str) => List<JobsListModel>.from(json.decode(str).map((x) => JobsListModel.fromJson(x)));

String jobsModelToJson(List<JobsListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JobsListModel {
  JobsListModel({
    this.id,
    this.jobRole,
    this.companyName,
    this.jobLocation,
    this.openingsNo,
    this.status,
    this.createdAt,
    this.expiredAt,
    this.jobcity,
    this.applied,
    this.views,
    this.create_time,
  });

  String? id;
  String? jobRole;
  String? companyName;
  String? jobLocation;
  String? openingsNo;
  String? status;
  DateTime? createdAt;
  dynamic expiredAt;
  String? jobcity;
  int? applied;
  String? views;
  DateTime? create_time;

  factory JobsListModel.fromJson(Map<String, dynamic> json) => JobsListModel(
    id: json["id"],
    jobRole: json["job_role"],
    companyName: json["company_name"],
    jobLocation: json["job_location"],
    openingsNo: json["openings_no"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    expiredAt: json["expired_at"],
    jobcity: json["jobcity"],
    applied: json["applied"],
    views: json["views"],
    create_time: DateTime.parse(json["create_time"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "job_role": jobRole,
    "company_name": companyName,
    "job_location": jobLocation,
    "openings_no": openingsNo,
    "status": status,
    "created_at": "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
    "expired_at": expiredAt,
    "jobcity": jobcity,
    "applied": applied,
    "views": views,
    "created_at": "${create_time!.year.toString().padLeft(4, '0')}-${create_time!.month.toString().padLeft(2, '0')}-${create_time!.day.toString().padLeft(2, '0')}",
  };
}
