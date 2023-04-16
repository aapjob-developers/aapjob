import 'dart:convert';

import 'package:Aap_job/data/respository/SearchApi.dart';
import 'package:Aap_job/helper/LocationManager.dart';
import 'package:Aap_job/helper/SharedManager.dart';
import 'package:Aap_job/models/JobCategoryModel.dart';
import 'package:Aap_job/models/JobTitleModel.dart';
import 'package:Aap_job/models/JobsModel.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/screens/JobDetailScreen.dart';
import 'package:Aap_job/screens/SearchScreen.dart';
import 'package:Aap_job/utill/dimensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:Aap_job/models/CitiesModel.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SearchScreenResult extends StatefulWidget {
  final String suggestion;
  SearchScreenResult({Key? key,required this.suggestion}) : super(key: key);
  @override
  _SearchScreenResultState createState() => new _SearchScreenResultState();
}

class _SearchScreenResultState extends State<SearchScreenResult> {

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
      Response response = await _dio.get(_baseUrl + AppConstants.SEARCH_JOBS_URI+"searchstring="+widget.suggestion+"&city="+City);
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
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Primary,
        title:
          Container(
            width: MediaQuery.of(context).size.width,
            child:
            GestureDetector(
              onTap: (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => SearchScreen()));
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius:BorderRadius.all(Radius.circular(8.0))),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.search,color: Colors.black54,size: 20,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(widget.suggestion,style: TextStyle(color: Colors.black,fontSize: 14),),
                    )
                  ],
                )
                ,
              ),
            ),
          ),
      ),
      body:
      SingleChildScrollView(
        child:
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
              child: Jobslist!=null ?
              Jobslist.length!=0?
              Container(
                height: (Jobslist.length)*130.0,
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
                                                Text(jobmodel.jobCityId,style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 14,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
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
                                        // Text(AppConstants.BASE_URL+jobmodel.recruiterImage),
                                        CircleAvatar(
                                          radius: 50.0,
                                          backgroundImage: CachedNetworkImageProvider(
                                            AppConstants.BASE_URL+jobmodel.recruiterImage,
                                            maxWidth:200,
                                            maxHeight:200,
                                          ),
                                          // child:
                                          // CachedNetworkImage(
                                          //   width:deviceSize.width*0.25,
                                          //   height:deviceSize.width*0.25,
                                          //   placeholder: (context, url) => const CircularProgressIndicator(),
                                          //   imageUrl: AppConstants.BASE_URL+jobmodel.recruiterImage,
                                          // ),
                                        )
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
              Center(
                child: Container(
                  margin: EdgeInsets.only(left: 20,top: 200,right: 20),
                  width: MediaQuery.of(context).size.width,
                 // decoration: BoxDecoration(color: Colors.pink.shade100),
                  child:
                  Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/error.json',
                        height:200,
                        animate: true,
                      ),
                      Text("No Jobs in Search.",style: LatinFonts.lato(fontSize: 20)),
                    ],
                  ),
                  ),
              )
                  :
              Center(
                child: Container(
                  margin: EdgeInsets.only(left: 20,top: 200,right: 20),
                  width: MediaQuery.of(context).size.width,
                  // decoration: BoxDecoration(color: Colors.pink.shade100),
                  child:
                  Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/error.json',
                        height:200,
                        animate: true,
                      ),
                      Text("No Jobs in Search.",style: LatinFonts.lato(fontSize: 20)),
                    ],
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

