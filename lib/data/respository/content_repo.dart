import 'package:flutter/material.dart';
import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:Aap_job/data/datasource/remote/exception/api_error_handler.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:Aap_job/utill/app_constants.dart';


class ContentRepo {
  final DioClient dioClient;
  ContentRepo({required this.dioClient});

  Future<ApiResponse> getAllContent() async {
    try {
      final response = await dioClient.get(AppConstants.CONTENT_URI);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getContent() async {
    try {
      final response = await dioClient.get(AppConstants.HOMEPAGE_AD_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getResumeContent() async {
    try {
      final response = await dioClient.get(AppConstants.RESUME_TUTORIAL_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> getFront() async {
    try {
      final response = await dioClient.get(AppConstants.HOMEPAGE_FRONT_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getHRContent() async {
    try {
      final response = await dioClient.get(AppConstants.HR_HOMEPAGE_AD_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> getHrResumeContent() async {
    try {
      final response = await dioClient.get(AppConstants.HR_RESUME_TUTORIAL_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getHrFront() async {
    try {
      final response = await dioClient.get(AppConstants.HR_HOMEPAGE_FRONT_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}