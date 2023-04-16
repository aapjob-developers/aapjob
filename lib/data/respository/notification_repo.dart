
import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:Aap_job/data/datasource/remote/exception/api_error_handler.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class NotificationRepo {
  final DioClient dioClient;
  NotificationRepo({required this.dioClient});

  Future<ApiResponse> getNotificationList(String Userid) async {
    try {
      Response response = await dioClient.get(AppConstants.NOTIFICATION_URI+"?userid="+Userid);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> getNotificationList2(String Userid) async {
    try {
      Response response = await dioClient.get(AppConstants.HR_NOTIFICATION_URI+"?userid="+Userid);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}