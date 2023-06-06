import 'package:flutter/material.dart';
import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:Aap_job/data/datasource/remote/exception/api_error_handler.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ConfigRepo {
  final DioClient dioClient;
  ConfigRepo({required this.dioClient, required this.sharedPreferences});
  final SharedPreferences? sharedPreferences;


  Future<ApiResponse> getConfig() async {
    try {
      final response = await dioClient.get(AppConstants.CONFIG_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  String getAppVersion()
  {
    return sharedPreferences!.getString("AppVersion")??"36";
  }

  void saveVersion(String version)
  {
    sharedPreferences!.setString("AppVersion", version);
  }

}