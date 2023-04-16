import 'package:flutter/material.dart';
import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:Aap_job/data/datasource/remote/exception/api_error_handler.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:Aap_job/utill/app_constants.dart';


class HrPlanRepo {
  final DioClient dioClient;
  HrPlanRepo({required this.dioClient});

  Future<ApiResponse> getHrPlanList() async {
    try {
      final response = await dioClient.get(AppConstants.HR_PLAN_URI);
      print(response);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // Future<ApiResponse> getHrPlanById(String userid) async {
  //   try {
  //     final response = await dioClient.get(AppConstants.CATEGORIES_URI+"?userid="+userid);
  //     print(response);
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }


}