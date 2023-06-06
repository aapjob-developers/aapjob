import 'dart:collection';
import 'dart:convert';

import 'package:Aap_job/data/chat/chat_auth_repository.dart';
import 'package:Aap_job/models/CurrentPlanModel.dart';
import 'package:Aap_job/models/ResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/data/respository/auth_repo.dart';
import 'package:Aap_job/models/HrModel.dart';
import 'package:Aap_job/models/UserModel.dart';
import 'package:Aap_job/models/langModel.dart';
import 'package:Aap_job/models/response/error_response.dart';
import 'package:Aap_job/models/response/response_model.dart';
import 'package:provider/provider.dart';
import '../models/register_model.dart';
import '../models/response/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;
  AuthProvider({required this.authRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<LangModel> _langList = [];

  List<LangModel> get langList => _langList;

  RecruiterPackage _recruiterPackage= new RecruiterPackage();
  ConsultancyPackage _consultancyPackage= new ConsultancyPackage();

  RecruiterPackage get recruiterPackage=>_recruiterPackage;

  ConsultancyPackage get consultancyPackage=> _consultancyPackage;

  Future sendotp(String phone, String otp, String signature,String acctype,Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await authRepo.sendotp(phone,otp,signature,acctype);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      print(apiResponse.response?.data);
      Map map = json.decode(apiResponse.response?.data);
      String message = map["message"];
      if(message=="Number already registered")
      {
        callback(false, message);
      }
      else {
        authRepo.saveMobileOtp(phone, otp, signature);
        callback(true, message);
      }
      notifyListeners();

    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage);
      notifyListeners();
    }
  }


  Future sendmyotp(String phone, String otp, String signature,Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse? apiResponse = await authRepo.sendmyotp(phone,otp,signature);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      print(apiResponse.response?.data);
      Map map = json.decode(apiResponse.response?.data);
      String message = map["acctype"];
        authRepo.saveMyMobileOtp(phone, otp, signature,message);
        callback(true, message);
      notifyListeners();
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage);
      notifyListeners();
    }
  }

  Future login(String userid, String phone, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.login(userid,phone);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      Map map = json.decode(apiResponse.response?.data);
      bool success=map["success"];
      String message = map["message"];
      if(success)
      {
        String route = map["route"];
        callback(success,route, message);
        notifyListeners();
      }
      else
      {
        callback(success, "no", message);
        notifyListeners();
      }

    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false,"no", errorMessage);
      notifyListeners();
    }
  }

  Future mylogin(String acctype,String accesstoken,String phone, Function callback) async {
    _isLoading = true;
    notifyListeners();

    print("Account type- ${acctype},access token-${accesstoken}, phone-${phone}");
    ApiResponse apiResponse = await authRepo.mylogin(acctype,accesstoken,phone);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      NewResponseModel responsemap = NewResponseModel.fromJson(json.decode(apiResponse.response?.data.toString()??""));
      if(responsemap.success==true) {
        print("Data for checkacc : ${apiResponse.response?.data.toString()??" "}");
        if (acctype == "hr") {
          HrModel map = HrModel.fromJson(
              json.decode(apiResponse.response?.data.toString() ?? ""));
          bool success = map.success;
          String message = map.message;
          String status = map.user.status;
          if (success) {
            String route = map.route;
            if (map.user != null) {
              // print("Hr data : "+map.user.idCardSrc);
              if (map.planModel.planType == "r") {
                _recruiterPackage = map.planModel.package;
              }
              else {
                _consultancyPackage = map.planModel.package;
              }

              authRepo.saveHrData(map.user, map.planModel, route);
            }
            callback(success, route, status, message);
            notifyListeners();
          }
          else {
            callback(false, "no", false, message);
            notifyListeners();
          }
        }
        else if(acctype == "candidate"){
          UserModel map = UserModel.fromJson(
              json.decode(apiResponse.response?.data.toString() ?? ""));
          bool success = map.success;
          String message = map.message;
          String status = map.user.status;
          if (success) {
            String route = map.route;
            if (map.user != null) {
              authRepo.saveUserData(map.user, route);
            }
            callback(success, route, status, message);
            notifyListeners();
          }
          else {
            callback(false, "no", false, message);
            notifyListeners();
          }
        }
        else if(acctype == "new")
          {
            callback(true, "Register", "success","Register");
          }
        else {
          callback(false, "no","failed", responsemap.message);
          notifyListeners();
        }
      }
      else
      {
        callback(false, "no","failed", responsemap.message);
        notifyListeners();
      }
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false,"no","0", errorMessage);
      notifyListeners();
    }
  }


  Future hrlogin(String userid, String phone, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.hrlogin(userid,phone);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      Map map = json.decode(apiResponse.response?.data);
      bool success=map["success"];
      String message = map["message"];
      if(success)
      {
        String route = map["route"];
        callback(success,route, message);
        notifyListeners();
      }
      else
      {
        callback(success, "no", message);
        notifyListeners();
      }

    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false,"no", errorMessage);
      notifyListeners();
    }
  }

  Future checkaccount(String acctype,String email, String AccessToken, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.checkacc(acctype, email,AccessToken);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      print("Data for checkacc : ${apiResponse.response?.data.toString()??" "}");
      NewResponseModel responsemap = NewResponseModel.fromJson(json.decode(apiResponse.response?.data.toString()??""));
      if(responsemap.success==true) {
        if (acctype == "hr") {
          HrModel map = HrModel.fromJson(
              json.decode(apiResponse.response?.data.toString() ?? ""));
          bool success = map.success;
          String message = map.message;
          String status = map.user.status;
          if (success) {
            String route = map.route;
            if (map.user != null) {
              // print("Hr data : "+map.user.idCardSrc);
              if (map.planModel.planType == "r") {
                _recruiterPackage = map.planModel.package;
              }
              else {
                _consultancyPackage = map.planModel.package;
              }

              authRepo.saveHrData(map.user, map.planModel, route);
            }
            callback(success, route, status, message);
            notifyListeners();
          }
          else {
            callback(false, "no", false, message);
            notifyListeners();
          }
        }
        else {
          UserModel map = UserModel.fromJson(
              json.decode(apiResponse.response?.data.toString() ?? ""));
          bool success = map.success;
          String message = map.message;
          String status = map.user.status;
          if (success) {
            String route = map.route;
            if (map.user != null) {
              authRepo.saveUserData(map.user, route);
            }
            callback(success, route, status, message);

            notifyListeners();
          }
          else {
            callback(false, "no", false, message);
            notifyListeners();
          }
        }
      }
      else
        {
          callback(false, "no","failed", responsemap.message);
          notifyListeners();
        }
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false,"no","0", errorMessage);
      notifyListeners();
    }
  }

  Future checkaccount2(String acctype,String mobile, String AccessToken, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.checkacc2(acctype, mobile,AccessToken);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      print("Data for checkacc : ${apiResponse.response?.data.toString()??" "}");
      NewResponseModel responsemap = NewResponseModel.fromJson(json.decode(apiResponse.response?.data.toString()??""));
      if(responsemap.success==true) {
        if (acctype == "hr") {
          HrModel map = HrModel.fromJson(
              json.decode(apiResponse.response?.data.toString() ?? ""));
          bool success = map.success;
          String message = map.message;
          String status = map.user.status;
          if (success) {
            String route = map.route;
            if (map.user != null) {
              // print("Hr data : "+map.user.idCardSrc);
              if (map.planModel.planType == "r") {
                _recruiterPackage = map.planModel.package;
              }
              else {
                _consultancyPackage = map.planModel.package;
              }

              authRepo.saveHrData(map.user, map.planModel, route);
            }
            callback(success, route, status, message,"hr");
            notifyListeners();
          }
          else {
            callback(false, "no", false, message,"hr");
            notifyListeners();
          }
        }
        else {
          UserModel map = UserModel.fromJson(
              json.decode(apiResponse.response?.data.toString() ?? ""));
          bool success = map.success;
          String message = map.message;
          String status = map.user.status;
          if (success) {
            String route = map.route;
            if (map.user != null) {
              authRepo.saveUserData(map.user, route);
            }
            callback(success, route, status, message,"candidate");
            notifyListeners();
          }
          else {
            callback(false, "no", false, message,"candidate");
            notifyListeners();
          }
        }
      }
      else
      {
        callback(false, "no","failed", responsemap.message,"new");
        notifyListeners();
      }
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false,"no","0", errorMessage,"new");
      notifyListeners();
    }
  }

  Future<bool> clearSharedData() async {
    return await authRepo.clearSharedData();
  }


  String getMobile() {
    return authRepo.getMobile();
  }

  bool IsMobileVerified() {
    return authRepo.IsMobileVerified();
  }



  String getHrName() {
    return authRepo.getHrName();
  }

  String getHrWebsite() {
    return authRepo.getHrWebsite();
  }

  String getHrCompanyCertificate() {
    return authRepo.getHrCompanyCertificate();
  }

  String getHrCompanyName() {
    return authRepo.getHrCompanyName();
  }

  String getprofileImage() {
    return authRepo.getprofileImage();
  }

  String getHrLocality() {
    return authRepo.getHrLocality();
  }

  String getJobCity() {
    return authRepo.getJobCity();
  }
  String getJobLocation() {
    return authRepo.getJobLocation();
  }
  String getHrCity() {
    return authRepo.getHrCity();
  }

  String getHrplanType() {
    return authRepo.getHrplanType();
  }

  String getProfileStatus() {
    return authRepo.getProfileStatus();
  }

  String getJobtitle() {
    return authRepo.getJobtitle();
  }
  String getCompany() {
    return authRepo.getCompany();
  }

  String getCurrentSalary() {
    return authRepo.getCurrentSalary();
  }

  String getDegree() {
    return authRepo.getDegree();
  }

  String getuniversity() {
    return authRepo.getuniversity();
  }
  String getshift() {
    return authRepo.getshift();
  }

  String gettotalexp() {
    return authRepo.gettotalexp();
  }
  bool getmyexp() {
    return authRepo.getmyexp();
  }

  String getEducation() {
    return authRepo.getEducation();
  }

  String getHrplanName() {
    return authRepo.getHrplanName();
  }
  String getHrPurchaseDate() {
    return authRepo.getHrPurchaseDate();
  }
  String getHrGST() {
    return authRepo.getHrGST();
  }

  String getName() {
    return authRepo.getName();
  }

  String getacctype() {
    return authRepo.getacctype();
  }

  String getSigna() {
    return authRepo.getSigna();
  }

  String getEmail() {
    return authRepo.getEmail();
  }

  String getAccessToken() {
    return authRepo.getAccessToken();
  }


  String getfullsubmited() {
    return authRepo.getfullsubmitted();
  }

  String getOtp() {
    return authRepo.getOtp();
  }

  String getUserid() {
    return authRepo.getUserid();
  }
  int getCurrentNotificationCount() {
    return authRepo.getCurrentNotificationCount();
  }

  bool setCurrentNotificationCount(int count) {
    return authRepo.setCurrentNotificationCount(count);
  }

  int getCurrentShortlistCount() {
    return authRepo.getCurrentShortlistCount();
  }

  bool setCurrentShortlistCount(int count) {
    return authRepo.setCurrentShortlistCount(count);
  }

  bool checkloggedin() {
    return authRepo.checkloggedin();
  }


}