import 'dart:convert';

import 'package:Aap_job/data/respository/notification_repo.dart';
import 'package:Aap_job/helper/api_checker.dart';
import 'package:Aap_job/models/notification_model.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:flutter/material.dart';


class NotificationProvider extends ChangeNotifier {
  final NotificationRepo notificationRepo;

  NotificationProvider({required this.notificationRepo});

  List<NotificationModel> _notificationList=<NotificationModel>[];
  List<NotificationModel> get notificationList => _notificationList;
  int _hr_noti_count=0;
  int get hr_noti_count => _hr_noti_count;
  int _noti_count=0;
  int get noti_count => _noti_count;

  Future<void> initNotificationList(BuildContext context, String Userid) async {
    ApiResponse? apiResponse = await notificationRepo.getNotificationList(Userid);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _notificationList = [];
      print("hrnote-${apiResponse.response!.data}");
      List<Map<String, dynamic>> output = List.from(json.decode(apiResponse.response!.data.toString()) as List);
      output.forEach((job) => _notificationList.add(NotificationModel.fromJson(job)));
      _noti_count=_notificationList.length;
      // apiResponse.response.data.forEach((notification) => _notificationList.add(NotificationModel.fromJson(notification)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> initNotificationList2(BuildContext context, String Userid) async {
    ApiResponse apiResponse = await notificationRepo.getNotificationList2(Userid);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _notificationList = [];
      List<Map<String, dynamic>> output = List.from(json.decode(apiResponse.response!.data.toString()) as List);
      output.forEach((job) => _notificationList.add(NotificationModel.fromJson(job)));
      _hr_noti_count=_notificationList.length;
      // apiResponse.response.data.forEach((notification) => _notificationList.add(NotificationModel.fromJson(notification)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

}
