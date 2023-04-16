// To parse this JSON data, do
//
//     final complaintReasonModel = complaintReasonModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<ComplaintReasonModel> complaintReasonModelFromJson(String str) => List<ComplaintReasonModel>.from(json.decode(str).map((x) => ComplaintReasonModel.fromJson(x)));

String complaintReasonModelToJson(List<ComplaintReasonModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ComplaintReasonModel {
  ComplaintReasonModel({
    required this.name,
  });

  String name;

  factory ComplaintReasonModel.fromJson(Map<String, dynamic> json) => ComplaintReasonModel(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
