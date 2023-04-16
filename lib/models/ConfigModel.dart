// To parse this JSON data, do
//
//     final configModel = configModelFromJson(jsonString);

import 'dart:convert';

ConfigModel configModelFromJson(String str) => ConfigModel.fromJson(json.decode(str));

String configModelToJson(ConfigModel data) => json.encode(data.toJson());

class ConfigModel {
  ConfigModel({
    this.id,
    this.ccMobile,
    this.ccEmail,
    this.ccWhatsapp,
    this.refAmt,
    this.appVersion,
  });

  String? id;
  String? ccMobile;
  String? ccEmail;
  String? ccWhatsapp;
  String? refAmt;
  String? appVersion;

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
    id: json["id"],
    ccMobile: json["cc_mobile"],
    ccEmail: json["cc_email"],
    ccWhatsapp: json["cc_whatsapp"],
    refAmt: json["ref_amt"],
    appVersion: json["app_version"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cc_mobile": ccMobile,
    "cc_email": ccEmail,
    "cc_whatsapp": ccWhatsapp,
    "ref_amt": refAmt,
    "app_version": appVersion,
  };
}
