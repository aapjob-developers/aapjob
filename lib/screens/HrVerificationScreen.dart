
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Aap_job/helper/uploader.dart';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/CurrentPlanModel.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/hr_save_profile.dart';
import 'package:Aap_job/screens/hrloginscreen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/providers/ads_provider.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/hrhomepage.dart';
import 'package:Aap_job/screens/loginscreen.dart';
import 'package:Aap_job/screens/save_profile.dart';
import 'package:Aap_job/screens/videoApp.dart';
import 'package:Aap_job/screens/widget/Profilebox.dart';
import 'package:Aap_job/screens/widget/adsView.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:provider/provider.dart';
import 'package:Aap_job/view/basewidget/textfield/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:intl/intl.dart';

class HrVerificationScreen extends StatefulWidget {
  HrVerificationScreen({Key? key}) : super(key: key);
  @override
  _HrVerificationScreenState createState() => new _HrVerificationScreenState();
}

class _HrVerificationScreenState extends State<HrVerificationScreen> {

  SharedPreferences? sharedPreferences;
  String? Imagepath,videopath, certificatepath="",pdfpath="";
  bool? fileselected=false, myexp;
  bool showoption=true,showgst=true,showpan=true,showfssai=true,showcomp=true,showshop=true,showmsme=true;
  bool selectedgst=false,selectedpan=false,selectedfssai=false,selectedcomp=false,selectedshop=false,selectedmsme=false;
  String filename="";
  String _hinttext="";
   String HrWebsite="";
   String Certificatetype="";
  String HrName="", HrCity="", HrAddress="", HrCompanyName="", HrLocality="";
  var _isLoading = false;
  TextEditingController _gstController = TextEditingController();
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;
File? file,videofile;
  File pdffile  = File('...');
  String? email, AccessToken;

  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';


  List<RecruiterPackage> duplicateJobsModel = <RecruiterPackage>[];
  @override
  initState() {
    super.initState();
    initializePreference().whenComplete((){
      setState(() {
        _isLoading=false;
        fileselected=false;
        HrName= sharedPreferences!.getString("HrName")?? "no Name";
        HrCity= sharedPreferences!.getString("HrCity")?? "no City";
        HrAddress= sharedPreferences!.getString("HrAddress")?? "no Address";
        HrCompanyName = sharedPreferences!.getString("HrCompanyName") ?? "no Company Name";
        HrLocality = sharedPreferences!.getString("HrLocality") ?? "no Locality";
        HrWebsite = sharedPreferences!.getString("HrWebsite") ?? "no Website";
        Imagepath=sharedPreferences!.getString("profileImage")?? "no Name";
        email=sharedPreferences!.getString("email")?? "email";
        AccessToken=sharedPreferences!.getString("AccessToken")?? "email";
        videopath=sharedPreferences!.getString("profileVideo")?? "no Name";
        getRecruiterlist();
         uploadProfileFile();
         uploadFileVideo();
      });
    });
  }

  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
  }

  uploadFile() async {
    String taskId = await BackgroundUploader.uploadEnqueue(AppConstants.UPDATE_HR_COMPANY_PROFILE,file!,Provider.of<AuthProvider>(context, listen: false).getUserid(),HrCompanyName,"image");
    if (taskId != null) {
    } else {
      BackgroundUploader.uploader.cancelAll();
    }
  }

  uploadFileVideo() async {
    print("uploading to: "+AppConstants.SAVE_HR_PROFILE_VIDEO_DATA_URI);
    videofile=File(videopath!);
    String taskId = await BackgroundUploader.uploadEnqueue(AppConstants.SAVE_HR_PROFILE_VIDEO_DATA_URI,videofile!,Provider.of<AuthProvider>(context, listen: false).getUserid(),"HR","video");
    if (taskId != null) {
    } else {
      BackgroundUploader.uploader.cancelAll();
    }
  }

  uploadProfileFile() async {
    file=File(Imagepath!);
    String taskId = await BackgroundUploader.uploadEnqueue(AppConstants.SAVE_HR_PROFILE_IMAGE_DATA_URI,file!,Provider.of<AuthProvider>(context, listen: false).getUserid(),"HR","image");
    if (taskId != null) {
    } else {
      BackgroundUploader.uploader.cancelAll();
    }
  }

  Future<void> _loadData(BuildContext context) async {
    await Provider.of<AdsProvider>(context, listen: false).getAds(context);
  }

  Future<void> _savestep4() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if(selectedgst) {
      if (_gstController.text
          .trim()
          .length == 15) {
        sharedPreferences!.setBool("step4", true);
        sharedPreferences!.setString("HrGst", _gstController.text);
        route();

      }
      else {
        setState(() {
          _isLoading = false;
          CommonFunctions.showSuccessToast('Please Enter a Valid GST Number.');
        });
      }
    }

    if(selectedpan) {
      if (_gstController.text
          .trim()
          .length == 10) {
        sharedPreferences!.setBool("step4", true);
        sharedPreferences!.setString("HrGst", _gstController.text);
        route();
      }
      else {
        setState(() {
          _isLoading = false;
          CommonFunctions.showSuccessToast('Please Enter a Valid Pan Number.');
        });
      }
    }

    if(selectedfssai) {
      if (_gstController.text
          .trim()
          .length == 14) {
        sharedPreferences!.setBool("step4", true);
        sharedPreferences!.setString("HrGst", _gstController.text);
        route();
      }
      else {
        setState(() {
          _isLoading = false;
          CommonFunctions.showSuccessToast('Please Enter a Valid Fssai Number.');
        });
      }
    }

    if(selectedcomp) {
      if (_gstController.text
          .trim()
          .length == 21) {
        sharedPreferences!.setBool("step4", true);
        sharedPreferences!.setString("HrGst", _gstController.text);
        route();

      }
      else {
        setState(() {
          _isLoading = false;
          CommonFunctions.showSuccessToast('Please Enter a Valid CIN Number.');
        });
      }
    }

    if(selectedshop) {
      if (_gstController.text
          .trim()
          .length == 6) {
        sharedPreferences!.setBool("step4", true);
        sharedPreferences!.setString("HrGst", _gstController.text);
        route();
      }
      else {
        setState(() {
          _isLoading = false;
          CommonFunctions.showSuccessToast('Please Enter a Valid Certificate Number.');
        });
      }
    }
    if(selectedmsme) {
      if (_gstController.text
          .trim()
          .length == 12) {
        sharedPreferences!.setBool("step4", true);
        sharedPreferences!.setString("HrGst", _gstController.text);
        route();

      }
      else {
        setState(() {
          _isLoading = false;
          CommonFunctions.showSuccessToast('Please Enter a Valid MSME Number.');
        });
      }
    }

  }

  Future<void> _fileipload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf'],
    );

    if (result != null) {
    String? resumepath = result.files.single.path;
    sharedPreferences!.setString("certificate", resumepath!);

    setState(() {
    fileselected=true;
    filename=result.files.single.name;
    file=File(resumepath);
        if(result.files.single.extension=="jpg")
        {
          certificatepath=result.files.single.path;
          pdfpath="";
        }
        else
        {
          certificatepath="";
          pdfpath=result.files.single.path;
          print("Path: "+pdfpath!);
        }
    });

    } else {
    CommonFunctions.showInfoDialog("Please Select a file", context);
    }
  }

  // loadDocument() async {
  //   doc = await PDFDocument.fromFile(pdffile);
  // }

  route() async {
    uploadFile();
    await Provider.of<ProfileProvider>(context, listen: false).updateHrInfo().then((response) {
      if (response.isSuccess) {
        print("Going to submit");
        _submit();
        // setState(() {
        //   _isLoading = false;
        // });
        // sharedPreferences!.setBool("loggedin",true);
        // print(" plan "+duplicateJobsModel[0].days+" | "+duplicateJobsModel[0].name);
        //   sharedPreferences!.setString("HrplanType", "r");
        //   sharedPreferences!.setString("RDays", duplicateJobsModel[0].days);
        //   sharedPreferences!.setString("ROriginalPrice",duplicateJobsModel[0].originalPrice);
        //   sharedPreferences!.setString("RDiscountedPrice", duplicateJobsModel[0].discountPrice);
        //   sharedPreferences!.setString("RProfilePerApp", duplicateJobsModel[0].profilePerApplication);
        //   sharedPreferences!.setString("RtotalJobPost", duplicateJobsModel[0].totalJobPost);
        //   sharedPreferences!.setString("RType", duplicateJobsModel[0].type);
        //   sharedPreferences!.setString("HrplanId", duplicateJobsModel[0].id);
        //   sharedPreferences!.setString("HrplanIcon", duplicateJobsModel[0].iconSrc);
        // sharedPreferences!.setString("HrplanName", duplicateJobsModel[0].name);
        // DateTime now = DateTime.now();
        // String formattedDate = DateFormat('yyyyy-MM-dd').format(now);
        // sharedPreferences!.setString("HrPurchaseDate", formattedDate);
        // Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => HrHomePage()),);
      } else {
        setState(() {
          _isLoading = false;
        });
        CommonFunctions.showErrorDialog(response.message, context);
      }
    });
  }

  _submit() async {
    String acctype="hr";
    await Provider.of<AuthProvider>(context, listen: false).checkaccount(acctype,email!, AccessToken!, routers);
  }

  routers(bool isRoute, String route,String status, String errorMessage) async {
    print(route);
    sharedPreferences!.setString("route", route);
    if (isRoute) {
      sharedPreferences!.setBool("loggedin", true);
      Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => HrHomePage()),);
    } else {
      CommonFunctions.showErrorDialog(errorMessage,context);
      setState(() {
        _isLoading = false;
      });
    }

  }

  bool _hasdataModel=false;
  getRecruiterlist() async {
    duplicateJobsModel.clear();
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.HR_RECRUITER_PLAN_URI);
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
            duplicateJobsModel.add(RecruiterPackage.fromJson(jobs)));
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
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    final TextStyle? textStyle = Theme
        .of(context)
        .textTheme
        .caption;
    _loadData(context);

    return Container(
      decoration: new BoxDecoration(color: Primary),
      child:
      SafeArea(child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
            onPressed:()=> Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => HrSaveProfile(path: "")),),),
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
                  child: Text("+91 "+Provider.of<AuthProvider>(context, listen: false).getMobile(),maxLines:2,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),

                  ),
                ),
              ]
          ),
        ),
        backgroundColor: Colors.transparent,
        body:
        SingleChildScrollView(
          child:new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                width: MediaQuery.of(context).size.width*0.9,
                padding: const EdgeInsets.all(5.0),
                decoration: new BoxDecoration(boxShadow: [new BoxShadow(
                  color: Colors.white,
                  blurRadius: 5.0,
                ),],color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child:
                new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                     // Profilebox(path:Provider.of<ProfileProvider>(context, listen: false).getProfileString()==null? AppConstants.BASE_URL+'uploads/ads/smallest_video4.mp4': Provider.of<ProfileProvider>(context, listen: false).getProfileString(),),
                      imageProfile(Imagepath!),
                      Container(
                        width: deviceSize.width*0.41,
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(HrName,style: TextStyle(fontSize: 24,color: Primary,fontWeight: FontWeight.w900),),
                                  ]
                              ),
                              new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                              Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child:
                                    Text(HrCompanyName,style: TextStyle(fontSize: 18,color: Primary,fontWeight: FontWeight.w900),),
                              ),
                                  ]
                              ),
                              new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(Icons.pin_drop_sharp,size: 20,),
                                    Text("  "+HrCity,style: TextStyle(fontSize: 16,color: Primary),),
                                  ]
                              ),
                              SizedBox(height: 3,),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.4,
                                      child:
                                      Text(" "+HrLocality,style: TextStyle(fontSize: 14,color: Primary,fontWeight: FontWeight.bold),),),
                                  ]
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.4,
                                      child:
                                      Text(" "+HrAddress,style: TextStyle(fontSize: 14,color: Primary,fontWeight: FontWeight.bold),),),
                                  ]
                              ),
                              SizedBox(height: 3,),
                              new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(Icons.public,size: 15,),
                                    Text(" "+HrWebsite,style: TextStyle(fontSize: 14,color: Primary),),
                                  ]
                              ),
                            ]
                        ),
                      ),
                    ]
                ),

              ),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        width: deviceSize.width * 0.8,
                        // padding: EdgeInsets.all(16.0),
                        child:
                        Text(getTranslated("UPLOAD_ANY_ONE_DOC", context)!,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                      ),
                    ]
                ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      width: deviceSize.width * 0.8,
                      // padding: EdgeInsets.all(16.0),
                      child:
                      Text("(Note: Do Not upload your personal documents )",style: TextStyle(color: Colors.white,fontSize: 10),),
                    ),
                  ]
              ),
              Container(
                width: deviceSize.width,
                padding: EdgeInsets.all(3.0),
                child:
                new Padding(
                  child:
                  new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        showgst?
                       GestureDetector(
                         onTap: (){
                           setState(() {
                             showpan=false;
                             showgst=false;
                             showfssai=false;
                             showcomp=false;
                             showshop=false;
                             showmsme=false;
                             showoption=false;
                             selectedpan=false;
                             selectedgst=true;
                             selectedfssai=false;
                             selectedcomp=false;
                             selectedshop=false;
                             selectedmsme=false;
                             _hinttext="Enter Company GST Certificate";
                           });
                         },
                         child:
                         Container(
                           decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                           padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                           margin: EdgeInsets.all(5),
                           child:
                           new Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               mainAxisSize: MainAxisSize.max,
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: <Widget>[
                                // Icon(Icons.file_copy,size: 30,color: Colors.pink,),
                                 new Image.asset(
                                   'assets/images/gst.png',
                                   fit: BoxFit.contain,
                                   height: 30,
                                   width: 30,
                                 ),
                                 Container(
                                   padding: EdgeInsets.symmetric(vertical: 10),
                                   width: deviceSize.width * 0.6,
                                   // padding: EdgeInsets.all(16.0),
                                   child:
                                   Text("Company GST Certificate ",style: TextStyle(color: Primary,fontSize: 14),),
                                 ),
                               ]
                           ),
                         ),

                       ):
                        selectedgst? Container(
                          decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          margin: EdgeInsets.all(5),
                          child:
                          new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                              //  Icon(Icons.file_copy,size: 30,color: Colors.pink,),
                                new Image.asset(
                                  'assets/images/gst.png',
                                  fit: BoxFit.contain,
                                  height: 30,
                                  width: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  width: deviceSize.width * 0.6,
                                  // padding: EdgeInsets.all(16.0),
                                  child:
                                  Text("Company GST Certificate ",style: TextStyle(color: Primary,fontSize: 14),),
                                ),
                                GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        showpan=true;
                                        showfssai=true;
                                        showcomp=true;
                                        showshop=true;
                                        showmsme=true;
                                        showoption=true;
                                        showgst=true;

                                        selectedpan=false;
                                        selectedgst=false;
                                        selectedfssai=false;
                                        selectedcomp=false;
                                        selectedshop=false;
                                        selectedmsme=false;
                                      });
                                    },
                                    child:
                                    Icon(Icons.highlight_off_sharp,size: 30,color: Colors.black,),
                                ),
                              ]
                          ),
                        ):Container(),

                        showpan?
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              showgst=false;
                              showpan=false;
                              showfssai=false;
                              showcomp=false;
                              showshop=false;
                              showmsme=false;
                              showoption=false;
                              selectedpan=true;
                              selectedgst=false;
                              selectedfssai=false;
                              selectedcomp=false;
                              selectedshop=false;
                              selectedmsme=false;
                              _hinttext="Enter Company PAN Number";
                            });
                          },
                          child:
                          Container(
                            decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            margin: EdgeInsets.all(5),
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Image.asset(
                                    'assets/images/pan.png',
                                    fit: BoxFit.contain,
                                    height: 30,
                                    width: 30,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    width: deviceSize.width * 0.5,
                                    // padding: EdgeInsets.all(16.0),
                                    child:
                                    Text("Company PAN Card ",style: TextStyle(color: Primary,fontSize: 16),),
                                  )
                                ]
                            ),
                          ),

                        ):
                        selectedpan?Container(
                          decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          margin: EdgeInsets.all(5),
                          child:
                          new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Image.asset(
                                  'assets/images/pan.png',
                                  fit: BoxFit.contain,
                                  height: 30,
                                  width: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  width: deviceSize.width * 0.5,
                                  // padding: EdgeInsets.all(16.0),
                                  child:
                                  Text("Company PAN Card ",style: TextStyle(color: Primary,fontSize: 16),),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      showpan=true;
                                      showfssai=true;
                                      showcomp=true;
                                      showshop=true;
                                      showmsme=true;
                                      showoption=true;
                                      showgst=true;

                                      selectedpan=false;
                                      selectedgst=false;
                                      selectedfssai=false;
                                      selectedcomp=false;
                                      selectedshop=false;
                                      selectedmsme=false;
                                    });
                                  },
                                  child:
                                  Icon(Icons.highlight_off_sharp,size: 30,color: Colors.black,),
                                ),
                              ]
                          ),
                        ):Container(),


                        showfssai?
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              showgst=false;
                              showfssai=false;
                              showpan=false;
                              showcomp=false;
                              showshop=false;
                              showmsme=false;
                              showoption=false;

                              selectedpan=false;
                              selectedgst=false;
                              selectedfssai=true;
                              selectedcomp=false;
                              selectedshop=false;
                              selectedmsme=false;
                              _hinttext="Enter FSSAI Certificate Number";
                            });
                          },
                          child:
                          Container(
                            decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            margin: EdgeInsets.all(5),
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Image.asset(
                                    'assets/images/fssai.png',
                                    fit: BoxFit.contain,
                                    height: 30,
                                    width: 30,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    width: deviceSize.width * 0.6,
                                    // padding: EdgeInsets.all(16.0),
                                    child:
                                    Text("FSSAI Certificate ",style: TextStyle(color: Primary,fontSize: 16),),
                                  ),
                                ]
                            ),
                          ),

                        ):
                        selectedfssai?Container(
                          decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          margin: EdgeInsets.all(5),
                          child:
                          new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Image.asset(
                                  'assets/images/fssai.png',
                                  fit: BoxFit.contain,
                                  height: 30,
                                  width: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  width: deviceSize.width * 0.5,
                                  // padding: EdgeInsets.all(16.0),
                                  child:
                                  Text("Company PAN Card ",style: TextStyle(color: Primary,fontSize: 16),),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      showpan=true;
                                      showfssai=true;
                                      showcomp=true;
                                      showshop=true;
                                      showmsme=true;
                                      showoption=true;
                                      showgst=true;

                                      selectedpan=false;
                                      selectedgst=false;
                                      selectedfssai=false;
                                      selectedcomp=false;
                                      selectedshop=false;
                                      selectedmsme=false;
                                    });
                                  },
                                  child:
                                  Icon(Icons.highlight_off_sharp,size: 30,color: Colors.black,),
                                ),
                              ]
                          ),
                        ):Container(),

                        showcomp?
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              showgst=false;
                              showpan=false;
                              showfssai=false;
                              showcomp=false;
                              showshop=false;
                              showmsme=false;
                              showoption=false;

                              selectedpan=false;
                              selectedgst=false;
                              selectedfssai=false;
                              selectedcomp=true;
                              selectedshop=false;
                              selectedmsme=false;
                              _hinttext="Enter Company Incorporation Number";
                            });
                          },
                          child:
                          Container(
                            decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            margin: EdgeInsets.all(5),
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Image.asset(
                                    'assets/images/company.png',
                                    fit: BoxFit.contain,
                                    height: 30,
                                    width: 30,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    width: deviceSize.width * 0.6,
                                    // padding: EdgeInsets.all(16.0),
                                    child:
                                    Text("Company Incorporation Certificate ",style: TextStyle(color: Primary,fontSize: 16),),
                                  ),
                                ]
                            ),
                          ),

                        ):
                        selectedcomp?Container(
                          decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          margin: EdgeInsets.all(5),
                          child:
                          new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Image.asset(
                                  'assets/images/company.png',
                                  fit: BoxFit.contain,
                                  height: 30,
                                  width: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  width: deviceSize.width * 0.6,
                                  // padding: EdgeInsets.all(16.0),
                                  child:
                                  Text("Company Incorporation Certificate ",style: TextStyle(color: Primary,fontSize: 16),),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      showpan=true;
                                      showfssai=true;
                                      showcomp=true;
                                      showshop=true;
                                      showmsme=true;
                                      showoption=true;
                                      showgst=true;

                                      selectedpan=false;
                                      selectedgst=false;
                                      selectedfssai=false;
                                      selectedcomp=false;
                                      selectedshop=false;
                                      selectedmsme=false;
                                    });
                                  },
                                  child:
                                  Icon(Icons.highlight_off_sharp,size: 30,color: Colors.black,),
                                ),
                              ]
                          ),
                        ):Container(),


                        showshop?
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              showgst=false;
                              showpan=false;
                              showfssai=false;
                              showcomp=false;
                              showshop=false;
                              showmsme=false;
                              showoption=false;

                              selectedpan=false;
                              selectedgst=false;
                              selectedfssai=false;
                              selectedcomp=false;
                              selectedshop=true;
                              selectedmsme=false;
                              _hinttext="Enter Shop & Establishment Certificate Number";
                            });
                          },
                          child:
                          Container(
                            decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            margin: EdgeInsets.all(5),
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Image.asset(
                                    'assets/images/shop.png',
                                    fit: BoxFit.contain,
                                    height: 30,
                                    width: 30,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    width: deviceSize.width * 0.6,
                                    // padding: EdgeInsets.all(16.0),
                                    child:
                                    Text("Shop & Establishment Certificate ",style: TextStyle(color: Primary,fontSize: 16),),
                                  ),
                                ]
                            ),
                          ),

                        ):
                        selectedshop?Container(
                          decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          margin: EdgeInsets.all(5),
                          child:
                          new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Image.asset(
                                  'assets/images/shop.png',
                                  fit: BoxFit.contain,
                                  height: 30,
                                  width: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  width: deviceSize.width * 0.6,
                                  // padding: EdgeInsets.all(16.0),
                                  child:
                                  Text("Shop & Establishment Certificate ",style: TextStyle(color: Primary,fontSize: 16),),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      showpan=true;
                                      showfssai=true;
                                      showcomp=true;
                                      showshop=true;
                                      showmsme=true;
                                      showoption=true;
                                      showgst=true;

                                      selectedpan=false;
                                      selectedgst=false;
                                      selectedfssai=false;
                                      selectedcomp=false;
                                      selectedshop=false;
                                      selectedmsme=false;
                                    });
                                  },
                                  child:
                                  Icon(Icons.highlight_off_sharp,size: 30,color: Colors.black,),
                                ),
                              ]
                          ),
                        ):Container(),


                        showmsme?
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              showgst=false;
                              showpan=false;
                              showfssai=false;
                              showcomp=false;
                              showshop=false;
                              showmsme=false;
                              showoption=false;

                              selectedpan=false;
                              selectedgst=false;
                              selectedfssai=false;
                              selectedcomp=false;
                              selectedshop=false;
                              selectedmsme=true;
                              _hinttext="Enter MSME Registration Number";
                            });
                          },
                          child:
                          Container(
                            decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            margin: EdgeInsets.all(5),
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Image.asset(
                                    'assets/images/msme.png',
                                    fit: BoxFit.contain,
                                    height: 30,
                                    width: 30,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    width: deviceSize.width * 0.6,
                                    // padding: EdgeInsets.all(16.0),
                                    child:
                                    Text("MSME Registration Certificate ",style: TextStyle(color: Primary,fontSize: 16),),
                                  ),
                                ]
                            ),
                          ),

                        ):
                        selectedmsme?Container(
                          decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          margin: EdgeInsets.all(5),
                          child:
                          new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Image.asset(
                                  'assets/images/msme.png',
                                  fit: BoxFit.contain,
                                  height: 30,
                                  width: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  width: deviceSize.width * 0.6,
                                  // padding: EdgeInsets.all(16.0),
                                  child:
                                  Text("MSME Registration Certificate ",style: TextStyle(color: Primary,fontSize: 16),),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      showpan=true;
                                      showfssai=true;
                                      showcomp=true;
                                      showshop=true;
                                      showmsme=true;
                                      showoption=true;
                                      showgst=true;

                                      selectedpan=false;
                                      selectedgst=false;
                                      selectedfssai=false;
                                      selectedcomp=false;
                                      selectedshop=false;
                                      selectedmsme=false;
                                    });
                                  },
                                  child:
                                  Icon(Icons.highlight_off_sharp,size: 30,color: Colors.black,),
                                ),
                              ]
                          ),
                        ):Container(),


                        showoption?
                        Container(
                          decoration: new BoxDecoration(color: Colors.lightGreenAccent,border: Border.all(color:Primary,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.all(10),
                          margin:EdgeInsets.all(5),
                          child:
                              Column(
                                children: [
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child:
                                          Text("Verification is required to:",style: LatinFonts.aBeeZee(color: Primary,fontSize: 14,fontWeight: FontWeight.w600),),
                                        ),
                                      ]
                                  ),
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.check_circle,size: 10,color: Colors.blue,),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 2),
                                          child:
                                          Text("Make your job post active",style: LatinFonts.aBeeZee(color: Primary,fontSize: 10,fontWeight: FontWeight.w600),),
                                        ),
                                      ]
                                  ),
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.check_circle,size: 10,color: Colors.blue,),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 2),
                                          child:
                                          Text(getTranslated("START_REC_CANDI", context)!,style: LatinFonts.aBeeZee(color: Primary,fontSize: 10,fontWeight: FontWeight.w600),),
                                        ),
                                      ]
                                  ),
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.check_circle,size: 10,color: Colors.blue,),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 2),
                                          child:
                                          Text(getTranslated("HELP_TO_MAINTAIN", context)!,style: LatinFonts.aBeeZee(color: Primary,fontSize: 10,fontWeight: FontWeight.w600),),
                                        ),
                                      ]
                                  ),
                                ],
                              )

                        ):
                        Container(),
                      ]

                  ),
                  padding: const EdgeInsets.all(5.0),
                ),
              ),
          showoption?
          Container()
              :
          Container(
            child:

            new Padding(
              child:
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: CustomTextField(
                          hintText: _hinttext,
                          textInputType: TextInputType.text,
                          isOtp: false,
                          maxLine: 1,
                          capitalization: TextCapitalization.characters,
                          controller: _gstController,
                          // textInputAction: TextInputAction.next,
                        )),
                  ]
              ),
              padding: const EdgeInsets.all(5.0),
            ),
          ),
              fileselected!?
              new Padding(
                child:
                new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: deviceSize.width*0.8,
                        child:
                        Text(filename,style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),),
                      )
                    ]

                ),
                padding: const EdgeInsets.all(5.0),
              ): Container(),
              certificatepath==""?
              Container():
              new Padding(
                child:
                new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width:deviceSize.width*0.8,
                       child:
                       Image.file(
                           File(certificatepath!)),
                        )
                    ]

                ),
                padding: const EdgeInsets.all(5.0),
              ),
              pdfpath==""?
              Container():
              new Padding(
                child:
                new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: new BoxDecoration(border: Border.all(color:Colors.white,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                        width:deviceSize.width*0.9,
                       height: deviceSize.width*0.9,
                       child:PdfView(path: pdfpath!),
                        )
                    ]

                ),
                padding: const EdgeInsets.all(5.0),
              ),
                  showoption?Container():
              Container(
                width: deviceSize.width,
                padding: EdgeInsets.all(3.0),
                child:
                new Padding(
                  child:
                  new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          child: fileselected!? Text('Select Another File'):Text('Select file to Upload'),
                          onPressed: () {
                            _fileipload();
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: new Size(deviceSize.width * 0.5,20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              primary: Colors.amber,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              textStyle:
                              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                        ),

                      ]

                  ),
                  padding: const EdgeInsets.all(5.0),
                ),
              ),
              Container(
                width: deviceSize.width,
                padding: EdgeInsets.all(3.0),
                child:
                new Padding(
                  child:
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        if (_isLoading)
                          CircularProgressIndicator()
                        else
                          ElevatedButton(
                            child: const Text('Save'),
                            onPressed: () {
                              setState(() {
                                _isLoading=true;
                              });
                              fileselected!
                                  ?
                              _savestep4()
                                  :
                              setState(() {
                                _isLoading=false;
                                CommonFunctions.showSuccessToast('Please Enter Certificate Details Or Select file to upload');
                              });

                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: new Size(deviceSize.width * 0.5,20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                primary: Colors.amber,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                textStyle:
                                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),

                      ]

                  ),
                  padding: const EdgeInsets.all(10.0),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
  Widget imageProfile(String _imageFile) {
    return Center(
      child: Stack(children: <Widget>[
      _imageFile == null?
        CircleAvatar(
        radius: 50.0,
        backgroundImage: AssetImage("assets/appicon.png"),
      )
        :
        CircleAvatar(
          radius: 50.0,
          backgroundImage: FileImage(File(_imageFile)),
        ),

      ]),
    );
  }
}