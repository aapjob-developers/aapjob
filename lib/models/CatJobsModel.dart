// To parse this JSON data, do
//
//     final catJobsModel = catJobsModelFromJson(jsonString);

import 'dart:convert';

CatJobsModel catJobsModelFromJson(String str) => CatJobsModel.fromJson(json.decode(str));

String catJobsModelToJson(CatJobsModel data) => json.encode(data.toJson());

class CatJobsModel {
  String id;
  String categoryId;
  String jobRole;
  String companyName;
  String maxSalary;
  String openingsNo;
  String recruiterName;
  DateTime createdAt;
  DateTime createTime;
  String jobcity;
  String recruiterId;
  String recruiterImage;
  String jobcat;

  CatJobsModel({
    required this.id,
    required this.categoryId,
    required this.jobRole,
    required this.companyName,
    required this.maxSalary,
    required this.openingsNo,
    required this.recruiterName,
    required this.createdAt,
    required this.createTime,
    required this.jobcity,
    required this.recruiterId,
    required this.recruiterImage,
    required this.jobcat,
  });

  factory CatJobsModel.fromJson(Map<String, dynamic> json) => CatJobsModel(
    id: json["id"],
    categoryId: json["category_id"],
    jobRole: json["job_role"],
    companyName: json["company_name"],
    maxSalary: json["max_salary"],
    openingsNo: json["openings_no"],
    recruiterName: json["recruiter_name"],
    createdAt: DateTime.parse(json["created_at"]),
    createTime: DateTime.parse(json["create_time"]),
    jobcity: json["jobcity"],
    recruiterId: json["recruiter_id"],
    recruiterImage: json["recruiter_image"],
    jobcat: json["jobcat"],
  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "job_role": jobRole,
    "company_name": companyName,
    "max_salary": maxSalary,
    "openings_no": openingsNo,
    "recruiter_name": recruiterName,
    "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
    "create_time": createTime.toIso8601String(),
    "jobcity": jobcity,
    "recruiter_id": recruiterId,
    "recruiter_image": recruiterImage,
    "jobcat": jobcat,
  };
}


// class Benefits {
//   Benefits({
//     required this.id,
//     required this.jobId,
//     required this.cab,
//     required this.meal,
//     required this.insurance,
//     required this.pf,
//     required this.medical,
//     required this.other,
//   });
//
//   String id;
//   String jobId;
//   String cab;
//   String meal;
//   String insurance;
//   String pf;
//   String medical;
//   String other;
//
//   factory Benefits.fromJson(Map<String, dynamic> json) => Benefits(
//     id: json["id"],
//     jobId: json["job_id"],
//     cab: json["cab"],
//     meal: json["meal"],
//     insurance: json["insurance"],
//     pf: json["PF"],
//     medical: json["medical"],
//     other: json["other"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "job_id": jobId,
//     "cab": cab,
//     "meal": meal,
//     "insurance": insurance,
//     "PF": pf,
//     "medical": medical,
//     "other": other,
//   };
// }
