// To parse this JSON data, do
//
//     final contentModel = contentModelFromJson(jsonString);

import 'dart:convert';

ContentModel contentModelFromJson(String str) => ContentModel.fromJson(json.decode(str));

String contentModelToJson(ContentModel data) => json.encode(data.toJson());

class ContentModel {
  ContentModel({
     this.id,
     this.name,
     this.url,
     this.imgSrc,
     this.internalVideoSrc,
     this.status,
  });

  String? id;
  String? name;
  dynamic url;
  String? imgSrc;
  String? internalVideoSrc;
  String? status;

  factory ContentModel.fromJson(Map<String, dynamic> json) => ContentModel(
    id: json["id"],
    name: json["name"],
    url: json["url"],
    imgSrc: json["img_src"],
    internalVideoSrc: json["internal_video_src"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url": url,
    "img_src": imgSrc,
    "internal_video_src": internalVideoSrc,
    "status": status,
  };
}
