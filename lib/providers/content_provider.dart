
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Aap_job/data/respository/content_repo.dart';
import 'package:Aap_job/helper/api_checker.dart';
import 'package:Aap_job/models/contentModel.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:Aap_job/models/response/error_response.dart';
import 'package:Aap_job/models/response/response_model.dart';
import '../models/register_model.dart';
import '../models/response/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContentProvider extends ChangeNotifier {
  final ContentRepo contentRepo;
  ContentProvider({required this.contentRepo});

  ContentModel? _contentModel;
  ContentModel? _resumecontentModel;
  ContentModel? _frontpage;
  ContentModel? get contentModel => _contentModel;
  ContentModel? get resumecontentModel => _resumecontentModel;
  ContentModel? get frontpage => _frontpage;

  List<ContentModel> _contentList = [];
  List<ContentModel> get contentList => _contentList;

  Future<bool> getContent(BuildContext context) async {
    ApiResponse? apiResponse = await contentRepo.getAllContent();
    if (apiResponse?.response != null && apiResponse.response?.statusCode == 200) {
      _contentList.clear();
      List<dynamic> data=json.decode(apiResponse.response?.data);
      data.forEach((category) => _contentList.add(ContentModel.fromJson(category)));
      return true;
    } else {
      ApiChecker.checkApi(context, apiResponse);
      return false;
    }
    notifyListeners();
  }

  Future<bool> getFront(BuildContext context) async {
    ApiResponse apiResponse = await contentRepo.getFront();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _frontpage = ContentModel.fromJson(jsonDecode(apiResponse.response?.data));
      return true;
    } else {
      ApiChecker.checkApi(context, apiResponse);
      return false;
    }
    notifyListeners();
  }

  Future<bool> getResumeContent(BuildContext context) async {
    ApiResponse apiResponse = await contentRepo.getResumeContent();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _resumecontentModel = ContentModel.fromJson(jsonDecode(apiResponse.response?.data));
      return true;
    } else {
      ApiChecker.checkApi(context, apiResponse);
      return false;
    }
    notifyListeners();
  }

  Future<bool> getHRContent(BuildContext context) async {
    ApiResponse apiResponse = await contentRepo.getHRContent();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _contentModel = ContentModel.fromJson(jsonDecode(apiResponse.response?.data));
      return true;
    } else {
      ApiChecker.checkApi(context, apiResponse);
      return false;
    }
    notifyListeners();
  }

  Future<bool> getHRFront(BuildContext context) async {
    ApiResponse apiResponse = await contentRepo.getHrFront();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _frontpage = ContentModel.fromJson(jsonDecode(apiResponse.response?.data));
      return true;
    } else {
      ApiChecker.checkApi(context, apiResponse);
      return false;
    }
    notifyListeners();
  }

  Future<bool> getHRResumeContent(BuildContext context) async {
    ApiResponse apiResponse = await contentRepo.getHrResumeContent();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _frontpage = ContentModel.fromJson(jsonDecode(apiResponse.response?.data));
      return true;
    } else {
      ApiChecker.checkApi(context, apiResponse);
      return false;
    }
    notifyListeners();
  }
}
