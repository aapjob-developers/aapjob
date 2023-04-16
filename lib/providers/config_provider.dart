
import 'dart:convert';
import 'package:Aap_job/data/respository/config_repo.dart';
import 'package:Aap_job/models/ConfigModel.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/data/respository/ads_repo.dart';
import 'package:Aap_job/helper/api_checker.dart';
import 'package:Aap_job/models/adsModel.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:Aap_job/models/response/error_response.dart';
import 'package:Aap_job/models/response/response_model.dart';
import '../models/register_model.dart';
import '../models/response/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigProvider extends ChangeNotifier {
  final ConfigRepo configRepo;

  ConfigProvider({required this.configRepo});

  ConfigModel? _configModel;
  String? _packversion;
  ConfigModel? get configModel => _configModel;
  String? get packversion => _packversion;

  Future<bool> getConfig(String Packversion,BuildContext context) async {
    ApiResponse? apiResponse = await configRepo.getConfig();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _configModel = ConfigModel.fromJson(jsonDecode(apiResponse.response?.data));
      configRepo.saveVersion(_configModel?.appVersion!??"0");
      _packversion=Packversion;
      return true;
    } else {
      ApiChecker.checkApi(context, apiResponse);
      return false;
    }
    notifyListeners();
  }

  String getAppVersion() {
    return configRepo.getAppVersion();
  }

}
