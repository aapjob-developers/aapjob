import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:Aap_job/data/respository/category_repo.dart';
import 'package:Aap_job/data/respository/jobs_repo.dart';
import 'package:Aap_job/helper/api_checker.dart';
import 'package:Aap_job/models/JobsModel.dart';
import 'package:Aap_job/models/category.dart';
import 'package:Aap_job/models/response/api_response.dart';

class JobsProvider extends ChangeNotifier {
  final JobsRepo jobsRepo;
  JobsProvider({required this.jobsRepo});

  List<JobsModel> _jobsList = [];
  bool _hasData=false;

  List<JobsModel> get jobsList => _jobsList;
  bool get hasData => _hasData;

  void initgetHomeJobsList(String catid, BuildContext context) async {
    //_jobsList.clear();
    _hasData = true;
    ApiResponse apiResponse = await jobsRepo.getHomeJobsList(catid);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(apiResponse.response!.data!=null) {
        List<dynamic> data=json.decode(apiResponse.response!.data);
        print("data :"+data.toString());
        if(data.toString()=="[]")
          {
             _jobsList=[];
          }
        else
          {
            data.forEach((job) =>
                _jobsList.add(JobsModel.fromJson(job)));
            _hasData = _jobsList.length > 1;
          }

       // _jobsList=[];

        // List<JobsModel> _jobs = [];
        // _jobs.addAll(_jobsList);
        // _jobsList.clear();
        // _jobsList.addAll(_products.reversed);
      }
      // else
      //   {
      //     _jobsList=[];
      //     _hasData = false;
      //   }
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }



// Future<void> getCategoryList(bool reload, BuildContext context) async {
  //   if (_categoryList.length == 0 || reload) {
  //     ApiResponse apiResponse = await categoryRepo.getCategoryList();
  //     if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
  //       _categoryList.clear();
  //       List<Map<String, dynamic>> output = List.from(json.decode(apiResponse.response.data.toString()) as List);
  //     //   List<Map<String, dynamic>> newData = List<dynamic>.from(json.decode(apiResponse.response.data.toString()));
  //       print(output);
  //       for (var item in output) {
  //         _categoryList.add(new Category(id:int.parse(item['id']),name: item['name'],icon: item['icon_src'],selected: item['selected']));
  //         if(item['selected']==true)
  //           {
  //              this.getCategoryList(reload, context);
  //           }
  //       }
  //       _categorySelectedIndex = 0;
  //
  //     } else {
  //       ApiChecker.checkApi(context, apiResponse);
  //     }
  //     notifyListeners();
  //   }
  // }
  //
  // Future<void> getCategoryListById(int userid,bool reload, BuildContext context) async {
  //   if (_categoryList.length == 0 || reload) {
  //     Color mm;
  //     ApiResponse apiResponse = await categoryRepo.getCategoryListById(userid.toString());
  //     if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
  //       _categoryList.clear();
  //       List<Map<String, dynamic>> output = List.from(json.decode(apiResponse.response.data.toString()) as List);
  //       //   List<Map<String, dynamic>> newData = List<dynamic>.from(json.decode(apiResponse.response.data.toString()));
  //       print(output);
  //       for (var item in output) {
  //         if(item['selected'])
  //         {
  //           mm=Colors.primaries[Random().nextInt(Colors.primaries.length)];
  //           _SelectedcategoryList.add(new Category(id:int.parse(item['id']),name: item['name'],icon: item['icon_src'],selected: item['selected'],mycolor: mm));
  //         }
  //         else
  //           {
  //             mm=Colors.white;
  //           }
  //         _categoryList.add(new Category(id:int.parse(item['id']),name: item['name'],icon: item['icon_src'],selected: item['selected'],mycolor: mm));
  //       }
  //       _categorySelectedIndex = 0;
  //
  //     } else {
  //       ApiChecker.checkApi(context, apiResponse);
  //     }
  //     notifyListeners();
  //   }
  // }
  //
  // void changeSelectedIndex(int selectedIndex) {
  //   _categorySelectedIndex = selectedIndex;
  //   notifyListeners();
  // }
  //
  // void changeSelectedIndexColor(int selectedIndex,bool selected, Category category) {
  //   this.categoryList[selectedIndex].selected=!selected;
  //   if(this.categoryList[selectedIndex].selected)
  //   {
  //     this.categoryList[selectedIndex].mycolor =Colors.primaries[Random().nextInt(Colors.primaries.length)];
  //     _SelectedcategoryList.add(category);
  //   }
  //   else
  //   {
  //     this.categoryList[selectedIndex].mycolor=Colors.white;
  //     _SelectedcategoryList.removeWhere((element) => element.id==category.id);
  //   }
  //   _categorySelectedIndex = selectedIndex;
  //   notifyListeners();
  // }

}
