import 'dart:convert';

import 'package:Aap_job/data/respository/jobtitle_repo.dart';
import 'package:Aap_job/helper/api_checker.dart';
import 'package:Aap_job/models/JobTitleModel.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:flutter/material.dart';

class JobtitleProvider extends ChangeNotifier {
  final JobtitleRepo jobtitleRepo;
  JobtitleProvider({required this.jobtitleRepo});


  List<JobTitleModel> _jobtitleList = [];
  int _jobtitleSelectedIndex=1;

  List<JobTitleModel> get jobtitleList => _jobtitleList;
  int get jobtitleSelectedIndex => _jobtitleSelectedIndex;

  Future<void> getJobTitleModelList(bool reload, BuildContext context) async {
    if (_jobtitleList.length == 0 || reload) {
      ApiResponse? apiResponse = await jobtitleRepo.getJobtitle();
      if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
        _jobtitleList.clear();
        List<dynamic> data=json.decode(apiResponse.response!.data);
        data.forEach((category) => _jobtitleList.add(JobTitleModel.fromJson(category)));
        _jobtitleSelectedIndex = 0;
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  void changeSelectedjobtitleIndex(int selectedIndex) {
    _jobtitleSelectedIndex = selectedIndex;
    notifyListeners();
  }
}
