
import 'package:flutter/material.dart';
import 'package:Aap_job/providers/ads_provider.dart';
import 'package:provider/provider.dart';
import 'package:Aap_job/screens/basewidget/NetworkPlayerWidget.dart';
import 'package:Aap_job/screens/basewidget/VideoPlayerScreen.dart';
import 'package:Aap_job/screens/widget/VideoPlayerWidget.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:video_player/video_player.dart';

class AdsView extends StatefulWidget {
  double width;
  double height;
  AdsView({Key? key,required this.width,required this.height}) : super(key: key);
  @override
  _AdsViewState createState() => new _AdsViewState();
}
class _AdsViewState extends State<AdsView> {

  initState() {
    initializePreference().whenComplete((){
    });
    super.initState();

  }

  Future<void> initializePreference() async{
   await Provider.of<AdsProvider>(context, listen: false).getAds(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdsProvider>(
      builder: (context, adsProvider, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          child:
          adsProvider.adsModel != null
              ?
          adsProvider.adsModel?.adType=='Image'
              ?
                FadeInImage.assetNetwork(
                  placeholder: 'assets/images/appicon.png',
                  image: '${AppConstants.BASE_URL}''${adsProvider.adsModel?.imgSrc}',
                  fit: BoxFit.cover,
                )
              :
                  adsProvider.adsModel?.videoType=='Upload a Video'
                        ?
                        VideoPlayerScreen(isLocal:false,width:widget.width-10,height:widget.height-10,urlLandscapeVideo: '${AppConstants.BASE_URL}''${adsProvider.adsModel?.internalVideoSrc}',)
                        :
                          VideoPlayerScreen(isLocal:false,width:widget.width-10,height:widget.height-10,urlLandscapeVideo: '${adsProvider.adsModel?.externalVideoSrc}',)

            :
          Center(child: Text('No Ads available')),
        );
      },
    );
  }


// _launchUrl(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

}




