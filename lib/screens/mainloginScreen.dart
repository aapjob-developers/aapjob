import 'dart:io';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/providers/config_provider.dart';
import 'package:Aap_job/screens/widget/adsView.dart';
import 'package:Aap_job/utill/authentification.dart';
import 'package:Aap_job/widgets/show_loading_dialog.dart';
import 'package:Aap_job/widgets/show_location_dialog.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/screens/selectOptionScreen.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:the_apple_sign_in/scope.dart';
// import 'package:permission_handler/permission_handler.dart';

class MainloginScreen extends StatefulWidget {
  MainloginScreen({Key? key}) : super(key: key);
  @override
  _MainloginScreenState createState() => new _MainloginScreenState();
}

class _MainloginScreenState extends State<MainloginScreen> {
  final Dio _dio = Dio();
  dynamic user;
  SharedPreferences? sharedPreferences;
  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
    if(Platform.isIOS)
      {
        await signInWithApple();
      }
    else
      {
        await signInWithGoogle();
      }
  }

  Future<dynamic> signInWithGoogle() async {
    showLocationDialog(
      context: context,
      message: 'assets/lottie/wait.json',
    );
    user=await Authentification().signInWithGoogle();
    if(user!=null)
    {
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelectOptionScreen()),);
    }
    else
    {
      Navigator.pop(context);
      CommonFunctions.showInfoDialog("Could not Complete Login due to error, Please try again", context);
    }

  }

  Future<dynamic> signInWithApple() async {
    user=await Authentification().signInWithApple(
        scopes: [Scope.email, Scope.fullName]);
    if(user!=null)
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelectOptionScreen()),);
    }
    else
    {
      CommonFunctions.showInfoDialog("Could not Complete Login", context);
    }

  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _loadData(context, false);
  }


  Future<bool> _loadData(BuildContext context, bool reload) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Provider.of<ConfigProvider>(context, listen: false).getConfig(packageInfo.version,context).then((bool isSuccess){
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return
      Container(
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
                                    height: deviceSize.height / 4,
                                    width: deviceSize.width / 2,
                                  )
                                ]

                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          Platform.isIOS?
                          new Padding(
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: signInWithApple,
                                    child:
                                    new Image.asset(
                                      'assets/images/applesignin.png',
                                      fit: BoxFit.contain,
                                      width: deviceSize.width * 0.8,
                                    ),
                                  ),
                                ]

                            ),
                            padding: const EdgeInsets.all(10.0),
                          )
                              :
                          new Padding(
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: signInWithGoogle,
                                    child:
                                    new Image.asset(
                                      'assets/images/googlebtn.png',
                                      fit: BoxFit.contain,
                                      width: deviceSize.width * 0.8,
                                    ),
                                  ),
                                ]

                            ),
                            padding: const EdgeInsets.all(10.0),
                          ),
                          new Padding(
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: new BoxDecoration(color: Color.fromARGB(
                                        255, 204, 204, 204)),
                                    width: deviceSize.width*0.8,
                                    height: deviceSize.width*0.8,
                                    padding: EdgeInsets.all(3.0),
                                    child:
                                    Center(child: AdsView(width:deviceSize.width*0.8,height:deviceSize.width*0.8),),
                                  ),
                                ]
                            ),
                            padding: const EdgeInsets.all(10.0),
                          ),

                        ]

                    ),
                  ),

                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: new BoxDecoration(
                                  color: Color.fromARGB(
                                      255, 204, 204, 204)),
                              width: deviceSize.width,
                              padding: EdgeInsets.all(3.0),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.lock_rounded,
                                    color: Colors.amberAccent,
                                  ),
                                  Text("100% Safe and Secure"),
                                ],
                              ),
                            ),
                          ]
                      ),
                      Divider(height: 1, thickness: 1,),
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: new BoxDecoration(
                                  color: Color.fromARGB(
                                      255, 204, 204, 204)),
                              width: deviceSize.width,
                              padding: EdgeInsets.all(3.0),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(getTranslated("CONTINUE_AGREE", context)!),
                                  Text(getTranslated("T_N_C", context)!, style: TextStyle(
                                      color: Colors.deepPurple),),
                                ],
                              ),
                            ),
                          ]
                      ),
                    ],
                  ),

                ),

              ],),),)
      );

  }
}