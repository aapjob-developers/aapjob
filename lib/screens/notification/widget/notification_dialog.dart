import 'package:Aap_job/models/notification_model.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/JobAppliedCandidates.dart';
import 'package:Aap_job/screens/getjobdetails.dart';
import 'package:Aap_job/screens/splashscreen.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:provider/provider.dart';

class NotificationDialog extends StatelessWidget {
  final NotificationModel notificationModel;
  NotificationDialog({required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

    InkWell(
        onTap:() {
          Navigator.of(context).pop();
    if(Provider.of<AuthProvider>(context, listen: false).getacctype()=="candidate")
      {
        if(notificationModel.jobid=="0")
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
        else
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => GetJobDetailSceen(jobid: notificationModel.jobid)), (route) => false);
      } 
      else 
      {
        if(notificationModel.jobid=="0")
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
        else 
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => JobAppliedCandidates(jobid: notificationModel.jobid)), (route) => false);
      }
    },
    child:Column(
    mainAxisSize: MainAxisSize.min,
    children: [
                    Container(
                      height: MediaQuery.of(context).size.width-130, width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor.withOpacity(0.20)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/appicon.png',
                          image:notificationModel.image!=""? AppConstants.BASE_URL+notificationModel.image:AppConstants.BASE_URL+"uploads/users/1.png",
                          height: MediaQuery.of(context).size.width-130, width: MediaQuery.of(context).size.width, fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                      child: Text(
                        notificationModel.title,
                        textAlign: TextAlign.center,
                        style: LatinFonts.aBeeZee(color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_LARGE,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: Text(
                        notificationModel.description,
                        textAlign: TextAlign.center,
                        style: LatinFonts.aBeeZee(),
                      ),
                    ),
])),
        ],
      ),
    );
  }
}
