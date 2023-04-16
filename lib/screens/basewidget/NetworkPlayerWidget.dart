import 'package:flutter/material.dart';
import 'package:Aap_job/screens/widget/VideoPlayerWidget.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:video_player/video_player.dart';

class NetworkPlayerWidget extends StatefulWidget {
  final String urlLandscapeVideo;
  NetworkPlayerWidget({ Key? key, required this.urlLandscapeVideo}) : super(key: key);
  @override
  _NetworkPlayerWidgetState createState() => _NetworkPlayerWidgetState();
}

class _NetworkPlayerWidgetState extends State<NetworkPlayerWidget> {

  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    print("init"+widget.urlLandscapeVideo);
    controller = VideoPlayerController.network(widget.urlLandscapeVideo)
      ..addListener(() => setState(() {}))
      ..setLooping(false)
      ..initialize().then((_) => controller.play());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("weq:"+widget.urlLandscapeVideo);
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.7,
      height: MediaQuery
          .of(context)
          .size
          .width * 0.7,
      alignment: Alignment.center,
      child: Column(
        children: [
          VideoPlayerWidget(controller: controller),
        ],
      ),
    );
  }

}