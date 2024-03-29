import 'dart:async';

import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/main.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/notification/NotificationServices.dart';
import 'package:Aap_job/providers/ads_provider.dart';
import 'package:Aap_job/providers/cities_provider.dart';
import 'package:Aap_job/providers/config_provider.dart';
import 'package:Aap_job/providers/content_provider.dart';
import 'package:Aap_job/providers/splash_provider.dart';
import 'package:Aap_job/screens/myloginscreen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:Aap_job/data/respository/auth_repo.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/HrPlanSelect.dart';
import 'package:Aap_job/screens/HrVerificationScreen.dart';
import 'package:Aap_job/screens/JobtypeSelect.dart';
import 'package:Aap_job/screens/ResumeUpload.dart';
import 'package:Aap_job/screens/hr_save_profile.dart';
import 'package:Aap_job/screens/hrhomepage.dart';
import 'package:Aap_job/screens/hrloginscreen.dart';
import 'package:Aap_job/screens/loginscreen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:Aap_job/screens/mainloginScreen.dart';
import 'package:Aap_job/screens/profile_exp.dart';
import 'package:Aap_job/screens/save_profile.dart';
import 'package:Aap_job/screens/selectOptionScreen.dart';
import 'package:Aap_job/screens/select_language.dart';
import '../providers/jobselect_category_provider.dart';
import '../providers/jobtitle_provider.dart';
import 'homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
// with TickerProviderStateMixin
    {
  AnimationController? _controller;
  bool loggedin=false, acctype=false, step1=false, step2=false, step3=false, step4=false, step5=false;
  String jobtypes = "", acctypevalue="";
  int userid=0;

  StreamSubscription? subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  PackageInfo? packageInfo;
  NotificationServices notificationServices= NotificationServices();

  void initState() {
   // getConnectivity();
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    // LocationManager.shared.getCurrentLocation();
    _loadData(context, false);
  }

  // getConnectivity() =>
  //     subscription = Connectivity().onConnectivityChanged.listen(
  //           (ConnectivityResult result) async {
  //         isDeviceConnected = await InternetConnectionChecker().hasConnection;
  //         if (!isDeviceConnected && isAlertSet == false) {
  //           showDialogBox();
  //           setState(() => isAlertSet = true);
  //         }
  //       },
  //     );

  // showDialogBox() => showCupertinoDialog<String>(
  //   context: context,
  //   builder: (BuildContext context) => CupertinoAlertDialog(
  //     title: const Text('No Connection'),
  //     content: const Text('Please check your internet connectivity'),
  //     actions: <Widget>[
  //       TextButton(
  //         onPressed: () async {
  //           Navigator.pop(context, 'Cancel');
  //           setState(() => isAlertSet = false);
  //           isDeviceConnected =
  //           await InternetConnectionChecker().hasConnection;
  //           if (!isDeviceConnected && isAlertSet == false) {
  //             showDialogBox();
  //             setState(() => isAlertSet = true);
  //           }
  //         },
  //         child: const Text('OK'),
  //       ),
  //     ],
  //   ),
  // );

  @override
  void dispose() {
    super.dispose();
  }

  // Future<bool> _handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location services are disabled. Please enable the services')));
  //     return false;
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Location permissions are denied')));
  //       return false;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location permissions are permanently denied, we cannot request permissions.')));
  //     return false;
  //   }
  //   return true;
  // }

  Future<bool> _loadData(BuildContext context, bool reload) async {
   //  PackageInfo packageInfo = await PackageInfo.fromPlatform();
    await Provider.of<ConfigProvider>(context, listen: false).getConfig("37",context);
   await  Provider.of<ContentProvider>(context, listen: false).getContent(context);
    if(Provider.of<CitiesProvider>(context, listen: false).cityModelList.isEmpty) {
      await Provider.of<CitiesProvider>(context, listen: false).getCities(context);
    }
    if(Provider.of<JobServiceCategoryProvider>(context, listen: false).jobcategoryList.isEmpty) {
      await Provider.of<JobServiceCategoryProvider>(context, listen: false)
          .getCategoryList(reload, context);
    }
    if(Provider.of<JobtitleProvider>(context, listen: false).jobtitleList.isEmpty) {
      await Provider.of<JobtitleProvider>(context, listen: false)
          .getJobTitleModelList(reload, context);
    }
    _route();
return false;
  }

  // void _route()
  // {
  //   Provider.of<SplashProvider>(context, listen: false).getloggedin()
  //       ? Provider.of<AuthProvider>(context, listen: false).getacctype() == 'hr'
  //       ? Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => HrHomePage()),
  //   )
  //       : Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => HomePage()),
  //   )
  //       :  Provider.of<AuthProvider>(context, listen: false).getAccessToken()!= "nn"
  //       ? Provider.of<SplashProvider>(context, listen: false).getacctype()
  //       ? Provider.of<SplashProvider>(context, listen: false).getstep1()
  //       ? Provider.of<SplashProvider>(context, listen: false).getstep2()
  //       ? Provider.of<SplashProvider>(context, listen: false).getstep3()
  //       ? Provider.of<SplashProvider>(context, listen: false).getstep4()
  //       ? Provider.of<SplashProvider>(context, listen: false).getstep5()
  //       ? Provider.of<SplashProvider>(context, listen: false).getjobtypelist() != "none" && Provider.of<SplashProvider>(context, listen: false).getloggedin()
  //       ? Provider.of<AuthProvider>(context, listen: false).getacctype() == "hr"
  //       ? Navigator
  //       .pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             HrHomePage()),
  //   )
  //       : Navigator
  //       .pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder:
  //             (context) =>
  //             HomePage()),
  //   )
  //       : Provider.of<AuthProvider>(context, listen: false).getacctype() == "hr"
  //       ? Navigator
  //       .pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             HrHomePage()),
  //   )
  //       : Navigator
  //       .pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             JobTypeSelect()),
  //   )
  //       : Provider.of<AuthProvider>(context, listen: false).getacctype() == "hr"
  //       ? Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             HrHomePage()),
  //   )
  //       : Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             ResumeUpload()),
  //   )
  //       : Provider.of<AuthProvider>(context, listen: false).getacctype() == "hr"
  //       ? Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             HrVerificationScreen()),
  //   )
  //       : Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             ProfileExp()),
  //   )
  //       : Provider.of<AuthProvider>(context, listen: false).getacctype() == "hr"
  //       ? Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             HrSaveProfile(
  //               path: "",
  //             )),
  //   )
  //       : Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             SaveProfile(
  //               path: "",
  //             )),
  //   )
  //   // acctypevalue=="hr"?Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => HrLoginScreen()),):Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => ProfileExp()),)
  //       :
  //   // acctypevalue=="hr"?Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => HrSaveProfile(path: "",)),): Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => SaveProfile(path: "",)),)
  //   Provider.of<AuthProvider>(context, listen: false).getacctype() == "hr"
  //       ? Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             HrLoginScreen()),
  //   )
  //       : Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             LoginScreen()),
  //   )
  //       : Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => SelectLanguage(
  //           isHome: false,
  //         )),
  //   )
  //   //  Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => LoginScreen()),)
  //       :
  //   //   Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => LoginScreen()),)
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => SelectOptionScreen()),
  //   )
  //       : Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => MainloginScreen()),
  //   );
  // }

  void _route()
  {
    Provider.of<SplashProvider>(context, listen: false).getloggedin() ?
    Provider.of<AuthProvider>(context, listen: false).getfullsubmited()=="1" ?
    Provider.of<AuthProvider>(context, listen: false).getacctype() == 'hr' ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HrHomePage()),) : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()),)
        : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelectLanguage(isHome: false)),)
        :loginpage();
  }
  void loginpage()
  {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyLoginScreen()),);
  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: Lottie.asset(
          'assets/lottie/hiring.json',
          controller: _controller,
          height: MediaQuery.of(context).size.height * 1,
          animate: true,
          // onLoaded: (composition) {
          //   _controller
          //     ..duration = composition.duration
          //     ..forward().whenComplete(
          //       () =>
          //       Provider.of<SplashProvider>(context, listen: false).getloggedin()
          //           ? Provider.of<AuthProvider>(context, listen: false).getacctype() == 'hr'
          //           ? Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(builder: (context) => HrHomePage()),
          //       )
          //           : Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(builder: (context) => HomePage()),
          //       )
          //           :  Provider.of<AuthProvider>(context, listen: false).getAccessToken()!= "nn"
          //           ? Provider.of<SplashProvider>(context, listen: false).getacctype()
          //           ? Provider.of<SplashProvider>(context, listen: false).getstep1()
          //           ? Provider.of<SplashProvider>(context, listen: false).getstep2()
          //           ? Provider.of<SplashProvider>(context, listen: false).getstep3()
          //           ? Provider.of<SplashProvider>(context, listen: false).getstep4()
          //           ? Provider.of<SplashProvider>(context, listen: false).getstep5()
          //           ? Provider.of<SplashProvider>(context, listen: false).getjobtypelist() != "none" && Provider.of<SplashProvider>(context, listen: false).getloggedin()
          //           ? Provider.of<AuthProvider>(context, listen: false).getacctype() == "hr"
          //           ? Navigator
          //           .pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 HrHomePage()),
          //       )
          //           : Navigator
          //           .pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder:
          //                 (context) =>
          //                 HomePage()),
          //       )
          //           : Provider.of<AuthProvider>(context, listen: false).getacctype() == "hr"
          //           ? Navigator
          //           .pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 HrHomePage()),
          //       )
          //           : Navigator
          //           .pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 JobTypeSelect()),
          //       )
          //           : Provider.of<AuthProvider>(context, listen: false).getacctype() == "hr"
          //           ? Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 HrHomePage()),
          //       )
          //           : Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 ResumeUpload()),
          //       )
          //           : Provider.of<AuthProvider>(context, listen: false).getacctype() == "hr"
          //           ? Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 HrVerificationScreen()),
          //       )
          //           : Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 ProfileExp()),
          //       )
          //           : Provider.of<AuthProvider>(context, listen: false).getacctype() == "hr"
          //           ? Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 HrSaveProfile(
          //                   path: "",
          //                 )),
          //       )
          //           : Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 SaveProfile(
          //                   path: "",
          //                 )),
          //       )
          //       // acctypevalue=="hr"?Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => HrLoginScreen()),):Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => ProfileExp()),)
          //           :
          //       // acctypevalue=="hr"?Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => HrSaveProfile(path: "",)),): Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => SaveProfile(path: "",)),)
          //       Provider.of<AuthProvider>(context, listen: false).getacctype() == "hr"
          //           ? Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 HrLoginScreen()),
          //       )
          //           : Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 LoginScreen()),
          //       )
          //           : Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => SelectLanguage(
          //               isHome: false,
          //             )),
          //       )
          //       //  Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => LoginScreen()),)
          //           :
          //       //   Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => LoginScreen()),)
          //       Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => SelectOptionScreen()),
          //       )
          //           : Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => MainloginScreen()),
          //       )
          //     );
          // },
        ),
      );
  }
}
