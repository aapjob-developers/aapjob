
import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'dart:math';
import 'package:Aap_job/models/category.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/AppliedJobDetailScreen.dart';
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

class MyAppliedJobs extends StatefulWidget {
  MyAppliedJobs({Key? key}) : super(key: key);
  @override
  _MyAppliedJobsState createState() => new _MyAppliedJobsState();
}

class _MyAppliedJobsState extends State<MyAppliedJobs> {

  SharedPreferences? sharedPreferences;
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;
  String City="";

  @override
  initState() {
    initializePreference().whenComplete((){
      setState(() {
        getCategoryJob();
      });
    });
    super.initState();
  }

  List<JobsModel> Jobslist = <JobsModel>[];
  bool _hasJobsModel=false;

  addviews(String jobid) async {
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.UPDATE_VIEW_URI+jobid);
      apidata = response.data;
      print('Job categories : ${apidata}');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }

  }

  getCategoryJob() async {
    Jobslist.clear();
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.APPLIED_JOBS_URI+Provider.of<AuthProvider>(context, listen: false).getUserid());
      apidata = response.data;
      print('JobsModelList : ${apidata}');
      List<dynamic> data=json.decode(apidata);
      if(data.toString()=="[]")
      {
        Jobslist=[];
        setState(() {
          _hasJobsModel = false;
        });
      }
      else
      {
        data.forEach((jobs) =>
            Jobslist.add(JobsModel.fromJson(jobs)));
        setState(() {
          _hasJobsModel=true;
        });
      }
      print('Jobtitle List: ${Jobslist}');

    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }

  }

  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
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
                child: new Text("My Applied Jobs ",style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 14,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),softWrap: true,maxLines: 2,),
              ),
            ],
          ),

        ),
        body:
        SingleChildScrollView(
          child:
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: 30),
                child: Jobslist!=null ?
                Jobslist.length!=0?
                Container(
                  height: MediaQuery.of(context).size.height,
                  //           decoration: BoxDecoration(boxShadow: [new BoxShadow(
                  // color: Primary,
                  // blurRadius: 5.0,
                  // ),],border: Border.all(color: Primary),borderRadius: BorderRadius.all(Radius.circular(10))),
                  child:
                  ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: Jobslist.length,
                      separatorBuilder: (context, index){
                        return SizedBox(height: 5,);
                      },
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        JobsModel jobmodel = Jobslist[index];
                        return  GestureDetector(
                          onTap: (){
                            addviews(jobmodel.id);
                            Navigator.push(context,MaterialPageRoute(builder: (context)=> AppliedJobDetailScreen(jobsModel: jobmodel)));
                          },
                          child:
                          Container(
                            width: MediaQuery.of(context).size.width*0.9,
                            decoration: new BoxDecoration(boxShadow: [new BoxShadow(
                              color: Color.fromRGBO(240, 87, 142, 1.0),
                              blurRadius: 5.0,
                            ),], gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromRGBO(240, 87, 142, 1.0),
                                  Color.fromRGBO(255, 87, 180, 1.0),
                                ]),
                                borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(5),
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Container( width: deviceSize.width*0.5,
                                    padding: EdgeInsets.all(8),
                                    child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: new Image.asset(
                                                    'assets/images/rupe.png',
                                                    fit: BoxFit.contain,
                                                    height: 10,
                                                    width:10,
                                                  ),
                                                ),
                                                new Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                                  child:
                                                  Text(jobmodel.maxSalary,style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 14,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
                                                ),
                                              ]
                                          ),
                                          new Container(
                                            padding: EdgeInsets.all(3),
                                            child:
                                            Text(jobmodel.jobRole,style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 12,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
                                          ),
                                          new Container(
                                            padding: EdgeInsets.symmetric(horizontal: 5),
                                            child:
                                            Text(jobmodel.companyName,style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 8,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
                                          ),
                                          Container(
                                            child: Divider(color:Primary,thickness: 2,),
                                          ),
                                          new Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                new Image.asset(
                                                  'assets/images/city.png',
                                                  fit: BoxFit.contain,
                                                  height: 10,
                                                  width:10,
                                                ),
                                                new Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                                  child:
                                                  Text(jobmodel.jobcity,style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 14,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
                                                ),
                                              ]
                                          ),
                                          new Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                new Image.asset(
                                                  'assets/images/opening.png',
                                                  fit: BoxFit.contain,
                                                  height: 10,
                                                  width:10,
                                                ),
                                                new Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                                  child:
                                                  Text(jobmodel.openingsNo+" Openings",style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 10,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
                                                ),
                                              ]
                                          ),
                                        ]
                                    ),
                                  ),
                                  // Container(
                                  //   // padding: EdgeInsets.all(5.0),
                                  //   width: deviceSize.width*0.3,
                                  //   height: deviceSize.width*0.3,
                                  //   child:
                                  //   Column(
                                  //       mainAxisAlignment: MainAxisAlignment.center,
                                  //       mainAxisSize: MainAxisSize.max,
                                  //       crossAxisAlignment: CrossAxisAlignment.center,
                                  //       children:[
                                  //         // VideoPlayerScreen(urlLandscapeVideo: jobmodel.recruiterId,),
                                  //         VideoPlayerScreen(isLocal:false,width:deviceSize.width*0.3,height:deviceSize.width*0.3,urlLandscapeVideo: AppConstants.BASE_URL+jobmodel.recruiterId,),
                                  //       ]
                                  //   ),
                                  // ),
                                  Container(
                                    // padding: EdgeInsets.all(5.0),
                                    width: deviceSize.width*0.3,
                                    height: deviceSize.width*0.3,
                                    child:
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children:[
                                          CircleAvatar(
                                            radius: 50.0,
                                            backgroundImage: CachedNetworkImageProvider(
                                              AppConstants.BASE_URL+jobmodel.recruiterImage,
                                              maxWidth:200,
                                              maxHeight:200,
                                            ),),
                                          // Text(AppConstants.BASE_URL+jobmodel.recruiterImage),
                                          // CircleAvatar(
                                          // radius: 80.0,
                                          // child: CachedNetworkImage(
                                          //     width:deviceSize.width*0.3,
                                          //     height:deviceSize.width*0.3,
                                          //     placeholder: (context, url) => const CircularProgressIndicator(),
                                          //     imageUrl: AppConstants.BASE_URL+jobmodel.recruiterImage,
                                          //   ),
                                          // )
                                          // VideoPlayerScreen(urlLandscapeVideo: jobmodel.recruiterId,),
                                          //  VideoPlayerScreen(isLocal:false,width:deviceSize.width*0.3,height:deviceSize.width*0.3,urlLandscapeVideo: AppConstants.BASE_URL+jobmodel.recruiterId,),
                                        ]
                                    ),
                                  ),
                                ]
                            ),
                          ),
                        )  ;
                      }
                  ),
                ) :
                Center(child:Container(
                  padding: EdgeInsets.only(top: 30,right: 30,left: 30,bottom: 30),
                  width: MediaQuery.of(context).size.width,
                  //decoration: BoxDecoration(color: Colors.pink.shade),
                  child:
                  Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/worried.json',
                        height: MediaQuery.of(context).size.width*0.7,
                        width: MediaQuery.of(context).size.width*0.7,
                        animate: true,),
                      Text("You have not applied any job yet!! Go Apply a job Now",style: LatinFonts.aBeeZee(fontSize: 20),textAlign:TextAlign.center,),
                      Padding(padding: EdgeInsets.all(20),
                        child:
                        ElevatedButton(
                          child: const Text('Apply a Job Now'),
                          onPressed: () {
                            Navigator.push(context,  MaterialPageRoute(builder: (context)=> HomePage()));
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: new Size(deviceSize.width * 0.5,20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              primary: Colors.amber,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              textStyle:
                              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),),)
                    :
                Center(child:Container(
                  padding: EdgeInsets.only(top: 30,right: 30,left: 30,bottom: 30),
                  width: MediaQuery.of(context).size.width,
                  //decoration: BoxDecoration(color: Colors.pink.shade),
                  child:
                  Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/worried.json',
                        height: MediaQuery.of(context).size.width*0.7,
                        width: MediaQuery.of(context).size.width*0.7,
                        animate: true,),
                      Text("You have not applied any job yet!! Go Apply a job Now",style: LatinFonts.aBeeZee(fontSize: 20),textAlign:TextAlign.center,),
                      Padding(padding: EdgeInsets.all(20),
                        child:
                        ElevatedButton(
                          child: const Text('Apply a Job Now'),
                          onPressed: () {
                            Navigator.push(context,  MaterialPageRoute(builder: (context)=> HomePage()));
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: new Size(deviceSize.width * 0.5,20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              primary: Colors.amber,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              textStyle:
                              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),),)
              ),
            ],
          ),
        ),

      ),
      ),
    );
  }

}



