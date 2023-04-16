// To parse this JSON data, do
//
//     final LivedataModel = LivedataModelFromJson(jsonString);

import 'dart:convert';

LivedataModel LivedataModelFromJson(String str) => LivedataModel.fromJson(json.decode(str));

String LivedataModelToJson(LivedataModel data) => json.encode(data.toJson());

class LivedataModel {
  LivedataModel({
    required this.ComapnyName,
    required this.name,
    required this.email,
    required this.phone
  });

  String ComapnyName;
  String name;
  String email;
  String phone;

  factory LivedataModel.fromJson(Map<String, dynamic> json) => LivedataModel(
    ComapnyName: json["companyname"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"]
  );

  Map<String, dynamic> toJson() => {
    "id": ComapnyName,
    "name": name,
    "email":email,
    "phone":phone
  };
}
