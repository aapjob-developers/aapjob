// To parse this JSON data, do
//
//     final cityModel = cityModelFromJson(jsonString);

import 'dart:convert';

List<CityModel> cityModelFromJson(String str) => List<CityModel>.from(json.decode(str).map((x) => CityModel.fromJson(x)));

String cityModelToJson(List<CityModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityModel {
  CityModel({
     this.id,
    this.name,
    this.iconSrc,
  });

  String? id;
  String? name;
  String? iconSrc;

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
    id: json["id"],
    name: json["name"],
    iconSrc: json["icon_src"] == null ? null : json["icon_src"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon_src": iconSrc == null ? null : iconSrc,
  };
}
