
import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:Aap_job/data/datasource/remote/exception/api_error_handler.dart';
import 'package:Aap_job/helper/LocationManager.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashRepo {
  final DioClient dioClient;
  final SharedPreferences? sharedPreferences;
  SplashRepo({required this.dioClient, required this.sharedPreferences});

  // Future<ApiResponse> getConfig() async {
  //   try {
  //     final response = await dioClient.get(AppConstants.CONFIG_URI);
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }


  // void initSharedData() async {
  //
  // }

  bool getloggedin() {
    return sharedPreferences!.getBool("loggedin")??false;
  }
  bool getacctype() {
    return sharedPreferences!.getBool("acctype")??false;
  }

  bool getstep1() {
    return sharedPreferences!.getBool("step1")??false;
  }

  bool getstep2() {
    return sharedPreferences!.getBool("step2")??false;
  }

  bool getstep3() {
    return sharedPreferences!.getBool("step3")??false;
  }
  bool getstep4() {
    return sharedPreferences!.getBool("step4")??false;
  }
  bool getstep5() {
    return sharedPreferences!.getBool("step5")??false;
  }

  String getjobtypelist() {
    return sharedPreferences!.getString("jobtypelist") ?? "none";;
  }

  // void disableIntro() {
  //   sharedPreferences!.setBool(AppConstants.INTRO, false);
  // }
  //
  // bool showIntro() {
  //   return sharedPreferences!.getBool(AppConstants.INTRO);
  // }


}
