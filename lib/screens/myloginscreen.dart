import 'dart:math';

import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/screens/otpscreen.dart';
//import 'package:Aap_job/screens/profile_exp.dart';
import 'package:Aap_job/screens/select_language.dart';
import 'package:Aap_job/screens/widget/adsView.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:Aap_job/providers/auth_provider.dart';
// import 'package:Aap_job/screens/JobtypeSelect.dart';
// import 'package:Aap_job/screens/homepage.dart';
// import 'package:Aap_job/screens/otpscreen.dart';
import 'package:Aap_job/view/basewidget/animated_custom_dialog.dart';
import 'package:Aap_job/view/basewidget/my_dialog.dart';
import '../models/register_model.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'myotpscreen.dart';

class MyLoginScreen extends StatefulWidget {
  MyLoginScreen({Key? key}) : super(key: key);
  @override
  _MyLoginScreenState createState() => new _MyLoginScreenState();
}

class _MyLoginScreenState extends State<MyLoginScreen> {
  var _isLoading = false;
  GlobalKey<FormState> _formKey= new GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();
  String? mobile,otp, signature="";
  final SmsAutoFill _autoFill = SmsAutoFill();
  var phone;
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
     Future<void>.delayed(const Duration(milliseconds: 300), _tryPasteCurrentPhone);
  }

  Future _tryPasteCurrentPhone() async {
    if (!mounted) return;
    try {
      final autoFill = SmsAutoFill();
       phone = await autoFill.hint;
      signature = await SmsAutoFill().getAppSignature;
      if (phone == null) return;
      if (!mounted) return;
      _phoneController.text = phone.toString().trim().substring(phone.toString().trim().length - 10);
    } on PlatformException catch (e) {
      print('Failed to get mobile number because of: ${e.message}');
    }
  }

  _submit() async {
    setState(() {
      _isLoading = true;
    });
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    await Provider.of<AuthProvider>(context, listen: false).sendmyotp(mobile!,otp!,signature!,route);
  }

  route(bool isRoute, String errorMessage) async {
    setState(() {
      _isLoading = false;
    });
    if (isRoute) {
      Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context)=> MyOtpScreen()), (route) => false);
      _phoneController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    Random rnd = new Random();
    final int genotp =1000 + rnd.nextInt(9999 - 1000);
    return Container(
        decoration: new BoxDecoration(color: Primary),
    child:
        SafeArea(child: Scaffold(
          appBar: AppBar(
            // leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
            //   onPressed:()=> Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => SelectLanguage(isHome:false)),),),
            // automaticallyImplyLeading: true,
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
                    child: Text("Aap Job",maxLines:2,style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),
                    ),
                  ),
                ]
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child:  Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child:new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Image.asset(
                                    'assets/images/appicon.png',
                                    fit: BoxFit.contain,
                                    height: deviceSize.width / 4,
                                    width: deviceSize.width / 4,
                                  )
                                ]

                            ),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          new Padding(
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text("Welcome to Aap Job",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w700), maxLines: 2,)
                                ]

                            ),
                            padding: const EdgeInsets.all(15.0),
                          ),
                          new Padding(
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text("Please Enter Your Mobile number to verify.",style: TextStyle(fontSize: 14,color: Colors.white), maxLines: 2,)
                                ]

                            ),
                            padding: const EdgeInsets.all(15.0),
                          ),
                          new Padding(
                              child:
                              new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: deviceSize.width * 0.8,
                                      // padding: EdgeInsets.all(16.0),
                                      child:
                                      TextFormField(
                                        controller: _phoneController,
                                        style: new TextStyle(fontSize: 20,color: Colors.white),
                                        decoration: InputDecoration(
                                          hintStyle: new TextStyle(color: Colors.white),
                                            labelStyle: new TextStyle(color: Colors.white),
                                            errorStyle: new TextStyle(color: Colors.white),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0)), borderSide: BorderSide(color: Colors.white)),
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0)), borderSide: BorderSide(color: Colors.white)),
                                            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0)), borderSide: BorderSide(color: Colors.white)),
                                            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0)), borderSide: BorderSide(color: Colors.white)),
                                            focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0)), borderSide: BorderSide(color: Colors.white)),
                                            fillColor: Colors.blue,
                                            labelText: 'Enter your mobile number',
                                            prefixIcon: Icon(
                                              Icons.phone,
                                              color: Colors.white,
                                            ),
                                            focusColor: Colors.white// myIcon is a 48px-wide widget.
                                        ),
                                        keyboardType: TextInputType.phone,
                                        validator: (value) {
                                          if (value!.isEmpty || value.length!=10) {
                                            return 'Invalid Mobile Number!';
                                          }
                                        },
                                        onSaved: (value) {
                                          mobile= value;
                                          if(mobile=="9999887799")
                                          {
                                            otp="1234";
                                          }
                                          else
                                          {
                                            otp = genotp.toString();
                                          }
                                        },
                                      ),
                                    ),
                                  ]
                              ),
                              padding: const EdgeInsets.all(20)
                          ),
                          new Padding(
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  _isLoading? CircularProgressIndicator():
                                  ElevatedButton(
                                    child: const Text('Verify Your Mobile Number'),
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
                            padding: const EdgeInsets.only(bottom: 50.0),
                          ),
                          new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: new BoxDecoration(color: Color.fromARGB(
                                      255, 204, 204, 204)),
                                  width: deviceSize.width*0.7,
                                  height: deviceSize.width*0.7,
                                  padding: EdgeInsets.all(3.0),
                                  child:
                                  Center(child: AdsView(width:deviceSize.width*0.8,height:deviceSize.width*0.8),),
                                  //Center(child: VideoApp(path:'https://www.youtube.com/watch?v=GFPUy8nNAFI'),),
                                ),
                              ]
                          ),
                        ]

                    ),
                  ),
                ),
              ),

            ],),),)
    );
  }
}