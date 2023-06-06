import 'dart:convert';
import 'dart:io';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/screens/NotificationScreen.dart';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:Aap_job/screens/JobHomeScreen.dart';
import 'package:Aap_job/screens/notification/notification_screen.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:Aap_job/main.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../firebase_options.dart';
import '../providers/auth_provider.dart';
import '../screens/JobAppliedCandidates.dart';
import '../screens/getjobdetails.dart';

class NotificationServices {

  FirebaseMessaging messaging =FirebaseMessaging.instance;
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
       alert: true,
       announcement: true,
       badge: true,
       carPlay: true,
       criticalAlert: true,
       provisional: true,
       sound: true,
     );
     if(settings.authorizationStatus==AuthorizationStatus.authorized)
     {
       //print("Notification is allowed");
        }
     else if(settings.authorizationStatus==AuthorizationStatus.notDetermined)
     {
      // print("Notification is not detemined");
     } else if(settings.authorizationStatus==AuthorizationStatus.provisional)
     {
       //print("Notification is not detemined");
     } else if(settings.authorizationStatus==AuthorizationStatus.denied)
     {
       // print("Notification is not allowed");
       // CommonFunctions.showSuccessToast("Please Allow notification to show");
       // AppSettings.openNotificationSettings();
     }
  }
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();

  void initLocalNotifications(BuildContext context, RemoteMessage message){
    var androidInitialize = const AndroidInitializationSettings('@drawable/notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    _flutterLocalNotificationsPlugin.initialize(initializationsSettings,
      onDidReceiveNotificationResponse: (response) async {
          if(response != null && response.payload!.isNotEmpty) {
          //  print(response.payload.toString());
            handleMessage(context, message);
          }
      },
     // onDidReceiveBackgroundNotificationResponse:
      //     (response) async {
      //   try{
      //     if(response != null && response.payload!.isNotEmpty) {
      //       print(response.payload.toString());
      //       handleMessage(context, message);
      //     }
      //   }catch (e) {
      //   }
      //   return;
      // },
    );
  }

  void handleMessage(BuildContext context, RemoteMessage message)
  {
    if(message.data['jobid']=='no')
    {
      if (Provider.of<AuthProvider>(context, listen: false).getacctype() ==
          "candidate") {
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NotificationScreen(isBacButtonExist: false,Userid: Provider.of<AuthProvider>(context, listen: false).getUserid())),);
      }
      else
        {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NotificationScreen2(isBacButtonExist: false,Userid: Provider.of<AuthProvider>(context, listen: false).getUserid())),);
        }
    }
    else
      {
        if (Provider.of<AuthProvider>(context, listen: false).getacctype() ==
            "candidate") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GetJobDetailSceen(jobid:message.data['jobid'])),);
        }
        else
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobAppliedCandidates(jobid: message.data['jobid'])),);
        }
      }
  }
  Future<void> setupInteractMessage(BuildContext context) async
  {
    final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(remoteMessage!=null)
      {
       // print("jobid terminate is :${remoteMessage.data['jobid'].toString()}");
        handleMessage(context, remoteMessage);
      }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
        if(event!=null)
      {
       // print("jobid background is :${event.data['jobid'].toString()}");
        handleMessage(context, event);
      }
    });
  }
  void firebaseInit(BuildContext context)
  {
    if(Provider.of<AuthProvider>(context, listen: false).getAccessToken()== "nn"||Provider.of<AuthProvider>(context, listen: false).getAccessToken()=="")
    FirebaseMessaging.instance.getToken().then((token) {
      sharedp.setString("AccessToken",token!);
    });
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    FirebaseMessaging.onMessage.listen((event) {
      if(Platform.isAndroid)
        {
          initLocalNotifications(context,event);
          showNotification(event);
        }
    else
      {
        showNotification(event);
      }
    });
  }

   static Future<void> showNotification(RemoteMessage message) async {

    if(message.data['image'] != null && message.data['image'].isNotEmpty) {
      try{
        await showBigPictureNotificationHiddenLargeIcon(message);
      //  print("onMessagebigpic: ");
      }catch(e) {
        await showBigTextNotification(message);
      //  print("onMessagetext: ");
      }
    }else {
      await showBigTextNotification(message);
    }
  }

  static Future<void> showBigTextNotification(RemoteMessage message) async {
    final id = DateTime
        .now()
        .millisecondsSinceEpoch ~/ 1000;
    String _title = message.data['title'];
    String _body = message.data['body'];
    // String _title = message.notification!.title.toString();
    // String _body = message.notification!.body.toString();
    //  String _orderID = message['order_id'];
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      _body, htmlFormatBigText: true,
      contentTitle: _title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel', 'big text channel name', importance: Importance.max,
      styleInformation: bigTextStyleInformation, priority: Priority.high, sound: RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    Future.delayed(Duration.zero,(){
      _flutterLocalNotificationsPlugin.show(0, _title, _body, platformChannelSpecifics, payload: message.data['jobid']);
    });    //await fln.show(0, _title, _body, platformChannelSpecifics);
  }

 static Future<void> showBigPictureNotificationHiddenLargeIcon(RemoteMessage message) async {
    final id = DateTime
        .now()
        .millisecondsSinceEpoch ~/ 1000;
    String _title = message.data['title'];
    String _body = message.data['body'];
    // String _title = message.notification!.title.toString();
    // String _body = message.notification!.body.toString();
    // String _orderID = message['order_id'];
//    String _image = message['image'].startsWith('https') ? message['image']
//        : AppConstants.BASE_URL+message['image'];
    String _image = message.data['image'];
   // print("trt:"+_image);
    final String largeIconPath = await _downloadAndSaveFile(_image, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(_image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
      contentTitle: _title, htmlFormatContentTitle: true,
      summaryText: _body, htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel', 'big text channel name',
      largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.high, sound: RawResourceAndroidNotificationSound('notification'),
      styleInformation: bigPictureStyleInformation, importance: Importance.max,
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    Future.delayed(Duration.zero,(){
      _flutterLocalNotificationsPlugin.show(0, _title, _body, platformChannelSpecifics, payload: message.data['jobid']);
    });    // await fln.show(0, _title, _body, platformChannelSpecifics);
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
   // print("path:"+filePath);
    final Response response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    final File file = File(filePath);
    await file.writeAsBytes(response.data);
    return filePath;
  }

}

@pragma('vm:entry-point')
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //print("my o my :${message.notification!.android!.imageUrl.toString()}");
}
