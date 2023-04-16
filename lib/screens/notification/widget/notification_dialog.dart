import 'package:Aap_job/models/notification_model.dart';
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

          Container(
            height: MediaQuery.of(context).size.width-130, width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor.withOpacity(0.20)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/appicon.png',
                image: AppConstants.BASE_URL+notificationModel.image,
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

        ],
      ),
    );
  }
}
