import 'dart:io';

import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/splashscreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/models/JobsModel.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/providers/ads_provider.dart';
import 'package:Aap_job/screens/save_profile.dart';
import 'package:Aap_job/screens/videoApp.dart';
import 'package:Aap_job/screens/widget/adsView.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';


class DeleteProfileScreen extends StatefulWidget {
  DeleteProfileScreen({Key? key}) : super(key: key);
  @override
  _DeleteProfileScreenState createState() => new _DeleteProfileScreenState();
}

class _DeleteProfileScreenState extends State<DeleteProfileScreen> {

  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata,apldata;
  bool applied=false, is_loading=false;
  late int currenttime;
  bool _hasCallSupport = false;
  late Future<void> _launched;

  @override
  initState() {
    super.initState();
  }

 Deleteprofile() async {
   print('Dio send');
    try {
      Response response;
      if(Provider.of<AuthProvider>(context, listen: false).getacctype()=="hr"){
        response = await _dio.get(_baseUrl + AppConstants.DELETE_HR_PROFILE+Provider.of<AuthProvider>(context, listen: false).getUserid());}
      else
        {
          response = await _dio.get(_baseUrl + AppConstants.DELETE_CANDIDATE_PROFILE+Provider.of<AuthProvider>(context, listen: false).getUserid());
        }
      apidata = response.data;
          Provider.of<AuthProvider>(context, listen: false).clearSharedData().then((condition) {
            FirebaseMessaging.instance.deleteToken();
            Provider.of<AuthProvider>(context,listen: false).clearSharedData();
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
          });

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
    return Container(
      //decoration: new BoxDecoration(color: Primary),
      child:
      SafeArea(child:
      Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {
            Navigator.of(context).pop();
          },icon: Icon(Icons.arrow_back_ios,color: Colors.white,),),
          automaticallyImplyLeading: true,
          centerTitle: true,
          elevation: 0.5,
          backgroundColor: Primary,
          title:
          new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Image.asset(
                  'assets/images/appicon.png',
                  fit: BoxFit.contain,
                  height: 30,
                  width: 30,
                ),
                SizedBox(width: 10,),
                Container(
                  width: MediaQuery.of(context).size.width*0.6,
                  child: Text("Delete Profile data",maxLines:2,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                  ),
                ),
              ]
          ),
        ),
        body:
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Lottie.asset(
                  'assets/lottie/worried.json',
                  animate: true,
                width: MediaQuery.of(context).size.width
                ),
            Text(
              "Do you really want to delete your profile data? your can't recover that later",
              textAlign: TextAlign.center,
              style:LatinFonts.aclonica(color:Primary,fontSize: 16,fontWeight:FontWeight.w500 ),),
                SizedBox(height: 20,),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("If you delete your data you not able to use aap job services"),
                  ],),
                SizedBox(height: 20,),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      child:Text('I Confirm to delete My Profile data'),
                      onPressed: () => Deleteprofile(),
                      style: ElevatedButton.styleFrom(
                          minimumSize: new Size(deviceSize.width * 0.5,20),
                          maximumSize: new Size(deviceSize.width * 0.9,20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          primary: Colors.amber,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          textStyle:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                    ),
                  ],),
              ],
            ),
          ),
      ),
      ),
    );
  }

}



