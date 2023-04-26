import 'dart:io';

import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/models/JobsModel.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/providers/ads_provider.dart';
import 'package:Aap_job/screens/save_profile.dart';
import 'package:Aap_job/screens/videoApp.dart';
import 'package:Aap_job/screens/widget/adsView.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailSceen extends StatefulWidget {
  JobDetailSceen({Key? key, required this.jobsModel}) : super(key: key);
  final JobsModel jobsModel;
  @override
  _JobDetailSceenState createState() => new _JobDetailSceenState();
}

class _JobDetailSceenState extends State<JobDetailSceen> {

  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata,apldata;
  bool applied=false, is_loading=false;
  bool _hasCallSupport = false;
  @override
  initState() {
    checkapplied();
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
    super.initState();
  }

  late Future<void> _launched;
  openwhatsapp() async {
    String textmsg="*Hi, Here is a Job that i want ot share with you :\n Job Role : "+widget.jobsModel.jobRole+"\n Job Company Name : "+widget.jobsModel.jobRole+"\n Location : "+widget.jobsModel.jobcity+"\n Download Aap Job Now and Apply :* shorturl.at/afmVZ";
    var whatsappURl_android = "whatsapp://send?"+"&text="+textmsg;
    var whatappURL_ios = "https://wa.me?text=${Uri.parse("hello Sir")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text(getTranslated('whatsapp_no_installed', context)!+":")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text(getTranslated('whatsapp_no_installed', context)!+":")));
      }
    }
  }

  applyjob() async {
    print('I am in');
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.APPLY_JOB_URI+widget.jobsModel.id+"&candidateid="+Provider.of<AuthProvider>(context, listen: false).getUserid());
      apidata = response.data;
      print('Applied : ${apidata}');
      if(apidata=="Applied")
      {
        setState(() {
          applied=true;
            is_loading=false;
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> JobDetailSceen(jobsModel: widget.jobsModel)));
        });

      }
      else
      {
        setState(() {
          applied=false;
          is_loading=false;
        });
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
  checkapplied() async {
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.CHECK_APPLY_JOB_URI+widget.jobsModel.id+"&candidateid="+Provider.of<AuthProvider>(context, listen: false).getUserid());
      apldata = response.data;
      print('Applied check : ${apldata}');
      if(apldata=="Applied")
        {
          setState(() {
            applied=true;
          });

        }
      else
        {
          setState(() {
            applied=false;
          });
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

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    List<String> text=[];
    widget.jobsModel.jobskills.length>0?
    text = widget.jobsModel.jobskills
    :
     text.add("No Specific Skill Required")
    ;
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
                  new Text(getTranslated('JOB_DETAILS', context)!),
                  ElevatedButton(
                    child:
                    Row(
                      children: [
                        new Image.asset(
                          'assets/images/WhatsApp.png',
                          fit: BoxFit.contain,
                          height: 20,
                          width:20,
                        ),
                        Text(getTranslated('SHARE', context)!),
                      ],
                    )
                    ,
                    onPressed:
                    _hasCallSupport
                        ? () => setState(() {
                      openwhatsapp();
                    })
                        : null,
                    style: ElevatedButton.styleFrom(
                        minimumSize: new Size(deviceSize.width *.3,20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        primary: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

                  ),
                ],
              ),

        ),
        body:
        SingleChildScrollView(
          child:
          Column(
            children: <Widget>[
              Container(
         // height: MediaQuery.of(context).size.height*0.3,
          decoration: new BoxDecoration(color: Primary),
          child:
          Column(
              children: <Widget>[
                new Padding(
                  child:
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.jobsModel.jobRole,style: LatinFonts.aBeeZee(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
                      ]
                  ),
                  padding: const EdgeInsets.only(top: 20,left: 20,bottom: 10)
                ),
                new Padding(
                  child:
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.jobsModel.companyName,style: LatinFonts.aBeeZee(color: Colors.white60,fontSize: 14,fontWeight: FontWeight.bold),),
                      ]
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                ),
                new Padding(
                  child:
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Image.asset(
                          'assets/images/city.png',
                          fit: BoxFit.contain,
                          height: 20,
                          width:20,
                        ),
                        Text(getTranslated('NEAR', context)!+widget.jobsModel.jobcity,style: LatinFonts.aBeeZee(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                      ]
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                ),
                new Padding(
                  child:
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Image.asset(
                          'assets/images/rupe.png',
                          fit: BoxFit.contain,
                          height: 20,
                          width:20,
                        ),
                        Text(getTranslated('SALARY', context)!+"Rs. "+widget.jobsModel.minSalary+" - Rs. "+widget.jobsModel.maxSalary+getTranslated('MONTHLY', context)!,style: LatinFonts.aBeeZee(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                      ]
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                ),
                widget.jobsModel.incentive=="1"? Padding(
                  child:
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("+ Incentives ",style: LatinFonts.aBeeZee(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),),
                        Text("(  "+getTranslated('EARN_MORE_INC', context)!+"  )",style: LatinFonts.aBeeZee(color: Colors.white54,fontSize: 10,fontWeight: FontWeight.bold),),
                      ]
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                ):Container(),
                new Padding(
                  child:
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                       Text(getTranslated('POSTED_BY', context)!,style: LatinFonts.aBeeZee(color: Colors.white54,fontSize: 12,fontWeight: FontWeight.bold),),
                        Text(widget.jobsModel.recruiterName,style: LatinFonts.aBeeZee(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),),
                      ]
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                ),
                Container(
                  decoration: new BoxDecoration(color: Colors.white70),
                  child: new Padding(
                    child:
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(" Total Openings : ",style: LatinFonts.aBeeZee(color:Primary,fontSize: 12,fontWeight: FontWeight.bold),),
                          Text(widget.jobsModel.openingsNo,style: LatinFonts.aBeeZee(color: Primary,fontSize: 12,fontWeight: FontWeight.bold),),
                        ]
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  ),
                ),
              ]),

          ),
              Container(
                child:
                Column(
                    children: <Widget>[
                      widget.jobsModel.benefits.cab=="true"||widget.jobsModel.benefits.meal=="true"||widget.jobsModel.benefits.insurance=="true"||widget.jobsModel.benefits.pf=="true"||widget.jobsModel.benefits.medical=="true"||widget.jobsModel.benefits.other=="true"?
                      new Padding(
                        child:
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:Text(" Job Benefits ",style: LatinFonts.aBeeZee(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                              ),
                            ]
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 10),
                      ):Container(),
                      widget.jobsModel.benefits.cab=="true"?
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.add, color: Color.fromARGB(255, 6, 143, 255),  size: 20),
                              ),
                              Text(" Cab ",style: LatinFonts.aBeeZee(color: Color.fromARGB(
                                  255, 79, 20, 76),fontSize: 12,fontWeight: FontWeight.bold),),
                            ]
                        ):Container(),

                      widget.jobsModel.benefits.meal=="true"?
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.add, color: Colors.black,  size: 20),
                            ),
                            Text(" Meal ",style: LatinFonts.aBeeZee(color: Color.fromARGB(255, 79, 20, 76),fontSize: 12,fontWeight: FontWeight.bold),),
                          ]
                      ):Container(),

                      widget.jobsModel.benefits.insurance=="true"?
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.add, color: Color.fromARGB(255, 6, 143, 255),  size: 20),
                            ),
                            Text(" Insurance ",style: LatinFonts.aBeeZee(color: Color.fromARGB(255, 79, 20, 76),fontSize: 12,fontWeight: FontWeight.bold),),
                          ]
                      ):Container(),

                      widget.jobsModel.benefits.pf=="true"?
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.add, color: Color.fromARGB(255, 6, 143, 255),  size: 20),
                            ),
                            Text(" PF ",style: LatinFonts.aBeeZee(color: Color.fromARGB(255, 79, 20, 76),fontSize: 12,fontWeight: FontWeight.bold),),
                          ]
                      ):Container(),

                      widget.jobsModel.benefits.medical=="true"?
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.add, color: Color.fromARGB(255, 6, 143, 255),  size: 20),
                            ),
                            Text(" Medical ",style: LatinFonts.aBeeZee(color: Color.fromARGB(255, 79, 20, 76),fontSize: 12,fontWeight: FontWeight.bold),),
                          ]
                      ):Container(),

                      widget.jobsModel.benefits.other.isNotEmpty?
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.add, color: Color.fromARGB(255, 6, 143, 255),  size: 20),
                            ),
                            Text(widget.jobsModel.benefits.other,style: LatinFonts.aBeeZee(color: Color.fromARGB(255, 79, 20, 76),fontSize: 12,fontWeight: FontWeight.bold),),
                          ]
                      ):Container(),

                      new Padding(
                        child:
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.access_time_filled, color: Color.fromARGB(
                                    255, 6, 143, 255),  size: 25),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getTranslated("EXPERIENCE", context)!,style: LatinFonts.aBeeZee(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.bold),),
                                  Text(" Min. "+widget.jobsModel.minExp+" Year "+" - Max. "+widget.jobsModel.maxExp+" Year ",style: LatinFonts.aBeeZee(color: Color.fromARGB(255, 79, 20, 76),fontSize: 14,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ]
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 10),
                      ),
                      new Padding(
                        child:
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.menu_book, color: Color.fromARGB(255, 6, 143, 255),  size: 25),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(" Minimum Education ",style: LatinFonts.aBeeZee(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.bold),),
                                  Text(" "+widget.jobsModel.minQualification,style: LatinFonts.aBeeZee(color: Color.fromARGB(255, 79, 20, 76),fontSize: 14,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ]
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 10),
                      ),
                      new Padding(
                        child:
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.comment_rounded, color: Color.fromARGB(255, 6, 143, 255),  size: 25),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(" English Level ",style: LatinFonts.aBeeZee(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.bold),),
                                  Text(" "+widget.jobsModel.englishLevel,style: LatinFonts.aBeeZee(color: Color.fromARGB(255, 79, 20, 76),fontSize: 14,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ]
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 10),
                      ),
                      new Padding(
                        child:
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.person, color: Color.fromARGB(255, 6, 143, 255),  size: 25),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getTranslated('WHO_CAN_APPLY', context)!,style: LatinFonts.aBeeZee(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.bold),),
                                  Text(" "+widget.jobsModel.gender,style: LatinFonts.aBeeZee(color: Color.fromARGB(255, 79, 20, 76),fontSize: 14,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ]
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 10),
                      ),
                      new Padding(
                        child:
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.date_range_rounded, color: Color.fromARGB(255, 6, 143, 255),  size: 25),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(" Job Type ",style: LatinFonts.aBeeZee(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.bold),),
                                  Text(" "+widget.jobsModel.typeOfJob,style: LatinFonts.aBeeZee(color: Color.fromARGB(255, 79, 20, 76),fontSize: 14,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ]
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 10),
                      ),
                      new Padding(
                        child:
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.format_align_justify, color: Color.fromARGB(255, 6, 143, 255),  size: 25),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(" Job Duration ",style: LatinFonts.aBeeZee(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.bold),),
                                  Text(" "+widget.jobsModel.isContractJob,style: LatinFonts.aBeeZee(color: Color.fromARGB(255, 79, 20, 76),fontSize: 14,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ]
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 10),
                      ),
                      new Padding(
                        child:
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.dark_mode, color: Color.fromARGB(255, 6, 143, 255),  size: 25),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(" Job Shift ",style: LatinFonts.aBeeZee(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.bold),),
                                  Text(" "+widget.jobsModel.shift,style: LatinFonts.aBeeZee(color: Color.fromARGB(255, 79, 20, 76),fontSize: 14,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ]
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 10),
                      ),
                      new Padding(
                        child:
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.account_balance_sharp, color: Color.fromARGB(255, 6, 143, 255),  size: 25),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(" Workplace ",style: LatinFonts.aBeeZee(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.bold),),
                                  Text(" "+ widget.jobsModel.workplace!=null?widget.jobsModel.workplace:"Office",style: LatinFonts.aBeeZee(color: Color.fromARGB(255, 79, 20, 76),fontSize: 14,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ]
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 10),
                      ),
                      new Padding(
                          child:
                          new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("Required Job Skills ",style: LatinFonts.aBeeZee(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                              ]
                          ),
                          padding: const EdgeInsets.only(top: 10,left: 10,bottom: 10)
                      ),

                      for( var i in text )
                        Padding(
                          padding: const EdgeInsets.only(left: 10,top: 2),
                          child: Row( mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.check, color: Color.fromARGB(255, 6, 143, 255),  size: 15),
                              Text( i.toString(),style: LatinFonts.aBeeZee(color: Colors.black,),),
                            ],
                          ),
                        ),

                      new Padding(
                          child:
                          new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
 Text(getTranslated("JOB_DESP", context)!,style: LatinFonts.aBeeZee(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                              ]
                          ),
                          padding: const EdgeInsets.only(top: 10,left: 10,bottom: 10)
                      ),
                      new Padding(
                          child:
                          new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                          Container(width:deviceSize.width*0.8,child:Text(widget.jobsModel.des,style: LatinFonts.aBeeZee(color: Colors.black,fontSize: 12,),maxLines: 10,)),
                              ]
                          ),
                          padding: const EdgeInsets.only(left: 10,bottom: 10)
                      ),
                    ]),

              ),
        Container(
          width: MediaQuery.of(context).size.width,
          child:
              Column(
                children: [
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.electric_bolt, color:Color.fromARGB(255, 6, 143, 255),  size: 25),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(getTranslated("HR_RESPONDED_SINCE", context)!+widget.jobsModel.createdAt.day.toString()+"-"+widget.jobsModel.createdAt.month.toString()+"-"+widget.jobsModel.createdAt.year.toString(),style: LatinFonts.aBeeZee(color: Colors.grey,fontSize: 10,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ]
                  ),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                                child:
                                    applied?
                                    ElevatedButton(
                                      child: const Text('Already Applied'),
                                      onPressed: (){
                                      },
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: new Size(deviceSize.width * 0.9,20),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15)),
                                          primary: Colors.green,
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          textStyle:
                                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                                    )

            :
                                    is_loading?
                                    CircularProgressIndicator():
                                ElevatedButton(
                                  child: const Text('Apply For Job'),
                                  onPressed: (){
                                    setState(() {
                                      is_loading=true;
                                    });
                                    applyjob();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: new Size(deviceSize.width * 0.9,20),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)),
                                      primary: Colors.amber,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      textStyle:
                                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                                ),



                        ),

                      ]
                  ),
                ],
              ),

        ),
            ],
          ),
        ),

      ),
      ),
    );
  }

}



