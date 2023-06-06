import 'dart:io';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/screens/splashscreen.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:flutter/services.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';


class TermsAccept extends StatelessWidget {
  bool istermsaccepted=sharedp.getBool("IsTermsAccepted")??false;
  static final facebookAppEvents = FacebookAppEvents();
  @override
  void trackAppInstall() {
    facebookAppEvents.setAdvertiserTracking(enabled: true);
    facebookAppEvents.logEvent(
      name: 'fb_mobile_install',
      parameters: {
        'fb_content_type': 'app',
        'fb_content_id': '1235491696998540',
      },
    );
    facebookAppEvents.logEvent(name: 'Contact');
    sharedp.setBool("install",true);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return
      Scaffold(
        body: Stack(
            children: [
                Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,

                        decoration: BoxDecoration(image: new DecorationImage(image: AssetImage('assets/images/ssback.png'))),
                        child:
                        Stack(children:[
                          Align(alignment: AlignmentDirectional.bottomCenter,
                            child:
                            Container(width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(right:10,left:10, bottom: 80),
                              height: MediaQuery.of(context).size.height*0.5,
                              decoration: new BoxDecoration(
                                  color:Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight:Radius.circular(40))
                              ),
                              child:
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    new Image.asset(
                                      'assets/images/termsbanner2.png',
                                      fit: BoxFit.contain,
                                      width:deviceSize.width,
                                    ),
                                    Text("Agree to Aap job’s Terms and Policies",style: LatinFonts.aBeeZee(fontSize: 16, fontWeight: FontWeight.bold,color:Colors.blue),maxLines: 2,textAlign: TextAlign.center,),
                                    Text("we acknowledge that when you interact with our app, we may collect and store your personal, social professional information and identity disclosure provided by you. The data",style: LatinFonts.aBeeZee(fontSize: 10, fontWeight: FontWeight.w200,color:Colors.black),maxLines: 12,),
                                    Text("What Information We Collect",style: TextStyle(color:Colors.blue,fontSize: 16,fontWeight: FontWeight.bold),maxLines: 2,),
                                    Text.rich(
                                        TextSpan(
                                            text: 'We Social Account Information - ',
                                            style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.green),
                                            children: <InlineSpan>[
                                              TextSpan(
                                                text: ' We collect personal identification information of users including the information that is available on the internet, such as from Truecaller, Facebook, LinkedIn, Twitter and Google or publicly available identify users for better communication, processing and personalization of the Services.',
                                                style: LatinFonts.aBeeZee(fontSize: 10, fontWeight: FontWeight.w200,color:Colors.black),
                                              )
                                            ]
                                        ),
                                      maxLines: 10,
                                    ),
                                    Text.rich(
                                      TextSpan(
                                          text: 'Contacts List -',
                                          style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.green),
                                          children: <InlineSpan>[
                                            TextSpan(
                                              text: ' When you sync your contacts with our services, we import and store the contacts list to our servers. you have the option to deny us the access to your contacts list. We also receive personal data (including contacts information ) about you when others import or sync their contacts with our services.',
                                              style: LatinFonts.aBeeZee(fontSize: 10, fontWeight: FontWeight.w200,color:Colors.black),
                                            )
                                          ]
                                      ),
                                      maxLines: 10,
                                    ),
                                    Text.rich(
                                      TextSpan(
                                          text: 'Location Information -',
                                          style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.green),
                                          children: <InlineSpan>[
                                            TextSpan(
                                              text: ' when you give location permission ,we access information that is derived from your GPS. We may use third - party cookies and similar technologies to collect some of this information .',
                                              style: LatinFonts.aBeeZee(fontSize: 10, fontWeight: FontWeight.w200,color:Colors.black),
                                            )
                                          ]
                                      ),
                                      maxLines: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(alignment: AlignmentDirectional.bottomCenter,
                            child:
                            Container(width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height*0.1,
                              padding: EdgeInsets.only(left: 10,right: 10),
                              decoration: new BoxDecoration(
                                  color:Colors.white,
                               //   borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight:Radius.circular(25))
                              ),
                              child:
                              new Padding(
                                child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      child:
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Decline ",style:TextStyle(fontWeight: FontWeight.w700,color: Colors.red)),
                                          Lottie.asset(
                                            'assets/lottie/decline.json',
                                            height: MediaQuery.of(context).size.width*0.06,
                                            //width: MediaQuery.of(context).size.width*0.45,
                                            animate: true,),
                                        ],
                                      ),
                                      onPressed: (){
                                        exit(0);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: new Size(deviceSize.width * 0.4,20),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16)),
                                          primary: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          textStyle:
                                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    ),
                                    ElevatedButton(
                                      child:
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Accept ",style:TextStyle(fontWeight: FontWeight.w700,color: Colors.white)),
                                          Lottie.asset(
                                            'assets/lottie/accept.json',
                                            height: MediaQuery.of(context).size.width*0.06,
                                            //width: MediaQuery.of(context).size.width*0.45,
                                            animate: true,),
                                        ],
                                      ),
                                      onPressed: ()async{
                                       await [
                                          Permission.storage,
                                          Permission.mediaLibrary,
                                          Permission.accessMediaLocation,
                                          //add more permission to request here.
                                        ].request();
                                       trackAppInstall();
                                       sharedp.setBool("IsTermsAccepted",true);
                                       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                           builder: (context) => SplashScreen()), (
                                           route) => false);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: new Size(deviceSize.width * 0.4,20), backgroundColor: Colors.amber,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16)),
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          textStyle:
                                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                                padding: const EdgeInsets.all(5.0),
                              ),
                            ),
                          )

                        ]),

                      ),
                    ]
                ),
                ]),
      );
  }


}

