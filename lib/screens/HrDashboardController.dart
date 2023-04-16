import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Aap_job/screens/HrHomeScreen.dart';
import 'package:Aap_job/screens/HrProfileHomePage.dart';

class HrDashboardController extends GetxController {
  final _selectedIndex = 0.obs;
  var show=true.obs;
  var version=true.obs;
  get selectedIndex => this._selectedIndex.value;
  set selectedIndex(index) => this._selectedIndex.value = index;

  List<Widget> widgetList = [
    HrHomeScreen(),
    HrProfileHomeScreen(),
  ];
}