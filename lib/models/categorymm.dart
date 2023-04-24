import 'dart:ui';

import 'package:Aap_job/models/JobsModel.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  String _id = "";
  String _name = "";
  String _icon = "";
  String _perma="";
  bool _selected = false;

  CategoryModel(
      {required String id,
        required String name,
        required String perma,
        required String icon,
        required bool selected,
      }) {
    this._id = id;
    this._name = name;
    this._perma=perma;
    this._icon = icon;
    this._selected=selected;
  }

  String get id => _id;
  String get name => _name;
  String get icon => _icon;
  String get perma => _perma;
  bool get selected => _selected;

  set selected(bool value) {
    _selected = value;
  }

  CategoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _perma = json['perma'];
    _icon = json['icon_src'];
    _selected=json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['perma']=this.perma;
    data['icon_src'] = this._icon;
    data['selected'] = this._selected;
    return data;
  }
}