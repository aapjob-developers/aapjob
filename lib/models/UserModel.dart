// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.user,
    required this.message,
    required this.success,
    required this.route,
  });

  User user;
  String message;
  bool success;
  String route;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    user: User.fromJson(json["user"]),
    message: json["message"],
    success: json["success"],
    route: json["route"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "message": message,
    "success": success,
    "route": route,
  };
}

class User {
  User({
    required this.id,
    required this.name,
    required this.gender,
    required this.profileImage,
    required this.dob,
    required this.resumeType,
    required this.resumeSrc,
    required this.docResumeSrc,
    required this.mobile,
    required this.password,
    required this.email,
    required this.address,
    required this.preferredCity,
    required this.myexp,
    required this.languageId,
    required this.status,
    required this.accessToken,
    required this.edu,
    required this.jobexp,
    required this.fullsubmited,
  });

  String id;
  String name;
  String gender;
  String profileImage;
  dynamic dob;
  String resumeType;
  dynamic resumeSrc;
  String docResumeSrc;
  String mobile;
  dynamic password;
  String email;
  String address;
  String preferredCity;
  String myexp;
  dynamic languageId;
  String status;
  String accessToken;
  List<Edu> edu;
  List<Jobexp> jobexp;
  String fullsubmited;
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"]??"",
    gender: json["gender"]??"",
    profileImage: json["profile_image"]??"",
    dob: json["dob"]??"",
    resumeType: json["resume_type"]??"",
    resumeSrc: json["resume_src"]??"",
    docResumeSrc: json["doc_resume_src"]??"",
    mobile: json["mobile"]??"",
    password: json["password"]??"",
    email: json["email"]??"",
    address: json["address"]??"",
    preferredCity: json["preferred_city"]??"",
    myexp: json["myexp"]??"",
    languageId: json["language_id"]??"",
    status: json["status"]??"",
    accessToken: json["AccessToken"]??"",
    edu: List<Edu>.from(json["edu"].map((x) => Edu.fromJson(x))),
    jobexp: List<Jobexp>.from(json["jobexp"].map((x) => Jobexp.fromJson(x))),
      fullsubmited:json["fullsubmited"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "gender": gender,
    "profile_image": profileImage,
    "dob": dob,
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
    "AccessToken": accessToken,
    "edu": List<dynamic>.from(edu.map((x) => x.toJson())),
    "jobexp": List<dynamic>.from(jobexp.map((x) => x.toJson())),
    "fullsubmited":fullsubmited,
  };
}


class Edu {
  Edu({
    required this.id,
    required this.candidateId,
    required this.level,
    required this.degreeOrName,
    required this.university,
    required this.startDate,
    required this.endDate,
  });

  String id;
  String candidateId;
  String level;
  String degreeOrName;
  String university;
  dynamic startDate;
  dynamic endDate;

  factory Edu.fromJson(Map<String, dynamic> json) => Edu(
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

class Jobexp {
  Jobexp({
    required this.id,
    required this.cId,
    required this.jobTitle,
    required this.companyName,
    required this.experience,
    required this.currentyWorkingHere,
    required this.currentSalary,
    required this.startDate,
    required this.endDate,
  });

  String id;
  String cId;
  String jobTitle;
  String companyName;
  String experience;
  String currentyWorkingHere;
  String currentSalary;
  dynamic startDate;
  dynamic endDate;

  factory Jobexp.fromJson(Map<String, dynamic> json) => Jobexp(
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
