import 'dart:async';

import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/HrPlanSelect.dart';
import 'package:Aap_job/screens/HrVerificationScreen.dart';
import 'package:Aap_job/screens/JobtypeSelect.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/hr_save_profile.dart';
import 'package:Aap_job/screens/hrloginscreen.dart';
import 'package:Aap_job/screens/save_profile.dart';
import 'package:Aap_job/screens/select_language.dart';
import 'package:Aap_job/screens/videoApp.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/view/basewidget/textfield/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../models/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:math';

import 'loginscreen.dart';

class HrOtpScreen extends StatelessWidget {
  // static const routeName = '/otpscreen';


  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed:()=> Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => HrLoginScreen()),),),
        automaticallyImplyLeading: true,
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Primary,
        title:
        new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/appicon.png',
                fit: BoxFit.contain,
                height: 30,
                width: 30,
              ),
              SizedBox(width: 10,),
              Container(
                width: MediaQuery.of(context).size.width*0.6,
                child: Text(getTranslated("CHANGE_MOBILE_NUM", context)!,maxLines:2,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                ),
              ),
            ]
        ),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              decoration: new BoxDecoration(color: Primary),
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    padding:
                    EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                    child: Text(
                      'Enter 4 digit otp that send to',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding:
                    EdgeInsets.symmetric(vertical: 4.0, horizontal: 94.0),
                    child: Text(
                      "+91 "+Provider.of<AuthProvider>(context, listen: false).getMobile(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(bottom: 10.0),
                  //   padding:
                  //   EdgeInsets.symmetric(vertical: 4.0, horizontal: 94.0),
                  //   child: Text(
                  //     "OTP "+Provider.of<AuthProvider>(context, listen: false).getOtp(),
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.normal,
                  //     ),
                  //   ),
                  // ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(mobile: Provider.of<AuthProvider>(context, listen: false).getMobile(),otp: Provider.of<AuthProvider>(context, listen: false).getOtp()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  String mobile, otp;
  AuthCard({
    Key? key,required this.mobile, required this.otp
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with CodeAutoFill{
  TextEditingController _box1Controller = TextEditingController();
  TextEditingController _box2Controller = TextEditingController();
  TextEditingController _box3Controller = TextEditingController();
  TextEditingController _box4Controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  FocusNode _box1Focus = FocusNode();
  FocusNode _box2Focus = FocusNode();
  FocusNode _box3Focus = FocusNode();
  FocusNode _box4Focus = FocusNode();

  String? submitotp;
  Map<String, String> _authData = {
    'mobile': '',
    'otp':'',
  };
  String codeValue = "";

  var _isLoading = false;
  SharedPreferences? sharedPreferences;
  int secondsRemaining = 30;
  bool enableResend = false;
  late Timer timer;
  bool? loggedin, step1, step2;

  @override
  initState() {

    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
    loggedin=Provider.of<AuthProvider>(context, listen: false).checkloggedin();

  }

  @override
  void codeUpdated() {
    print("Update code $code");
    setState(() {
      print("codeUpdated");
    });
  }

  void listenOtp() async {
    // await SmsAutoFill().unregisterListener();
    // listenForCode();
    await SmsAutoFill().listenForCode;
    print("OTP listen Called");
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    timer.cancel();
    print("unregisterListener");
    super.dispose();
  }

  // @override
  // dispose(){
  //   timer.cancel();
  //   super.dispose();
  // }

  Future<void> _resend() async {
    setState((){
      secondsRemaining = 30;
      enableResend = false;
    });
    await Provider.of<AuthProvider>(context, listen: false).sendotp(Provider.of<AuthProvider>(context, listen: false).getMobile(),Provider.of<AuthProvider>(context, listen: false).getOtp(),Provider.of<AuthProvider>(context, listen: false).getSigna(),"hr",noroute);
  }
  noroute(bool isRoute, String errorMessage) async {
  }

  // Future<void> _submit() async {
  //   if (!_formKey.currentState.validate()) {
  //     // Invalid!
  //     return;
  //   }
  //   _formKey.currentState.save();
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   String _box1 = _box1Controller.text.trim();
  //   String _box2 = _box2Controller.text.trim();
  //   String _box3 = _box3Controller.text.trim();
  //   String _box4 = _box4Controller.text.trim();
  //
  //   if (_box1.isEmpty||_box2.isEmpty||_box3.isEmpty||_box4.isEmpty) {
  //     CommonFunctions.showSuccessToast('Please fill all boxes');
  //   }
  //   else
  //     {
  //       String Otp = _box1 + _box2 + _box3 + _box4;
  //       if(Otp==Provider.of<AuthProvider>(context, listen: false).getOtp())
  //         {
  //           await Provider.of<AuthProvider>(context, listen: false).login(Provider.of<AuthProvider>(context, listen: false).getUserid(),Provider.of<AuthProvider>(context, listen: false).getMobile(), route);
  //         }
  //       else
  //         {
  //           CommonFunctions.showSuccessToast('OTP Not Matched');
  //         }
  //     }
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  Future<void> _submit() async {
    if(codeValue==Provider.of<AuthProvider>(context, listen: false).getOtp())
    {
      await Provider.of<AuthProvider>(context, listen: false).hrlogin(Provider.of<AuthProvider>(context, listen: false).getUserid(),Provider.of<AuthProvider>(context, listen: false).getMobile(), route);
    }
    else
    {
      CommonFunctions.showSuccessToast("Otp Not Matched");
    }

    setState(() {
      _isLoading = false;
    });
  }

  route(bool isRoute, String route, String errorMessage) async {
    if (isRoute) {
      // Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => JobTypeSelect()),);
      this.sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences!.setBool("step2", true);
      Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => HrSaveProfile(path: "",)),);
    } else {
      CommonFunctions.showErrorDialog(errorMessage,context);
    }
  }
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      height: 360,
      constraints: BoxConstraints(minHeight: 260),
      width: deviceSize.width * 0.8,
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child:
                Center(
                  child: PinFieldAutoFill(
                    decoration: UnderlineDecoration(
                      textStyle: TextStyle(fontSize: 20, color: Colors.white),
                      colorBuilder: FixedColorBuilder(Colors.white.withOpacity(0.3)),
                    ),
                    currentCode: codeValue,
                    codeLength: 4,
                    onCodeChanged: (code) {
                      print("onCodeChanged $code");
                      setState(() {
                        codeValue = code.toString();
                      });
                      _submit();
                    },
                    onCodeSubmitted: (val) {
                      print("onCodeSubmitted $val");
                    },
                  ),
                ),),
              // Row(
              //   children: [
              //     Expanded(
              //         child: CustomTextField(
              //           hintText: "0",
              //           textInputType: TextInputType.phone,
              //           focusNode: _box1Focus,
              //           nextNode: _box2Focus,
              //           isOtp: true,
              //           maxLine: 1,
              //           capitalization: TextCapitalization.words,
              //           controller: _box1Controller,
              //           textInputAction: TextInputAction.next,
              //         )),
              //     SizedBox(width: 15),
              //     Expanded(
              //         child: CustomTextField(
              //           hintText: "0",
              //           textInputType: TextInputType.phone,
              //           focusNode: _box2Focus,
              //           nextNode: _box3Focus,
              //           isOtp: true,
              //           maxLine: 1,
              //           capitalization: TextCapitalization.words,
              //           controller: _box2Controller,
              //           textInputAction: TextInputAction.next,
              //         )),
              //     SizedBox(width: 15),
              //     Expanded(
              //         child: CustomTextField(
              //           hintText: "0",
              //           textInputType: TextInputType.phone,
              //           focusNode: _box3Focus,
              //           nextNode: _box4Focus,
              //           isOtp: true,
              //           maxLine: 1,
              //           capitalization: TextCapitalization.words,
              //           controller: _box3Controller,
              //           textInputAction: TextInputAction.next,
              //         )),
              //     SizedBox(width: 15),
              //     Expanded(
              //         child: CustomTextField(
              //           hintText: "0",
              //           textInputType: TextInputType.phone,
              //           focusNode: _box4Focus,
              //           isOtp: true,
              //           maxLine: 1,
              //           capitalization: TextCapitalization.words,
              //           controller: _box4Controller,
              //         )),
              //   ])),
              SizedBox(
                height: 20,
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                new Padding(
                  child:
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          child: const Text('Submit'),
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                              minimumSize: new Size(deviceSize.width * 0.5,20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              primary: Colors.amber,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              textStyle:
                              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                        ),
                      ]

                  ),
                  padding: const EdgeInsets.all(5.0),
                ),
              SizedBox(
                height: 20,
              ),
              Text(
                'after $secondsRemaining seconds',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              new Padding(
                child:
                new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: const Text('Resend Code'),
                        onPressed: enableResend ? _resend : null,
                        style: ElevatedButton.styleFrom(
                            minimumSize: new Size(deviceSize.width * 0.5,20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            primary: Colors.grey,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            textStyle:
                            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),

                      ),
                    ]

                ),
                padding: const EdgeInsets.all(5.0),
              ),
            ],
          ),
        ),
      ),
    );
  }


}


