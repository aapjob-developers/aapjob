import 'dart:convert';
import 'dart:io';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/JobsModel.dart';
import 'package:Aap_job/providers/HrJobs_provider.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/providers/jobtitle_provider.dart';
import 'package:Aap_job/screens/EditJobPostScreen2.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Aap_job/models/CitiesModel.dart';
import 'package:Aap_job/models/JobCategoryModel.dart';
import 'package:Aap_job/models/JobTitleModel.dart';
import 'package:Aap_job/models/LocationModel.dart';
import 'package:Aap_job/models/common_functions.dart';

import 'package:Aap_job/screens/JobPostScreen2.dart';
import 'package:Aap_job/screens/LocationSelectionScreen.dart';
import 'package:Aap_job/screens/hrloginscreen.dart';
import 'package:Aap_job/screens/loginscreen.dart';
import 'package:Aap_job/screens/profile_exp.dart';
import 'package:Aap_job/screens/widget/CitySelectionScreen.dart';
import 'package:Aap_job/screens/widget/JobTitleSelectionScreen.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/utill/dimensions.dart';
import 'package:Aap_job/view/basewidget/animated_custom_dialog.dart';
import 'package:Aap_job/view/basewidget/textfield/custom_textfield.dart';
import 'package:video_player/video_player.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:google_language_fonts/google_language_fonts.dart';

import 'EditJobPostScreen.dart';


class EditJobLoading extends StatefulWidget {
  EditJobLoading({Key? key,required this.jobid,required this.repost}) : super(key: key);
  String jobid;
  bool repost;
  @override
  _EditJobLoadingState createState() => new _EditJobLoadingState();
}

class _EditJobLoadingState extends State<EditJobLoading> {

  @override
  void initState() {
    super.initState();
    _loadData(context, false);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Provider.of<HrJobProvider>(context, listen: false).initgetHrJob(widget.jobid, context).then((bool isSuccess){
      if(isSuccess){
        _route(Provider.of<HrJobProvider>(context, listen: false).Job!);
      }
    });
  }

  void _route(JobsModel Job)
  {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EditJobPostScreen(job: Job,repost: widget.repost,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return
      Container(
      decoration: new BoxDecoration(color: Colors.white),
      child:
      SafeArea(child:
      CircularProgressIndicator(),
      ),
    );
  }

}



