
import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'dart:math';
import 'dart:isolate';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/CandidateModel.dart';
import 'package:Aap_job/models/JobsModel.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/basewidget/VideoPlayerScreen.dart';
import 'package:Aap_job/screens/hrhomepage.dart';
import 'package:Aap_job/screens/splashscreen.dart';
import 'package:Aap_job/screens/widget/VideoPopup.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/date_converter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../utill/colors.dart';


class JobAppliedCandidatesList extends StatefulWidget {
  JobAppliedCandidatesList({Key? key, required this.jobid, required this.jobrole,required this.jobapplied}) : super(key: key);
  String jobid,jobrole;
  int jobapplied;
  @override
  _JobAppliedCandidatesListState createState() => new _JobAppliedCandidatesListState();
}

class _JobAppliedCandidatesListState extends State<JobAppliedCandidatesList> {
  final ReceivePort _port = ReceivePort();
  SharedPreferences? sharedPreferences;
  final Dio _dio = Dio();
  final Dio _dioi = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  int toreview=0,selected=0;

  bool _hasCallSupport = false;
  late Future<void> _launched;

  @override
  initState() {
    initializePreference().whenComplete((){
      setState(() {
        getselected();
        getunselected();
      });

      IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
      _port.listen((dynamic data) {
        String id = data[0];
        DownloadTaskStatus status = data[1];
        int progress = data[2];
        setState((){ });
      });
      FlutterDownloader.registerCallback(downloadCallback);
    });
    super.initState();


    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });

  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }


  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
  //  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableDomStorage: true,enableJavaScript: true),
    )) {
      throw 'Could not launch $url';
    }
  }

  selectedcandidate(String candidateid) async {
    try {
      FormData formData = new FormData.fromMap({"jobid": widget.jobid, "candidateid":candidateid, });
      Response response = await _dio.post(_baseUrl + AppConstants.SELECT_CANDIDATE_URI,data: formData);
      String selectedcandidate = response.data;
      if(selectedcandidate.toString()=="success")
      {
        Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context)=> JobAppliedCandidatesList(jobid:widget.jobid,jobrole: widget.jobrole,jobapplied: widget.jobapplied,)));
      }
      else
      {
        CommonFunctions.showInfoDialog("Error in Selecting Candidate"+selectedcandidate, context);
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

  Future<List<CandidateModel>>? getselectedcandidates() async {
    List<CandidateModel>? list=<CandidateModel>[];
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.SELECTED_CANDIDATES_URI+widget.jobid);
      final List result =jsonDecode(response.data);
      print(result);
      return result.map(((e) => CandidateModel.fromJson(e))).toList();
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
        return list;
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
        return list;
      }
    }

  }
  Future<List<CandidateModel>>? getunselectedcandidates() async {
    List<CandidateModel>? list=<CandidateModel>[];
    try {
      Response responsee = await _dioi.get(_baseUrl + AppConstants.UNSELECTED_CANDIDATES_URI+widget.jobid);
      final List result =jsonDecode(responsee.data);
      print(result);
      return result.map(((e) => CandidateModel.fromJson(e))).toList();
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
        return list;
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
        return list;
      }
    }

  }



  Future<void> requestDownload(String _url, String _name) async {
    print("URL: "+_url);
    final status= await Permission.storage.request();
    if(status.isGranted) {
      final dir = await getExternalStorageDirectory(); //From path_provider package
      final id = await FlutterDownloader.enqueue(
        url: _url,
        fileName: _name,
        savedDir: dir!.path,
        showNotification: true,
        openFileFromNotification: true,
      );
      CommonFunctions.showSuccessToast("Resume is Downloading...");
      final Uri _vrl = Uri.parse(_url);
      _launched = _launchInWebViewOrVC(_vrl);
    }
    else
      {
        CommonFunctions.showInfoDialog("Permission not Granted for downloding", context);
      }

  }


  getselected() async {
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.SELECTED_CANDIDATES_URI+widget.jobid);
      final List result =jsonDecode(response.data);
      setState(() {
        selected= result.map(((e) => CandidateModel.fromJson(e))).toList().length;
      });
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

  getunselected() async {
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.UNSELECTED_CANDIDATES_URI+widget.jobid);
      final List result =jsonDecode(response.data);
      setState(() {
        toreview= result.map(((e) => CandidateModel.fromJson(e))).toList().length;
      });
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
        //whatsapp_no_installed
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text(getTranslated('whatsapp_no_installed', context)!)));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        //whatsapp_no_installed
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text(getTranslated('whatsapp_no_installed', context)!)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize =MediaQuery.of(context).size;
    return
      WillPopScope(
        onWillPop: ()async{
      if(Provider.of<AuthProvider>(context, listen: false).getacctype()=="hr")
      //  CommonFunctions.showSuccessToast("done");
       Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => SplashScreen()),);
      return true;
    },
    child:
      DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:Primary,
          bottom: TabBar(
            labelColor: Colors.white,
            indicatorWeight: 5,
            indicatorColor: Colors.amberAccent,
            labelStyle:LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold, color:Colors.black),
            tabs: [
              Tab(text:"To Review ( "+toreview.toString()+" )"),
              Tab(text:"Shortlisted ( "+selected.toString()+" )",),
            ],
          ),
          title:
          Text.rich(
              TextSpan(
                  text: widget.jobrole,
                  style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold, color:Colors.white),
                  children: <InlineSpan>[
                    TextSpan(
                      text: " ("+widget.jobapplied.toString()+" Candidates )",
                      style: LatinFonts.aBeeZee(fontSize: 10, fontWeight: FontWeight.bold,color:Colors.white),
                    )
                  ]
              )
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child:
                  FutureBuilder<List<CandidateModel>>(
                      future: getunselectedcandidates(),
                      builder: (context,snapshot){
                        if(snapshot.hasData)
                        {
                          if(snapshot.data!.length>0)
                            return
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  CandidateModel candi=snapshot.data![index];
                                  return
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.9,
                                      decoration: new BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [new BoxShadow(
                                            color: Color.fromRGBO(00, 132, 122, 1.0),
                                            blurRadius: 5.0,
                                          ),],
                                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                      margin: EdgeInsets.all(5),
                                      padding: EdgeInsets.all(10),
                                      child:
                                      new Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  new Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        CircleAvatar(
                                                          radius: 50.0,
                                                          backgroundImage: CachedNetworkImageProvider(
                                                            AppConstants.BASE_URL+candi.profileImage,
                                                            maxWidth:200,
                                                            maxHeight:200,
                                                          ),
                                                        ),
                                                        SizedBox(height: 2,),
                                                        // Applied_on
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.max,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Text(getTranslated('Applied_on', context)!+":",style: LatinFonts.aBeeZee(color:Colors.grey,fontSize: 10),
                                                              ),

                                                            ]
                                                        ),
                                                        new Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.max,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              DateTime.now().difference(candi.applydatetime).inMinutes >= 59
                                                                  ?
                                                              DateTime.now().difference(candi.applydatetime).inHours >= 23 ?
                                                              DateTime.now().difference(candi.applydatetime).inDays > 1 ?
                                                              new Container(
                                                                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                                                                child:
                                                                Text( DateFormat('dd/MM/yyyy').format(DateConverter.isoStringToLocalDate(candi.applydatetime.toString())).toString()
                                                                  ,style: LatinFonts.aBeeZee(color:Colors.black,fontSize: 10,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
                                                              )
                                                                  :
                                                              new Container(
                                                                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                                                                child:
                                                                Text( DateTime.now().difference(candi.applydatetime).inDays.toStringAsFixed(0)+" Day Ago"
                                                                  ,style: LatinFonts.aBeeZee(color:Colors.black,fontSize: 10,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
                                                              )
                                                                  :
                                                              new Container(
                                                                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                                                                child:
                                                                Text( DateTime.now().difference(candi.applydatetime).inHours.toStringAsFixed(0)+" Hours Ago"
                                                                  ,style: LatinFonts.aBeeZee(color:Colors.black,fontSize: 10,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
                                                              )
                                                                  :
                                                              new Container(
                                                                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                                                                child:
                                                                Text( DateTime.now().difference(candi.applydatetime).inMinutes.toStringAsFixed(0)+" Minutes Ago"
                                                                  ,style: LatinFonts.aBeeZee(color:Colors.black,fontSize: 10,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
                                                              ),
                                                            ]
                                                        ),
                                                        // SizedBox(height: 2,),
                                                        // Row(
                                                        //     mainAxisAlignment: MainAxisAlignment.start,
                                                        //     mainAxisSize: MainAxisSize.max,
                                                        //     crossAxisAlignment: CrossAxisAlignment.start,
                                                        //     children: <Widget>[
                                                        //       Text(candi.applydatetime.toString(),style: LatinFonts.aBeeZee(color:Colors.grey,fontSize: 10),
                                                        //       ),
                                                        //
                                                        //     ]
                                                        // ),
                                                        //VideoPlayerScreen(isLocal:false,width:MediaQuery.of(context).size.width*0.3,height:MediaQuery.of(context).size.width*0.3,urlLandscapeVideo: AppConstants.BASE_URL+candi.resumeSrc,),
                                                        // ElevatedButton(
                                                        //   child: Text('view resume',style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 12 )),
                                                        //   onPressed: () => setState(() {
                                                        //      final String _url = AppConstants.BASE_URL+candi.docResumeSrc;
                                                        //     requestDownload(_url, "resume"+candi.mobile);
                                                        //   }),
                                                        //   style: ElevatedButton.styleFrom(
                                                        //       minimumSize: new Size(deviceSize.width * 0.25,30),
                                                        //       shape: RoundedRectangleBorder(
                                                        //           borderRadius: BorderRadius.circular(16)),
                                                        //       primary: Colors.blue,
                                                        //       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                        //       textStyle:
                                                        //       const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                        //
                                                        // ),
                                                      ]),
                                                  SizedBox(width: 15,),
                                                  new Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(candi.name!,style: LatinFonts.aBeeZee(fontSize: 24, fontWeight: FontWeight.bold, color:Colors.black),),
                                                        SizedBox(height: 10,),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.max,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Icon(Icons.pin_drop_rounded,size: 20, color: Colors.grey,),
                                                              SizedBox(width: 5,),
                                                              new Container(
                                                                width: deviceSize.width*0.4,
                                                                child:
                                                                Text.rich(
                                                                    TextSpan(
                                                                        text: candi.address!+" , ",
                                                                        style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold, color:Colors.grey),
                                                                        children: <InlineSpan>[
                                                                          TextSpan(
                                                                            text: candi.preferredCity,
                                                                            style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.grey),
                                                                          )
                                                                        ]
                                                                    )
                                                                ),
                                                              ),
                                                            ]
                                                        ),
                                                        SizedBox(height: 10,),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.max,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Icon(Icons.school,size: 15,color: Colors.grey,),
                                                              SizedBox(width: 10,),
                                                              new Container(
                                                                width: deviceSize.width*0.4,
                                                                child:
                                                                Text.rich(
                                                                    TextSpan(
                                                                        text: candi.education![0].level!+", ",
                                                                        style: LatinFonts.aBeeZee(fontSize: 12, fontWeight: FontWeight.bold, color:Colors.grey),
                                                                        children: <InlineSpan>[
                                                                          TextSpan(
                                                                            text: candi.education![0].degreeOrName,
                                                                            style: LatinFonts.aBeeZee(fontSize: 12, fontWeight: FontWeight.bold,color:Colors.grey),
                                                                          )
                                                                        ]
                                                                    )
                                                                ),

                                                              ),
                                                            ]
                                                        ),
                                                        SizedBox(height: 10,),
                                                        new Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.max,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Icon(Icons.person,size: 15,color: Colors.grey,),
                                                              SizedBox(width: 15,),
                                                              new Container(
                                                                  width: deviceSize.width*0.4,
                                                                  child:
                                                                  Text(candi.gender! ,style: LatinFonts.aBeeZee(fontWeight: FontWeight.bold, color:Colors.grey,fontSize: 12 ),)
                                                              ),
                                                            ]
                                                        ),
                                                        SizedBox(height: 10,),
                                                        new Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.max,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: <Widget>[
                                                              new Container(
                                                                  width: deviceSize.width*0.3,
                                                                  child:
                                                                  RatingBarIndicator(
                                                                    rating: candi.rating is String?double.parse(candi.rating):candi.rating,
                                                                    itemBuilder: (context, index) => Icon(
                                                                      Icons.star,
                                                                      color: Colors.amber,
                                                                    ),
                                                                    itemCount: 5,
                                                                    itemSize: 20.0,
                                                                    direction: Axis.horizontal,
                                                                  ),
                                                              ),
                                                              SizedBox(width: 15,),
                                                              new Container(
                                                                  width: deviceSize.width*0.2,
                                                                  child:
                                                                  ElevatedButton(
                                                                    child:
                                                                    new Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        mainAxisSize: MainAxisSize.max,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: <Widget>[
                                                                          SizedBox(width: 5,),
                                                                          Text(getTranslated('RATE_ME', context)! ,style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 12 ),)
                                                                          ,SizedBox(width: 5,),
                                                                        ]
                                                                    ),
                                                                    onPressed: _hasCallSupport
                                                                        ? () => setState(() {    })
                                                                        : null,
                                                                    style: ElevatedButton.styleFrom(
                                                                        minimumSize: new Size(deviceSize.width * 0.25,30),
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(16)),
                                                                        primary: Colors.green,
                                                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                                        textStyle:
                                                                        const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),

                                                                  ),
                                                              ),
                                                            ]
                                                        ),
                                                      ]),
                                                ]
                                            ),

                                            SizedBox(height: 10,),
                                            candi.myexp=="experienced"?
                                            new Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(width: 15,),
                                                  Icon(Icons.currency_rupee,size: 15,color: Colors.grey,),
                                                  SizedBox(width: 15,),
                                                  new Container(
                                                      width: deviceSize.width*0.7,
                                                      child:
                                                      Text(getTranslated('EARNING', context)!+ candi.exp![0].currentSalary! +getTranslated('MONTHLY', context)! ,style: LatinFonts.aBeeZee(color:Colors.grey,fontSize: 12 ),)
                                                  ),
                                                ]
                                            )
                                                :
                                            Container(),
                                            SizedBox(height: 10,),
                                            candi.myexp=="experienced"?
                                            new Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(width: 15,),
                                                  Icon(Icons.account_balance_sharp,size: 15,color: Colors.grey,),
                                                  SizedBox(width: 15,),
                                                  new Container(
                                                      width: deviceSize.width*0.7,
                                                      child:
                                                      Text(candi.exp![0].experience! +" experience as "+candi.exp![0].jobTitle!+" in "+candi.exp![0].companyName! ,style: LatinFonts.aBeeZee(color:Colors.grey,fontSize: 12 ),)
                                                  ),
                                                ]
                                            )
                                                :
                                            new Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(Icons.account_balance_sharp,size: 15,color: Colors.grey,),
                                                  SizedBox(width: 15,),
                                                  new Container(
                                                      width: deviceSize.width*0.7,
                                                      child:
                                                      Text(getTranslated('FRESHER', context)!,style: LatinFonts.aBeeZee(color:Colors.grey,fontSize: 12 ),)
                                                  ),
                                                ]
                                            ),
                                            SizedBox(height: 10,),
                                            new Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[

                                                  // ElevatedButton(
                                                  //   child:
                                                  //   new Row(
                                                  //       mainAxisAlignment: MainAxisAlignment.center,
                                                  //       mainAxisSize: MainAxisSize.max,
                                                  //       crossAxisAlignment: CrossAxisAlignment.center,
                                                  //       children: <Widget>[
                                                  //         SizedBox(width: 5,),
                                                  //         Icon(Icons.phone_android_rounded,size: 15,color: Colors.white,),
                                                  //         SizedBox(width: 5,),
                                                  //         Text(" Call" ,style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 12 ),)
                                                  //       ]
                                                  //   ),
                                                  //   onPressed: _hasCallSupport
                                                  //       ? () => setState(() {
                                                  //     _launched = _makePhoneCall(candi.mobile);
                                                  //   })
                                                  //       : null,
                                                  //   style: ElevatedButton.styleFrom(
                                                  //       minimumSize: new Size(deviceSize.width * 0.25,30),
                                                  //       shape: RoundedRectangleBorder(
                                                  //           borderRadius: BorderRadius.circular(16)),
                                                  //       primary: Colors.green,
                                                  //       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                  //       textStyle:
                                                  //       const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                  //
                                                  // ),
                                                  SizedBox(width: 10,),
                                                  ElevatedButton(
                                                    child:
                                                    new Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          SizedBox(width: 5,),
                                                          Icon(Icons.check_circle,size: 15,color: Colors.white,),
                                                          SizedBox(width: 5,),
                                                          Text(getTranslated('SHORTLIST', context)!,style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 12 ),)

                                                        ]
                                                    ),

                                                    onPressed: () {
                                                      selectedcandidate(candi.id!);
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        minimumSize: new Size(deviceSize.width * 0.4,30),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(16)),
                                                        primary: Colors.deepPurple,
                                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                        textStyle:
                                                        const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),

                                                  ),

                                                ]
                                            ),
                                          ]
                                      ),
                                    );

                                },
                              );
                          else
                            return
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(padding: EdgeInsets.all(20),
                                    child:
                                    Text(getTranslated('NO_CANDIDATE_SHORTLIST', context)!, style: LatinFonts.aBeeZee(fontSize: 18, color:Primary),textAlign: TextAlign.center,),
                                  )
                                ],
                              );
                        }
                        else if(snapshot.hasError)
                        {
                          return Text('${snapshot.error}');
                        }
                        return const CircularProgressIndicator();
                      }
                  ),

                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child:
                  FutureBuilder<List<CandidateModel>>(
                      future: getselectedcandidates(),
                      builder: (context,snapshot){
                        if(snapshot.hasData)
                        {
                          if(snapshot.data!.length>0)
                            return
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  CandidateModel candi=snapshot.data![index];
                                  return
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.9,
                                      decoration: new BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [new BoxShadow(
                                            color: Color.fromRGBO(00, 132, 122, 1.0),
                                            blurRadius: 5.0,
                                          ),],
                                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                      margin: EdgeInsets.all(5),
                                      padding: EdgeInsets.all(10),
                                      child:
                                      new Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  new Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        CircleAvatar(
                                                          radius: 50.0,
                                                          backgroundImage: CachedNetworkImageProvider(
                                                            AppConstants.BASE_URL+candi.profileImage,
                                                            maxWidth:200,
                                                            maxHeight:200,
                                                          ),
                                                        ),
                                                        SizedBox(height: 2,),
                                                        // Applied_on
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.max,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Text(getTranslated('Applied_on', context)!+":",style: LatinFonts.aBeeZee(color:Colors.grey,fontSize: 10),
                                                              ),

                                                            ]
                                                        ),
                                                        SizedBox(height: 2,),
                                                        new Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.max,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              DateTime.now().difference(candi.applydatetime).inMinutes >= 59
                                                                  ?
                                                              DateTime.now().difference(candi.applydatetime).inHours >= 23 ?
                                                              DateTime.now().difference(candi.applydatetime).inDays > 1 ?
                                                              new Container(
                                                                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                                                                child:
                                                                Text( DateFormat('dd/MM/yyyy').format(DateConverter.isoStringToLocalDate(candi.applydatetime.toString())).toString()
                                                                  ,style: LatinFonts.aBeeZee(color:Colors.black,fontSize: 10,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
                                                              )
                                                                  :
                                                              new Container(
                                                                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                                                                child:
                                                                Text( DateTime.now().difference(candi.applydatetime).inDays.toStringAsFixed(0)+" Day Ago"
                                                                  ,style: LatinFonts.aBeeZee(color:Colors.black,fontSize: 10,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
                                                              )
                                                                  :
                                                              new Container(
                                                                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                                                                child:
                                                                Text( DateTime.now().difference(candi.applydatetime).inHours.toStringAsFixed(0)+" Hours Ago"
                                                                  ,style: LatinFonts.aBeeZee(color:Colors.black,fontSize: 10,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
                                                              )
                                                                  :
                                                              new Container(
                                                                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                                                                child:
                                                                Text( DateTime.now().difference(candi.applydatetime).inMinutes.toStringAsFixed(0)+" Minutes Ago"
                                                                  ,style: LatinFonts.aBeeZee(color:Colors.black,fontSize: 10,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic ),),
                                                              ),
                                                            ]
                                                        ),
                                                        //VideoPlayerScreen(isLocal:false,width:MediaQuery.of(context).size.width*0.3,height:MediaQuery.of(context).size.width*0.3,urlLandscapeVideo: AppConstants.BASE_URL+candi.resumeSrc,),
                                                       candi.resumeSrc!=null&&candi.resumeSrc!=""&&candi.resumeSrc!="NULL"
                                                        ?
                                                        ElevatedButton(
                                                          child: Text('view video resume',style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 12 )),
                                                          onPressed: () => setState(() {
                                                            VideoPopup(
                                                                title: candi.resumeSrc!
                                                            ).show(context);
                                                          }),
                                                          style: ElevatedButton.styleFrom(
                                                              minimumSize: new Size(deviceSize.width * 0.25,30),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(16)),
                                                              primary: Colors.blue,
                                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                              textStyle:
                                                              const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),

                                                        )
                                                        :
                                                        Container(),
                                                        ElevatedButton(
                                                          child: Text('view resume',style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 12 )),
                                                          onPressed: () => setState(() {
                                                            // final Uri _url = Uri.parse(AppConstants.BASE_URL+candi.docResumeSrc);
                                                            // _launched = _launchInWebViewOrVC(_url);
                                                            final _url = AppConstants.BASE_URL+candi.docResumeSrc!;
                                                            requestDownload(_url, "resume"+candi.mobile!);
                                                          }),
                                                          style: ElevatedButton.styleFrom(
                                                              minimumSize: new Size(deviceSize.width * 0.25,30),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(16)),
                                                              primary: Colors.blue,
                                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                              textStyle:
                                                              const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),

                                                        ),
                                                      ]),
                                                  SizedBox(width: 15,),
                                                  new Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(candi.name!,style: LatinFonts.aBeeZee(fontSize: 24, fontWeight: FontWeight.bold, color:Colors.black),),
                                                        SizedBox(height: 10,),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.max,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Icon(Icons.pin_drop_rounded,size: 20, color: Colors.grey,),
                                                              SizedBox(width: 5,),
                                                              new Container(
                                                                width: deviceSize.width*0.4,
                                                                child:
                                                                Text.rich(
                                                                    TextSpan(
                                                                        text: candi.address!+" , ",
                                                                        style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold, color:Colors.grey),
                                                                        children: <InlineSpan>[
                                                                          TextSpan(
                                                                            text: candi.preferredCity,
                                                                            style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.grey),
                                                                          )
                                                                        ]
                                                                    )
                                                                ),
                                                              ),
                                                            ]
                                                        ),
                                                        SizedBox(height: 10,),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.max,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Icon(Icons.school,size: 15,color: Colors.grey,),
                                                              SizedBox(width: 10,),
                                                              new Container(
                                                                width: deviceSize.width*0.4,
                                                                child:
                                                                Text.rich(
                                                                    TextSpan(
                                                                        text: candi.education![0].level!+", ",
                                                                        style: LatinFonts.aBeeZee(fontSize: 12, fontWeight: FontWeight.bold, color:Colors.grey),
                                                                        children: <InlineSpan>[
                                                                          TextSpan(
                                                                            text: candi.education![0].degreeOrName!,
                                                                            style: LatinFonts.aBeeZee(fontSize: 12, fontWeight: FontWeight.bold,color:Colors.grey),
                                                                          )
                                                                        ]
                                                                    )
                                                                ),

                                                              ),
                                                            ]
                                                        ),
                                                        SizedBox(height: 10,),
                                                        new Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.max,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Icon(Icons.person,size: 15,color: Colors.grey,),
                                                              SizedBox(width: 15,),
                                                              new Container(
                                                                  width: deviceSize.width*0.4,
                                                                  child:
                                                                  Text(candi.gender! ,style: LatinFonts.aBeeZee(fontWeight: FontWeight.bold, color:Colors.grey,fontSize: 12 ),)
                                                              ),
                                                            ]
                                                        ),
                                                        SizedBox(height: 10,),
                                                        new Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.max,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: <Widget>[
                                                              new Container(
                                                                width: deviceSize.width*0.3,
                                                                child:
                                                                RatingBarIndicator(
                                                                  rating: candi.rating is String?double.parse(candi.rating):candi.rating,
                                                                  itemBuilder: (context, index) => Icon(
                                                                    Icons.star,
                                                                    color: Colors.amber,
                                                                  ),
                                                                  itemCount: 5,
                                                                  itemSize: 20.0,
                                                                  direction: Axis.horizontal,
                                                                ),
                                                              ),
                                                              SizedBox(width: 15,),
                                                              new Container(
                                                                width: deviceSize.width*0.2,
                                                                child:
                                                                ElevatedButton(
                                                                  child:
                                                                  new Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      mainAxisSize: MainAxisSize.max,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: <Widget>[
                                                                        SizedBox(width: 5,),
                                                                        Text("Rate Me" ,style: LatinFonts.aBeeZee(color:Colors.white,fontSize: 12 ),)
                                                                        ,SizedBox(width: 5,),
                                                                      ]
                                                                  ),
                                                                  onPressed: _hasCallSupport
                                                                      ? () => setState(() {    })
                                                                      : null,
                                                                  style: ElevatedButton.styleFrom(
                                                                      minimumSize: new Size(deviceSize.width * 0.25,30),
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(16)),
                                                                      primary: Colors.green,
                                                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                                      textStyle:
                                                                      const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),

                                                                ),
                                                              ),
                                                            ]
                                                        ),
                                                      ]),
                                                ]
                                            ),

                                            SizedBox(height: 10,),
                                            candi.myexp=="experienced"?
                                            new Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(width: 15,),
                                                  Icon(Icons.currency_rupee,size: 15,color: Colors.grey,),
                                                  SizedBox(width: 15,),
                                                  new Container(
                                                      width: deviceSize.width*0.7,
                                                      child:
                                                      Text("Earning "+ candi.exp![0].currentSalary! +getTranslated('MONTHLY', context)! ,style: LatinFonts.aBeeZee(color:Colors.grey,fontSize: 12 ),)
                                                  ),
                                                ]
                                            )
                                                :
                                            Container(),
                                            SizedBox(height: 10,),
                                            candi.myexp=="experienced"?
                                            new Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(width: 15,),
                                                  Icon(Icons.account_balance_sharp,size: 15,color: Colors.grey,),
                                                  SizedBox(width: 15,),
                                                  new Container(
                                                      width: deviceSize.width*0.7,
                                                      child:
                                                      Text(candi.exp![0].experience!+" experience as "+candi.exp![0].jobTitle!+" in "+candi.exp![0].companyName!,style: LatinFonts.aBeeZee(color:Colors.grey,fontSize: 12 ),)
                                                  ),
                                                ]
                                            )
                                                :
                                            new Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(Icons.account_balance_sharp,size: 15,color: Colors.grey,),
                                                  SizedBox(width: 15,),
                                                  new Container(
                                                      width: deviceSize.width*0.7,
                                                      child:
                                                      Text("Fresher" ,style: LatinFonts.aBeeZee(color:Colors.grey,fontSize: 12 ),)
                                                  ),
                                                ]
                                            ),
                                            SizedBox(height: 10,),
                                            new Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  ElevatedButton(
                                                    child:
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Lottie.asset(
                                                          'assets/lottie/callicon.json',
                                                          height: MediaQuery.of(context).size.width*0.05,
                                                          width: MediaQuery.of(context).size.width*0.05,
                                                          animate: true,),
                                                        SizedBox(width: 10,),
                                                        Text("Call"),
                                                      ],),

                                                    onPressed: _hasCallSupport
                                                        ? () => setState(() {
                                                      _launched = _makePhoneCall(candi.mobile!);
                                                    })
                                                        : null,
                                                    style: ElevatedButton.styleFrom(
                                                        minimumSize: new Size(deviceSize.width * 0.25,30),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(16)),
                                                        primary: Colors.green,
                                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                        textStyle:
                                                        const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),

                                                  ),
                                                  SizedBox(width: 10,),
                                                  ElevatedButton(
                                                    child:
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Lottie.asset(
                                                          'assets/lottie/whatsapp.json',
                                                          height: MediaQuery.of(context).size.width*0.05,
                                                          width: MediaQuery.of(context).size.width*0.05,
                                                          animate: true,),
                                                        SizedBox(width: 10,),
                                                        Text("Whatsapp"),
                                                      ],),
                                                    onPressed: _hasCallSupport ? () => setState(() {openwhatsapp(candi.mobile!);  }) : null,
                                                    style: ElevatedButton.styleFrom(
                                                        minimumSize: new Size(deviceSize.width * 0.25,30),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(16)),
                                                        primary: Colors.amber,
                                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                  ),
                                                  ),
                                                ]
                                            ),
                                          ]
                                      ),
                                    );

                                },
                              );
                          else
                            return
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(padding: EdgeInsets.all(20),
                                    child:
                                    Text(getTranslated("NO_CANDIDATE_SHORTLIST", context)!, style: LatinFonts.aBeeZee(fontSize: 18, color:Primary),textAlign: TextAlign.center,),
                                  )
                                ],
                              );
                        }
                        else if(snapshot.hasError)
                        {
                          return Text('${snapshot.error}');
                        }
                        return const CircularProgressIndicator();
                      }
                  ),

                ),
              ],
            ),
          ],
        ),
      ),
    ),);
  }

}

