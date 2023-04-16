import 'package:flutter/material.dart';
import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:Aap_job/data/datasource/remote/exception/api_error_handler.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:Aap_job/utill/app_constants.dart';


class HrJobRepo {
  final DioClient dioClient;
  HrJobRepo({required this.dioClient});


  Future<ApiResponse> getHrJobsList(String userid) async {
    try {
      final response = await dioClient.get(AppConstants.HR_JOBS_URI+userid);
      print(response);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getHrClosedJobsList(String userid) async {
    try {
      final response = await dioClient.get(AppConstants.HR_CLOSED_JOBS_URI+userid);
      print(response);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getHrJob(String jobid) async {
    try {
      final response = await dioClient.get(AppConstants.GET_JOB_DETAILS_URI+jobid);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getReasonList() async {
    try {
      final response = await dioClient.get(AppConstants.JOB_CLOSE_REASONS_URI);
      print(response);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}