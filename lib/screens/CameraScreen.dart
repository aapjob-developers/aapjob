// import 'dart:math';
// import 'package:Aap_job/providers/auth_provider.dart';
// //import 'package:Aap_job/screens/EditProfileVideo.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// //import 'package:Aap_job/screens/VideoView.dart';
// //import 'package:Aap_job/screens/hr_save_profile.dart';
// //import 'package:Aap_job/screens/save_profile.dart';
// import 'package:provider/provider.dart';
//
// late List<CameraDescription> cameras;
//
// class CameraScreen extends StatefulWidget {
//   String? pt;
//   CameraScreen({Key? key, this.pt}) : super(key: key);
//
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }
//
// class _CameraScreenState extends State<CameraScreen> {
//   CameraController? _cameraController;
//   Future<void>? cameraValue;
//   bool isRecoring = false;
//   bool flash = false;
//   bool iscamerafront = true;
//   double transform = 0;
//   Stopwatch? _stopwatch;
//   bool loggedin=false;
//
//   @override
//   void initState() {
//     super.initState();
//     _cameraController = CameraController(cameras[0], ResolutionPreset.low);
//     cameraValue = _cameraController!.initialize();
//     _stopwatch = Stopwatch();
//   }
//
//   void handleStartStop() {
//     if (_stopwatch!.isRunning) {
//       _stopwatch!.stop();
//     } else {
//       _stopwatch!.start();
//       // _stopwatch.reset();
//     }
//     setState(() {});    // re-render the page
//   }
//
//   void timerReset() {
//     if (_stopwatch!.isRunning) {
//       setState(() {
//         _stopwatch!.reset();
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _cameraController!.dispose();
//   }
//
//   Widget formatTime(int milisecond)
//   {
//     String twoDigits(int n) => n.toString().padLeft(2,'0');
//     int seconds=(milisecond/1000).floor();
//     final hours =twoDigits(Duration(seconds: seconds).inHours);
//     final minutes =twoDigits(Duration(seconds: seconds).inMinutes.remainder(60));
//     final secondss =twoDigits(Duration(seconds: seconds).inSeconds.remainder(60));
//     return Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           buildTimeCard(time: hours, header:'HOURS'),
//           SizedBox(width: 8,),
//           buildTimeCard(time: minutes, header:'MINUTES'),
//           SizedBox(width: 8,),
//           buildTimeCard(time: secondss, header:'SECONDS'),
//         ]
//     );
//    // return '${(Duration(seconds: secondss))}'.split('.')[0].padLeft(8, '0');
//   }
//
//   Widget buildTimeCard({ String? time,String? header}) =>
//       Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: EdgeInsets.all(1),
//             child: Text(time!, style: TextStyle(fontWeight: FontWeight.bold,
//                 color: Colors.white,fontSize: 12),),
//           ),
//         ],
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     loggedin=Provider.of<AuthProvider>(context, listen: false).checkloggedin();
//     return Scaffold(
//       body: Stack(
//         children: [
//           FutureBuilder(
//               future: cameraValue,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.height,
//                       child: CameraPreview(_cameraController!));
//                 } else {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               }),
//           Positioned(
//             bottom: 0.0,
//             child: Container(
//               color: Colors.black,
//               padding: EdgeInsets.only(top: 5, bottom: 5),
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 children: [
//                   // Row(
//                   //   mainAxisSize: MainAxisSize.max,
//                   //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   //   children: [
//                   //     IconButton(
//                   //         icon: Icon(
//                   //           Icons.access_time_filled,
//                   //           color: Colors.white,
//                   //           size: 28,
//                   //         ),
//                   //         onPressed: () {
//                   //         }),
//                   //     Container( child: Text(formatTime(_stopwatch.elapsedMilliseconds), style: TextStyle(fontSize: 14.0,color: Colors.white))),
//                   //     Container()
//                   //   ],
//                   // ),
//                   formatTime(_stopwatch!.elapsedMilliseconds),
//                   Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       IconButton(
//                           icon: Icon(
//                             flash ? Icons.flash_on : Icons.flash_off,
//                             color: Colors.white,
//                             size: 28,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               flash = !flash;
//                             });
//                             flash
//                                 ? _cameraController!
//                                     .setFlashMode(FlashMode.torch)
//                                 : _cameraController!.setFlashMode(FlashMode.off);
//                           }),
//                       GestureDetector(
//                         onTap: () async {
//                           if(isRecoring)
//                             {
//                               timerReset();
//                               XFile videopath =
//                               await _cameraController!.stopVideoRecording();
//                               setState(() {
//                                 isRecoring = false;
//                               });
//                               if(widget.pt=="hr")
//                                 {
//                                   if(loggedin)
//                                     {
//                                       // Navigator.pushReplacement(
//                                       //     context,
//                                       //     MaterialPageRoute(
//                                       //         builder: (builder) =>
//                                       //             EditProfileVideo(
//                                       //               path: videopath.path,
//                                       //               usertype: widget.pt,
//                                       //             )));
//                                     }
//                                   else {
//                                     // Navigator.pushReplacement(
//                                     //     context,
//                                     //     MaterialPageRoute(
//                                     //         builder: (builder) =>
//                                     //             HrSaveProfile(
//                                     //               path: videopath.path,
//                                     //             )));
//                                   }
//                                 }
//                               else
//                                 {
//                                 if(loggedin)
//                                 {
//                                 // Navigator.pushReplacement(
//                                 // context,
//                                 // MaterialPageRoute(
//                                 // builder: (builder) =>
//                                 // EditProfileVideo(
//                                 // path: videopath.path,
//                                 // usertype: widget.pt,
//                                 // )));
//                                 }
//                                 else {
//                                   // Navigator.pushReplacement(
//                                   //     context,
//                                   //     MaterialPageRoute(
//                                   //         builder: (builder) =>
//                                   //             SaveProfile(
//                                   //               path: videopath.path,
//                                   //             )));
//                                 }
//                                 }
//                             }
//                           else
//                             {
//                               await _cameraController!.startVideoRecording();
//                               setState(() {
//                                 isRecoring = true;
//                                 handleStartStop();
//                               });
//                             }
//
//                         },
//                         child: isRecoring
//                             ? Icon(
//                                 Icons.radio_button_on,
//                                 color: Colors.red,
//                                 size: 80,
//                               )
//                             : Icon(
//                                 Icons.panorama_fish_eye,
//                                 color: Colors.white,
//                                 size: 70,
//                               ),
//                       ),
//                       IconButton(
//                           icon: Transform.rotate(
//                             angle: transform,
//                             child: Icon(
//                               Icons.flip_camera_ios,
//                               color: Colors.white,
//                               size: 28,
//                             ),
//                           ),
//                           onPressed: () async {
//                             setState(() {
//                               iscamerafront = !iscamerafront;
//                               transform = transform + pi;
//                             });
//                             int cameraPos = iscamerafront ? 0 : 1;
//                             _cameraController = CameraController(
//                                 cameras[cameraPos], ResolutionPreset.low);
//                             cameraValue = _cameraController!.initialize();
//                           }),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Text(
//                     "record Video",
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                     textAlign: TextAlign.center,
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// }
