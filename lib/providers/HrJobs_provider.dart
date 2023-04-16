import 'dart:convert';
import 'package:Aap_job/data/respository/hr_jobs_repo.dart';
import 'package:Aap_job/models/ComplaintReasonModel.dart';
import 'package:Aap_job/models/JobsListModel.dart';
import 'package:Aap_job/models/JobsModel.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/helper/api_checker.dart';
import 'package:Aap_job/models/response/api_response.dart';

class HrJobProvider extends ChangeNotifier {
  final HrJobRepo hrJobRepo;
  HrJobProvider({required this.hrJobRepo});

  List<JobsListModel> _jobsList = [];
  List<JobsListModel> _closedjobsList = [];
  List<String> _reasonList = [];
  JobsModel? _Job ;
  bool _hasData=false;
  bool _hasClosedData=false;
  int _currentplanactivejobs=0;
  int _currentclosedjobs=0;

  List<JobsListModel> get jobsList => _jobsList;
  List<JobsListModel> get closedjobsList => _closedjobsList;
  List<String> get reasonList => _reasonList;
  JobsModel? get Job => _Job;
  bool get hasData => _hasData;
  bool get hasClosedData => _hasClosedData;
  int get currentplanactivejobs => _currentplanactivejobs;
  int get currentclosedjobs => _currentclosedjobs;

  Future<bool> initgetHrHomeJobsList(String userid, BuildContext context) async {
    this._jobsList.clear();
    _hasData = true;
    ApiResponse? apiResponse = await hrJobRepo.getHrJobsList(userid);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (apiResponse.response!.data != null) {
        List<dynamic> data = json.decode(apiResponse.response!.data);
        if (data.toString() == "[]") { this._jobsList= []; this._currentplanactivejobs=0; }
        else {
          this._jobsList.clear();
          int ocurrentplanactivejobs=0;

          data.forEach((job) {
            this._jobsList.add(JobsListModel.fromJson(job));
            ocurrentplanactivejobs++;
          } );

        this._currentplanactivejobs=ocurrentplanactivejobs;
          _hasData = this._jobsList.length > 1;
          print("Total Jobs${this._currentplanactivejobs}");
        }
        notifyListeners();
        return true;
      } else {
        ApiChecker.checkApi(context, apiResponse);
        notifyListeners();
        return false;
      }

    }
    else
      {
        return false;
      }
  }

  Future<bool> initgetHrCloseJobsList(String userid, BuildContext context) async {
    this._closedjobsList.clear();
    _hasClosedData = true;
    ApiResponse apiResponse = await hrJobRepo.getHrClosedJobsList(userid);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (apiResponse.response!.data != null) {
        List<dynamic> data = json.decode(apiResponse.response!.data);
        if (data.toString() == "[]") { this._closedjobsList= []; this._currentclosedjobs=0; }
        else {
          this._closedjobsList.clear(); int ocurrentplanclosedjobs=0;
          data.forEach((job) { this._closedjobsList.add(JobsListModel.fromJson(job)); ocurrentplanclosedjobs++; } );
          this._currentplanactivejobs=ocurrentplanclosedjobs;
          _hasClosedData = this._jobsList.length > 1;
          print("Total Jobs${this._currentplanactivejobs}");
        }
        notifyListeners();
        return true;
      } else {
        ApiChecker.checkApi(context, apiResponse);
        notifyListeners();
        return false;
      }

    }
    else
      {
        return false;
      }
  }

  void initgetReasonList(BuildContext context) async {
    this._reasonList.clear();
    _hasData = true;
    ApiResponse? apiResponse = await hrJobRepo.getReasonList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (apiResponse.response!.data != null) {
        List<dynamic> data = json.decode(apiResponse.response!.data);
        if (data.toString() == "[]") {
          this._reasonList= [];
        }
        else {
          this._reasonList.clear();
          _reasonList.add("Select A Reason");
          data.forEach((job) =>
              this._reasonList.add(ComplaintReasonModel.fromJson(job).name)
          );

        }
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  Future<bool> initgetHrJob(String jobid, BuildContext context) async {
    ApiResponse? apiResponse = await hrJobRepo.getHrJob(jobid);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if (apiResponse.response!.data != null) {
        _Job = JobsModel.fromJson(json.decode(apiResponse.response!.data));
        return true;
      } else {
        ApiChecker.checkApi(context, apiResponse);
        notifyListeners();
        return false;
      }
    }
    else
      return false;
  }
}
