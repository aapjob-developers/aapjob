import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoApp extends StatefulWidget {
  VideoApp({Key? key, required this.path}) : super(key: key);
  final String path;
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller=VideoPlayerController as VideoPlayerController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.path)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        setState(() {
          //_controller.setLooping(true);
         _controller.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return  Scaffold(
        body:
        Container(
          decoration: new BoxDecoration(color: Color.fromARGB(
              255, 204, 204, 204)),
          width: deviceSize.width*0.8,
          height: deviceSize.width*0.8,
          padding: EdgeInsets.all(3.0),
          child:
          Center(child: _controller.value.isInitialized
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
                : Container(),
          ),
        ),
      )    ;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}