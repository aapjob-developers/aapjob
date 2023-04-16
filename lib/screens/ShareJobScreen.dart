import 'dart:io';

import 'package:Aap_job/localization/language_constrants.dart';
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
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';


class ShareJobScreen extends StatefulWidget {
  ShareJobScreen({Key? key, required this.jobsModel}) : super(key: key);
  final JobsModel jobsModel;
  @override
  _ShareJobScreenState createState() => new _ShareJobScreenState();
}

class _ShareJobScreenState extends State<ShareJobScreen> {

  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata,apldata;
  bool applied=false, is_loading=false;
  int currenttime=0;
  bool _hasCallSupport = false;
  late Future<void> _launched;

  @override
  initState() {
    // canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
    //   setState(() {
    //     _hasCallSupport = result;
    //   });
    // });
    super.initState();
  }

  openwhatsapp(String mobile) async {
    var whatsapp = "+91" + mobile;
    var whatsappURl_android = "whatsapp://send?phone=" + whatsapp +
        "&text=hello";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello Sir")}";
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
          Column(
            children: <Widget>[
              Container(
          height: MediaQuery.of(context).size.height,
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
            ],
          ),
      ),
      ),
    );
  }

}



