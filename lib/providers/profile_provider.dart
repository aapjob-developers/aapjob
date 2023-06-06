import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:Aap_job/data/respository/auth_repo.dart';
import 'package:Aap_job/models/response/error_response.dart';
import 'package:Aap_job/models/response/response_model.dart';
//import 'package:Aap_job/screens/save_profile.dart';
import '../main.dart';
import '../models/register_model.dart';
import '../models/response/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileProvider with ChangeNotifier {
  final AuthRepo authRepo;
  ProfileProvider({required this.authRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future SaveProfileVideo(String path) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.saveProfileVideo(path);
    _isLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      responseModel = ResponseModel(apiResponse.response?.data["message"], true);
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
      responseModel = ResponseModel(errorMessage, false);
    }
    return responseModel;
  }

  void saveProfileString(String path) {
    authRepo.saveProfileString(path);
  }

  String getProfileString() {
    return authRepo.getProfileString();
  }

  String getResumeString() {
    return authRepo.getResumeString();
  }

  String getResumeName() {
    return authRepo.getResumeName();
  }

  Future<ResponseModel> updateUserInfo() async {
    _isLoading = true;
    notifyListeners();
    sharedp.remove("profileImage");
    sharedp.remove("profileVideo");
    sharedp.remove("resume");
    bool myexp= sharedp.getBool("myexp")?? false;
    String jobtitle=sharedp.getString("jobtitle")?? "no jobtitle";
    String companyname=sharedp.getString("companyname")?? "no companyname";
    String totalexp=sharedp.getString("totalexp")?? "no totalexp";
    String currentsalary=sharedp.getString("currentsalary")?? "no currentsalary";
    String education=sharedp.getString("education")?? "no education";
    String degree=sharedp.getString("degree")?? "no degree";
    String university=sharedp.getString("university")?? "no university";
     String shift=sharedp.getString("pref_shift")?? "no shift";
    String jobtypelist=sharedp.getString("jobtypelist")?? "no jobtypelist";
    String candidateSkillList=sharedp.getString("candidateskills")?? "No Specific Skill";
    print("joblidst-"+jobtypelist);
    print("candidateSkillList-"+candidateSkillList);
    ResponseModel responseModel;
    // http.StreamedResponse response = await authRepo.updateProfile(name, gender, jobcity,joblocation, authRepo.getUserid(), file, myexp ,jobtitle,companyname,totalexp,currentsalary,education,degree,university,resumefile, jobtypelist,videofile);
    http.StreamedResponse response = await authRepo.updateProfile(authRepo.getUserid(), myexp ,jobtitle,companyname,totalexp,currentsalary,education,degree,university, jobtypelist,candidateSkillList,shift);
    _isLoading = false;
    if (response.statusCode == 200) {
      // Map map = jsonDecode(await response.stream.bytesToString());
      //  String message = map["message"];
      String message = "Profile Saved";
      responseModel = ResponseModel(message, true);
      print(response.toString());
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
      responseModel = ResponseModel('${response.statusCode} ${response.reasonPhrase}', false);
    }
    notifyListeners();
    return responseModel;
  }
  Future<ResponseModel> updateUserExperience(bool myexp,String jobtitle,String companyname,String totalexp,String currentsalary,String candidateSkillList) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel responseModel;
    http.StreamedResponse response = await authRepo.updateUserExperience(authRepo.getUserid(), myexp ,jobtitle,companyname,totalexp,currentsalary,candidateSkillList);
    _isLoading = false;
    if (response.statusCode == 200) {
      // Map map = jsonDecode(await response.stream.bytesToString());
      //  String message = map["message"];
      String message = "Profile Saved";
      responseModel = ResponseModel(message, true);
      print(response.toString());
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
      responseModel = ResponseModel('${response.statusCode} ${response.reasonPhrase}', false);
    }
    notifyListeners();
    return responseModel;
  }
  Future<ResponseModel> updateUserEducation(String education,String degree,String university,String shift) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel responseModel;
    http.StreamedResponse response = await authRepo.updateUserEducation(authRepo.getUserid(),education,degree,university,shift);
    _isLoading = false;
    if (response.statusCode == 200) {
      String message = "Education Saved";
      responseModel = ResponseModel(message, true);
      print(response.toString());
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
      responseModel = ResponseModel('${response.statusCode} ${response.reasonPhrase}', false);
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateHrInfo() async {
    _isLoading = true;
    notifyListeners();
    
    String HrGst=sharedp.getString("HrGst")?? "HrGst";
    // String mobile=sharedp.getString("mobile")?? "No Mobile";
    String certificate=sharedp.getString("certificate")?? "no certificate";

    ResponseModel responseModel;
    http.StreamedResponse response =
    //await authRepo.updateHrProfile(HrWebsite,HrAddress,HrName,HrGst,HrCompanyName,email,HrCity,HrLocality, authRepo.getUserid());
    await authRepo.updateHrProfile(HrGst,authRepo.getMobile(),authRepo.getUserid());
    _isLoading = false;
    if (response.statusCode == 200) {
      // Map map = jsonDecode(await response.stream.bytesToString());
      //  String message = map["message"];
      String message = "Profile Saved";
      responseModel = ResponseModel(message, true);
      print(message);
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
      responseModel = ResponseModel('${response.statusCode} ${response.reasonPhrase}', false);
    }
    notifyListeners();
    return responseModel;
  }

}