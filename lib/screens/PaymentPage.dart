
import 'dart:convert';

import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/CurrentPlanModel.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/ThankYouScreen.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:provider/provider.dart';
import '../utill/dimensions.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPageScreen extends StatefulWidget {
  PaymentPageScreen({Key? key,required this.PacakgeName,required this.amount,required this.packagetype,required this.pacakgeid}) : super(key: key);
  String PacakgeName,amount,packagetype,pacakgeid;
  @override
  _PaymentPageScreenState createState() => new _PaymentPageScreenState();
}

class _PaymentPageScreenState extends State<PaymentPageScreen> {
  Razorpay? _razorpay;
  SharedPreferences? sharedPreferences;
  String apiresponse="",HrCompany="",HrWebsite="",HrName="",phone="", emaile="";
  int userid=0;
  bool is_loading=false;

  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;

  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    initializePreference().whenComplete(() {
      setState(() {

        HrCompany= sharedPreferences!.getString("HrCompanyName")?? "no Job Title";
        HrWebsite= sharedPreferences!.getString("HrWebsite")?? "no Job Title";
        HrName=sharedPreferences!.getString("HrName")?? "no Job Title";
        phone=sharedPreferences!.getString("phone")?? "no Job Title";
        emaile=sharedPreferences!.getString("email")?? "no Job Title";
      });
    });
    super.initState();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay!.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_DQUcKXTzzogT3n',
     'amount': int.parse(widget.amount)*100,
      'name': HrName,
      'description': widget.PacakgeName+' Payment',
      'prefill': {'contact': phone, 'email': emaile},
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint(e as String?);
    }
  }
  // response.paymentId

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "Payment done Successfully.", timeInSecForIosWeb: 4);
    setState(() {
      is_loading=true;
    });
    updateplan(Provider.of<AuthProvider>(context, listen: false).getUserid(),widget.pacakgeid,widget.packagetype,response.paymentId!);
  }


  void _handlePaymentError(PaymentFailureResponse response) {
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message,
    //     timeInSecForIosWeb: 4);
    Fluttertoast.showToast(
        msg: "ERROR in payment processing, Please Try again later ",
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET:  ${response.walletName}", timeInSecForIosWeb: 4);
  }

  updateplan(String userid, String planid, String packageType,String PaymentCode) async {
    try {
      FormData formData = new FormData.fromMap({"userid": userid, "planid":planid,"packagetype":packageType,"PaymentCode":PaymentCode,"Amount":widget.amount});
      Response response = await _dio.post(_baseUrl + AppConstants.HR_UPDATE_CURRENT_PLAN_URI,data: formData);
      Map data=json.decode(response.data);
      print(data);
      print("res :"+data['response']);
      if(data['response']=="success")
      {
        setState(() {
          is_loading=false;
        });
        if(widget.packagetype=="Consultancy Package")
       {
         ConsultancyPackage Cplan=ConsultancyPackage.fromJson(data['package']);
         //print("Cplan"+Cplan.name);
         sharedPreferences!.setString("HrplanType", "c");
         sharedPreferences!.setString("CDays",Cplan.validity!);
         sharedPreferences!.setString("COriginalPrice", Cplan.originalPrice!);
         sharedPreferences!.setString("CDiscountedPrice", Cplan.discountPrice!);
         sharedPreferences!.setString("Cperdaylimit", Cplan.perdayLimit!);
         sharedPreferences!.setString("CtotalJobPost", Cplan.jobPostNo!);
         sharedPreferences!.setString("CtotalResumes", Cplan.totalResumes!);
         sharedPreferences!.setString("HrplanId", Cplan.id!);
         sharedPreferences!.setString("HrplanIcon", Cplan.iconSrc!);
       }
        else
        {
          RecruiterPackage Rplan=RecruiterPackage.fromJson(data['package']);
          print("Rplan"+Rplan.name!);
          sharedPreferences!.setString("HrplanType", "r");
          sharedPreferences!.setString("RDays", Rplan.days!);
          sharedPreferences!.setString("ROriginalPrice", Rplan.originalPrice!);
          sharedPreferences!.setString("RDiscountedPrice", Rplan.discountPrice!);
          sharedPreferences!.setString("RProfilePerApp", Rplan.profilePerApplication!);
          sharedPreferences!.setString("RtotalJobPost", Rplan.totalJobPost!);
          sharedPreferences!.setString("RType", Rplan.type!);
          sharedPreferences!.setString("HrplanId", Rplan.id!);
          sharedPreferences!.setString("HrplanIcon", Rplan.iconSrc!);
        }
        sharedPreferences!.setString("HrplanName", widget.PacakgeName);
        sharedPreferences!.setString("HrPurchaseDate", data['purchasedate']);
        Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context)=> ThankYouScreen()));
      }
      else
      {
        CommonFunctions.showErrorDialog("Error in Updating Plan", context);
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
  // sharedPreferences!.setString("HrplanName", widget.PacakgeName);
  // sharedPreferences!.setString("HrplanId", widget.pacakgeid);

  @override
  Widget build(BuildContext context)
    {
      final deviceSize = MediaQuery.of(context).size;
      return is_loading? CircularProgressIndicator():
      Container(
          decoration: new BoxDecoration(color: Colors.white),
          child:
          SafeArea(child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child:
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                    Lottie.asset(
                                      'assets/lottie/purchasedetail.json',
                                      height: deviceSize.width / 2,
                                      width: deviceSize.width / 2,
                                      animate: true,),
                                    // new Image.asset(
                                    //   'assets/images/appicon.png',
                                    //   fit: BoxFit.contain,
                                    //   height: deviceSize.height / 4,
                                    //   width: deviceSize.width / 2,
                                    // )
                                  ]

                              ),
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Your Purchase Details ', style: LatinFonts.aBeeZee(fontSize: 18,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                                ]
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Package Type ', style: LatinFonts.aBeeZee(fontSize: 14,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  Text(widget.packagetype, style: LatinFonts.aBeeZee(fontSize: 14,), maxLines: 2, overflow: TextOverflow.ellipsis),
                                ]
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Package Name ', style: LatinFonts.aBeeZee(fontSize: 14,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  Text(widget.PacakgeName, style: LatinFonts.aBeeZee(fontSize: 14,), maxLines: 2, overflow: TextOverflow.ellipsis),
                                ]
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Name ', style: LatinFonts.aBeeZee(fontSize: 14,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  Text(HrName, style: LatinFonts.aBeeZee(fontSize: 14,), maxLines: 2, overflow: TextOverflow.ellipsis),
                                ]
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Phone ', style: LatinFonts.aBeeZee(fontSize: 14,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  Text(phone, style: LatinFonts.aBeeZee(fontSize: 14,), maxLines: 2, overflow: TextOverflow.ellipsis),
                                ]
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Email ', style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  Text(emaile, style: LatinFonts.aBeeZee(fontSize: 14,), maxLines: 2, overflow: TextOverflow.ellipsis),
                                ]
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Divider(thickness: 2,),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Amount to pay ', style: LatinFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  Text(" \u{20B9} "+widget.amount, style: LatinFonts.aBeeZee(fontSize: 18,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                                ]
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          ]

                      ),
                    ),
                  ),

                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: deviceSize.width-10,
                              padding: EdgeInsets.all(3.0),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(getTranslated("BUTTON_CLICK_AGREE", context)!,style: TextStyle(
                                  color: Colors.deepPurple, fontSize: 10),),
                                  Text(getTranslated("T_N_C", context)!, style: TextStyle(
                                      color: Colors.deepPurple, fontSize: 10),),
                                ],
                              ),
                            ),
                          ]
                      ),
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // Container(
                            //   decoration: BoxDecoration(color: Colors.blue),
                            //
                            //   child: GestureDetector(
                            //     onTap: (){
                            //       // Navigator.push(
                            //       //     context,
                            //       //     MaterialPageRoute(
                            //       //         builder: (builder) =>
                            //       //            // PaymentPageScreen(PacakgeName:itemNo.name,amount:itemNo.discountPrice,packagetype:"Recruiter Package",pacakgeid:itemNo.id)
                            //       //     ));
                            //     },
                            //     child:Lottie.asset(
                            //       'assets/lottie/upgrade.json',
                            //       // height: MediaQuery.of(context).size.width*0.15,
                            //       width: MediaQuery.of(context).size.width*0.45,
                            //       animate: true,),
                            //   ),
                            // ),
                            Container(
                             // width: deviceSize.width,
                              padding: EdgeInsets.all(10.0),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  // GestureDetector( onTap:(){openCheckout();},
                                  // child:Lottie.asset(
                                  //   'assets/lottie/proceedtopayment2.json',
                                  //  // height: MediaQuery.of(context).size.width*0.5,
                                  //   width: MediaQuery.of(context).size.width*0.45,
                                  //   animate: true,),),
                                  ElevatedButton(
                                    child:
                                    // const Text('Proceed to Payment'),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 20,),
                                        Text('Proceed to Payment',style: LatinFonts.aBeeZee(fontSize: 22, fontWeight: FontWeight.bold),),
                                        SizedBox(width: 20,),
                                        Lottie.asset(  'assets/lottie/proceedtopayment3.json',
                                          height: MediaQuery.of(context).size.width*0.12,
                                          width: MediaQuery.of(context).size.width*0.12,
                                          animate: true,),
                                      ],),
                                    onPressed: () {
                                      openCheckout();

                                    },
                                    style: ElevatedButton.styleFrom(
                                       // minimumSize: new Size(MediaQuery.of(context).size.width * 0.6,MediaQuery.of(context).size.width * 0.1),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16)),
                                        primary: Colors.amber,
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                        textStyle:
                                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          ]
                      ),
                    ],
                  ),

                ),

              ],),),)
      );
    }
  }
