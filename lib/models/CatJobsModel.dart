// // To parse this JSON data, do
// //
// //     final jobsModel = jobsModelFromJson(jsonString);
//
// import 'dart:convert';
//
// JobsModel jobsModelFromJson(String str) => JobsModel.fromJson(json.decode(str));
//
// String jobsModelToJson(JobsModel data) => json.encode(data.toJson());
//
// class JobsModel {
//   JobsModel({
//     this.id,
//     this.recruiterId,
//     this.categoryId,
//     this.jobRole,
//     this.workplace,
//     this.companyName,
//     this.companyWebsite,
//     this.jobCityId,
//     this.address,
//     this.typeOfJob,
//     this.minSalary,
//     this.maxSalary,
//     this.openingsNo,
//     this.shift,
//     this.minQualification,
//     this.gender,
//     this.experienceLevel,
//     this.minExp,
//     this.maxExp,
//     this.englishLevel,
//     this.des,
//     this.recruiterName,
//     this.recruiterMobile,
//     this.status,
//   });
//
//   String id;
//   String recruiterId;
//   String categoryId;
//   String jobRole;
//   String workplace;
//   String companyName;
//   String companyWebsite;
//   String jobCityId;
//   String address;
//   String typeOfJob;
//   String minSalary;
//   String maxSalary;
//   String openingsNo;
//   String shift;
//   String minQualification;
//   String gender;
//   String experienceLevel;
//   String minExp;
//   String maxExp;
//   String englishLevel;
//   String des;
//   String recruiterName;
//   String recruiterMobile;
//   String status;
//
//   factory JobsModel.fromJson(Map<String, dynamic> json) => JobsModel(
//     id: json["id"],
//     recruiterId: json["recruiter_id"],
//     categoryId: json["category_id"],
//     jobRole: json["job_role"],
//     workplace: json["workplace"],
//     companyName: json["company_name"],
//     companyWebsite: json["company_website"],
//     jobCityId: json["job_city_id"],
//     address: json["address"],
//     typeOfJob: json["type_of_job"],
//     minSalary: json["min_salary"],
//     maxSalary: json["max_salary"],
//     openingsNo: json["openings_no"],
//     shift: json["shift"],
//     minQualification: json["min_qualification"],
//     gender: json["gender"],
//     experienceLevel: json["experience_level"],
//     minExp: json["min_exp"],
//     maxExp: json["max_exp"],
//     englishLevel: json["english_level"],
//     des: json["des"],
//     recruiterName: json["recruiter_name"],
//     recruiterMobile: json["recruiter_mobile"],
//     status: json["status"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "recruiter_id": recruiterId,
//     "category_id": categoryId,
//     "job_role": jobRole,
//     "workplace": workplace,
//     "company_name": companyName,
//     "company_website": companyWebsite,
//     "job_city_id": jobCityId,
//     "address": address,
//     "type_of_job": typeOfJob,
//     "min_salary": minSalary,
//     "max_salary": maxSalary,
//     "openings_no": openingsNo,
//     "shift": shift,
//     "min_qualification": minQualification,
//     "gender": gender,
//     "experience_level": experienceLevel,
//     "min_exp": minExp,
//     "max_exp": maxExp,
//     "english_level": englishLevel,
//     "des": des,
//     "recruiter_name": recruiterName,
//     "recruiter_mobile": recruiterMobile,
//     "status": status,
//   };
// }



// To parse this JSON data, do
//
//     final jobsModel = jobsModelFromJson(jsonString);
// To parse this JSON data, do
//
//     final jobsModel = jobsModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final jobsModel = jobsModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final jobsModel = jobsModelFromJson(jsonString);

import 'dart:convert';

List<CatJobsModel> CatJobsModelFromJson(String str) => List<CatJobsModel>.from(json.decode(str).map((x) => CatJobsModel.fromJson(x)));

String CatJobsModelToJson(List<CatJobsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CatJobsModel {
  CatJobsModel({
    required this.id,
    required this.recruiterId,
    required this.recruiterImage,
    required this.categoryId,
    required this.jobRole,
    required this.companyName,
    required this.maxSalary,
    required this.openingsNo,
    required this.recruiterName,
    required this.createdAt,
    required this.expiredAt,
    required this.jobcity,
    required this.jobcat,
    required this.create_time,
  });

  String id;
  String recruiterId;
  String recruiterImage;
  String categoryId;
  String jobRole;
  String companyName;
  String maxSalary;
  String openingsNo;
  String recruiterName;
  DateTime createdAt;
  dynamic expiredAt;
  String jobcity;
  String jobcat;
  DateTime create_time;
  factory CatJobsModel.fromJson(Map<String, dynamic> json) => CatJobsModel(
    id: json["id"],
    recruiterId: json["recruiter_id"],
    recruiterImage: json["recruiter_image"],
    categoryId: json["category_id"],
    jobRole: json["job_role"],
    companyName: json["company_name"],
    maxSalary: json["max_salary"],
    openingsNo: json["openings_no"],
    recruiterName: json["recruiter_name"],
    createdAt: DateTime.parse(json["created_at"]),
    expiredAt: json["expired_at"],
    jobcity: json["jobcity"],
    jobcat: json["jobcat"],
    create_time: DateTime.parse(json["create_time"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "recruiter_id": recruiterId,
    "recruiter_image": recruiterImage,
    "category_id": categoryId,
    "job_role": jobRole,
    "company_name": companyName,
    "max_salary": maxSalary,
    "openings_no": openingsNo,
    "recruiter_name": recruiterName,
    "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
    "expired_at": expiredAt,
    "jobcity": jobcity,
    "jobcat": jobcat,
    "created_at": "${create_time.year.toString().padLeft(4, '0')}-${create_time.month.toString().padLeft(2, '0')}-${create_time.day.toString().padLeft(2, '0')}",
  };
}

class Benefits {
  Benefits({
    required this.id,
    required this.jobId,
    required this.cab,
    required this.meal,
    required this.insurance,
    required this.pf,
    required this.medical,
    required this.other,
  });

  String id;
  String jobId;
  String cab;
  String meal;
  String insurance;
  String pf;
  String medical;
  String other;

  factory Benefits.fromJson(Map<String, dynamic> json) => Benefits(
    id: json["id"],
    jobId: json["job_id"],
    cab: json["cab"],
    meal: json["meal"],
    insurance: json["insurance"],
    pf: json["PF"],
    medical: json["medical"],
    other: json["other"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "job_id": jobId,
    "cab": cab,
    "meal": meal,
    "insurance": insurance,
    "PF": pf,
    "medical": medical,
    "other": other,
  };
}
