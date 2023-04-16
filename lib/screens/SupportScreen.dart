import 'dart:convert';
import 'dart:io';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/ComplaintReasonModel.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:lottie/lottie.dart';



class SupportScreen extends StatefulWidget {
  SupportScreen({Key? key}) : super(key: key);
  @override
  _SupportScreenState createState() => new _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {

  bool _hasCallSupport = false;
  late Future<void> _launched;
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;
  String dropdownvalue = 'Select A Reason';
  SharedPreferences? sharedPreferences;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _detailController = TextEditingController();

  List<String> items = ['Select A Reason'];
  @override
  void initState() {
    initializePreference().whenComplete(() {

      canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
        setState(() {
          _hasCallSupport = result;
        });
      });
    });
    super.initState();
  }


  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
    await getreasons();
  }

  getreasons() async {
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.COMPLAINT_REASONS_URI+"?type=candidate");
      apidata= response.data;
      print('City List: ${apidata}');
      List<dynamic> data=json.decode(apidata);

      if(data.toString()=="[]")
      {
        items=[];
      }
      else
      {
        data.forEach((city) =>
            items.add(ComplaintReasonModel.fromJson(city).name));
      }
      print('City List: ${items}');

    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }

  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  openwhatsapp(String mobile) async {
    var whatsapp = "+91" + mobile;
    var whatsappURl_android = "whatsapp://send?phone=" + whatsapp +
        "&text=hello";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text(getTranslated('whatsapp_no_installed', context)!+":",maxLines:2)));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text(getTranslated('whatsapp_no_installed', context)!+":")));
      }
    }
  }

  opentelegram(String mobile) async {
    var whatsapp = "+91" + mobile;
    var whatsappURl_android = "https://t.me/"+whatsapp;
    var whatappURL_ios = "https://t.me/$whatsapp";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text(getTranslated('whatsapp_no_installed', context)!+":")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text(getTranslated('whatsapp_no_installed', context)!+":")));
      }
    }
  }

  openchrome() async {
    var whatsappURl_android = "https://aapjob.com/";
    var whatappURL_ios = "https://aapjob.com/";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text(getTranslated('whatsapp_no_installed', context)!+":")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text(getTranslated('whatsapp_no_installed', context)!+":")));
      }
    }
  }
  openmail() async {
    var whatsappURl_android = "mailto:support@aapjob.com";
    var whatappURL_ios = "mailto:support@aapjob.com";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text(getTranslated('whatsapp_no_installed', context)!+":")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text(getTranslated('whatsapp_no_installed', context)!+":")));
      }
    }
  }
  SubmitComplaint(String dropdownvalue,String details) async {
    try {
      FormData formData = new FormData.fromMap({"reason": dropdownvalue, "details":details,"userid":Provider.of<AuthProvider>(context, listen: false).getUserid(),"usertype":"candidate" });
      Response response = await _dio.post(_baseUrl + AppConstants.SUBMIT_COMPLAINT,data: formData);
      String closejob = response.data;
      if(closejob.toString()=="success")
      {
        CommonFunctions.showSuccessToast("Complaint Submitted Successfully. We contact you soon");
        _detailController.clear();
        dropdownvalue='Select A Reason';
      }
      else
      {
        CommonFunctions.showErrorDialog("Error in Updating Job"+closejob, context);
      }
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Primary,
        title: new Text(getTranslated('CCS', context)!),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              width: deviceSize.width,
              height: deviceSize.height,
              decoration: new BoxDecoration(color: Primary),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //  Padding(padding: EdgeInsets.all(20),child:Text("Contact Us",textAlign: TextAlign.center,style: LatinFonts.aBeeZee(fontSize: 20,color: Colors.white),),),
                  Padding(padding: EdgeInsets.all(10),
                    child:
                    Form(
                      key: _formKey,
                      child: Container(
                        width: deviceSize.width-40,
                        padding: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                        decoration: new BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(20))),
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(getTranslated('LOVE_TO_HEAR', context)!,style: LatinFonts.aBeeZee(fontSize: 12, fontWeight: FontWeight.w700),),
                            Container(
                              padding: EdgeInsets.only(left: 10,),
                              decoration: new BoxDecoration(color: Colors.white),
                              width: deviceSize.width * 0.8,
                              child:
                              DropdownButton(
                                focusColor: Colors.white,
                                value: dropdownvalue,
                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),
                                // Array list of items
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child:
                                    //Text(items),
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Lottie.asset(
                                              'assets/lottie/arrowright.json',
                                              height: MediaQuery.of(context).size.width*0.05,
                                              width: MediaQuery.of(context).size.width*0.05,
                                              animate: true,),
                                            SizedBox(width: 3,),
                                            Text(items,style: LatinFonts.aBeeZee(fontSize: 10,fontWeight: FontWeight.bold)),
                                          ]

                                      ),
                                    ),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue = newValue!;
                                  });
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              // margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular((5))),
                                  boxShadow: [
                                    BoxShadow(blurRadius: 4,spreadRadius: 4,color: Colors.indigo)
                                  ]
                              ),
                              child: new TextFormField(
                                decoration: InputDecoration(hintText: "Details"),
                                maxLines: 5,
                                controller: _detailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty||value.length<20) {
                                    return 'Please Enter Details with minimum 20 Characters.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 10,),
                            ElevatedButton(
                              child: const Text('Submit'),
                              onPressed: (){
                                if (_formKey.currentState!.validate()) {
                                  if (dropdownvalue == 'Select A Reason') {
                                    CommonFunctions.showErrorDialog(
                                        "Please Select a reason of submission.", context);
                                  }
                                  else {
                                    SubmitComplaint(dropdownvalue, _detailController.text);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: new Size(deviceSize.width * 0.5,20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  primary: Colors.amber,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  textStyle: LatinFonts.aBeeZee(fontSize: 16, fontWeight: FontWeight.bold)),

                            ),
                            SizedBox(height: 30,),
                            new Text(getTranslated('REACH_US', context)!,style: LatinFonts.aBeeZee(fontSize: 16, fontWeight: FontWeight.w700),),
                            SizedBox(height: 10,),

                            GestureDetector(onTap: _hasCallSupport  ? () => setState(() {      openchrome();        }) : null, child:
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Lottie.asset(
                                    'assets/lottie/website.json',
                                    height: MediaQuery.of(context).size.width*0.15,
                                    width: MediaQuery.of(context).size.width*0.15,
                                    animate: true,),
                                  Text("www.aapjob.com",style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),),
                                  Lottie.asset(
                                    'assets/lottie/arrowright.json',
                                    height: MediaQuery.of(context).size.width*0.08,
                                    width: MediaQuery.of(context).size.width*0.08,
                                    animate: true,),
                                ]

                            ),
                            ),
                            SizedBox(height: 40,),
                            new Text(getTranslated('SUPPORT', context)!,style: LatinFonts.aBeeZee(fontSize: 16, fontWeight: FontWeight.w700),),
                            SizedBox(height: 20,),
                            GestureDetector(onTap: _hasCallSupport  ? () => setState(() {      openmail();        }) : null, child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Lottie.asset(
                                    'assets/lottie/mailicon.json',
                                    height: MediaQuery.of(context).size.width*0.15,
                                    width: MediaQuery.of(context).size.width*0.15,
                                    animate: true,),
                                  Text("support@aapjob.com",style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),),
                                  Lottie.asset(
                                    'assets/lottie/arrowright.json',
                                    height: MediaQuery.of(context).size.width*0.08,
                                    width: MediaQuery.of(context).size.width*0.08,
                                    animate: true,),
                                ]

                            ),
                            ),
                            SizedBox(height: 20,),
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(onTap: _hasCallSupport
                                      ? () => setState(() {
                                    _launched = _makePhoneCall("+916296335173");
                                  })
                                      : null,
                                    child:
                                    Lottie.asset(
                                      'assets/lottie/callicon.json',
                                      height: MediaQuery.of(context).size.width*0.2,
                                      width: MediaQuery.of(context).size.width*0.2,
                                      animate: true,),
                                  ),
                                  GestureDetector(onTap:   _hasCallSupport
                                      ? () => setState(() {
                                    openwhatsapp("6296335173");
                                  })
                                      : null,
                                    child:
                                    Lottie.asset(
                                      'assets/lottie/whatsapp.json',
                                      height: MediaQuery.of(context).size.width*0.2,
                                      width: MediaQuery.of(context).size.width*0.2,
                                      animate: true,),
                                  ),
                                  GestureDetector(onTap:                         _hasCallSupport
                                      ? () => setState(() {
                                    opentelegram("6296335173");
                                  })
                                      : null,child:
                                  Lottie.asset(
                                    'assets/lottie/telegram.json',
                                    height: MediaQuery.of(context).size.width*0.2,
                                    width: MediaQuery.of(context).size.width*0.2,
                                    animate: true,),
                                  ),
                                ]

                            ),
                            SizedBox(height: 20,),
                          ],),
                      ),
                    ),
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
