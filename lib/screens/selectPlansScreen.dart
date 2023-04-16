import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/screens/RecruiterPlansScreen.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:lottie/lottie.dart';

import 'ConsultancyPlansScreen.dart';


class SelectPlansScreen extends StatefulWidget {
  SelectPlansScreen({Key? key}) : super(key: key);
  @override
  _SelectPlansScreenState createState() => new _SelectPlansScreenState();
}

class _SelectPlansScreenState extends State<SelectPlansScreen> {

Color box1color=Colors.transparent, box2color=Colors.transparent;

var _ishrLoading = false;
bool _isRecruiterShowing=true;
bool _isConsultancyShowing=true;
bool _isRecruiterLoading=false;
bool _isConsultancyLoading=false;

  @override
  void initState() {
    super.initState();

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
                      child: Text(getTranslated("UPGRADE_YOUR_PLAN", context)!,maxLines:2,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]
              ),
            ),
            body: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          // new Padding(
                          //   child:
                          //   new Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       mainAxisSize: MainAxisSize.max,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: <Widget>[
                          //         new Image.asset(
                          //           'assets/images/appicon.png',
                          //           fit: BoxFit.contain,
                          //           height: deviceSize.width / 4,
                          //           width: deviceSize.width / 4,
                          //         )
                          //       ]
                          //
                          //   ),
                          //   padding: const EdgeInsets.all(8.0),
                          // ),

                          new Padding(
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(child:
                                  Text(
                                    "Please Select a Plan Type",
                              style:LatinFonts.aclonica(color:Colors.white,fontSize: 16,fontWeight:FontWeight.w500 ),
                            textAlign: TextAlign.center,)
                                  )
                                ]

                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          _isRecruiterShowing?
                          new Container(
                            decoration: new BoxDecoration(boxShadow: [new BoxShadow(
                          color: Colors.white,
                            blurRadius: 5.0,
                          ),],
                                gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.white,
                        ]),),
                            child:
                                Column(
                                    children:[
                                      Padding(padding: EdgeInsets.symmetric(vertical: 5.0),
                                        child:Text(
                                          "Recruiter Plan",
                                          textAlign: TextAlign.center,
                                          style:LatinFonts.aclonica(color:Colors.green,fontSize: 18,fontWeight:FontWeight.w500 ),),
                                      ),
                                      new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                       // padding: EdgeInsets.all(5.0),
                                        decoration: new BoxDecoration(
                                          color: box1color,),
                                        width: deviceSize.width * 0.5,
                                        // padding: EdgeInsets.all(16.0),
                                        child:
                                        Lottie.asset(
                                          'assets/lottie/interview.json',
                                          height: deviceSize.width * 0.4,
                                          width: deviceSize.width * 0.5,
                                          animate: true,),
                                    ),
                                  Expanded(child:
                                      Column(
                                        children: [
                                          Padding(padding: EdgeInsets.symmetric(vertical: 5.0),
                                            child:
                                            Text(
                                              'Specially Made for Company Hiring',
                                              textAlign: TextAlign.left,
                                              style: LatinFonts.aBeeZee(textStyle:TextStyle(fontSize: 10)),
                                            ),
                                          ),

                                          Padding(padding: EdgeInsets.symmetric(vertical: 5.0),
                                            child:
                                            Text(
                                              'Get Desired candidates only according to your rquirement',
                                              textAlign: TextAlign.left,
                                              style: LatinFonts.aBeeZee(textStyle:TextStyle(fontSize: 10)),
                                            ),
                                          ),

                                          Padding(padding: EdgeInsets.symmetric(vertical: 5.0),
                                            child:
                                            Text(
                                              'Economical and choose according to need',
                                              textAlign: TextAlign.left,
                                              style: LatinFonts.aBeeZee(textStyle:TextStyle(fontSize: 10)),
                                            ),
                                          ),
                                          Padding(padding: EdgeInsets.symmetric(vertical: 5.0),
                                            child:
                                            Text(
                                              'Pay only for shortlisted candidates',
                                              textAlign: TextAlign.left,
                                              style: LatinFonts.aBeeZee(textStyle:TextStyle(fontSize: 10)),
                                            ),
                                          ),
                                        ],
                                      ),


                                  )
                                ]
                            ),
                                      new Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if (_isRecruiterLoading)
                                            CircularProgressIndicator()
                                          else
                                            ElevatedButton(
                                              child: const Text('Select a Recruiter Plan'),
                                              onPressed:(){
                                                setState(() {
                                                  // _isRecruiterLoading=true;
                                                  // _isConsultancyShowing=false;
                                                });
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (builder) => RecruiterPlansScreen()));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  minimumSize: new Size(
                                                      deviceSize.width * 0.5, 20),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(
                                                          15)),
                                                  primary: Colors.green,
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 10, vertical: 10),
                                                  textStyle:
                                                  const TextStyle(fontSize: 20,
                                                      fontWeight: FontWeight.bold)),

                                            ),
                                        ],
                                      ),
                                    ]
                                ),
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          ):Container(),
                          new SizedBox(height: 20,),
                          _isConsultancyShowing?
                          new Container(
                            decoration: new BoxDecoration(boxShadow: [new BoxShadow(
                              color: Colors.white,
                              blurRadius: 5.0,
                            ),],
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Colors.white,
                                  ]),),
                            child:
                            Column(children: [
                              Padding(padding: EdgeInsets.symmetric(vertical: 5.0),
                                child:Text(
                                  "Consultancy Plan",
                                  textAlign: TextAlign.center,
                                  style:LatinFonts.aclonica(color:Colors.blue,fontSize: 18,fontWeight:FontWeight.w500 ),),
                              ),
                              new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    Container(
                                        decoration: new BoxDecoration(
                                          color: box2color,),
                                        width: deviceSize.width * 0.5,
                                        // padding: EdgeInsets.all(16.0),
                                        child:
                                        Lottie.asset(
                                          'assets/lottie/consultancy.json',
                                          height: deviceSize.width * 0.4,
                                          width: deviceSize.width * 0.5,
                                          animate: true,),

                                    ),
                                    Expanded(child:
                                    Column(
                                      children: [
                                        Padding(padding: EdgeInsets.symmetric(vertical: 5.0),
                                          child:
                                          Text(
                                            'Specially Made for Recruitment Agencies',
                                            textAlign: TextAlign.left,
                                            style: LatinFonts.aBeeZee(textStyle:TextStyle(fontSize: 10)),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.symmetric(vertical: 5.0),
                                          child:
                                          Text(
                                            'get daily resumes of all job categories',
                                            textAlign: TextAlign.left,
                                            style: LatinFonts.aBeeZee(textStyle:TextStyle(fontSize: 10)),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.symmetric(vertical: 5.0),
                                          child:
                                          Text(
                                            'No need to post jobs to find right candidates',
                                            textAlign: TextAlign.left,
                                            style: LatinFonts.aBeeZee(textStyle:TextStyle(fontSize: 10)),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.symmetric(vertical: 5.0),
                                          child:
                                          Text(
                                            'Access all types of candidates data',
                                            textAlign: TextAlign.left,
                                            style: LatinFonts.aBeeZee(textStyle:TextStyle(fontSize: 10)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    )
                                  ]
                              ),
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_isConsultancyLoading)
                                    CircularProgressIndicator()
                                  else
                                    ElevatedButton(
                                      child: const Text('Select a Consultancy Plan'),
                                      onPressed:(){
                                        setState(() {
                                          // _isConsultancyLoading=true;
                                          // _isRecruiterShowing=false;
                                        });
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (builder) => ConsultancyPlansScreen()));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: new Size(
                                              deviceSize.width * 0.5, 20),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  15)),
                                          primary: Colors.blue,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          textStyle:
                                          const TextStyle(fontSize: 20,
                                              fontWeight: FontWeight.bold)),

                                    ),
                                ],
                              ),
                            ],),


                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          ):Container(),

                        ]

                    ),
                  ),

                ),
              ],),),)
      );

  }
}