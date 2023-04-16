import 'package:Aap_job/models/JobsModel.dart';
import 'package:flutter/material.dart';
class Category {
  int? _id;
  String? _name;
  String? _perma;
  String? _icon;
  bool _selected=false;
  Color _mycolor = Colors.red;
  List<JobsModel> _jobsModellist=[];

  Category({
    required int id,
    required String name,
    required String perma,
    required String icon,
    required bool selected,
    required Color mycolor,
    required List<JobsModel> jobsModellist,
  }) { _id = id;
        _name = name;
        _perma=perma;
        _icon = icon;
        _selected = selected;
        _mycolor = mycolor;
        _jobsModellist = jobsModellist; }

  int? get id => _id;
  String? get name => _name;
  String? get icon => _icon;
  String? get perma => _perma;
  bool get selected => _selected;
  Color get mycolor => _mycolor;
  List<JobsModel> get jobsModellist => _jobsModellist;

  set selected(bool value) => _selected = value;
  set mycolor(Color value) => _mycolor = value;
  set jobsModel(List<JobsModel> jobsModellist) => _jobsModellist = jobsModellist;

  Category.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _name = json['name'],
        _perma = json['perma'],
        _icon = json['icon_src'],
        _selected = json['selected'];

  Map<String, dynamic> toJson() => {
    'id': _id,
    'name': _name,
    'icon_src': _icon,
    'selected': _selected,
  };
}
