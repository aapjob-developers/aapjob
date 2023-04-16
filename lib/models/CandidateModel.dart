// To parse this JSON data, do
//
//     final candidateModel = candidateModelFromJson(jsonString);

import 'dart:convert';

List<CandidateModel> candidateModelFromJson(String str) => List<CandidateModel>.from(json.decode(str).map((x) => CandidateModel.fromJson(x)));

String candidateModelToJson(List<CandidateModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CandidateModel {
  CandidateModel({
    this.id,
    this.name,
    this.gender,
    this.profileImage,
    this.resumeType,
    this.resumeSrc,
    this.docResumeSrc,
    this.mobile,
    this.password,
    this.email,
    this.address,
    this.preferredCity,
    this.myexp,
    this.languageId,
    this.status,
    this.exp,
    this.education,
    this.rating,
    required this.applydatetime,
  });

  String? id;
  String? name;
  String? gender;
  dynamic profileImage;
  String? resumeType;
  String? resumeSrc;
  String? docResumeSrc;
  String? mobile;
  dynamic password;
  String? email;
  String? address;
  String? preferredCity;
  String? myexp;
  dynamic languageId;
  String? status;
  List<Exp>? exp;
  List<Education>? education;
  dynamic rating;
  DateTime applydatetime;

  factory CandidateModel.fromJson(Map<String, dynamic> json) => CandidateModel(
    id: json["id"],
    name: json["name"],
    gender: json["gender"],
    profileImage: json["profile_image"],
    resumeType: json["resume_type"],
    resumeSrc: json["resume_src"],
    docResumeSrc: json["doc_resume_src"],
    mobile: json["mobile"],
    password: json["password"],
    email: json["email"],
    address: json["address"],
    preferredCity: json["preferred_city"],
    myexp: json["myexp"],
    languageId: json["language_id"],
    status: json["status"],
    exp: List<Exp>.from(json["exp"].map((x) => Exp.fromJson(x))),
    education: List<Education>.from(json["education"].map((x) => Education.fromJson(x))),
    rating: json["rating"],
    applydatetime:DateTime.parse(json["applyDateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "gender": gender,
    "profile_image": profileImage,
    "resume_type": resumeType,
    "resume_src": resumeSrc,
    "doc_resume_src": docResumeSrc,
    "mobile": mobile,
    "password": password,
    "email": email,
    "address": address,
    "preferred_city": preferredCity,
    "myexp": myexp,
    "language_id": languageId,
    "status": status,
    "exp": List<dynamic>.from(exp!.map((x) => x.toJson())),
    "education": List<dynamic>.from(education!.map((x) => x.toJson())),
    "rating":rating,
    "applyDateTime":applydatetime,
  };
}

class Education {
  Education({
    this.id,
    this.candidateId,
    this.level,
    this.degreeOrName,
    this.university,
    this.startDate,
    this.endDate,
  });

  String? id;
  String? candidateId;
  String? level;
  String? degreeOrName;
  String? university;
  dynamic startDate;
  dynamic endDate;

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    id: json["id"],
    candidateId: json["candidate_id"],
    level: json["level"],
    degreeOrName: json["degree_or_name"],
    university: json["university"],
    startDate: json["start_date"],
    endDate: json["end_date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "candidate_id": candidateId,
    "level": level,
    "degree_or_name": degreeOrName,
    "university": university,
    "start_date": startDate,
    "end_date": endDate,
  };
}

class Exp {
  Exp({
    this.id,
    this.cId,
    this.jobTitle,
    this.companyName,
    this.experience,
    this.currentyWorkingHere,
    this.currentSalary,
    this.startDate,
    this.endDate,
  });

  String? id;
  String? cId;
  String? jobTitle;
  String? companyName;
  String? experience;
  String? currentyWorkingHere;
  String? currentSalary;
  dynamic startDate;
  dynamic endDate;

  factory Exp.fromJson(Map<String, dynamic> json) => Exp(
    id: json["id"],
    cId: json["c_id"],
    jobTitle: json["job_title"],
    companyName: json["company_name"],
    experience: json["experience"],
    currentyWorkingHere: json["currenty_working_here"],
    currentSalary: json["current_salary"],
    startDate: json["start_date"],
    endDate: json["end_date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "c_id": cId,
    "job_title": jobTitle,
    "company_name": companyName,
    "experience": experience,
    "currenty_working_here": currentyWorkingHere,
    "current_salary": currentSalary,
    "start_date": startDate,
    "end_date": endDate,
  };
}
