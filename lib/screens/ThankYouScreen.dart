import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:Aap_job/data/respository/auth_repo.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/HrPlanSelect.dart';
import 'package:Aap_job/screens/HrVerificationScreen.dart';
import 'package:Aap_job/screens/JobtypeSelect.dart';
import 'package:Aap_job/screens/ResumeUpload.dart';
import 'package:Aap_job/screens/hr_save_profile.dart';
import 'package:Aap_job/screens/hrhomepage.dart';
import 'package:Aap_job/screens/hrloginscreen.dart';
import 'package:Aap_job/screens/loginscreen.dart';
import 'package:provider/provider.dart';
import 'package:Aap_job/screens/mainloginScreen.dart';
import 'package:Aap_job/screens/profile_exp.dart';
import 'package:Aap_job/screens/save_profile.dart';
import 'package:Aap_job/screens/selectOptionScreen.dart';
import 'package:Aap_job/screens/select_language.dart';
import 'homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThankYouScreen extends StatefulWidget {
  const ThankYouScreen({Key? key}) : super(key: key);

  @override
  _ThankYouScreenState createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    super.initState();
    initializePreference().whenComplete((){
      setState(() {
        _controller = AnimationController(
          duration: Duration(seconds: (5)),
          vsync: this,
        );
      });
    });
  }

  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Container
            (
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/thankyou.json',
                  controller: _controller,
                  height: MediaQuery.of(context).size.height * 0.8,
                  animate: true,
                  onLoaded: (composition) {
                    _controller!
                      ..duration = composition.duration
                      ..forward().whenComplete(() =>
                          Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => HrHomePage()),),
                      );
                  },
                ),
                Text('Wait...Updating your plan'),
              ],
            ),
          ),

    );
  }
}