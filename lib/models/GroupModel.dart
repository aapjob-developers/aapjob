// To parse this JSON data, do
//
//     final groupModel = groupModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<GroupModel> groupModelFromJson(String str) => List<GroupModel>.from(json.decode(str).map((x) => GroupModel.fromJson(x)));

String groupModelToJson(List<GroupModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupModel {
  GroupModel({
    required this.id,
    required this.name,
    required this.iconSrc,
    required this.categoryId,
    required this.link,
    required this.totalMember,
  });

  String id;
  String name;
  String iconSrc;
  String categoryId;
  String link;
  String totalMember;

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    id: json["id"],
    name: json["name"],
    iconSrc: json["icon_src"],
    categoryId: json["category_id"],
    link: json["link"],
    totalMember: json["total_member"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon_src": iconSrc,
    "category_id": categoryId,
    "link": link,
    "total_member": totalMember,
  };
}
