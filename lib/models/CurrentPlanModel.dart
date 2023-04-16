// To parse this JSON data, do
//
//     final currentPlanModel = currentPlanModelFromJson(jsonString);

import 'dart:convert';

CurrentPlanModel currentPlanModelFromJson(String str) => CurrentPlanModel.fromJson(json.decode(str));

String currentPlanModelToJson(CurrentPlanModel data) => json.encode(data.toJson());

class CurrentPlanModel {
  CurrentPlanModel({
      this.planType,
      this.purchaseDate,
      this.planId,
      this.planName,
      this.planIcon,
      this.package,
  });

  String? planType;
  DateTime? purchaseDate;
  String? planId;
  String? planName;
  String? planIcon;
  dynamic package;

  factory CurrentPlanModel.fromJson(Map<String, dynamic> json) => CurrentPlanModel(
    planType: json["plan_type"],
    purchaseDate: DateTime.parse(json["purchase_date"]),
    planId: json["plan_id"],
    planName: json["plan_name"],
    planIcon: json["plan_icon"],
    package: json["plan_type"]=="r"?RecruiterPackage.fromJson(json["package"]):ConsultancyPackage.fromJson(json["package"]),
  );

  Map<String, dynamic> toJson() => {
    "plan_type": planType,
    "purchase_date": "${purchaseDate!.year.toString().padLeft(4, '0')}-${purchaseDate!.month.toString().padLeft(2, '0')}-${purchaseDate!.day.toString().padLeft(2, '0')}",
    "plan_id": planId,
    "plan_name": planName,
    "plan_icon": planIcon,
    "package": package.toJson(),
  };
}

class RecruiterPackage {
  RecruiterPackage({
      this.id,
      this.name,
      this.iconSrc,
      this.typeId,
      this.days,
      this.originalPrice,
      this.discountPrice,
      this.profilePerApplication,
      this.totalJobPost,
     this.type,
  });

  String? id;
  String? name;
  String? iconSrc;
  String? typeId;
  String? days;
  String? originalPrice;
  String? discountPrice;
  String? profilePerApplication;
  String? totalJobPost;
  String? type;

  factory RecruiterPackage.fromJson(Map<String, dynamic> json) => RecruiterPackage(
    id: json["id"],
    name: json["name"],
    iconSrc: json["icon_src"],
    typeId: json["type_id"],
    days: json["days"],
    originalPrice: json["original_price"],
    discountPrice: json["discount_price"],
    profilePerApplication: json["profile_per_application"],
    totalJobPost: json["total_job_post"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon_src": iconSrc,
    "type_id": typeId,
    "days": days,
    "original_price": originalPrice,
    "discount_price": discountPrice,
    "profile_per_application": profilePerApplication,
    "total_job_post": totalJobPost,
  };
}


class ConsultancyPackage {
  ConsultancyPackage({
      this.id,
      this.name,
      this.iconSrc,
      this.des,
      this.jobPostNo,
      this.totalResumes,
      this.perdayLimit,
      this.validity,
      this.originalPrice,
      this.discountPrice,
  });

  String? id;
  String? name;
  String? iconSrc;
  String? des;
  String? jobPostNo;
  String? totalResumes;
  String? perdayLimit;
  String? validity;
  String? originalPrice;
  String? discountPrice;

  factory ConsultancyPackage.fromJson(Map<String, dynamic> json) => ConsultancyPackage(
    id: json["id"],
    name: json["name"],
    iconSrc: json["icon_src"],
    des: json["des"],
    jobPostNo: json["job_post_no"],
    totalResumes: json["total_resumes"],
    perdayLimit: json["perday_limit"],
    validity: json["validity"],
    originalPrice: json["original_price"],
    discountPrice: json["discount_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon_src": iconSrc,
    "des": des,
    "job_post_no": jobPostNo,
    "total_resumes": totalResumes,
    "perday_limit": perdayLimit,
    "validity": validity,
    "original_price": originalPrice,
    "discount_price": discountPrice,
  };
}
