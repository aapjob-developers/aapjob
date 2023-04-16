// To parse this JSON data, do
//
//     final langModel = langModelFromJson(jsonString);

import 'dart:convert';

LangModel langModelFromJson(String str) => LangModel.fromJson(json.decode(str));

String langModelToJson(LangModel data) => json.encode(data.toJson());

class LangModel {
  LangModel({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory LangModel.fromJson(Map<String, dynamic> json) => LangModel(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
