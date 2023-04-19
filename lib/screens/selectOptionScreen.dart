import 'dart:io';
import 'dart:math';

import 'package:Aap_job/data/chat/chat_auth_repository.dart';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/utill/authentification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/ResumeUpload.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/otpscreen.dart';
import 'package:Aap_job/screens/profile_exp.dart';
import 'package:Aap_job/screens/save_profile.dart';
import 'package:Aap_job/screens/select_language.dart';
import 'package:Aap_job/view/basewidget/animated_custom_dialog.dart';
import 'package:Aap_job/view/basewidget/my_dialog.dart';
import '../models/register_model.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:Aap_job/screens/mainloginScreen.dart';


class SelectOptionScreen extends StatefulWidget {
  SelectOptionScreen({Key? key}) : super(key: key);
  @override
  _SelectOptionScreenState createState() => new _SelectOptionScreenState();
}

class _SelectOptionScreenState extends State<SelectOptionScreen> {

  Color box1color=Colors.transparent, box2color=Colors.transparent;
  String acctype="";
  bool  step1=false, step2=false,step3=false, step4=false;
  var _iscandidateLoading = false;
  var _ishrLoading = false;
  String AccessToken="";
  var _iscandidateShowing = true;
  var _ishrShowing = true;
  SharedPreferences? sharedPreferences;
  @override
  void initState() {
    super.initState();
    initializePreference().whenComplete(() {
      setState(() {
        box1color = Colors.transparent;
        box2color = Colors.transparent;
        acctype = "none";
      });
    });
  }

  Future<void> signOut() async {
    await Authentification().signOut();
  }

  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
  }
  @override
  void dispose() {
    super.dispose();
  }
  _hrsubmit() async {
    setState(() {
      _ishrLoading = true;
      _iscandidateShowing=false;
      AccessToken=sharedPreferences!.getString("AccessToken")??"Not found";
    });
    if(acctype!="none")
    {
      await Provider.of<AuthProvider>(context, listen: false).checkaccount(acctype, Provider.of<AuthProvider>(context, listen: false).getEmail(),Provider.of<AuthProvider>(context, listen: false).getAccessToken(), route);
    }
    else
    {
      CommonFunctions.showSuccessToast(" Please Select an Account Type");
    }

  }

  _candidatesubmit() async {
    setState(() {
      _iscandidateLoading = true;
      _ishrShowing=false;
      AccessToken=sharedPreferences!.getString("AccessToken")??"Not found";
    });
    if(acctype!="none")
    {
      print("send access : "+AccessToken.toString());
      await Provider.of<AuthProvider>(context, listen: false).checkaccount(acctype, Provider.of<AuthProvider>(context, listen: false).getEmail(),Provider.of<AuthProvider>(context, listen: false).getAccessToken(), route);
    }
    else
    {
      CommonFunctions.showSuccessToast(" Please Select an Account Type");
    }

  }

  _loginsuccess() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("accounttype", acctype);
    sharedPreferences.setBool("acctype", true);
  }


  route(bool isRoute, String route,String status, String errorMessage) async {
    // _user.email
    setState(() {
      if(_iscandidateLoading==true)
      {
        _iscandidateLoading = false;
      }
      if(_ishrLoading==true)
      {
        _ishrLoading = false;
      }
    });
    if (isRoute) {
      final sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("accounttype", acctype);
      sharedPreferences.setBool("acctype", true);
      if(route=="Login")
      {
        print("selectoption->"+Provider.of<AuthProvider>(context, listen: false).getfullsubmited());
        // if(Provider.of<AuthProvider>(context, listen: false).getfullsubmited()=="1") {
        if (status == "0") {
          CommonFunctions.showErrorDialog(
              "Your Account is disabled by admin. Please contact Customer care",
              context);
        }
        else {
          _loginsuccess();
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => SelectLanguage(isHome: false,)));
        }

        // }
        // else
        // {
        //   Navigator.pushReplacement(context, MaterialPageRoute(
        //       builder: (context) => SelectLanguage(isHome: false,)));
        // }
      }
      else
      {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => SelectLanguage(isHome: false,)), (
            route) => false);

      }
    } else {
      setState(() {
        _iscandidateShowing=true;
        _ishrShowing=true;
      });

      CommonFunctions.showErrorDialog(errorMessage,context);
    }
  }


  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    if(Provider.of<AuthProvider>(context, listen: false).getAccessToken()==null)
    {
      return Container(
        width: deviceSize.width,
        height: deviceSize.height,
        decoration: BoxDecoration(color: Colors.redAccent),
        child:Center(child:
        Column(
          children: [
            Lottie.asset(
              'assets/lottie/worried.json',
              height: MediaQuery.of(context).size.width*0.7,
              width: MediaQuery.of(context).size.width*0.7,
              animate: true,),
            Text("Do not pay amount for any job interview. Beware of scammers.",style: LatinFonts.aBeeZee(fontSize: 20),textAlign:TextAlign.center,),
          ],
        ),
        ) ,
      );

    }
    else {
      return Container(
          decoration: new BoxDecoration(color: Primary),
          child:
          SafeArea(child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          new Padding(
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Image.asset(
                                    'assets/images/appicon.png',
                                    fit: BoxFit.contain,
                                    height: deviceSize.width / 4,
                                    width: deviceSize.width / 4,
                                  )
                                ]

                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          new Padding(
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(getTranslated("WELCOME", context)! , style: new TextStyle(
                                      color: Colors.white, fontSize: 20),
                                    textAlign: TextAlign.center,),
                                ]

                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          new Padding(
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(Provider.of<AuthProvider>(context, listen: false).getEmail(),
                                    style: new TextStyle(
                                        color: Colors.white, fontSize: 16),
                                    textAlign: TextAlign.center,),
                                ]

                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          new Padding(
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(getTranslated("NOT_YOU", context)!,
                                    style: new TextStyle(
                                        color: Colors.white, fontSize: 16),
                                    textAlign: TextAlign.center,),
                                ]

                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          new Padding(
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: (){
                                      Provider.of<AuthProvider>(context, listen: false).clearSharedData().then((condition) {
                                        Provider.of<AuthProvider>(context,listen: false).clearSharedData();
                                        // googleSignIn.disconnect();
                                        signOut();
                                        Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => MainloginScreen()),);
                                      });
                                    },
                                    child: Text(getTranslated("CLICK_HERE_TO_CHANGE_ACCOUNT", context)!,
                                      style: new TextStyle(
                                        color: Colors.white, fontSize: 16,decoration: TextDecoration.underline,),
                                      textAlign: TextAlign.center,),
                                  ),
                                ]

                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          new Padding(
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(child:
                                  Text(
                                    "What are you Looking For",
                                    style:LatinFonts.aclonica(color:Colors.white,fontSize: 16,fontWeight:FontWeight.w500 ),
                                    textAlign: TextAlign.center,)
                                  )
                                ]

                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          _iscandidateShowing?
                          new Container(
                            decoration: new BoxDecoration(boxShadow: [new BoxShadow(
                              color: Colors.white,
                              blurRadius: 5.0,
                            ),],
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Colors.white,
                                  ]),),
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    // padding: EdgeInsets.all(5.0),
                                      decoration: new BoxDecoration(
                                        color: box1color,),
                                      width: deviceSize.width * 0.5,
                                      // padding: EdgeInsets.all(16.0),
                                      child:
                                      new Image.asset(
                                        'assets/images/candidate.png',
                                        fit: BoxFit.cover,
                                        height: deviceSize.width * 0.4,
                                        width: deviceSize.width * 0.5,
                                      )
                                  ),
                                  Expanded(child:
                                  Column(
                                    children: [
                                      Padding(padding: EdgeInsets.symmetric(vertical: 5.0),
                                        child:Text(
                                          "I want Job for Free",
                                          textAlign: TextAlign.center,
                                          style:LatinFonts.aclonica(color:Colors.green,fontSize: 14,fontWeight:FontWeight.w500 ),),
                                      ),

                                      Padding(padding: EdgeInsets.symmetric(vertical: 5.0),
                                        child:
                                        Text(
                                          'मुझे नौकरी चाहिए',
                                          style: DevanagariFonts.hind(textStyle:TextStyle(fontSize: 24)),
                                        ),
                                      ),
                                      if (_iscandidateLoading)
                                        CircularProgressIndicator()
                                      else
                                        ElevatedButton(
                                          child: const Text('Get a job Now'),
                                          onPressed:(){
                                            setState(() {
                                              acctype = "candidate";
                                            });
                                            _candidatesubmit();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              minimumSize: new Size(
                                                  deviceSize.width * 0.5, 20),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(
                                                      15)),
                                              primary: Colors.green,
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 10),
                                              textStyle:
                                              const TextStyle(fontSize: 20,
                                                  fontWeight: FontWeight.bold)),

                                        ),

                                    ],
                                  ),


                                  )
                                ]
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          ):Container(),
                          new SizedBox(height: 20,),
                          _ishrShowing?
                          new Container(
                            decoration: new BoxDecoration(boxShadow: [new BoxShadow(
                              color: Colors.white,
                              blurRadius: 5.0,
                            ),],
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Colors.white,
                                  ]),),
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      decoration: new BoxDecoration(
                                        color: box2color,),
                                      width: deviceSize.width * 0.5,
                                      // padding: EdgeInsets.all(16.0),
                                      child:
                                      new Image.asset(
                                        'assets/images/hr.png',
                                        fit: BoxFit.cover,
                                        height: deviceSize.width * 0.4,
                                        width: deviceSize.width * 0.5,
                                      )
                                  ),
                                  Expanded(child:
                                  Column(
                                    children: [
                                      Padding(padding: EdgeInsets.symmetric(vertical: 5.0),
                                        child:Text(
                                          "I want to hire staff",
                                          textAlign: TextAlign.center,
                                          style:LatinFonts.aclonica(color:Colors.blue,fontSize: 14,fontWeight:FontWeight.w500 ),),
                                      ),

                                      Padding(padding: EdgeInsets.symmetric(vertical: 5.0),
                                        child:
                                        Text(
                                          'Post Job within a minute',
                                          textAlign: TextAlign.center,
                                          style: LatinFonts.aBeeZee(textStyle:TextStyle(fontSize: 10)),
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.symmetric(vertical: 5.0),
                                        child:
                                        Text(
                                          'View Video resumes of Applicants',
                                          textAlign: TextAlign.center,
                                          style: LatinFonts.aBeeZee(textStyle:TextStyle(fontSize: 10)),
                                        ),
                                      ),

                                      if (_ishrLoading)
                                        CircularProgressIndicator()
                                      else
                                        ElevatedButton(
                                          child: const Text('Start Hiring Now'),
                                          onPressed:(){
                                            setState(() {
                                              acctype = "hr";
                                            });
                                            _hrsubmit();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              minimumSize: new Size(
                                                  deviceSize.width * 0.5, 20),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(
                                                      15)),
                                              primary: Colors.blue,
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 10),
                                              textStyle:
                                              const TextStyle(fontSize: 20,
                                                  fontWeight: FontWeight.bold)),

                                        ),

                                    ],
                                  ),


                                  )
                                ]
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          ):Container(),
                          // new Padding(
                          //   child:
                          //   new Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       mainAxisSize: MainAxisSize.max,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: <Widget>[
                          //         GestureDetector(
                          //           onTap: () {
                          //             setState(() {
                          //               box1color = Colors.green;
                          //               box2color = Colors.transparent;
                          //               acctype = "candidate";
                          //             });
                          //           },
                          //           child: Container(
                          //               padding: EdgeInsets.all(5.0),
                          //               decoration: new BoxDecoration(
                          //                 color: box1color,),
                          //               width: deviceSize.width * 0.4,
                          //               // padding: EdgeInsets.all(16.0),
                          //               child:
                          //               new Image.asset(
                          //                 'assets/images/candidate.png',
                          //                 fit: BoxFit.contain,
                          //                 height: deviceSize.width * 0.35,
                          //                 width: deviceSize.width * 0.35,
                          //               )
                          //           ),
                          //         ),
                          //         GestureDetector(
                          //           onTap: () {
                          //             setState(() {
                          //               box1color = Colors.transparent;
                          //               box2color = Colors.green;
                          //               acctype = "hr";
                          //             });
                          //           },
                          //           child:
                          //           Container(
                          //               decoration: new BoxDecoration(
                          //                 color: box2color,),
                          //               width: deviceSize.width * 0.4,
                          //               // padding: EdgeInsets.all(16.0),
                          //               child:
                          //               new Image.asset(
                          //                 'assets/images/hr.png',
                          //                 fit: BoxFit.contain,
                          //                 height: deviceSize.width * 0.35,
                          //                 width: deviceSize.width * 0.35,
                          //               )
                          //           ),
                          //         )
                          //
                          //       ]
                          //   ),
                          //   padding: const EdgeInsets.all(10.0),
                          // ),
                          // if (_isLoading)
                          //   CircularProgressIndicator()
                          // else
                          // new Padding(
                          //   child:
                          //   new Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       mainAxisSize: MainAxisSize.max,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: <Widget>[
                          //         ElevatedButton(
                          //           child: const Text('Save and Continue'),
                          //           onPressed:(){_submit();},
                          //           style: ElevatedButton.styleFrom(
                          //               minimumSize: new Size(
                          //                   deviceSize.width * 0.5, 20),
                          //               shape: RoundedRectangleBorder(
                          //                   borderRadius: BorderRadius.circular(
                          //                       15)),
                          //               primary: Colors.amber,
                          //               padding: const EdgeInsets.symmetric(
                          //                   horizontal: 10, vertical: 10),
                          //               textStyle:
                          //               const TextStyle(fontSize: 20,
                          //                   fontWeight: FontWeight.bold)),
                          //
                          //         ),
                          //       ]
                          //
                          //   ),
                          //   padding: const EdgeInsets.all(10.0),
                          // ),
                        ]

                    ),
                  ),

                ),
              ],),),)
      );
    }
  }
}