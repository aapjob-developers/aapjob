import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/CatJobsModel.dart';
import 'package:Aap_job/models/ContentModel.dart';
import 'package:Aap_job/models/categorywithjob.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/providers/content_provider.dart';
import 'package:Aap_job/providers/notification_provider.dart';
import 'package:Aap_job/screens/JobListOfCategory.dart';
import 'package:Aap_job/screens/JobLiveDataScreen.dart';
import 'package:Aap_job/screens/JobtypeSelect.dart';
import 'package:Aap_job/screens/NotificationScreen.dart';
import 'package:Aap_job/screens/SearchScreen.dart';
import 'package:Aap_job/screens/SupportScreen.dart';
import 'package:Aap_job/screens/getjobdetails.dart';
import 'package:Aap_job/screens/notification/notification_screen.dart';
import 'package:Aap_job/screens/widget/ChangeLocationScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:Aap_job/screens/widget/VideoPopup.dart';
import 'package:Aap_job/models/JobsModel.dart';
import 'package:Aap_job/models/category.dart';
import 'package:Aap_job/providers/category_provider.dart';
import 'package:Aap_job/screens/JobDetailScreen.dart';
import 'package:Aap_job/screens/basewidget/VideoPlayerScreen.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/utill/dimensions.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:Aap_job/utill/date_converter.dart';

class JobHomeScreen extends StatefulWidget {
  JobHomeScreen({Key? key}) : super(key: key);
  @override
  _JobHomeScreenState createState() => new _JobHomeScreenState();
}

class _JobHomeScreenState extends State<JobHomeScreen> {
  SharedPreferences? sharedPreferences;
  final ScrollController _scrollController = ScrollController();


  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;
  ContentModel duplicateItems = new ContentModel();
  List<Category> categoryList = [];

  Future<void> _loadData(BuildContext context) async {
    await Provider.of<CategoryProvider>(context, listen: false).getSelectedCategoryListById(context);

  }
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

  initState() {
    initializePreference().whenComplete((){
      getdata();
    });
    super.initState();

  }

  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
   // await Provider.of<ContentProvider>(context, listen: false).getContent(context);
  }

  getdata() async{
    await _loadData(context);
  }
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
   Provider.of<NotificationProvider>(context, listen: false).initNotificationList(context,Provider.of<AuthProvider>(context, listen: false).getUserid());
    return Container(
        decoration: new BoxDecoration(color: Primary),
        child:
        SafeArea(child:
              Scaffold(
      body:
    Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: deviceSize.height*0.4,
      centerTitle: true,
      elevation: 0.5,
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(color: Colors.black),
      title:
          Column(
            children: [
              Topbar(),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap:(){
                        VideoPopup(title:Provider.of<ContentProvider>(context, listen: false).contentList[2].internalVideoSrc!).show(context);
                      },
                      child:
                      FadeInImage.assetNetwork(
                        width: MediaQuery.of(context).size.width*0.9,
                        height: MediaQuery.of(context).size.width*0.2,
                        placeholder: 'assets/images/no_data.png',
                        image:AppConstants.BASE_URL+Provider.of<ContentProvider>(context, listen: false).contentList[2].imgSrc!,
                        fit: BoxFit.contain,
                      ),
                    )
                  ]),
            ],
          ),

    ),
    body:
    Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          return categoryProvider.NewSelectedcategoryList.isNotEmpty ?
          ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: categoryProvider.NewSelectedcategoryList.length,
            padding: EdgeInsets.all(0),
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index){
              return SizedBox(height: 1,);
            },
            itemBuilder: (context, index) {
              CategoryWithJob selectedcategory = categoryProvider.NewSelectedcategoryList[index];
              return Container(
                decoration: BoxDecoration(),
                child:
                Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                        child:
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(width:deviceSize.width*0.6,child: Text(selectedcategory.name!,style: LatinFonts.aBeeZee(color:Primary,fontWeight: FontWeight.w500 ),maxLines: 3,)),
                             // Text(categoryProvider.SelectedcategoryList.length.toString(),style: LatinFonts.aBeeZee(color:Primary,fontWeight: FontWeight.w500 )),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=> JobListOfCategorySceen(jobCategory: selectedcategory,City:Provider.of<AuthProvider>(context, listen: false).getJobCity(),)));
                                },
                                child:  Chip(
                                  backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                  padding: EdgeInsets.all(5.0),
                                  label: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [Text('View All ',style: LatinFonts.aBeeZee(color:Colors.white )),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: Dimensions.FONT_SIZE_SMALL,
                                        ),
                                      ]),
                                ),
                              )
                            ])
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      child: selectedcategory.jobsModellist.isNotEmpty?
                  Container(
                        height: (selectedcategory.jobsModellist.length)*MediaQuery.of(context).size.width*0.4,
                        child:
                    ListView.separated(
                      scrollDirection: Axis.vertical,
                        itemCount: selectedcategory.jobsModellist.length,
                      separatorBuilder: (context, index){
                        return SizedBox(height: 0.5,);
                      },
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        CatJobsModel jobmodel = selectedcategory.jobsModellist[index];
                        return  GestureDetector(
                          onTap: (){
                            addviews(jobmodel.id);
                        Navigator.push(context,MaterialPageRoute(builder: (context)=> GetJobDetailSceen(jobid:jobmodel.id)));
                        },
                          child:
                          Container(
                            width: MediaQuery.of(context).size.width*0.9,
                           // height: MediaQuery.of(context).size.width*0.38,
                            decoration: new BoxDecoration(
                                boxShadow: [new BoxShadow(
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
                                  new Container( width: deviceSize.width*0.55,
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
                                            Text(jobmodel.jobRole,style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 12,fontWeight: FontWeight.w800,fontStyle: FontStyle.italic ),maxLines: 2,),
                                          ),
                                          new Container(
                                            padding: EdgeInsets.symmetric(horizontal: 5),
                                            child:
                                            Text(jobmodel.companyName,style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 8,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),maxLines: 2,),
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
                                                  Text(jobmodel.openingsNo+" Openings",style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 10,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),maxLines: 2,),
                                                ),
                                              ]
                                          ),
                                          new Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                               // Text( jobmodel.create_time.toString()),
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
                                          jobmodel.recruiterImage==null?AppConstants.BASE_URL+"uploads/users/1.png":AppConstants.BASE_URL+jobmodel.recruiterImage,
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
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.pink.shade100),
                      child: Text(getTranslated("NO_JOBS_IN_CATE", context)!),),
                        //   :  Container(
                        // padding: EdgeInsets.all(20),
                        // width: MediaQuery.of(context).size.width,
                        // decoration: BoxDecoration(color: Colors.black12),
                        // child: Text(getTranslated("NO_JOBS_IN_CATE", context)!),),
                    ),
                  ],
                ),

              );
                //CategoryBox(Jobcat: selectedcategory.id,CategoryTitle: selectedcategory.name,);

            },
          )
              : Center(child: Lottie.asset(
            'assets/lottie/gps.json',
            height: 140,
            //width: MediaQuery.of(context).size.width*0.45,
            animate: true,
          ),);

        }
    ),
    ),
    )
        ),
    );
  }
}


class Topbar extends StatefulWidget {
  Topbar({Key? key}) : super(key: key);
  @override
  _TopbarState createState() => new _TopbarState();
}
class _TopbarState extends State<Topbar> {
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;
  @override
  void initState() {
    super.initState();
  }

  adcategory(String categoryid,String perma) async {
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.UPDATE_CATEGORY_URI+categoryid+"&userid="+Provider.of<AuthProvider>(context, listen: false).getUserid());
      apidata = response.data;
      //print('rev :'+apidata.toString());
      if(apidata.toString().contains("added"))
        {
          if(perma!=null)
            {FirebaseMessaging.instance.subscribeToTopic(perma); print('add cate : ${perma}'); }
        }
      else if(apidata.toString().contains("deleted"))
        {
          if(perma!=null)
          FirebaseMessaging.instance.unsubscribeFromTopic(perma);
          print('del cate : ${perma}');
        }
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
  Stream<int> getnotificationcount() => Stream<int>.periodic(Duration(seconds: 1),(count)=>Provider.of<NotificationProvider>(context, listen: false).noti_count,);
  @override
  Widget build(BuildContext context) {
    final  deviceSize= MediaQuery.of(context).size;
    return Container(
      // decoration: new BoxDecoration(border: Border.all(color: Primary),),
      width: deviceSize.width,
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context,  MaterialPageRoute(builder: (context)=> ChangeLocationScreen(CurrentCity: Provider.of<AuthProvider>(context, listen: false).getJobCity(), CurrentLocation:Provider.of<AuthProvider>(context, listen: false).getJobLocation(),usertype: "candidate",)));
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  width: MediaQuery.of(context).size.width*0.20,
                  child:
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        Lottie.asset(
                          'assets/lottie/locatione.json',
                          height: MediaQuery.of(context).size.width*0.15,
                          width: MediaQuery.of(context).size.width*0.15,
                          animate: true,),

                        Column(
                          children: [
                            Text(Provider.of<AuthProvider>(context, listen: false).getJobLocation(),style:LatinFonts.aBeeZee(fontSize: 12),textAlign: TextAlign.center,),
                            Text(Provider.of<AuthProvider>(context, listen: false).getJobCity(),style: LatinFonts.aBeeZee(fontSize: 10, fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                          ],
                        ),

                      ]
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width*0.25,
                child:
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Text(getTranslated("WELCOME", context)!,style: LatinFonts.aBeeZee(fontSize:12),),
                      Text(Provider.of<AuthProvider>(context, listen: false).getName(),style: LatinFonts.aBeeZee(fontSize:12,fontWeight: FontWeight.bold),),
                    ]),


              ),
              Container(
                padding: EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width*0.4,
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,  MaterialPageRoute(builder: (context)=> JobLiveDataScreen()));
                      },
                      child: Lottie.asset(
                        'assets/lottie/liveprofile.json',
                        height: MediaQuery.of(context).size.width*0.1,
                        width: MediaQuery.of(context).size.width*0.1,
                        animate: true,),
                    ),

                    SizedBox(width: MediaQuery.of(context).size.width*0.005,),
                    // new Image.asset(
                    //   'assets/images/map.png',
                    //   fit:BoxFit.contain,
                    //   width: MediaQuery.of(context).size.width*0.09,
                    // ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,  MaterialPageRoute(builder: (context)=> SupportScreen()));
                      },
                      child:
                      Lottie.asset(
                        'assets/lottie/support.json',
                        height: MediaQuery.of(context).size.width*0.15,
                        width: MediaQuery.of(context).size.width*0.15,
                        animate: true,),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.005,),
                    StreamBuilder<int>(
                      initialData: Provider.of<NotificationProvider>(context, listen: false).noti_count,
                      stream: getnotificationcount(),
                      builder: (context, snapshot) {
                        if(snapshot.data!<Provider.of<AuthProvider>(context, listen: false).getCurrentNotificationCount()){
                          Provider.of<AuthProvider>(context, listen: false).setCurrentNotificationCount(snapshot.data!);}
                        return new Stack(
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                if(Provider.of<AuthProvider>(context, listen: false).setCurrentNotificationCount(snapshot.data!))
                                Navigator.push(context,  MaterialPageRoute(builder: (context)=>NotificationScreen(Userid: Provider.of<AuthProvider>(context, listen: false).getUserid())));
                              },
                              child:
                              Lottie.asset(
                                'assets/lottie/notification_bell.json',
                                height: MediaQuery.of(context).size.width*0.1,
                                width: MediaQuery.of(context).size.width*0.1,
                                animate: true,),
                            ),
                            snapshot.data == Provider.of<AuthProvider>(context, listen: false).getCurrentNotificationCount() ?
                            new Container():
                            new Positioned(
                              right: 5,
                              top: 5,
                              child: new Container(
                                padding: EdgeInsets.all(2),
                                decoration: new BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 10,
                                  minHeight: 10,
                                ),
                                child: Text(
                        (snapshot.data!-Provider.of<AuthProvider>(context, listen: false).getCurrentNotificationCount()).toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 6,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        );
                      }
                    ),

                    // new Image.asset(
                    //   'assets/images/map.png',
                    //   fit:BoxFit.contain,
                    //   width: MediaQuery.of(context).size.width*0.08,
                    // ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child:
            GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => SearchScreen()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(3),
                decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                child:  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.search_rounded,color: Colors.black,),
                      SizedBox(width: 5,),
                      Text(getTranslated("SEARCH_BY_TITLE", context)!, style: TextStyle(fontSize: 12),)
                    ]),
              ),
            ),
            //BannersView(),
          ),
          Container(
            height: 60.0,
            decoration: BoxDecoration(color: Colors.blue.shade200),
            child:
            Consumer<CategoryProvider>(
              builder: (context, categoryProvider, child) {
                return categoryProvider.NewcategoryList.isNotEmpty ?
                ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: categoryProvider.NewcategoryList.length,
                  padding: EdgeInsets.all(0),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index){
                    return SizedBox(width: 10);
                  },
                  itemBuilder: (context, index) {
                    CategoryWithJob category = categoryProvider.NewcategoryList[index];
                   
                    return
                      GestureDetector(
                          onTap: (){
                         //   if(categoryProvider.TotalSelectedIndex<=5) {
                              adcategory(category.id.toString(),category.perma.toString());
                              categoryProvider.TotalSelectedIndex=categoryProvider.TotalSelectedIndex+1;
                              Provider.of<CategoryProvider>(
                                  context, listen: false)
                                  .changeNewSelectedIndexColor(
                                  index, category.selected, category);
                           // }
                            },
                          child:Chip(
                            ///backgroundColor: isSelected? Colors.primaries[Random().nextInt(Colors.primaries.length)]:Colors.white,
                              backgroundColor: category.mycolor,
                              // avatar: CircleAvatar( radius: 50,
                              //   backgroundImage: NetworkImage('${AppConstants.BASE_URL}/${category.icon}',scale:.8), //NetworkImage
                              // ), //CircleAvatar
                              // label:
                              //  Text(" "+category.name,style:LatinFonts.lato(fontStyle: FontStyle.italic,color: Colors.black,fontWeight: FontWeight.bold),),
                            label:          Row(
                                children: [
                                  // FadeInImage.assetNetwork(
                                  //   width: 40,
                                  //   height: 40,
                                  //   placeholder: 'assets/images/appicon.png',
                                  //   image: '${AppConstants.BASE_URL}/${category.icon}',
                                  //   fit: BoxFit.contain,
                                  // ),
                                  CircleAvatar( radius: 15,
                                    backgroundImage: NetworkImage('${AppConstants.BASE_URL}/${category.icon}',scale:.8), //NetworkImage
                                  ),
                                  Text(" "+category.name!,style:LatinFonts.lato(fontStyle: FontStyle.italic,color: Colors.black,fontWeight: FontWeight.bold),),
                                ],
                              )
                          )
                      )
                    ;

                    //   HCategoryItem(
                    //   title: _category.name,
                    //   isSelected: categoryProvider.categorySelectedIndex == index,
                    //   id: _category.id,
                    //
                    // );
                  },
                )
                    : Center(child: Lottie.asset(
                  'assets/lottie/gps.json',
                  height: 40,
                  //width: MediaQuery.of(context).size.width*0.45,
                  animate: true,
                ),);
              },
            ),

          ),
        ],
      ),
    );
  }

}


