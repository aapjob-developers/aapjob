// import 'dart:developer';
// import 'dart:io';
//
// //import 'package:Aap_job/screens/JobHomeScreen.dart';
// import 'package:Aap_job/screens/notification/notification_screen.dart';
// import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:Aap_job/main.dart';
// import 'package:Aap_job/utill/app_constants.dart';
// import 'package:path_provider/path_provider.dart';
//
// class MyNotification {
//
//   static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     var androidInitialize = new AndroidInitializationSettings('notification_icon');
//     var iOSInitialize = new DarwinInitializationSettings();
//     var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
//     flutterLocalNotificationsPlugin.initialize(initializationsSettings,
//         onDidReceiveNotificationResponse: (response) async {
//       try{
//         if(response != null && response.payload!.isNotEmpty) {
//            print(response.payload.toString());
//         }
//       }catch (e) {
//       }
//       return;
//     },
//     onDidReceiveBackgroundNotificationResponse:
//         (response) async {
//       try{
//         if(response != null && response.payload!.isNotEmpty) {
//
//         }
//       }catch (e) {
//       }
//       return;
//     }
//     );
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("onMessage: ${message.data}");
//       print("onMessageid: ${message.data['id']}");
//       MyNotification.showNotification(message.data, flutterLocalNotificationsPlugin);
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("onMessageApp: ${message.data}");
//       MyNotification.showNotification(message.data, flutterLocalNotificationsPlugin);
//     });
//     print("onMessageInitiliaze: ");
//   }
//
//   static Future<void> showNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
//      if(message['image'] != null && message['image'].isNotEmpty) {
//       try{
//         await showBigPictureNotificationHiddenLargeIcon(message, fln);
//         print("onMessagebigpic: ");
//       }catch(e) {
//         await showBigTextNotification(message, fln);
//         print("onMessagetext: ");
//       }
//      }else {
//        await showBigTextNotification(message, fln);
//      }
//   }
//
//   static Future<void> showTextNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
//     final id = DateTime
//         .now()
//         .millisecondsSinceEpoch ~/ 1000;
//     String _title = message['title'];
//     String _body = message['body'];
//     String _orderID = message['jobid'];
//     const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'high_importance_channel', 'your channel name', sound: RawResourceAndroidNotificationSound('notification'),
//       importance: Importance.max, priority: Priority.high,
//     );
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(id, _title, _body, platformChannelSpecifics, payload: message['jobid']);
//    // await fln.show(0, _title, _body, platformChannelSpecifics);
//   }
//
//   static Future<void> showBigTextNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
//     final id = DateTime
//         .now()
//         .millisecondsSinceEpoch ~/ 1000;
//     String _title = message['title'];
//     String _body = message['body'];
//   //  String _orderID = message['order_id'];
//     BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
//       _body, htmlFormatBigText: true,
//       contentTitle: _title, htmlFormatContentTitle: true,
//     );
//     AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'high_importance_channel', 'big text channel name', importance: Importance.max,
//       styleInformation: bigTextStyleInformation, priority: Priority.high, sound: RawResourceAndroidNotificationSound('notification'),
//     );
//     NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(id, _title, _body, platformChannelSpecifics, payload: message['jobid']);
//     //await fln.show(0, _title, _body, platformChannelSpecifics);
//   }
//
//   static Future<void> showBigPictureNotificationHiddenLargeIcon(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
//     final id = DateTime
//         .now()
//         .millisecondsSinceEpoch ~/ 1000;
//     String _title = message['title'];
//     String _body = message['body'];
//    // String _orderID = message['order_id'];
// //    String _image = message['image'].startsWith('https') ? message['image']
// //        : AppConstants.BASE_URL+message['image'];
//     String _image = message['image'];
//     print("trt:"+_image);
//     final String largeIconPath = await _downloadAndSaveFile(_image, 'largeIcon');
//     final String bigPicturePath = await _downloadAndSaveFile(_image, 'bigPicture');
//     final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
//       FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
//       contentTitle: _title, htmlFormatContentTitle: true,
//       summaryText: _body, htmlFormatSummaryText: true,
//     );
//     final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'high_importance_channel', 'big text channel name',
//       largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.high, sound: RawResourceAndroidNotificationSound('notification'),
//       styleInformation: bigPictureStyleInformation, importance: Importance.max,
//     );
//     final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(id, _title, _body, platformChannelSpecifics, payload: message['jobid']);
//    // await fln.show(0, _title, _body, platformChannelSpecifics);
//   }
//
//   static Future<String> _downloadAndSaveFile(String url, String fileName) async {
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final String filePath = '${directory.path}/$fileName';
//     print("path:"+filePath);
//     final Response response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
//     final File file = File(filePath);
//     await file.writeAsBytes(response.data);
//     return filePath;
//   }
//
// }
//
// @pragma('vm:entry-point')
// Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
//   print('background: ${message.data}');
//   var androidInitialize = new AndroidInitializationSettings('notification_icon');
//   var iOSInitialize = new DarwinInitializationSettings();
//   var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
//   flutterLocalNotificationsPlugin.initialize(initializationsSettings,);
//   log("i am called in notification");
//   MyNotification.showNotification(message.notification!.title,message.notification.body,message.data, flutterLocalNotificationsPlugin);
// }