import 'dart:convert';
import 'dart:math';

import 'package:Aap_job/models/categorymm.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/data/respository/category_repo.dart';
import 'package:Aap_job/helper/api_checker.dart';
import 'package:Aap_job/models/JobsModel.dart';
import 'package:Aap_job/models/category.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:provider/provider.dart';

class JobServiceCategoryProvider extends ChangeNotifier {
  final CategoryRepo categoryRepo;
  JobServiceCategoryProvider({required this.categoryRepo});

  List<CategoryModel> _jobcatcategoryList = [];

  List<CategoryModel> get jobcategoryList => _jobcatcategoryList;

  Future<void> getCategoryList(bool reload, BuildContext context) async {
    _jobcatcategoryList.clear();
      ApiResponse apiResponse = await categoryRepo.getCategoryList();
      if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
        _jobcatcategoryList.clear();
        List<Map<String, dynamic>> output = List.from(json.decode(apiResponse.response!.data.toString()) as List);
        for (var item in output) {
          _jobcatcategoryList.add(new CategoryModel(id:item['id'],name: item['name'],icon: item['icon_src'],selected: false, perma: item['perma']));
        }
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
  }

}
