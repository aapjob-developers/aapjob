import 'package:Aap_job/screens/JobPostScreen.dart';
import 'package:Aap_job/utill/authentification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/loginscreen.dart';
import 'package:Aap_job/screens/mainloginScreen.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/utill/dimensions.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JobResetConfirmationDialog extends StatelessWidget {


  void resetfo() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences!.remove("Min exp");
    sharedPreferences!.remove("Max exp");
    sharedPreferences!.remove("Min salary");
    sharedPreferences!.remove("Max salary");
    sharedPreferences!.remove("incentive");
    sharedPreferences!.remove("cab");
    sharedPreferences!.remove("meal");
    sharedPreferences!.remove("insurance");
    sharedPreferences!.remove("PF");
    sharedPreferences!.remove("medical");
    sharedPreferences!.remove("other");
    sharedPreferences!.remove("otherbenefits");
    sharedPreferences!.remove("shift");
    sharedPreferences!.remove("englishlevel");
    sharedPreferences!.remove("address");
    sharedPreferences!.remove("jobdes");
    sharedPreferences!.remove("Experience");
    sharedPreferences!.remove("contract");
    sharedPreferences!.remove("jobcityid");
    sharedPreferences!.remove("JobTitle");
    sharedPreferences!.remove("JobCategory");
    sharedPreferences!.remove("Jobcatid");
    sharedPreferences!.remove("openings");
    sharedPreferences!.remove("jobtype");
    sharedPreferences!.remove("workplace");
    sharedPreferences!.remove("jobcity");
    sharedPreferences!.remove("joblocation");
    sharedPreferences!.remove("Gender");
    sharedPreferences!.remove("education");
    sharedPreferences!.remove("postjobstep1");

  }
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 20),
          child: Text('Do You Really Want to Reset Form? All Data entered will Lost.', textAlign: TextAlign.center),
        ),

        Divider(height: 0, color: Colors.grey),
        Row(children: [

          Expanded(child: InkWell(
            onTap: () {
             resetfo();
             Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobPostScreen()));
            },
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
              child: Text('YES', style: new TextStyle(color: Primary)),
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
