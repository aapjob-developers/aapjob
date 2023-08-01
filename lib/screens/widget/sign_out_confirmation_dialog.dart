import 'package:Aap_job/main.dart';
import 'package:Aap_job/screens/myloginscreen.dart';
import 'package:Aap_job/screens/splashscreen.dart';
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
import 'package:restart_app/restart_app.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class SignOutConfirmationDialog extends StatelessWidget {
  // Future<void> signOut() async {
  //   await Authentification().signOut();
  // }
  //  getsubscribedTopics(String query) async {
  //   final url = Uri.parse(AppConstants.BASE_URL+ AppConstants.JOB_TITLE_URI);
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     final List users = json.decode(response.body);
  //     return users.map((json) => JobTitleModel.fromJson(json)).where((user) {
  //       final nameLower = user.name.toLowerCase();
  //       final queryLower = query.toLowerCase();
  //       return nameLower.contains(queryLower);
  //     }).toList();
  //   } else {
  //     throw Exception();
  //   }
  // }
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
          child: Text('Do You Want to Sign Out', textAlign: TextAlign.center),
        ),

        Divider(height: 0, color: Colors.grey),
        Row(children: [

          Expanded(child: InkWell(
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).clearSharedData().then((condition) {
                FirebaseMessaging.instance.deleteToken();
                Navigator.pop(context);
                Provider.of<AuthProvider>(context,listen: false).clearSharedData();
                sharedp.clear();
                Restart.restartApp();                // signOut();
               // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
              });
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
