import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:Aap_job/data/respository/hrplan_repo.dart';
import 'package:Aap_job/helper/api_checker.dart';
import 'package:Aap_job/models/HrPlanModel.dart';

import 'package:Aap_job/models/response/api_response.dart';

class HrPlanProvider extends ChangeNotifier {
  final HrPlanRepo hrPlanRepo;
  HrPlanProvider({required this.hrPlanRepo});

  List<HrPlanModel> _HrPlanList = [];
  List<HrPlanModel> _SelectedHrPlanList = [];
  int _HrPlanSelectedIndex=0;

  List<HrPlanModel> get HrPlanList => _HrPlanList;

  List<HrPlanModel> get SelectedHrPlanList => _SelectedHrPlanList;

  int get HrPlanSelectedIndex => _HrPlanSelectedIndex;

  Future<void> getHrPlanList(bool reload, BuildContext context) async {
    if (_HrPlanList.length == 0 || reload) {
      ApiResponse apiResponse = await hrPlanRepo.getHrPlanList();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _HrPlanList.clear();
        List<Map<String, dynamic>> output = List.from(json.decode(apiResponse.response!.data.toString()) as List);print(output);
        for (var item in output) {
          _HrPlanList.add(HrPlanModel.fromJson(item));
        }
        _HrPlanSelectedIndex = 0;

      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  // Future<void> getHrPlanListById(int userid,bool reload, BuildContext context) async {
  //   if (_HrPlanList.length == 0 || reload) {
  //     Color mm;
  //     ApiResponse apiResponse = await hrPlanRepo.getHrPlanListById(userid.toString());
  //     if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
  //       _HrPlanList.clear();
  //       List<Map<String, dynamic>> output = List.from(json.decode(apiResponse.response.data.toString()) as List);
  //       //   List<Map<String, dynamic>> newData = List<dynamic>.from(json.decode(apiResponse.response.data.toString()));
  //       print(output);
  //       for (var item in output) {
  //         List<JobsModel> joblist=[];
  //         if(item['jobs']!=null)
  //           {
  //             List<Map<String, dynamic>> dd = List.from(jsonDecode(item['jobs'].toString()) as List);
  //             for (var d in dd) {
  //               joblist.add(JobsModel.fromJson(d));
  //             }
  //           }
  //         if(item['selected'])
  //         {
  //           mm=Colors.primaries[Random().nextInt(Colors.primaries.length)];
  //           _SelectedHrPlanList.add(new HrPlan(id:int.parse(item['id']),name: item['name'],icon: item['icon_src'],selected: item['selected'],mycolor: mm,jobsModellist: joblist));
  //         }
  //         else
  //           {
  //             mm=Colors.white;
  //           }
  //         _HrPlanList.add(new HrPlan(id:int.parse(item['id']),name: item['name'],icon: item['icon_src'],selected: item['selected'],mycolor: mm,jobsModellist: joblist));
  //
  //       }
  //       _HrPlanSelectedIndex = 0;
  //
  //     } else {
  //       ApiChecker.checkApi(context, apiResponse);
  //     }
  //     notifyListeners();
  //   }
  // }

  void changeSelectedIndex(int selectedIndex) {
    _HrPlanSelectedIndex = selectedIndex;
    notifyListeners();
  }

  // void changeSelectedIndexColor(int selectedIndex,bool selected, HrPlanModel HrPlan) {
  //
  //   this.HrPlanList[selectedIndex].selected=!selected;
  //   if(this.HrPlanList[selectedIndex].selected)
  //   {
  //     this.HrPlanList[selectedIndex].mycolor =Colors.primaries[Random().nextInt(Colors.primaries.length)];
  //     _SelectedHrPlanList.add(HrPlan);
  //   }
  //   else
  //   {
  //     this.HrPlanList[selectedIndex].mycolor=Colors.white;
  //     _SelectedHrPlanList.removeWhere((element) => element.id==HrPlan.id);
  //   }
  //   _HrPlanSelectedIndex = selectedIndex;
  //   notifyListeners();
  // }

}
