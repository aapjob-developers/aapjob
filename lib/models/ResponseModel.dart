
import 'dart:convert';

NewResponseModel userModelFromJson(String str) => NewResponseModel.fromJson(json.decode(str));

String userModelToJson(NewResponseModel data) => json.encode(data.toJson());

class NewResponseModel {
  NewResponseModel({
    required this.message,
    required this.success,
    required this.route,
  });

  String message;
  bool success;
  String route;

  factory NewResponseModel.fromJson(Map<String, dynamic> json) => NewResponseModel(
    message: json["message"],
    success: json["success"],
    route: json["route"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "success": success,
    "route": route,
  };
}
