// To parse this JSON data, do
//
//     final hrModel = hrModelFromJson(jsonString);

import 'dart:convert';

import 'package:Aap_job/models/CurrentPlanModel.dart';
import 'package:Aap_job/models/HrPlanModel.dart';

HrModel hrModelFromJson(String str) => HrModel.fromJson(json.decode(str));

String hrModelToJson(HrModel data) => json.encode(data.toJson());

class HrModel {
  HrModel({
    required this.user,
    required this.planModel,
    required this.message,
    required this.success,
    required this.route,
  });

  HrUser user;
  CurrentPlanModel planModel;
  String message;
  bool success;
  String route;

  factory HrModel.fromJson(Map<String, dynamic> json) => HrModel(
    user: HrUser.fromJson(json["user"]),
    planModel: CurrentPlanModel.fromJson(json["package"]),
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

class HrUser {
  HrUser({
    required this.id,
    required this.name,
    required this.companyName,
    required this.idCardSrc,
    required this.gst,
    required this.city,
    required this.location,
    required this.address,
    required this.email,
    required this.passkey,
    required this.resumeType,
    required this.resumeSrc,
    required this.docResumeSrc,
    required this.languageId,
    required this.currentPlanId,
    required this.status,
    required this.mobile,
    required this.profileComplete,
    required this.AccessToken,
    required this.fullsubmited,
  });

  String id;
  String name;
  String companyName;
  dynamic idCardSrc;
  String gst;
  String city;
  String location;
  String address;
  String email;
  dynamic passkey;
  String resumeType;
  String resumeSrc;
  String docResumeSrc;
  dynamic languageId;
  String currentPlanId;
  String status;
  String mobile;
  String profileComplete;
  String AccessToken;
  String fullsubmited;
  factory HrUser.fromJson(Map<String, dynamic> json) => HrUser(
    id: json["id"],
    name: json["name"]??"",
    companyName: json["company_name"]??"",
    idCardSrc: json["id_card_src"]??"",
    gst: json["gst"]??"",
    city: json["city"]??"",
    location: json["location"]??"",
    address: json["address"]??"",
    email: json["email"]??"",
    passkey: json["passkey"]??"",
    resumeType: json["resume_type"]??"",
    resumeSrc: json["resume_src"]??"",
    docResumeSrc: json["doc_resume_src"]??"",
    languageId: json["language_id"]??"",
    currentPlanId: json["current_plan_id"]??"",
    status: json["status"]??"",
    mobile: json["mobile"]??"",
    profileComplete: json["ProfileComplete"]??"",
    AccessToken: json["AccessToken"]??"",
    fullsubmited: json["fullsubmited"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "company_name": companyName,
    "id_card_src": idCardSrc,
    "gst": gst,
    "city": city,
    "location": location,
    "address": address,
    "email": email,
    "passkey": passkey,
    "resume_type": resumeType,
    "resume_src": resumeSrc,
    "doc_resume_src": docResumeSrc,
    "language_id": languageId,
    "current_plan_id": currentPlanId,
    "status": status,
    "mobile": mobile,
    "ProfileComplete": profileComplete,
    "AccessToken":AccessToken,
    "fullsubmited":fullsubmited,
  };
}
