
import 'dart:convert';
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

class AdsProvider extends ChangeNotifier {
  final AdsRepo? adsRepo;
  AdsProvider({required this.adsRepo});
  AdsModel? _adsModel;

  AdsModel? get adsModel => _adsModel;

  Future<bool> getAds(BuildContext context) async {
    ApiResponse apiResponse = await adsRepo!.getAds();

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _adsModel = AdsModel.fromJson(jsonDecode(apiResponse.response!.data));
      return true;
    } else {
      ApiChecker.checkApi(context, apiResponse);
      return false;
    }

  }

}
