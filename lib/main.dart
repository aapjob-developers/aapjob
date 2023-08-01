// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Uncomment the following lines when enabling Firebase Crashlytics
// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

import 'dart:developer';

import 'package:Aap_job/data/chat/ContactsRepository.dart';
import 'package:Aap_job/data/chat/chat_auth_repository.dart';
import 'package:Aap_job/data/chat/chat_repository.dart';
import 'package:Aap_job/data/chat/firebase_storage_repository.dart';
import 'package:Aap_job/localization/app_localization.dart';
import 'package:Aap_job/notification/NotificationServices.dart';
import 'package:Aap_job/providers/HrJobs_provider.dart';
import 'package:Aap_job/providers/Jobs_provider.dart';
import 'package:Aap_job/providers/ads_provider.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/providers/category_provider.dart';
import 'package:Aap_job/providers/cities_provider.dart';
import 'package:Aap_job/providers/config_provider.dart';
import 'package:Aap_job/providers/content_provider.dart';
import 'package:Aap_job/providers/hrplan_provider.dart';
import 'package:Aap_job/providers/jobselect_category_provider.dart';
import 'package:Aap_job/providers/jobtitle_provider.dart';
import 'package:Aap_job/providers/localization_provider.dart';
import 'package:Aap_job/providers/notification_provider.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:Aap_job/providers/splash_provider.dart';
import 'package:Aap_job/screens/CameraScreen.dart';
import 'package:Aap_job/screens/JobAppliedCandidates.dart';
import 'package:Aap_job/screens/NotificationScreen.dart';
import 'package:Aap_job/screens/TermsAccept.dart';
import 'package:Aap_job/screens/getjobdetails.dart';
import 'package:Aap_job/screens/notification/notification_screen.dart';
import 'package:Aap_job/screens/splashscreen.dart';
import 'package:Aap_job/screens/testing.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:files_uploader/files_uploader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:Aap_job/notification/my_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'di_container.dart' as di;
import 'helper/AppleSignInAvailable.dart';
import 'helper/custom_delegate.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
late SharedPreferences sharedp;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedp= await SharedPreferences.getInstance();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  await di.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // final appleSignInAvailable = await AppleSignInAvailable.check();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      color: Colors.white,
      child:
      Center(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            new Image.asset(
              'assets/images/appicon.png',
              fit: BoxFit.contain,
              height: 80,
              width: 80,
            ),
            Text(
              "Please Wait...",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
          ],),
      ),
    );
  };
  runApp(MultiProvider(
    providers: [
       StreamProvider.value(value: FirebaseAuth.instance.authStateChanges(), initialData: FirebaseAuth.instance.currentUser,),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CategoryProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<JobServiceCategoryProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AdsProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<JobsProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<HrPlanProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<JobtitleProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ConfigProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ContentProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<HrJobProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CitiesProvider>()),
      Provider(create: (context) => di.sl<FirebaseStorageRepository>()),
      ChangeNotifierProvider(create: (context) => di.sl<ContactsRepository>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatAuthRepository>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatRepository>()),
      //Provider<AppleSignInAvailable>.value(value: appleSignInAvailable,),
    ],
    child: MyApp(),
  ));
}


class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  static final navigatorKey = new GlobalKey<NavigatorState>();
  bool _isLoading=true;
// This widget is the root of your application.
bool istermsaccepted=sharedp.getBool("IsTermsAccepted")??false;
  @override
  Widget build(BuildContext context) {
    List<Locale> _locals = [];
    AppConstants.languages.forEach((language) {
      _locals.add(Locale(language.languageCode, language.countryCode));
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      locale: Provider.of<LocalizationProvider>(context).locale,
      localizationsDelegates: [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackLocalizationDelegate()
      ],
      supportedLocales: _locals,
      title: 'Aap Job',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      // home:Data==null?SplashScreen(): NotificationScreen(Userid: Provider.of<AuthProvider>(context, listen: false).getUserid()),
//      home:istermsaccepted?Data==null||Data=="blank"?SplashScreen():Provider.of<AuthProvider>(context, listen: false).getacctype()=="candidate"?Data=="no"?NotificationScreen(isBacButtonExist: false,Userid: Provider.of<AuthProvider>(context, listen: false).getUserid()):GetJobDetailSceen(jobid:Data!):Provider.of<AuthProvider>(context, listen: false).getacctype()=="hr"?Data=="no"?NotificationScreen2(isBacButtonExist: false,Userid: Provider.of<AuthProvider>(context, listen: false).getUserid()):JobAppliedCandidates(jobid: Data!):SplashScreen():TermsAccept(),
      home:istermsaccepted?SplashScreen():TermsAccept(),
    );
  }
}


