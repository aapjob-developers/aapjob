import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:Aap_job/data/datasource/remote/exception/api_error_handler.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:flutter/material.dart';

class JobtitleRepo {
  final DioClient dioClient;
  JobtitleRepo({required this.dioClient});

  Future<ApiResponse> getJobtitle() async {
    try {
      final response = await dioClient.get(AppConstants.JOB_TITLE_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}