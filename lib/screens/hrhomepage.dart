import 'dart:io';

import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/providers/config_provider.dart';
import 'package:Aap_job/providers/content_provider.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/screens/HrDashboardController.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:flutter/services.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'homePageController.dart';
import 'package:get/get.dart';

class HrHomePage extends StatelessWidget {
  final HrDashboardController dashboard = Get.put(HrDashboardController());
  @override
  Widget build(BuildContext context) {
    dashboard.version.value=Provider.of<ConfigProvider>(context, listen: false).packversion!.substring(0,2).toString()!=Provider.of<ConfigProvider>(context, listen: false).getAppVersion();
    return
      Stack(
        children: [
          Scaffold(
          bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: dashboard.selectedIndex,
            // onTap: (index) => {index==3 ? Navigator.of(context).push(MaterialPageRoute(builder: (context) => OfferScreen())) : index==2 ? Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventScreen())) : dashboard.selectedIndex = index, },
            onTap: (index)=> {dashboard.selectedIndex = index,},
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Primary,
            selectedItemColor: Colors.amber,
            selectedLabelStyle:
            new TextStyle(fontWeight: FontWeight.w500),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label:"Dashboard"
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Account",
              ),
            ],
          )),
          body: Obx(
                () => dashboard.widgetList.elementAt(dashboard.selectedIndex),
          ),
    ),
          Platform.isIOS ?Container(): Obx(() => Visibility(
              child:
              Stack(
              children: [
              Container(
              width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black.withOpacity(0.8),
          child:
              Stack(children:[
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){
                          dashboard.show.value=!dashboard.show.value;
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      CachedNetworkImage(
                        imageUrl: AppConstants.BASE_URL+Provider.of<ContentProvider>(context, listen: false).contentList[5].imgSrc!,
                        width: MediaQuery.of(context).size.width*0.5,
                        // height: MediaQuery.of(context).size.width*0.5,
                        placeholder: (context, url) => Image.asset('assets/images/no_data.png'),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )
                    ],
                  ),
                )
              ]),
          
              ),
              ]
              ),
              visible:dashboard.show.value,
            ),
          ),
          Obx(() => Visibility(
            child:
            Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black.withOpacity(0.8),
                    child:
                    Stack(children:[
                      Align(alignment: AlignmentDirectional.bottomCenter,
                        child:
                        Container(width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.5,
                          decoration: new BoxDecoration(
                              color:Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight:Radius.circular(25))),
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 1,
                                child: Column(
                                  children: [
                                    Lottie.asset(
                                      'assets/lottie/welcome.json',
                                      height:200,
                                      animate: true,
                                    ),
                                  ],
                                ),
                              ),
                              Text(getTranslated("NEW_UPDATE_AVAILABLE", context)!,style: LatinFonts.aBeeZee(color: Primary,fontSize: 16,fontWeight: FontWeight.bold),),
                              Text(getTranslated("NEW_UPDATE_MSG", context)!,style: LatinFonts.aBeeZee(color: Primary,fontSize: 12),),
                              Container(
                                padding: EdgeInsets.all(3.0),
                                child:
                                new Padding(
                                  child:
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        ElevatedButton(
                                          child: const Text(' Update Now '),
                                          onPressed: () {
                                            // https://play.google.com/store/apps/details?id=com.unick.aapjob
                                            if (Platform.isAndroid || Platform.isIOS) {
                                              final appId = Platform.isAndroid ? 'com.unick.aapjob' : '567567';
                                              final url = Uri.parse(
                                                Platform.isAndroid
                                                    ? "market://details?id=$appId"
                                                    : "https://apps.apple.com/app/id$appId",
                                              );
                                              launchUrl(
                                                url,
                                                mode: LaunchMode.externalApplication,
                                              );
                                              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(16)),
                                              primary: Colors.amber,
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              textStyle:
                                              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        ),

                                      ]

                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                ),
                              ),
                            ],
                          ),
                        )
                        ,
                      )
                    ]),

                  ),
                ]
            ),
            visible:dashboard.version.value,
          ),)
        ],
      );
  }
}

