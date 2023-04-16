import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Aap_job/screens/ConnectionHomePage.dart';
import 'package:Aap_job/screens/FeedHomePage.dart';
import 'package:Aap_job/screens/JobHomeScreen.dart';
import 'package:Aap_job/screens/ProfileHomePage.dart';

class HomePageController extends GetxController {
  final _selectedIndex = 0.obs;
  var show=true.obs;
  var version=true.obs;
  get selectedIndex => this._selectedIndex.value;
  set selectedInde(index) => this._selectedIndex.value = index;

  List<Widget> widgetList = [
    JobHomeScreen(),
    FeedHomeScreen(),
    ConnectionHomeScreen(),
    ProfileHomeScreen(),
  ];
}