import 'dart:convert';
import 'dart:math';

import 'package:Aap_job/models/categorywithjob.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/data/respository/category_repo.dart';
import 'package:Aap_job/helper/api_checker.dart';
import 'package:Aap_job/models/JobsModel.dart';
import 'package:Aap_job/models/category.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:provider/provider.dart';

import '../models/CatJobsModel.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo categoryRepo;
  CategoryProvider({required this.categoryRepo});

  List<Category> _categoryList = [];
  List<Category> _SelectedcategoryList = [];
  List<CategoryWithJob> _NewcategoryList = [];
  List<CategoryWithJob> _NewSelectedcategoryList = [];
  int _categorySelectedIndex=0;
  int _TotalSelectedIndex=0;

  List<Category> get categoryList => _categoryList;

  List<Category> get SelectedcategoryList => _SelectedcategoryList;

  List<CategoryWithJob> get NewcategoryList => _NewcategoryList;

  List<CategoryWithJob> get NewSelectedcategoryList => _NewSelectedcategoryList;

  int get categorySelectedIndex => _categorySelectedIndex;

  int get TotalSelectedIndex => _TotalSelectedIndex;

  set TotalSelectedIndex(int value) {
    _TotalSelectedIndex = value;
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

  Future<void> getCategoryListById(String userid,bool reload, BuildContext context) async {
    _SelectedcategoryList.clear();
      Color mm;
      ApiResponse apiResponse = await categoryRepo.getCategoryListById(userid.toString());
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _categoryList.clear();
        List<Map<String, dynamic>> output = List.from(json.decode(apiResponse.response!.data.toString()) as List);
        //   List<Map<String, dynamic>> newData = List<dynamic>.from(json.decode(apiResponse.response.data.toString()));
      //  print(output);
        for (var item in output) {
          mm=Colors.primaries[Random().nextInt(Colors.primaries.length)];
          List<JobsModel> joblist=[];
          if(item['jobs']!=null)
            {
              List<Map<String, dynamic>> dd = List.from(jsonDecode(item['jobs'].toString()) as List);
              for (var d in dd) {
                joblist.add(JobsModel.fromJson(d));
              }
            }
          if(item['selected'])
          {
            mm=Colors.white;
            _SelectedcategoryList.add(new Category(id:int.parse(item['id']),name: item['name'],perma:item['perma'],icon: item['icon_src'],selected: item['selected'],mycolor: mm,jobsModellist: joblist));
          }
          _categoryList.add(new Category(id:int.parse(item['id']),name: item['name'],perma:item['perma'],icon: item['icon_src'],selected: item['selected'],mycolor: mm,jobsModellist: joblist));
        }
        _categorySelectedIndex = 0;
        _TotalSelectedIndex=_SelectedcategoryList.length;
     //   print("load Total -> "+_TotalSelectedIndex.toString());
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();

  }
  Future<void> getSelectedCategoryListById(BuildContext context) async {
    _NewSelectedcategoryList.clear();
    Color mm;
    ApiResponse apiResponse = await categoryRepo.getCategoryListById2(Provider.of<AuthProvider>(context, listen: false).getUserid());
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _NewcategoryList.clear();
    //  List<Map<String, dynamic>> output = List.from(json.decode(apiResponse.response!.data.toString()) as List);
      List<Map<String, dynamic>> output = List.from(json.decode(apiResponse.response!.data.toString()) as List);
      for (var item in output) {
        mm=Colors.primaries[Random().nextInt(Colors.primaries.length)];
        List<CatJobsModel> joblist=[];
      //   if(item['jobs']!="[]") {
        //   List<Map<String, dynamic>> dd = List.from(json.decode(item['jobs'].toString()) as List);
           List<dynamic> dd = item['jobs'];
           List<CatJobsModel> jobs=dd.map((job) => CatJobsModel.fromJson(job as Map<String, dynamic>)).toList();
           joblist.addAll(jobs);
           // for (var d in dd) {
           //   joblist.add(CatJobsModel.fromJson(d));
           // }
       //  }
        if(item['selected'])
        {
          mm=Colors.white;
          _NewSelectedcategoryList.add(new CategoryWithJob(id:int.parse(item['id']),name: item['name'],perma:item['perma'],icon: item['icon_src'],selected: item['selected'],mycolor: mm,jobsModellist: joblist));
        }
        _NewcategoryList.add(new CategoryWithJob(id:int.parse(item['id']),name: item['name'],perma:item['perma'],icon: item['icon_src'],selected: item['selected'],mycolor: mm,jobsModellist: joblist));
      }
      _categorySelectedIndex = 0;
      _TotalSelectedIndex=_NewSelectedcategoryList.length;
      //   print("load Total -> "+_TotalSelectedIndex.toString());
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();

  }

  void changeSelectedIndex(int selectedIndex) {
    _categorySelectedIndex = selectedIndex;
    notifyListeners();
  }

  void changeSelectedIndexColor(int selectedIndex,bool selected, Category category) {
    this.categoryList[selectedIndex].selected=!selected;
    if(this.categoryList[selectedIndex].selected)
    {
      this.categoryList[selectedIndex].mycolor =Colors.primaries[Random().nextInt(Colors.primaries.length)];
      _SelectedcategoryList.add(category);
      print("ChangeSelect->"+_SelectedcategoryList.length.toString());
    }
    else
    {
      this.categoryList[selectedIndex].mycolor=Colors.white;
      _SelectedcategoryList.removeWhere((element) => element.id==category.id);
    }
    _categorySelectedIndex = selectedIndex;
    notifyListeners();
  }

  void changeNewSelectedIndexColor(int selectedIndex,bool selected, CategoryWithJob category) {
    this.NewcategoryList[selectedIndex].selected=!selected;
    if(this.NewcategoryList[selectedIndex].selected)
    {
      this.NewcategoryList[selectedIndex].mycolor =Colors.primaries[Random().nextInt(Colors.primaries.length)];
      _NewSelectedcategoryList.add(category);
    }
    else
    {
      this.NewcategoryList[selectedIndex].mycolor=Colors.white;
      _NewSelectedcategoryList.removeWhere((element) => element.id==category.id);
    }
    _categorySelectedIndex = selectedIndex;
    notifyListeners();
  }

}
