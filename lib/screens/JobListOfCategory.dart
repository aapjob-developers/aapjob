import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'dart:math';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/category.dart';
import 'package:Aap_job/models/categorywithjob.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/JobAppliedCandidatesList.dart';
import 'package:Aap_job/screens/JobDetailScreen.dart';
import 'package:Aap_job/screens/basewidget/VideoPlayerScreen.dart';
import 'package:Aap_job/utill/date_converter.dart';
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
import 'package:provider/provider.dart';

class JobListOfCategorySceen extends StatefulWidget {
  JobListOfCategorySceen({Key? key, required this.jobCategory, required this.City}) : super(key: key);
  final CategoryWithJob jobCategory;
  final  String City;
  @override
  _JobListOfCategorySceenState createState() => new _JobListOfCategorySceenState();
}

class _JobListOfCategorySceenState extends State<JobListOfCategorySceen> {

  SharedPreferences? sharedPreferences;
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;


  @override
  initState() {
    initializePreference().whenComplete((){
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
   // Jobslist.clear();
    try {
      String url=_baseUrl + AppConstants.CAT_JOBS_URI+"catid="+widget.jobCategory.id.toString()+"&city="+widget.City;
      print(url);
      Response response = await _dio.get(url);
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
    await getCategoryJob();
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
             child: new Text("All Jobs in "+widget.jobCategory!.name!,style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 14,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),softWrap: true,maxLines: 2,),
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
                padding: EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 10),
                child: Jobslist.length!=null ?
                Jobslist.isNotEmpty?
                Container(
                  padding: EdgeInsets.only(top: 10,left: 5,right: 5,bottom: deviceSize.height*0.15),
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
                            Navigator.push(context,MaterialPageRoute(builder: (context)=> JobDetailSceen(jobsModel: jobmodel)));
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
                                          new Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                DateTime.now().difference(jobmodel.create_time).inMinutes >= 59
                                                    ?
                                                DateTime.now().difference(jobmodel.create_time).inHours >= 23 ?
                                                DateTime.now().difference(jobmodel.create_time).inDays > 1 ?
                                                new Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                                                  child:
                                                  Text("Posted on : "+DateFormat('dd/MM/yyyy').format(DateConverter.isoStringToLocalDate(jobmodel.create_time.toString())).toString()
                                                    ,style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 10,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
                                                )
                                                    :
                                                new Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                                                  child:
                                                  Text("Posted on : "+DateTime.now().difference(jobmodel.create_time).inDays.toStringAsFixed(0)+" Day Ago"
                                                    ,style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 10,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
                                                )
                                                    :
                                                new Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                                                  child:
                                                  Text("Posted on : "+DateTime.now().difference(jobmodel.create_time).inHours.toStringAsFixed(0)+" Hours Ago"
                                                    ,style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 10,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
                                                )
                                                    :
                                                new Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                                                  child:
                                                  Text("Posted on : "+DateTime.now().difference(jobmodel.create_time).inMinutes.toStringAsFixed(0)+" Minutes Ago"
                                                    ,style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 10,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
                                                ),
                                              ]
                                          ),
                                        ]
                                    ),
                                  ),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: 30),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.pink.shade100),
                  child: Text(getTranslated("NO_JOBS_IN_CATE", context)!),)
                    :  Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.black12),
                  child: CircularProgressIndicator(),),
              ),
            ],
          ),
        ),

      ),
      ),
    );
  }

}



