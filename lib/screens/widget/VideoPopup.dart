// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../utill/app_constants.dart';
import '../basewidget/VideoPlayerScreen.dart';

class VideoPopup {
  final String title;


  VideoPopup({
    required this.title,
  });

  show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _PopupCall(
            title: title
        );
      },
    );
  }
}

class _PopupCall extends StatefulWidget {
  final String title;

  const _PopupCall(
      {Key? key,
        required this.title})
      : super(key: key);
  @override
  _PopupCallState createState() => _PopupCallState();
}

class _PopupCallState extends State<_PopupCall> {
 // VideoPlayerController controller=VideoPlayerController;
  late VideoPlayerController controller;
  @override
  void initState() {
    print("url->"+widget.title);
    controller = VideoPlayerController.network(AppConstants.BASE_URL+widget.title);
    controller.initialize().then((value) {
      controller.play();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    // ignore: avoid_print
    print('Dispose used');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      backgroundColor: Colors.black87,
      titlePadding: EdgeInsets.all(0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.red,
                size: 25,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
              child: controller.value.isInitialized
                  ? AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller))
                  : const CircularProgressIndicator()),
          // VideoPlayerScreen(isLocal:false,width:MediaQuery.of(context).size.width*0.9,height:MediaQuery.of(context).size.width*0.9,urlLandscapeVideo: AppConstants.BASE_URL+widget.title,)
        ],
      ),
    );
  }
}