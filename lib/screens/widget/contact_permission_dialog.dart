import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/loginscreen.dart';
import 'package:Aap_job/screens/mainloginScreen.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/utill/dimensions.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class PermissionDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        new Image.asset(
          'assets/images/appicon.png',
          fit: BoxFit.contain,
          height: 50,
          width: 50,
        ),
        Platform.isAndroid ?
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 20),
            child: Text(
                "To connect you with your friends,\n allow Aapjob to access your contacts. \nOpen Settings > Permissions and turn Contacts on.",
                textAlign: TextAlign.center),
          )
        :
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 20),
          child: Text(
              "To connect you with your friends,\n allow Aapjob to access your contacts. \nOpen Settings > Permissions and turn Contacts on.",
              textAlign: TextAlign.center),
        )
        ,

        Divider(height: 0, color: Colors.grey),
        Row(children: [
          Expanded(child: InkWell(
            onTap: ()
        {
        //SystemNavigator.pop();
              openAppSettings();
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
              child: Text('Open Settings', style: new TextStyle(color: Primary)),
            ),
          )),

          Expanded(child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
              child: Text('NO', style: new TextStyle(color: Colors.white)),
            ),
          )),

        ]),
      ]),
    );
  }
}
