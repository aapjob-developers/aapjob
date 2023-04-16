
import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'dart:math';
import 'package:Aap_job/models/JobsListModel.dart';
import 'package:Aap_job/models/category.dart';
import 'package:Aap_job/providers/HrJobs_provider.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/AppliedJobDetailScreen.dart';
import 'package:Aap_job/screens/EditJobLoading.dart';
import 'package:Aap_job/screens/JobAppliedCandidatesList.dart';
import 'package:Aap_job/screens/JobDetailScreen.dart';
import 'package:Aap_job/screens/basewidget/VideoPlayerScreen.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/screens/EditJobPostScreen.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/models/JobsModel.dart';
import 'package:Aap_job/screens/JobPostScreen.dart';
import 'package:Aap_job/screens/JobPostScreen2.dart';
import 'package:Aap_job/screens/basewidget/title_row.dart';
import 'package:Aap_job/screens/select_language.dart';

import 'package:Aap_job/screens/widget/Profilebox.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/utill/dimensions.dart';

import 'package:Aap_job/screens/profile_exp.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/view/basewidget/textfield/custom_textfield.dart';
import 'package:video_player/video_player.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:google_language_fonts/google_language_fonts.dart';

import '../localization/language_constrants.dart';

class MyClosedJobs extends StatefulWidget {
  MyClosedJobs({Key? key}) : super(key: key);
  @override
  _MyClosedJobsState createState() => new _MyClosedJobsState();
}

class _MyClosedJobsState extends State<MyClosedJobs> {

  SharedPreferences? sharedPreferences;
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;
  String City="";
  final DateFormat formatter = DateFormat('dd-MMM-yyyy');

  @override
  initState() {
    super.initState();
    _loadData(context, false);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    await Provider.of<HrJobProvider>(context, listen: false).initgetHrCloseJobsList(Provider.of<AuthProvider>(context, listen: false).getUserid(), context);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return Container(
      //decoration: new BoxDecoration(color: Primary),
      child:
      SafeArea(child:
      Scaffold(
        appBar: new AppBar(
          backgroundColor: Primary,
          title:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.7,
                child: new Text(getTranslated("MY_CLOSED_JOBS", context)!,style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 14,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),softWrap: true,maxLines: 2,),
              ),
            ],
          ),

        ),
        body:
        Column(
          children: [
            Consumer<HrJobProvider>(
                builder: (context,hrJobProvider, child) {
                  List<JobsListModel> myjobsList=hrJobProvider.closedjobsList;
                  return hrJobProvider.closedjobsList.length == 0 ?
                  Center(
                    child: Container( child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height*0.2,),
                        Image.asset('assets/images/no_data.png',height: 100,),
                        Text("No Job Closed Yet.", style: LatinFonts.aBeeZee(fontSize: 18, color:Primary),textAlign: TextAlign.center,),
                      ],
                    ),),
                  )
                      :
                  Expanded(
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: myjobsList.length,
                      separatorBuilder: (context, index) {
                        return Divider(height: 1,);
                      },
                      itemBuilder: (context, index) {
                        JobsListModel job = myjobsList[index];
                        return
                          Container(width: MediaQuery.of(context).size.width * 0.9,
                            decoration: new BoxDecoration(boxShadow: [new BoxShadow(
                              color: Color.fromRGBO(00, 132, 122, 1.0),
                              blurRadius: 5.0,
                            ),
                            ],
                                color: Color.fromRGBO(00, 132, 122, 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(5),
                            child:
                            Column(
                              children: [
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(width: deviceSize.width * 0.6,
                                        padding: EdgeInsets.all(8),
                                        child: new Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    new Container(
                                                      padding: EdgeInsets.all(2.0),
                                                      margin: EdgeInsets.only(bottom: 5.0),
                                                      decoration: new BoxDecoration(
                                                          color:  Color.fromARGB(
                                                              255, 224, 38, 7),
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(5.0))),
                                                      width: deviceSize.width * 0.32,
                                                      child:
                                                      Text("Created on " + formatter.format(job.createdAt!),
                                                        style: LatinFonts.aBeeZee(
                                                            color: Colors.white,
                                                            fontSize: 8,
                                                            fontWeight: FontWeight.w200,
                                                            fontStyle: FontStyle.italic),
                                                        textAlign: TextAlign.center,),
                                                    ),

                                                    SizedBox(width: 3,),
                                                    new Container(
                                                      padding: EdgeInsets.all(2.0),
                                                      margin: EdgeInsets.only(bottom: 5.0),
                                                      decoration: new BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(5.0))),
                                                      width: deviceSize.width * 0.2,
                                                      child:
                                                      Text(
                                                        "views : " + job.views.toString(),
                                                        style: LatinFonts.aBeeZee(
                                                            color: Colors.black,
                                                            fontSize: 8,
                                                            fontWeight: FontWeight.w200,
                                                            fontStyle: FontStyle.italic),
                                                        textAlign: TextAlign.center,),
                                                    ),
                                                  ]
                                              ),
                                              new Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    new Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 8),
                                                      child:
                                                      Text('${job.jobRole}',
                                                        style: LatinFonts.aBeeZee(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),),
                                                    ),
                                                  ]
                                              ),
                                              new Container(
                                                padding: EdgeInsets.all(3),
                                                child:
                                                Text('${job.companyName}',
                                                  style: LatinFonts.aBeeZee(fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white),),
                                              ),
                                              new Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    new Image.asset(
                                                      'assets/images/opening.png',
                                                      fit: BoxFit.contain,
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    new Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 5),
                                                      child:
                                                      Text('Openings : ${job.openingsNo}',
                                                        style: LatinFonts.aBeeZee(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),),
                                                    ),
                                                  ]),
                                              new Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    new Image.asset(
                                                      'assets/images/city.png',
                                                      fit: BoxFit.contain,
                                                      height: 15,
                                                      width: 15,
                                                    ),
                                                    new Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 5),
                                                      child:
                                                      Row(
                                                        children: [
                                                          Text('${job.jobLocation} ,',
                                                            style: LatinFonts.aBeeZee(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white),),
                                                          SizedBox(width: 5,),
                                                          Text('${job.jobcity}',
                                                            style: LatinFonts.aBeeZee(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white),),

                                                        ],
                                                      ),
                                                    ),
                                                  ]),
                                              Container(
                                                child: Divider(
                                                  color: Primary, thickness: 2,),
                                              ),
                                              new Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .center,
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .center,
                                                  children: <Widget>[
                                                    SizedBox(width: 2,),
                                                  ]
                                              ),
                                            ]
                                        ),
                                      ),
                                      new Container(
                                        // padding: EdgeInsets.all(5.0),
                                        width: deviceSize.width * 0.25,
                                        child:
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  job.applied != 0 ?
                                                  Navigator.push(context, MaterialPageRoute(
                                                      builder: (context) =>
                                                          JobAppliedCandidatesList(
                                                              jobid: job.id!,jobrole: job.jobRole!,jobapplied:job.applied!)))
                                                      :
                                                  Container()
                                                  ;
                                                },
                                                child: new Container(
                                                  margin: EdgeInsets.only(top: 10.0),
                                                  padding: EdgeInsets.all(5.0),
                                                  decoration: new BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          93, 0, 147, 1.0),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(10.0))),
                                                  width: deviceSize.width * 0.25,
                                                  child:
                                                  Text("${job.applied} Applied ",
                                                    style: LatinFonts.aBeeZee(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w200,
                                                        fontStyle: FontStyle.italic),
                                                    textAlign: TextAlign.center,),
                                                ),
                                              ),
                                              // job.status == "open" ?
                                              // ElevatedButton(
                                              //   child:
                                              //   Row(
                                              //       children: [
                                              //         new Image.asset(
                                              //           'assets/images/editjob.png',
                                              //           fit: BoxFit.contain,
                                              //           width: 20,
                                              //         ),
                                              //         const Text('Edit Job'),
                                              //       ]
                                              //   ),
                                              //
                                              //   onPressed: () {
                                              //     Navigator.push(context, MaterialPageRoute(
                                              //         builder: (context) => EditJobLoading(jobid:job.id, repost: false,)));
                                              //   },
                                              //   style: ElevatedButton.styleFrom(
                                              //       minimumSize: new Size(
                                              //           deviceSize.width * 0.2, 0),
                                              //       shape: RoundedRectangleBorder(
                                              //           borderRadius: BorderRadius.circular(
                                              //               10)),
                                              //       padding: const EdgeInsets.symmetric(
                                              //           horizontal: 5, vertical: 5),
                                              //       primary: Color.fromRGBO(
                                              //           255, 151, 0, 1.0),
                                              //       textStyle:
                                              //       const TextStyle(fontSize: 14,
                                              //           fontWeight: FontWeight.bold)),
                                              // ),
                                              ElevatedButton(
                                                child:
                                                Row(
                                                    children: [
                                                      new Image.asset(
                                                        'assets/images/editjob.png',
                                                        fit: BoxFit.contain,
                                                        width: 20,
                                                      ),
                                                      const Text('Repost Job'),
                                                    ]
                                                ),

                                                onPressed: () {
                                                  Navigator.push(context, MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditJobLoading(jobid:job.id!, repost: true,)));
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    minimumSize: new Size(
                                                        deviceSize.width * 0.2, 0),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(
                                                            10)),
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 5, vertical: 5),
                                                    primary: Color.fromRGBO(
                                                        255, 151, 0, 1.0),
                                                    textStyle:
                                                    const TextStyle(fontSize: 14,
                                                        fontWeight: FontWeight.bold)),
                                              ),

                                            ]
                                        ),
                                      ),
                                    ]
                                ),
                                job.applied != 0 ?
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            JobAppliedCandidatesList(
                                                jobid: job.id!,jobrole: job.jobRole!,jobapplied:job.applied!)));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5.0),
                                    decoration: new BoxDecoration(color: Colors.amber,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0))),
                                    width: deviceSize.width * 0.5,
                                    height: 30,
                                    child:
                                    Text(getTranslated('VIEW_ALL_APPLIED', context)!,
                                      style: LatinFonts.aBeeZee(color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w200,
                                          fontStyle: FontStyle.italic),
                                      textAlign: TextAlign.center,),
                                  ),
                                )
                                    : Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: new BoxDecoration(color: Colors.amber,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0))),
                                  width: deviceSize.width * 0.5,
                                  height: 30,
                                  child:
                                  Text(getTranslated('No_CANDIDATES_APPLIED', context)!,
                                    style: LatinFonts.aBeeZee(color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w200,
                                        fontStyle: FontStyle.italic),
                                    textAlign: TextAlign.center,),
                                ),
                              ],
                            ),
                          );
                      },
                    ),
                  )

                  ;
                }),
          ],
        ),

      ),
      ),
    );
  }

}



