// To parse this JSON data, do
//
//     final adsModel = adsModelFromJson(jsonString);

import 'dart:convert';

AdsModel adsModelFromJson(String str) => AdsModel.fromJson(json.decode(str));

String adsModelToJson(AdsModel data) => json.encode(data.toJson());

class AdsModel {
  AdsModel({
    required this.id,
    required this.name,
    this.url,
    required this.adType,
    this.imgSrc,
    required this.videoType,
    this.internalVideoSrc,
    required this.externalVideoSrc,
    required this.belowLanguage,
    required this.status,
  });

  String id;
  String name;
  dynamic url;
  String adType;
  dynamic imgSrc;
  String videoType;
  dynamic internalVideoSrc;
  String externalVideoSrc;
  String belowLanguage;
  String status;

  factory AdsModel.fromJson(Map<String, dynamic> json) => AdsModel(
    id: json["id"],
    name: json["name"],
    url: json["url"],
    adType: json["ad_type"],
    imgSrc: json["img_src"],
    videoType: json["video_type"],
    internalVideoSrc: json["internal_video_src"]??"",
    externalVideoSrc: json["external_video_src"]??"",
    belowLanguage: json["below_language"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url": url,
    "ad_type": adType,
    "img_src": imgSrc,
    "video_type": videoType,
    "internal_video_src": internalVideoSrc,
    "external_video_src": externalVideoSrc,
    "below_language": belowLanguage,
    "status": status,
  };
}
