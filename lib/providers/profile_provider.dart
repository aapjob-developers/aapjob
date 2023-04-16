import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:Aap_job/data/respository/auth_repo.dart';
import 'package:Aap_job/models/response/error_response.dart';
import 'package:Aap_job/models/response/response_model.dart';
//import 'package:Aap_job/screens/save_profile.dart';
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
    final sharedPreferences = await SharedPreferences.getInstance();
    //  File file, resumefile,videofile;

    // String name=sharedPreferences.getString("name")?? "no Name";
    //  String jobcity=sharedPreferences.getString("jobcity")?? "no jobcity";
    //  String joblocation=sharedPreferences.getString("joblocation")?? "no joblocation";
    //  String Videopath=sharedPreferences.getString("profileVideo")?? "no profileVideo";
    //  String path=sharedPreferences.getString("profileImage")?? "no profileImage";
    //  String gender=sharedPreferences.getString("gender")?? "no gender";
    sharedPreferences.remove("profileImage");
    sharedPreferences.remove("profileVideo");
    sharedPreferences.remove("resume");
    bool myexp= sharedPreferences.getBool("myexp")?? false;
    String jobtitle=sharedPreferences.getString("jobtitle")?? "no jobtitle";
    String companyname=sharedPreferences.getString("companyname")?? "no companyname";
    String totalexp=sharedPreferences.getString("totalexp")?? "no totalexp";
    String currentsalary=sharedPreferences.getString("currentsalary")?? "no currentsalary";
    String education=sharedPreferences.getString("education")?? "no education";
    String degree=sharedPreferences.getString("degree")?? "no degree";
    String university=sharedPreferences.getString("university")?? "no university";
     String shift=sharedPreferences.getString("pref_shift")?? "no shift";
    String jobtypelist=sharedPreferences.getString("jobtypelist")?? "no jobtypelist";
    String candidateSkillList=sharedPreferences.getString("candidateskills")?? "No Specific Skill";
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

  Future<ResponseModel> updateHrInfo() async {
    _isLoading = true;
    notifyListeners();
    final sharedPreferences = await SharedPreferences.getInstance();
    File file, certificatefile,videofile;

    // String HrWebsite=sharedPreferences.getString("HrWebsite")?? "HrWebsite";
    // String HrAddress=sharedPreferences.getString("HrAddress")?? "HrAddress";
    //String Videopath=sharedPreferences.getString("profileVideo")?? "no profileVideo";
    //String path=sharedPreferences.getString("profileImage")?? "no profileImage";
    // String HrName=sharedPreferences.getString("HrName")?? "HrName";
    String HrGst=sharedPreferences.getString("HrGst")?? "HrGst";
    //String HrCompanyName=sharedPreferences.getString("HrCompanyName")?? "HrCompanyName";
    String email=sharedPreferences.getString("email")?? "email";
    //String HrLocality = sharedPreferences.getString("HrLocality") ?? "no Locality";
    //String HrCity=sharedPreferences.getString("HrCity")?? "HrCity";
    String certificate=sharedPreferences.getString("certificate")?? "no certificate";

    // file = File(path);
    // if(Videopath!="no profileVideo")
    // {
    //   videofile=File(Videopath);
    // }
    // if(certificate!=null&&certificate!="no certificate")
    //  certificatefile = File(certificate);

    ResponseModel responseModel;
    http.StreamedResponse response =
    //await authRepo.updateHrProfile(HrWebsite,HrAddress,HrName,HrGst,HrCompanyName,email,HrCity,HrLocality, authRepo.getUserid());
    await authRepo.updateHrProfile(HrGst,email,authRepo.getUserid());
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