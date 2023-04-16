// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

List<LocationModel> locationModelFromJson(String str) => List<LocationModel>.from(json.decode(str).map((x) => LocationModel.fromJson(x)));

String locationModelToJson(List<LocationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationModel {
  LocationModel({
    required this.id,
    required this.cityId,
    required this.name,
  });

  String id;
  String cityId;
  String name;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    id: json["id"],
    cityId: json["city_id"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "city_id": cityId,
    "Name": name,
  };
}
