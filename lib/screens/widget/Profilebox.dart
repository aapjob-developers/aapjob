import 'dart:io';
import 'package:flutter/material.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/utill/dimensions.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';


class Profilebox extends StatefulWidget {
  Profilebox({Key? key, required this.path}) : super(key: key);
  final String path;
  @override
  _ProfileboxState createState() => new _ProfileboxState();
}
class _ProfileboxState extends State<Profilebox> {
  VideoPlayerController? _controller;
  int _value = 0;
  @override
  void initState() {
    super.initState();
    if(widget.path!="") {
      _controller = VideoPlayerController.file(File(widget.path))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }
    else
    {

    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return  Container(
      // padding: EdgeInsets.all(5.0),
      width: deviceSize.width*0.41,
      child: Stack(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(5),
              width: (deviceSize.width*0.5),
              height:(deviceSize.width*0.5),
              child: _controller!.value.isInitialized
                  ?
              Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              )
                  : Container(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                setState(() {
                  _controller!.value.isPlaying
                      ? _controller!.pause()
                      : _controller!.play();
                });
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black38,
                child: Icon(
                  _controller!.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),);
  }

}