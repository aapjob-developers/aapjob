import 'dart:convert';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/providers/notification_provider.dart';
import 'package:Aap_job/screens/basewidget/no_internet_screen.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/hrhomepage.dart';
import 'package:Aap_job/screens/notification/widget/notification_dialog.dart';
import 'package:Aap_job/screens/splashscreen.dart';
import 'package:Aap_job/utill/date_converter.dart';
import 'package:Aap_job/utill/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/models/CitiesModel.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class NotificationScreen2 extends StatelessWidget {
  final bool isBacButtonExist;
  final String? Userid;
  NotificationScreen2({this.isBacButtonExist = true, this.Userid});

  @override
  Widget build(BuildContext context) {
    Provider.of<NotificationProvider>(context, listen: false).initNotificationList2(context,Userid!);
    return
      WillPopScope(
        onWillPop: ()async{
          if(Provider.of<AuthProvider>(context, listen: false).getacctype()=="hr")
            Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => SplashScreen()),);
        return false;
          },
        child:
      Scaffold(
      appBar: new AppBar(
        backgroundColor: Primary,
        title: new Text("Notifications"),
      ),
      body: Column(children: [
        // CustomAppBar(title: getTranslated('notification', context), isBackButtonExist: isBacButtonExist),
        Expanded(
          child: Consumer<NotificationProvider>(
            builder: (context, notification, child) {
              return notification.notificationList != null ? notification.notificationList.length != 0 ? RefreshIndicator(
                backgroundColor: Theme.of(context).primaryColor,
                onRefresh: () async {
                  await Provider.of<NotificationProvider>(context, listen: false).initNotificationList2(context,Userid!);
                },
                child: ListView.builder(
                  itemCount: Provider.of<NotificationProvider>(context).notificationList.length,
                  padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => showDialog(context: context, builder: (context) => NotificationDialog(notificationModel: notification.notificationList[index])),
                      child: Container(
                        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(color: Colors.white,boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)],),
                        child: ListTile(
                          leading:
                          notification.notificationList[index].image!=null?
                          ClipOval(child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/appicon.png',
                            image: AppConstants.BASE_URL+notification.notificationList[index].image,
                            height: 50, width: 50, fit: BoxFit.cover,
                          ))
                              :
                          ClipOval(child:Image.asset('assets/images/appicon.png',
                            height: 50, width: 50, fit: BoxFit.cover,
                          ))
                          ,
                          title: Text(notification.notificationList[index].title, style:
                          LatinFonts.aBeeZee(fontSize: Dimensions.FONT_SIZE_SMALL,)),
                          subtitle: Text(
                           // DateFormat('dd/MM/yyyy').format(DateConverter.isoStringToLocalDateo(notification.notificationList[index].createdAt)),
                              notification.notificationList[index].createdAt.split("-").last+"/"+notification.notificationList[index].createdAt.split("-")[1]+"/"+notification.notificationList[index].createdAt.split("-").first,
                            style: LatinFonts.aBeeZee( fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ) : NoInternetOrDataScreen(isNoInternet: false, child: this,) : NotificationShimmer();
            },
          ),
        ),

      ]),
    ),
      );
  }
}

class NotificationShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Container(
          height: 80,
          margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
          color: Colors.grey,
          alignment: Alignment.center,
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: Provider.of<NotificationProvider>(context).notificationList == null,
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.notifications)),
              title: Container(height: 20, color: Colors.white),
              subtitle: Container(height: 10, width: 50, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
