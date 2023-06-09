
import 'dart:convert';
import 'package:Aap_job/data/respository/jobcity_repo.dart';
import 'package:Aap_job/models/CitiesModel.dart';
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

class CitiesProvider extends ChangeNotifier {
  final JobCityRepo jobCityRepo;
  CitiesProvider({required this.jobCityRepo});
  List<CityModel> _cityModelList = [];
  List<CityModel> get cityModelList => _cityModelList;
SharedPreferences? sharedpref;
  Future<bool> getCities(BuildContext context) async {
    sharedpref=await SharedPreferences.getInstance();
    ApiResponse apiResponse = await jobCityRepo.getCities();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      if(apiResponse.response?.data!=null) {
        List<dynamic> data=json.decode(apiResponse.response!.data);
      //  print("cities :"+data.toString());
        if(data.toString()=="[]")
        {
          _cityModelList=[];
        }
        else
        {
          sharedpref?.setString("citilist",apiResponse.response!.data);
          data.forEach((city) =>
              _cityModelList.add(CityModel.fromJson(city)));
        }
        notifyListeners();
        return true;
      }
      return false;
    } else {
      ApiChecker.checkApi(context, apiResponse);
      notifyListeners();
      return false;
    }

  }

  Future<bool> getCitiesOffline(BuildContext context) async {
    sharedpref=await SharedPreferences.getInstance();
    String? citilist=sharedpref?.getString("citilist");
      if(citilist!=null) {
        List<dynamic> data=json.decode(citilist);
        if(data.toString()=="[]")
        {
          _cityModelList=[];
        }
        else
        {
          data.forEach((city) =>
              _cityModelList.add(CityModel.fromJson(city)));
        }
        notifyListeners();
        return true;
      }
      else {
        return false;
      }


  }
}


