import 'dart:io';

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


class ShareAppScreen extends StatefulWidget {
  ShareAppScreen({Key? key}) : super(key: key);
  @override
  _ShareAppScreenState createState() => new _ShareAppScreenState();
}

class _ShareAppScreenState extends State<ShareAppScreen> {

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

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Download Aap Job',
        text: 'Hiring and Job Search to find full time jobs in India, entry level jobs, graduate jobs, fresher jobs, digital marketing jobs, back office jobs, sales jobs, office admin jobs, IT jobs, accounting jobs, operation jobs, retail jobs and marketing jobs vacancies in multiple fields.\n *Download Aap Job*',
        linkUrl: 'https://play.google.com/store/apps/details?id=com.unick.aapjob',
        chooserTitle: 'Please share Aap job'
    );
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
        body:
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Lottie.asset(
                  'assets/lottie/shareapp.json',
                  animate: true,
                width: MediaQuery.of(context).size.width
                ),
            Text(
              "Do you like Aap Job?",
              textAlign: TextAlign.center,
              style:LatinFonts.aclonica(color:Primary,fontSize: 16,fontWeight:FontWeight.w500 ),),
                SizedBox(height: 20,),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      child: const Text('Share App Now'),
                      onPressed: () {
                        share();
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: new Size(deviceSize.width * 0.5,20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          primary: Colors.amber,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          textStyle:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                    ),
                  ],),
                SizedBox(height: 20,),
                Lottie.asset(
                    'assets/lottie/starss.json',
                    animate: true,
                    width: MediaQuery.of(context).size.width
                ),
                SizedBox(height: 20,),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      child: const Text('Rate Us 5 Stars on Play Store'),
                      onPressed: () => LaunchReview.launch(
                        androidAppId: "com.unick.aapjob",
                        iOSAppId: "585027354",
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: new Size(deviceSize.width * 0.5,20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          primary: Colors.amber,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          textStyle:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

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



