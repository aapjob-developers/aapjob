
import 'dart:convert';

import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/CurrentPlanModel.dart';
import 'package:Aap_job/screens/PaymentPage.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import '../utill/dimensions.dart';


class ConsultancyPlansScreen extends StatefulWidget {
  ConsultancyPlansScreen({Key? key}) : super(key: key);
  @override
  _ConsultancyPlansScreenState createState() => new _ConsultancyPlansScreenState();
}

class _ConsultancyPlansScreenState extends State<ConsultancyPlansScreen> {

  Color box1color=Colors.transparent, box2color=Colors.transparent;

  var _ishrLoading = false;
  bool _isRecruiterShowing=true;
  bool _isConsultancyShowing=true;
  bool _isRecruiterLoading=false;
  bool _isConsultancyLoading=false;

  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;

  List<ConsultancyPackage> duplicateJobsModel = <ConsultancyPackage>[];

  bool _hasdataModel=false;

  getRecruiterlist() async {
    duplicateJobsModel.clear();
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.HR_CONSULTANCY_PLAN_URI);
      apidata = response.data;
      print('JobsModelList : ${apidata}');
      List<dynamic> data=json.decode(apidata);
      if(data.toString()=="[]")
      {
        duplicateJobsModel=[];
        setState(() {
          _hasdataModel = false;
        });
      }
      else
      {
        data.forEach((jobs) =>
            duplicateJobsModel.add(ConsultancyPackage.fromJson(jobs)));
        setState(() {
          _hasdataModel=true;
        });
      }
      print('Jobtitle List: ${duplicateJobsModel}');
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
  void initState() {
    super.initState();
    getRecruiterlist();
    setState(() {
      box1color=Colors.transparent;
      box2color=Colors.transparent;

    });

  }


  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
        decoration: new BoxDecoration(color: Primary),
        child:
        SafeArea(child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(onPressed: () {
              Navigator.of(context).pop();
            },icon: Icon(Icons.arrow_back_ios,color: Colors.white,),),
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
                    child: Text("Consultancy Plans",maxLines:2,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                    ),
                  ),
                ]
            ),
          ),
          body:
          // Stack(
          //   children: <Widget>[
          //     Align(
          //       alignment: Alignment.topCenter,
          //       child: SingleChildScrollView(
          //         child: new Column(
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             mainAxisSize: MainAxisSize.max,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: <Widget>[
          //
          //             ]
          //         ),
          //       ),
          //
          //     ),
          //   ],),
          duplicateJobsModel.length>0?GridView.builder(
            itemCount: duplicateJobsModel.length,
            itemBuilder: (context, index) => ItemTile(duplicateJobsModel[index]),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1,
            ),
          ):
          Center(child: CircularProgressIndicator(),)
          ,
        ),)
    );

  }
}

class ItemTile extends StatelessWidget {
  final ConsultancyPackage itemNo;
  const ItemTile(
      this.itemNo,
      );

  @override
  Widget build(BuildContext context) {
    double discount=0;
    if(int.parse(itemNo.discountPrice!)>0) {
      int diffrence=int.parse(itemNo.originalPrice!)-int.parse(itemNo.discountPrice!);
      discount = (diffrence/int.parse(itemNo.originalPrice!))*100;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
      Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)],
        ),
        child: Stack(children: [
          Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Product Image
                Container(
                  height: MediaQuery.of(context).size.width*0.2,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  decoration: BoxDecoration(
                    color: Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                  ),
                  child:
                  FadeInImage.assetNetwork(
                    placeholder: 'assets/images/appicon.png',
                    image: '${AppConstants.BASE_URL}/${itemNo.iconSrc}',
                    fit: BoxFit.contain,
                  ),
                ),
                // Product Details
                Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(itemNo.name ?? '', style: LatinFonts.aBeeZee(fontSize: 18,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Text(getTranslated("IDEAL_FOR_RESUME", context)!+itemNo.totalResumes!+" Resumes", style: LatinFonts.aBeeZee(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Text('Package Details', style: LatinFonts.aBeeZee(fontSize: 14,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Job Posting Allowed : ', style: LatinFonts.aBeeZee(fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis),
                            Text(itemNo.jobPostNo! + " Jobs", style: LatinFonts.aBeeZee(fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ]
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Resumes Download Allowed per day : ', style: LatinFonts.aBeeZee(fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis),
                            Text(itemNo.perdayLimit! + " Resumes", style: LatinFonts.aBeeZee(fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ]
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Total Resumes Download Allowed : ', style: LatinFonts.aBeeZee(fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis),
                            Text(itemNo.totalResumes! + " Resumes", style: LatinFonts.aBeeZee(fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ]
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Validity : ', style: LatinFonts.aBeeZee(fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis),
                            Text(itemNo.validity! + " Days", style: LatinFonts.aBeeZee(fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ]
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            discount> 0 ?
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    'assets/lottie/coin.json',
                                    height: MediaQuery.of(context).size.width*0.1,
                                    width: MediaQuery.of(context).size.width*0.1,
                                    animate: true,),
                                  Text(" "+itemNo.discountPrice!,
                                    style: LatinFonts.aBeeZee(fontSize: 24, fontWeight: FontWeight.bold, color:Colors.black),
                                  ),
                                  Lottie.asset(
                                    'assets/lottie/coin.json',
                                    height: MediaQuery.of(context).size.width*0.1,
                                    width: MediaQuery.of(context).size.width*0.1,
                                    animate: true,),
                                  Text(" "+itemNo.originalPrice!,
                                    style: LatinFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.bold,color:Colors.grey,decoration: TextDecoration.lineThrough),
                                  ),
                                  Text(" ( "+discount.toStringAsFixed(0)+" % off )",
                                    style: LatinFonts.aBeeZee(fontSize: 14,color:Colors.red),
                                  ),
                                ])
                                :
                            Text.rich(
                                TextSpan(
                                    text: "Free",
                                    style: LatinFonts.aBeeZee(fontSize: 24, fontWeight: FontWeight.bold, color:Colors.black),
                                    children: <InlineSpan>[
                                    ]
                                )
                            )
                            ,
                          ]),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      itemNo.discountPrice=="0"?
                      Container()
                          :
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 30,),
                                  Text('Buy Now',style: LatinFonts.aBeeZee(fontSize: 20, fontWeight: FontWeight.bold),),
                                  SizedBox(width: 50,),
                                  Lottie.asset(  'assets/lottie/arrowright.json',
                                    height: MediaQuery.of(context).size.width*0.13,
                                    width: MediaQuery.of(context).size.width*0.13,
                                    animate: true,),
                                ],),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            PaymentPageScreen(PacakgeName:itemNo.name!,amount:itemNo.discountPrice!,packagetype:"Consultancy Package",pacakgeid:itemNo.id!)
                                    ));
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: new Size(MediaQuery.of(context).size.width * 0.7,20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  primary: Colors.amber,
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  textStyle:
                                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                          ]),
                    ],
                  ),
                ),
              ]),

          // Off
          discount> 0 ?
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              height: 25,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Primary,
                borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomLeft: Radius.circular(7)),
              ),
              child: Center(
                child: Text(
                  discount.toStringAsFixed(0)+ "% off",
                  style:  LatinFonts.aBeeZee(color: Colors.white,fontSize: 20),
                ),
              ),
            ),
          )
              : Positioned(
            top: 0,
            right: 0,
            child: Container(
              height: 25,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Primary,
                borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomLeft: Radius.circular(7)),
              ),
              child: Center(
                child: Text(
                  "Free",
                  style:  LatinFonts.aBeeZee(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}