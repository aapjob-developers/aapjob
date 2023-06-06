
import 'package:Aap_job/data/respository/splash_repo.dart';
import 'package:Aap_job/helper/api_checker.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo splashRepo;
  SplashProvider({required this.splashRepo});

  bool _hasConnection = true;
  bool _fromSetting = false;
  bool _firstTimeConnectionCheck = true;
  bool _onOff = true;
  bool get onOff => _onOff;


  bool get hasConnection => _hasConnection;
  bool get fromSetting => _fromSetting;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  Future<bool> initConfig(BuildContext context) async {
    _hasConnection = true;
    bool isSuccess=true;
   // notifyListeners();
    return isSuccess;
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  // void initSharedPrefData() {
  //   splashRepo.initSharedData();
  // }

  // void setFromSetting(bool isSetting) {
  //   _fromSetting = isSetting;
  // }
  //
  // bool showIntro() {
  //   return splashRepo.showIntro();
  // }


  bool getloggedin() {
    return splashRepo.getloggedin();
  }

  String getlanguage() {
    return splashRepo.getlanguage();
  }

  bool getacctype() {
    return splashRepo.getacctype();  }

  bool getstep1() {
    return splashRepo.getstep1();  }

  bool getstep2() {
    return splashRepo.getstep2();  }

  bool getstep3() {
    return splashRepo.getstep3();  }

  bool getstep4() {
    return splashRepo.getstep4();  }

  bool getstep5() {
    return splashRepo.getstep5();  }

  String getjobtypelist() {
    return splashRepo.getjobtypelist();  }

}
