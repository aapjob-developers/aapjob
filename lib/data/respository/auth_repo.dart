
import 'dart:convert';
import 'dart:io';

import 'package:Aap_job/models/CurrentPlanModel.dart';
import 'package:Aap_job/models/HrPlanModel.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:Aap_job/data/datasource/remote/exception/api_error_handler.dart';
import 'package:Aap_job/models/HrModel.dart';
import 'package:Aap_job/models/UserModel.dart';
import 'package:Aap_job/models/register_model.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../utill/app_constants.dart';
import 'package:http/http.dart' as http;

class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences? sharedPreferences;
  AuthRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> sendotp(String phone, String otp,String signature,String acctype) async {
    try {
      //  print(phone);
      Response response = await dioClient.post(AppConstants.SEND_OTP_URI, data: {"phone": phone,"otp":otp,"signature":signature,"acctype":acctype});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> sendmyotp(String phone, String otp,String signature) async {
    try {
      Response response = await dioClient.post(AppConstants.SEND_MY_OTP_URI, data: {"phone": phone,"otp":otp,"signature":signature});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> mylogin(String acctype,String accesstoken, String phone) async {
    if(acctype=="hr")
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.HRTOPIC);
    else  if(acctype=="candidate")
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
    try {
      Response response = await dioClient.post(AppConstants.MY_LOGIN_URI, data: {"acctype":acctype,"AccessToken":accesstoken,"mobile": phone});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> login(String userid, String phone) async {
    try {
      Response response = await dioClient.post(AppConstants.LOGIN_URI, data: {"userid": userid,"mobile": phone});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> hrlogin(String userid, String phone) async {
    try {
      Response response = await dioClient.post(AppConstants.HR_LOGIN_URI, data: {"userid": userid,"mobile": phone});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> checkacc(String acctype, String email, String AccessToken) async {
    String _deviceToken = await _getDeviceToken();
    if(acctype=="hr")
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.HRTOPIC);
    else
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
    try {
      Response response = await dioClient.post(AppConstants.CHECKACC_URI, data: {"acctype": acctype,"email":email,"AccessToken":_deviceToken});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> checkacc2(String acctype, String mobile,String AccessToken) async {
    if(acctype=="hr")
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.HRTOPIC);
    else if(acctype=="candidate")
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
    try {
      Response response = await dioClient.post(AppConstants.CHECKACCC_URI, data: {"acctype": acctype,"mobile":mobile,"AccessToken":AccessToken});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<void> saveUserToken(String token) async {
    dioClient.token = token;
    dioClient.dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      await sharedPreferences!.setString(AppConstants.TOKEN, token);
    } catch (e) {
      throw e;
    }
  }
  //
  String getUserToken() {
    return sharedPreferences!.getString(AppConstants.TOKEN) ?? "";
  }
  //
  // bool isLoggedIn() {
  //   return sharedPreferences!.containsKey(AppConstants.TOKEN);
  // }
  //
  Future<bool> clearSharedData() async {
    sharedPreferences!.clear();
    return true;
  }


  Future<void> saveMobileOtp(String phone, String otp,String signature) async {
    try {
      sharedp.setString('phone', phone);
      sharedp.setString('otp', otp);
      sharedp.setString('signa', signature);
      sharedp.getString("accounttype");
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveMyMobileOtp(String phone, String otp,String signature, String acctype) async {
    try {
      sharedp.setString('phone', phone);
      sharedp.setString('otp', otp);
      sharedp.setString('signa', signature);
      sharedp.setString("accounttype",acctype);
    } catch (e) {
      throw e;
    }
  }

  Future<ApiResponse>  saveProfileVideo(String path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Response response = await dioClient.post(AppConstants.SEND_OTP_URI, data: {"path": path});
      prefs.setString('profileVideo', path);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  // Future<ApiResponse>  GetHrProfileStatus() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     Response response = await dioClient.get(AppConstants.CHECK_HR_PROFILE_STATUS_URI+this.getUserid());
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }

  Future<void> saveProfileString(String path) async {
    try {
      await sharedPreferences!.setString("profileVideo", path);
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveUserData(User user, String route) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('userid', int.parse(user.id));
      sharedPreferences!.setString("fullsubmited", user.fullsubmited);
      sharedPreferences!.setString("email", user.email);
      sharedPreferences!.setString("route", route);
      if(user.fullsubmited=="1") {
        sharedPreferences!.setBool("step1", true);
        sharedPreferences!.setBool("step2", true);
        sharedPreferences!.setBool("step3", true);
        sharedPreferences!.setBool("step4", true);
        sharedPreferences!.setBool("step5", true);
      }
      sharedPreferences!.setBool("loggedin", true);
      sharedPreferences!.setString("shift", user.languageId==""?"Any":user.languageId);
      sharedPreferences!.setString("status", user.status==""?"0":user.status);
      sharedPreferences!.setString("joblocation",user.address==""?"No JobLocation":user.address);
      if(user.profileImage!="uploads/users/1.png")
        sharedPreferences!.setString("profileImage",user.profileImage==""?"No profileImage":user.profileImage);
      if(user.docResumeSrc!="NULL"&& user.docResumeSrc!="null"&& user.docResumeSrc!="")
      {
        sharedPreferences!.setString("resume", user.docResumeSrc);
        String str = user.docResumeSrc;
        List<String> strarray = str.split("/");
        sharedPreferences!.setString("resumeName", strarray.last);
      }
      else
      {
        sharedPreferences!.setString("resume","No resume");
        sharedPreferences!.setString("resumeName", "No resumeName");
      }
      sharedPreferences!.setString("name",user.name==""?"no Name":user.name);
      sharedPreferences!.setString("jobcity",user.preferredCity==""?"no Jobcity":user.preferredCity);
      sharedPreferences!.setString("phone",user.mobile==""?"no Mobile":user.mobile);
      sharedPreferences!.setBool("IsMobileVerified",user.mobile==""||user.mobile==null?false:true);
      sharedPreferences!.setString("gender",user.gender==""?"no gender":user.gender);
      sharedPreferences!.setString("status",user.status==""?"0":user.status);
      // print("status : "+user.status);
      // print("add : "+user.address);
      if(user.resumeSrc!="")
        sharedPreferences!.setString("profileVideo", user.resumeSrc);
      // else
      //   sharedPreferences!.setString("profileVideo", "no video");
      List<Edu> user_edu=user.edu;
      if(user_edu.length>0)
      {
        sharedPreferences!.setString("education", user_edu.first.level);
        if(user_edu.first.degreeOrName!="")
        {
          sharedPreferences!.setString("degree", user_edu.first.degreeOrName);
        }
        if(user_edu.first.university!="")
        {
          sharedPreferences!.setString("university", user_edu.first.university);
        }

      }

      List<Jobexp> user_exp=user.jobexp;
      if(user_exp.length>0)
      {
        sharedPreferences!.setBool("myexp", true);
        sharedPreferences!.setString("jobtitle", user_exp.first.jobTitle);
        sharedPreferences!.setString("totalexp", user_exp.first.experience);
        sharedPreferences!.setString("companyname", user_exp.first.companyName);
        sharedPreferences!.setString("currentsalary", user_exp.first.currentSalary);
      }

      //  }

    } catch (e) {
      throw e;
    }
  }

  Future<void> saveHrData(HrUser user, CurrentPlanModel planModel, String route) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('userid', int.parse(user.id));
      prefs.setString("fullsubmited", user.fullsubmited);
      sharedPreferences!.setString("email",user.email);
      if(planModel.planType=="r")
      {
        RecruiterPackage Rplan=planModel.package;
        sharedPreferences!.setString("RDays", Rplan.days??"0");
        sharedPreferences!.setString("ROriginalPrice", Rplan.originalPrice??"0");
        sharedPreferences!.setString("RDiscountedPrice", Rplan.discountPrice??"0");
        sharedPreferences!.setString("RProfilePerApp", Rplan.profilePerApplication??"0");
        sharedPreferences!.setString("RtotalJobPost", Rplan.totalJobPost??"0");
        sharedPreferences!.setString("RType", Rplan.type??"r");
      }
      else
      {
        ConsultancyPackage Cplan=planModel.package;
        sharedPreferences!.setString("CDays",Cplan.validity??"0");
        sharedPreferences!.setString("COriginalPrice", Cplan.originalPrice??"0");
        sharedPreferences!.setString("CDiscountedPrice", Cplan.discountPrice??"0");
        sharedPreferences!.setString("Cperdaylimit", Cplan.perdayLimit??"0");
        sharedPreferences!.setString("CtotalJobPost", Cplan.jobPostNo??"0");
        sharedPreferences!.setString("CtotalResumes", Cplan.totalResumes??"0");
      }

      // if(user.status=="0")
      //   {
      //     sharedPreferences!.setString("route", route);
      //     sharedPreferences!.setString("HrplanName", planModel.planName);
      //     sharedPreferences!.setString("HrplanType", planModel.planType);
      //     sharedPreferences!.setString("HrplanId", planModel.planId);
      //     sharedPreferences!.setString("HrplanIcon", planModel.planIcon);
      //     sharedPreferences!.setString("HrPurchaseDate", planModel.purchaseDate.toString());
      //     print("st==0=>"+user.idCardSrc);
      //     sharedPreferences!.setString("profileImage", user.idCardSrc);
      //     //sharedPreferences!.setString("certificate", user.docResumeSrc);
      //     sharedPreferences!.setString("HrCompanyCertificate", user.docResumeSrc);
      //   }
      //   else
      //  {
      // print("Mobile==0=>"+user.mobile==""?"no Mobile":user.mobile);
      if(user.fullsubmited=="1")
      {
        sharedPreferences!.setBool("step1", true);
        sharedPreferences!.setBool("step2", true);
        sharedPreferences!.setBool("step3", true);
        sharedPreferences!.setBool("step4", true);
        sharedPreferences!.setBool("step5", true);

      }
      sharedPreferences!.setBool("loggedin", true);
      sharedPreferences!.setString("route", route);
      sharedPreferences!.setString("HrWebsite", user.passkey==""?"no website":user.passkey);
      sharedPreferences!.setString("HrAddress", user.address==""?"no address":user.address);
      sharedPreferences!.setString("profileImage",user.idCardSrc==""?"no profileImage":user.idCardSrc );
      //   print("st!=0=>"+user.idCardSrc);
      // print("certificate=>${user.docResumeSrc}");
      sharedPreferences!.setString("HrName",user.name==""?"no Name":user.name);
      sharedPreferences!.setString("HrGst", user.gst==""?"no GST":user.gst);
      sharedPreferences!.setString("HrCompanyName", user.companyName==""?"no Company Name":user.companyName);
      sharedPreferences!.setString("HrCity",user.city==""?"no City":user.city);
      sharedPreferences!.setString("HrCompanyCertificate",user.docResumeSrc==""?"no Certificate":user.docResumeSrc );
      if(sharedPreferences!.getString("HrCompanyCertificate")=="no Certificate"&&sharedPreferences!.getString("cfilename")!=null)
        {
          sharedPreferences!.setString("HrCompanyCertificate","uploads/hr_resume/docs/"+sharedPreferences!.getString("cfilename")!);
        }
      sharedPreferences!.setString("phone",user.mobile==""?"no Mobile":user.mobile);
      sharedPreferences!.setBool("IsMobileVerified",user.mobile==""||user.mobile==null?false:true);
      sharedPreferences!.setString("HrLocality",user.location==""?"no Locality":user.location);
      //  sharedPreferences!.setString("certificate", user.docResumeSrc);
      sharedPreferences!.setString("status",user.status==""?"no Status":user.status);
      sharedPreferences!.setString("profilestatus",user.profileComplete==""?"no ProfileCompleted":user.profileComplete);
      // plan details
      sharedPreferences!.setString("HrplanName", planModel.planName??"no plan");
      sharedPreferences!.setString("HrplanType", planModel.planType??"no Plantype");
      sharedPreferences!.setString("HrplanId", planModel.planId??"no planId");
      sharedPreferences!.setString("HrplanIcon", planModel.planIcon??"no planIcon");
      sharedPreferences!.setString("HrPurchaseDate", planModel.purchaseDate.toString());
      if(user.resumeSrc!=null)
        sharedPreferences!.setString("profileVideo", user.resumeSrc);
      else
        sharedPreferences!.setString("profileVideo", "no video");
      //   }

    } catch (e) {
      throw e;
    }
  }

  Future<ApiResponse> getLang() async {
    try {
      final response = await dioClient.get(AppConstants.ADS_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> updateProfile(String userid, bool myexp ,String jobtitle,String companyname,String totalexp,String currentsalary,String education,String degree,String university, String jobtypelist, String candidateSkillList, String shift) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.SAVE_PROFILE_DATA_URI}'));
    // request.files.add(http.MultipartFile('image', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    // if(videofile!=null) {
    //   request.files.add(await http.MultipartFile.fromPath("video", videofile.path));
    // }
    // request.files.add(await http.MultipartFile.fromPath("image", file.path));
    // request.files.add(await http.MultipartFile.fromPath("resume", resumefile.path));
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'userid':userid,
      // 'name': name,
      // 'gender':gender,
      // 'jobcity': jobcity,
      'shift': shift,
      'myexp' : myexp.toString(),
      'jobtitle':  jobtitle,
      'companyname':companyname,
      'totalexp':totalexp,
      'currentsalary': currentsalary,
      'education': education,
      'degree':degree,
      'university':university,
      'jobtypelist':jobtypelist,
      'candidateSkillList':candidateSkillList,
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      //    print("Profile Save Response from API : "+value);
    });
    return response;
  }

  Future<http.StreamedResponse> updateUserExperience(String userid, bool myexp ,String jobtitle,String companyname,String totalexp,String currentsalary, String candidateSkillList) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.SAVE_EXP_DATA_URI}'));
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'userid':userid,
      'myexp' : myexp.toString(),
      'jobtitle':  jobtitle,
      'companyname':companyname,
      'totalexp':totalexp,
      'currentsalary': currentsalary,
      'candidateSkillList':candidateSkillList,
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      //    print("Profile Save Response from API : "+value);
    });
    return response;
  }

  Future<http.StreamedResponse> updateUserEducation(String userid,String education,String degree,String university, String shift) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.SAVE_EDUCATION_DATA_URI}'));
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'userid':userid,
      'shift': shift,
      'education': education,
      'degree':degree,
      'university':university,
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      //    print("Profile Save Response from API : "+value);
    });
    return response;
  }


  Future<http.StreamedResponse> updateHrProfile(String HrGst,String email,String userid) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.SAVE_HR_PROFILE_DATA_URI}'));
    // request.files.add(http.MultipartFile('image', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    //  if(videofile!=null) {
    //    request.files.add(await http.MultipartFile.fromPath("video", videofile.path));
    //  }
    //  request.files.add(await http.MultipartFile.fromPath("image", file.path));
    //  request.files.add(await http.MultipartFile.fromPath("certificate", certificatefile.path));
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'userid':userid,
      // 'HrWebsite':HrWebsite,
      // 'HrAddress':HrAddress,
      // 'HrName':HrName,
      'HrGst':HrGst,
      //'HrCompanyName':HrCompanyName,
      'email':email,
      // 'HrCity':HrCity,
      // 'HrLocality':HrLocality
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      //   print(value);
    });
    return response;
  }

  Future<ApiResponse> updateToken() async {
    try {
      String _deviceToken = await _getDeviceToken();
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
      Response response = await dioClient.post( AppConstants.TOKEN_URI, data: {"_method": "put", "cm_firebase_token": _deviceToken},);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<String> _getDeviceToken() async {
    String? _deviceToken;
    if(Platform.isIOS) {
      _deviceToken = await FirebaseMessaging.instance.getAPNSToken();
    }else {
      _deviceToken = await FirebaseMessaging.instance.getToken();
    }

    if (_deviceToken != null) {
      //  print('--------Device Token---------- '+_deviceToken);
    }
    return _deviceToken!;
  }


  String getMobile() {
    return sharedPreferences!.getString("phone") ?? "";
  }

  bool IsMobileVerified() {
    return sharedPreferences!.getBool("IsMobileVerified") ?? false;
  }
  String getName() {
    return sharedPreferences!.getString("name") ?? "";
  }

  String getacctype() {
    return sharedPreferences!.getString("accounttype") ?? "";
  }
  String getSigna() {
    return sharedPreferences!.getString("signa") ?? "";
  }

  String getEmail() {
    return sharedPreferences!.getString("email") ?? "No Email";
  }

  String getAccessToken() {
    return sharedPreferences!.getString("AccessToken") ?? "nn";
  }


  String getfullsubmitted() {
    return sharedPreferences!.getString("fullsubmited") ?? "0";
  }

  String getUserid() {
    int userid=  sharedPreferences!.getInt("userid") ?? 0;
    return userid.toString();
  }

  int getCurrentNotificationCount() {
    int notificationcount=  sharedPreferences!.getInt("notificationcount") ?? 0;
    return notificationcount;
  }

  bool setCurrentNotificationCount(int count) {
    sharedPreferences!.setInt("notificationcount", count);
    return true;
  }

  int getCurrentShortlistCount() {
    int notificationcount=  sharedPreferences!.getInt("shortlistcount") ?? 0;
    return notificationcount;
  }

  bool setCurrentShortlistCount(int count) {
    sharedPreferences!.setInt("shortlistcount", count);
    return true;
  }
  String getProfileString() {
    return sharedPreferences!.getString("profileVideo") ?? "";
  }

  String getJobtitle() {
    return sharedPreferences!.getString("jobtitle") ?? "fresher";
  }
  String getCompany() {
    return sharedPreferences!.getString("companyname") ?? "no Company";
  }
  String getCurrentSalary() {
    return sharedPreferences!.getString("currentsalary") ?? "no Salary";
  }


  String getEducation() {
    return sharedPreferences!.getString("education") ?? "no education";
  }

  String getDegree() {
    return sharedPreferences!.getString("degree") ?? " ";
  }
  String getuniversity() {
    return sharedPreferences!.getString("university") ?? "no University";
  }

  String getshift() {
    return sharedPreferences!.getString("shift") ?? "Any";
  }

  String gettotalexp() {
    return sharedPreferences!.getString("totalexp") ?? "no Experience";
  }
  bool getmyexp() {
    return sharedPreferences!.getBool("myexp") ?? false;
  }

  String getResumeString() {
    return sharedPreferences!.getString("resume") ?? "";
  }
  String getResumeName() {
    return sharedPreferences!.getString("resumeName") ?? "";
  }

  String getHrName() {
    return sharedPreferences!.getString("HrName") ?? "";
  }

  String getHrWebsite() {
    return sharedPreferences!.getString("HrWebsite") ?? "no website";
  }

  String getHrCompanyCertificate() {
    return sharedPreferences!.getString("HrCompanyCertificate") ?? "no Certificate";
  }

  String getHrCompanyName() {
    return sharedPreferences!.getString("HrCompanyName") ?? "no Company Name";
  }

  String getprofileImage() {
    return sharedPreferences!.getString("profileImage") ?? "no profileImage";
  }


  String getHrLocality() {
    return sharedPreferences!.getString("HrLocality") ?? "no Locality";
  }
  String getHrCity() {
    return sharedPreferences!.getString("HrCity") ?? "no City";
  }

  String getJobCity() {
    return sharedPreferences!.getString("jobcity") ?? "no City";
  }
  String getJobLocation() {
    return sharedPreferences!.getString("joblocation") ?? "no JobLocation";
  }

  String getHrplanType() {
    return sharedPreferences!.getString("HrplanType") ?? "r";
  }

  String getProfileStatus() {
    return sharedPreferences!.getString("profilestatus") ?? "0";
  }

  String getHrplanName() {
    return sharedPreferences!.getString("HrplanName") ?? "Starter";
  }

  String getHrPurchaseDate() {
    return sharedPreferences!.getString("HrPurchaseDate") ?? "S";
  }

  String getHrGST() {
    return sharedPreferences!.getString("HrGst") ?? "";
  }

  String getOtp() {
    return sharedPreferences!.getString("otp") ?? "";
  }

  bool checkloggedin() {
    return sharedPreferences!.getBool("loggedin") ?? false;
  }

}
