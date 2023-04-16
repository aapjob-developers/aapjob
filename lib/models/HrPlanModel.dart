// To parse this JSON data, do
//
//     final hrPlanModel = hrPlanModelFromJson(jsonString);

import 'dart:convert';

HrPlanModel hrPlanModelFromJson(String str) => HrPlanModel.fromJson(json.decode(str));

String hrPlanModelToJson(HrPlanModel data) => json.encode(data.toJson());

class HrPlanModel {
  HrPlanModel({
    required this.id,
    required this.name,
    required this.iconSrc,
    required this.typeId,
    required this.targetProfile,
    required this.perApplication,
    required this.staffHiring,
    required this.days,
    required this.price,
  });

  String id;
  String name;
  String iconSrc;
  String typeId;
  String targetProfile;
  String perApplication;
  String staffHiring;
  String days;
  String price;

  factory HrPlanModel.fromJson(Map<String, dynamic> json) => HrPlanModel(
    id: json["id"],
    name: json["name"],
    iconSrc: json["icon_src"],
    typeId: json["type_id"],
    targetProfile: json["target_profile"],
    perApplication: json["per_application"],
    staffHiring: json["staff_hiring"],
    days: json["days"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon_src": iconSrc,
    "type_id": typeId,
    "target_profile": targetProfile,
    "per_application": perApplication,
    "staff_hiring": staffHiring,
    "days": days,
    "price": price,
  };
}
