import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/ContentModel.dart';
import 'package:Aap_job/models/JobsModel.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/providers/content_provider.dart';
import 'package:Aap_job/screens/EditJobProfileDetails.dart';
import 'package:Aap_job/screens/EditProfileImage.dart';
import 'package:Aap_job/screens/EditProfileVideo.dart';
import 'package:Aap_job/screens/MyAppliedJobs.dart';
import 'package:Aap_job/screens/MyInterviewCalls.dart';
import 'package:Aap_job/screens/homePageController.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/widget/ChangeLocationScreen.dart';
import 'package:Aap_job/screens/widget/VideoPopup.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:Aap_job/screens/basewidget/VideoPlayerScreen.dart';
import 'package:Aap_job/screens/select_language.dart';
import 'package:Aap_job/screens/ShareAppScreen.dart';
import 'package:Aap_job/screens/widget/sign_out_confirmation_dialog.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'EditProfileDetails.dart';
import 'EditProfileVideo.dart';
import 'package:dio/dio.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:http/http.dart' as http;

class ProfileHomeScreen extends StatefulWidget {
  ProfileHomeScreen({Key? key}) : super(key: key);
  @override
  _ProfileHomeScreenState createState() => new _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  final HomePageController dashboard = HomePageController();
  SharedPreferences? sharedPreferences;
  String Name="", jobcity="", joblocation="", company="", expyears="", eduvalue="",collegename="",degree="", route="";
  bool myexp=false;
  final ImagePicker _picker = ImagePicker();
  String jobtitle="Fresher";
  String filename="",filenn="";
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata,shortapidata;
  String? _imageFile;
  var _isLoading = false;
  File? file;
  late Future<void> _launched;
  final ReceivePort _port = ReceivePort();
  List<JobsModel> Jobslist = <JobsModel>[];
  bool _hasJobsModel=false;
  static bool _hasnewshort=false;
  int numberofshortlist=0,newshort=0;
  String? pdfFlePath;
  List<String> strarray =[];
  String Imagepath="", certificatepath="",pdfpath="";

  @override
  initState() {
    initializePreference().whenComplete((){
      setState(() {
        Name= sharedPreferences!.getString("name")?? "no Name";
        jobcity= sharedPreferences!.getString("jobcity")?? "no Name";
        joblocation= sharedPreferences!.getString("joblocation")?? "no Name";
        _imageFile=sharedPreferences!.getString("profileImage")?? "no Name";
        myexp=sharedPreferences!.getBool("myexp")?? false;
        if(myexp) {
          jobtitle = sharedPreferences!.getString("jobtitle") ?? "no";
          company = sharedPreferences!.getString("companyname") ?? "no";
          expyears = sharedPreferences!.getString("totalexp") ?? "no";
        }
        eduvalue=sharedPreferences!.getString("education") ?? "no";
        degree=sharedPreferences!.getString("degree") ?? " ";
        collegename=sharedPreferences!.getString("university") ?? " ";
        route=sharedPreferences!.getString("route") ?? "Register";
        numberofshortlist= sharedPreferences!.getInt("numberofshortlist")?? 0;
        if(Provider.of<ProfileProvider>(context, listen: false).getResumeString()==""||Provider.of<ProfileProvider>(context, listen: false).getResumeString()==null||Provider.of<ProfileProvider>(context, listen: false).getResumeString()=="uploads/candidate_resume/docs/SampleResume.pdf")
        {

        }
          else {
          strarray = Provider.of<ProfileProvider>(context, listen: false).getResumeString().split("/");
          print("strarray->${strarray.last}");
          String tt=AppConstants.BASE_URL+Provider.of<ProfileProvider>(context, listen: false).getResumeString();
          print("full->${tt}");
          if (strarray.last
              .toString()
              .split(".")
              .last
              .toString() == "pdf") {
            loadPdf();
          }
        }
       // print(AppConstants.BASE_URL+Provider.of<ProfileProvider>(context, listen: false).getProfileString());
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

    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {

      });
    });
    super.initState();
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

  Future<String> downloadAndSavePdf() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${strarray.last}');
    if (await file.exists()) {
      return file.path;
    }
    final response = await http.get(Uri.parse(AppConstants.BASE_URL+Provider.of<ProfileProvider>(context, listen: false).getResumeString()));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  void loadPdf() async {
    pdfFlePath = await downloadAndSavePdf();
    setState(() {});
  }



  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
   // await Provider.of<ContentProvider>(context, listen: false).getResumeContent(context);
    await getCategoryJob();
  }


  getCategoryJob() async {
    Jobslist.clear();
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.MY_INTERVIEW_CALLS_URI+Provider.of<AuthProvider>(context, listen: false).getUserid());
      shortapidata = response.data;
      print('JobsModelList : ${shortapidata}');
      List<dynamic> data=json.decode(shortapidata);
      if(data.toString()=="[]")
      {
        Jobslist=[];
        setState(() {
          _hasJobsModel = false;
        });
      }
      else
      {
        data.forEach((jobs) =>
            Jobslist.add(JobsModel.fromJson(jobs)));
        setState(() {
          _hasJobsModel=true;
          sharedPreferences!.setInt("numberofshortlist",Jobslist.length);
        });
        if(Jobslist.length>numberofshortlist)
          {
            setState(() {
              _hasnewshort=true;
              sharedPreferences!.setInt("numberofshortlist",Jobslist.length);
              newshort=Jobslist.length-numberofshortlist;
            });
          }
        else
          {
            setState(() {
              sharedPreferences!.setInt("numberofshortlist",Jobslist.length);
            });
          }
      }
      print('Jobtitle List: ${Jobslist}');

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

  _removeresume() async {
    http.StreamedResponse response =  await removeResume();
    print(response.toString());
  }
  _submit(String path) async {
    setState(() {
      _isLoading=true;
    });
    print(path);
    file = File(path);
    http.StreamedResponse response =  await updateResume(file!);
    print(response.toString());
  }

  Future<http.StreamedResponse> updateResume(File file) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.SAVE_RESUME_DATA_URI}'));
    request.files.add(await http.MultipartFile.fromPath("resume", file.path));
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{'userid':Provider.of<AuthProvider>(context, listen: false).getUserid()});
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print("response : "+value);
      if (response.statusCode == 200) {
        if(response.toString()!="Failed")
        {
          print("submit response->"+response.toString());
          print("value->"+value.toString());
          print("filenn->"+filenn.toString());
          sharedPreferences!.setString("resume", value);
          strarray=value.split('/');
          sharedPreferences!.setString("resumeName", strarray.last);
          setState(() {
            _isLoading=false;
          });
          Navigator.of(context).pop();
        }
        else
        {
          setState(() {
            _isLoading=false;
            CommonFunctions.showErrorDialog("Error in Uploading File", context);
          });
        }

      }
      else {

        setState(() {
          _isLoading=false;
        });

        print('${response.statusCode} ${response.reasonPhrase}');

        CommonFunctions.showErrorDialog("Error in Connection", context);
      }
    });
    return response;
  }

  Future<http.StreamedResponse> removeResume() async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.SAVE_RESUME_DATA_URI}'));
    String userid=Provider.of<AuthProvider>(context, listen: false).getUserid();
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{'userid':userid});
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print("response : "+value);
      if (response.statusCode == 200) {
        if(response.toString()!="Failed")
        {
          sharedPreferences!.setString("resume", "");
          sharedPreferences!.setString("resumeName", "");;
          Navigator.of(context).pop();
        }
        else
        {
          setState(() {
            _isLoading=false;
            CommonFunctions.showErrorDialog("Error in Removing Resume", context);
          });
        }

      } else {
        print('${response.statusCode} ${response.reasonPhrase}');
        CommonFunctions.showErrorDialog("Error in Connection", context);
      }
    });
    return response;
  }
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return
      WillPopScope(
        onWillPop: () async{
          dashboard.selectedInde=1;
      Navigator.push( context,  MaterialPageRoute(builder: (context) => HomePage()),);
      return false;
    },
        child:
      SafeArea(
        child: Scaffold(
        body:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          new Container(
            width: deviceSize.width-3,
          padding: const EdgeInsets.all(5.0),
          decoration: new BoxDecoration(boxShadow: [new BoxShadow(
            color: Primary,
            blurRadius: 5.0,
          ),],color: Primary,),
          child:
              Column(
                children: [
                  // new Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     mainAxisSize: MainAxisSize.max,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Text("Change Profile Videos",style: LatinFonts.roboto(color:Colors.white),),
                  //       GestureDetector(
                  //         onTap: (){
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (builder) => EditProfileVideo(path: "", usertype:"candidate")));
                  //         },
                  //         child:
                  //         Icon(Icons.mode_edit,size: 25,color: Colors.white,),
                  //       ),
                  //
                  //     ]
                  // ),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Change Profile Image",style: LatinFonts.roboto(color:Colors.white),),
                        // GestureDetector(
                        //   onTap: (){
                        //     // Navigator.push(
                        //     //     context,
                        //     //     MaterialPageRoute(
                        //     //         builder: (builder) => EditProfileVideo(path: "", usertype:"candidate")));
                        //   },
                        //   child:
                        //   Icon(Icons.mode_edit,size: 25,color: Colors.white,),
                        // ),

                      ]
                  ),
                  SizedBox(height: 5,),
                  // new Container(
                  //   width: deviceSize.width*0.6,
                  //   height: deviceSize.width*0.6,
                  //   padding: const EdgeInsets.all(5.0),
                  //   decoration: new BoxDecoration(boxShadow: [new BoxShadow(
                  //     color: Colors.white,
                  //     blurRadius: 5.0,
                  //   ),],color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  //   child:
                  //   new Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       mainAxisSize: MainAxisSize.max,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: <Widget>[
                  //         route=="Login"
                  //         ?
                  //     VideoPlayerScreen(isLocal:false,width:deviceSize.width*0.5,height:deviceSize.width*0.5,urlLandscapeVideo: AppConstants.BASE_URL+Provider.of<ProfileProvider>(context, listen: false).getProfileString(),)
                  // :
                  //         //VideoPlayerScreen(isLocal:true,width:deviceSize.width*0.5,height:deviceSize.width*0.5,urlLandscapeVideo:Provider.of<ProfileProvider>(context, listen: false).getProfileString(),),
                  //         Profilebox(path:Provider.of<ProfileProvider>(context, listen: false).getProfileString()==null? AppConstants.BASE_URL+'uploads/ads/smallest_video4.mp4': Provider.of<ProfileProvider>(context, listen: false).getProfileString(),),
                  //       ]
                  //   ),
                  // ),
                  imageProfile(),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap:(){
                            VideoPopup(
                                title: Provider.of<ContentProvider>(context, listen: false).contentList[0].internalVideoSrc!,
                            ).show(context);
                          },
                          child:
                          FadeInImage.assetNetwork(
                            width: MediaQuery.of(context).size.width*0.9,
                            height: MediaQuery.of(context).size.width*0.18,
                            placeholder: 'assets/images/no_data.png',
                            image:AppConstants.BASE_URL+ Provider.of<ContentProvider>(context, listen: false).contentList[0].imgSrc!,
                            fit: BoxFit.contain,
                          ),
                        )
                      ]),
                  new Container(
                    width: deviceSize.width*0.9,
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.01),
                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02,top: MediaQuery.of(context).size.width*0.01,right: MediaQuery.of(context).size.width*0.02,bottom: MediaQuery.of(context).size.width*0.01),
                    decoration: new BoxDecoration(boxShadow: [new BoxShadow(
                      color: Colors.white,
                      blurRadius: 5.0,
                    ),], gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.purple.shade900,
                          Primary,
                        ]),
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.01))),
                    child:
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container( width: deviceSize.width*0.85,
                         // padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.01),
                          child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(Name,style: LatinFonts.aclonica(color:Colors.white,fontSize: MediaQuery.of(context).size.width*0.05 ),),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (builder) => EditJobProfileDetails()));
                                        },
                                        child:
                                        Icon(Icons.mode_edit,size: MediaQuery.of(context).size.width*0.07,color: Colors.white,),
                                      ),
                                    ]
                                ),
                                SizedBox(height: MediaQuery.of(context).size.width*0.01,),
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.account_circle,size: MediaQuery.of(context).size.width*0.04,color: Colors.white,),
                                      SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                                      new Container(
                                        width: deviceSize.width*0.7-10,
                                        child:
                                        myexp?
                                        Text(jobtitle+" at "+company ,style: LatinFonts.lato(color:Colors.white,fontSize: MediaQuery.of(context).size.width*0.03 ),):
                                        Text(jobtitle,style: LatinFonts.lato(color:Colors.white,fontSize: MediaQuery.of(context).size.width*0.03 ),),

                                      ),
                                    ]
                                ),
                                SizedBox(height: MediaQuery.of(context).size.width*0.02,),
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.account_balance,size: MediaQuery.of(context).size.width*0.04, color: Colors.white,),
                                      SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                                      new Container(
                                        width: deviceSize.width*0.7-10,
                                        child:
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(eduvalue,style: LatinFonts.lato(color:Colors.white,fontSize: MediaQuery.of(context).size.width*0.03,fontWeight: FontWeight.w600 ),),
                                            myexp? Text("  |  "+ expyears +" Years experience",style: LatinFonts.lato(color:Colors.white,fontSize: MediaQuery.of(context).size.width*0.03 ),):Container(),
                                          ],
                                        ),
                                      ),
                                    ]
                                ),
                                SizedBox(height: MediaQuery.of(context).size.width*0.02,),
                                degree!=" "?new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.school,size: MediaQuery.of(context).size.width*0.04, color: Colors.white,),
                                      SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                                      new Container(
                                        width: deviceSize.width*0.6,
                                        child:
                                        Text(degree+" from "+collegename ,style: LatinFonts.lato(color:Colors.white,fontSize: MediaQuery.of(context).size.width*0.03 ),),
                                      ),
                                    ]
                                ):Container(),
                                Container(
                                //  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*0.02),
                                  child: Divider(color: Colors.white,thickness: 2,),
                                ),
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.pin_drop_rounded,size: MediaQuery.of(context).size.width*0.05, color: Colors.yellow,),
                                            SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                                            new Container(
                                              width: deviceSize.width*0.5-10,
                                              child:
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(joblocation,style: LatinFonts.lato(color:Colors.white,fontSize: MediaQuery.of(context).size.width*0.02 ),),
                                                  Text(jobcity,style: LatinFonts.lato(color:Colors.white,fontSize: MediaQuery.of(context).size.width*0.03, ),)
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(context,  MaterialPageRoute(builder: (context)=> ChangeLocationScreen(CurrentCity: Provider.of<AuthProvider>(context, listen: false).getJobCity(), CurrentLocation:Provider.of<AuthProvider>(context, listen: false).getJobLocation(),usertype: "candidate")));
                                        },
                                        child:
                                        Icon(Icons.mode_edit,size: MediaQuery.of(context).size.width*0.05,color: Colors.white,),
                                      ),
                                    ]
                                ),
                                Container(
                                  //  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*0.02),
                                  child: Divider(color: Colors.white,thickness: 2,),
                                ),
                                Provider.of<ProfileProvider>(context, listen: false).getProfileString()==""||Provider.of<ProfileProvider>(context, listen: false).getProfileString()==null||Provider.of<ProfileProvider>(context, listen: false).getProfileString()=="no video"
                                    ?
                                GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) => EditProfileVideo(path: "", usertype:"candidate")));
                                    },
                                    child:
                                    new Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Column(children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(Icons.video_camera_back_rounded,size: 20, color: Colors.yellow,),
                                                SizedBox(width: 10,),
                                                new Container(
                                                    width: deviceSize.width*0.6-10,
                                                    child:
                                                    Text(getTranslated("ADD_YOUR_VIDEO_RESUME", context)!,style: LatinFonts.lato(color:Colors.white,fontSize: 14 ),)
                                                ),
                                              ],
                                            )
                                          ],),
                                          Icon(Icons.add,size: 25,color: Colors.white,),
                                        ]
                                    )
                                )
                                    :
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(children: [
                                        InkWell(
                                            onTap: (){
                                              VideoPopup(
                                                  title: Provider.of<ProfileProvider>(context, listen: false).getProfileString()
                                              ).show(context);
                                            },
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(Icons.video_camera_back_rounded,size: 20, color: Colors.yellow,),
                                                SizedBox(width: 10,),
                                                new Container(
                                                    width: deviceSize.width*0.6-10,
                                                    child:
                                                    Text(getTranslated("CLICK_TO_VIEW_VIDEO_RESUME", context)!,style: LatinFonts.lato(color:Colors.white,fontSize: 14),)
                                                ),
                                                Icon(Icons.play_circle,size: 20, color: Colors.yellow,),
                                              ],
                                            )
                                        ),

                                      ],),

                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (builder) => EditProfileVideo(path: "", usertype:"candidate")));
                                        },
                                        child:
                                        Icon(Icons.mode_edit,size: 25,color: Colors.white,),
                                      ),


                                    ]
                                ),
                                Container(
                                  //  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*0.02),
                                  child: Divider(color: Colors.white,thickness: 2,),
                                ),
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(Icons.fact_check_rounded,size: 20, color: Colors.blue,),
                                                SizedBox(width: 10,),
                                                new Container(
                                                    width: deviceSize.width*0.6-10,
                                                    child:
                                                    Text("Document Resume",style: LatinFonts.lato(color:Colors.white,fontSize: 14),)
                                                ),
                                              ],
                                            )

                                      ],),

                                      GestureDetector(
                                        onTap: (){
                                          showModalBottomSheet(
                                            context: context,
                                            builder: ((builder) => bottomSheet()),
                                          );
                                        },
                                        child:
                                        Icon(Icons.mode_edit,size: 25,color: Colors.white,),
                                      ),


                                    ]
                                ),

                              ]
                          ),
                          ),

                        ]
                    ),

                  ),
                  Container(
                   // padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(color: Colors.white,thickness: 2,),
                  ),
                ],
              ),


          ),
              Divider(
                thickness: 1.2,
              ),
              Padding(padding: EdgeInsets.all(10),
              child:
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => MyAppliedJobs()));
                    },
                    child:
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(getTranslated('My_Applied_jobs', context)!,style: LatinFonts.aBeeZee(fontSize: 14,fontWeight: FontWeight.bold, color: Color.fromARGB(255,39, 170, 225))),
                          Lottie.asset(
                            'assets/lottie/arrowright.json',
                            height: MediaQuery.of(context).size.width*0.08,
                            width: MediaQuery.of(context).size.width*0.08,
                            animate: true,),
                        ]

                    ),
                  ),
                  ),
                  Divider(
                    thickness: 1.2,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _hasnewshort=false;
                      });
                      if(Provider.of<AuthProvider>(context, listen: false).setCurrentShortlistCount(Jobslist.length))
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => MyInterviewCalls(Jobslist: Jobslist,)));
                    },
                    child:
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(getTranslated('MY_SHORT_LIST', context)!,style: LatinFonts.aBeeZee(fontSize: 14,fontWeight: FontWeight.bold, color: Color.fromARGB(255,39, 170, 225))),
                                _hasJobsModel==true?
                                Jobslist.length==Provider.of<AuthProvider>(context, listen: false).getCurrentShortlistCount()
                                ?
                                Container()
                                    :
                                        CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.red,
                                  child:Text((Jobslist.length-Provider.of<AuthProvider>(context, listen: false).getCurrentShortlistCount()).toString(),style: LatinFonts.aBeeZee(fontSize: 10,fontWeight: FontWeight.bold)),
                                )

                                    :
                                Container(),
                              ],
                            ),
                            Lottie.asset(
                              'assets/lottie/arrowright.json',
                              height: MediaQuery.of(context).size.width*0.08,
                              width: MediaQuery.of(context).size.width*0.08,
                              animate: true,),
                          ]

                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1.2,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push( context,  MaterialPageRoute(builder: (context) => SelectLanguage(isHome: true)));
                    },
                    child:
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(getTranslated('CHANGE_LANGUAGE', context)!,style: LatinFonts.aBeeZee(fontSize: 14,fontWeight: FontWeight.bold,color: Color.fromARGB(255,39, 170, 225))),
                            Lottie.asset(
                              'assets/lottie/arrowright.json',
                              height: MediaQuery.of(context).size.width*0.08,
                              width: MediaQuery.of(context).size.width*0.08,
                              animate: true,),
                          ]

                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1.2,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push( context,  MaterialPageRoute(builder: (context) => ShareAppScreen()));
                    },
                    child:
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(getTranslated('Rate_and_Share', context)!,style: LatinFonts.aBeeZee(fontSize: 14,fontWeight: FontWeight.bold,color: Color.fromARGB(255,39, 170, 225))),
                            Lottie.asset(
                              'assets/lottie/arrowright.json',
                              height: MediaQuery.of(context).size.width*0.08,
                              width: MediaQuery.of(context).size.width*0.08,
                              animate: true,),
                          ]

                      ),
                    ),
                  ),
                ],
              ),
              ),
              SizedBox(height: 20,),
              new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Logout'),
              onPressed: () => showAnimatedDialog(context, SignOutConfirmationDialog(), isFlip: true),
              style: ElevatedButton.styleFrom(
                  minimumSize: new Size(deviceSize.width * 0.5,20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  primary: Colors.amber,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            ),
            ],),


            ],
          ),
        ),
    ),
      ),)
    ;
  }
  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        Provider.of<AuthProvider>(context, listen: false).getprofileImage()=="no profileImage"?
        CircleAvatar(
          radius: MediaQuery.of(context).size.width*0.2,
          backgroundImage: AssetImage("assets/appicon.png"),
        ) :
        CircleAvatar(
          radius: MediaQuery.of(context).size.width*0.2,
          backgroundImage: NetworkImage(AppConstants.BASE_URL+Provider.of<AuthProvider>(context, listen: false).getprofileImage()),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.width*0.04,
          right: MediaQuery.of(context).size.width*0.04,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => EditProfileImage(usertype:"candidate")));
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: MediaQuery.of(context).size.width*0.07,
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child:
      Provider.of<ProfileProvider>(context, listen: false).getResumeString()==""||Provider.of<ProfileProvider>(context, listen: false).getResumeString()==null||Provider.of<ProfileProvider>(context, listen: false).getResumeString()=="uploads/candidate_resume/docs/SampleResume.pdf"
        ?
              filename==""
              ?
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Upload your resume",
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              "only HRs on AapJob can view",
                              style: TextStyle(
                                color: Colors.black26,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          label: Text("Close"),
                        ),
                      ]),
                  GestureDetector(
                    onTap: (){
                      _fileipload();
                    },
                    child: Container(
                      //decoration: new BoxDecoration(border: Border.all(color: Colors.blueAccent),borderRadius: BorderRadius.all(Radius.circular(20))),
                      height: MediaQuery.of(context).size.width*0.6,
                      width: MediaQuery.of(context).size.width*0.6,
                      child:
                      Center(child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                    new Image.asset(
                                      'assets/images/pdficon.png',
                                      fit: BoxFit.contain,
                                      height: MediaQuery.of(context).size.width*0.2,
                                      width: MediaQuery.of(context).size.width*0.2,
                                    ),
                             // Icon(Icons.upload, color: Colors.blueAccent,size: MediaQuery.of(context).size.width*0.1,),
                              Text("Please Click Here Upload a Resume",style: LatinFonts.aBeeZee(color:Colors.grey),textAlign: TextAlign.center,)
                            ],
                          ),
                      ),
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tips for a good resume",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width-30,
                              child: Text(
                                "* Your name and mobile number should be mentioned in the resume",
                                maxLines: 3,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width-30,
                              child: Text(
                                "* Highlight important details about your work & education",
                                maxLines: 3,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width-30,
                              child: Text(
                                "* Try top keep your resume to 1-2 pages only",
                                maxLines: 3,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ],
                        ),

                      ]),
                ],
              )
              :
              Column(
                children: <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Submit your resume",
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              "only HRs on AapJob can view",
                              style: TextStyle(
                                color: Colors.black26,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          label: Text("Close"),
                        ),
                      ]),
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
                            width:MediaQuery.of(context).size.width*0.6,
                            height: MediaQuery.of(context).size.width*0.6,
                            child:
                            Image.file(
                                File(certificatepath)),
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
                           // decoration: new BoxDecoration(border: Border.all(color:Colors.white,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                            width:MediaQuery.of(context).size.width*0.6,
                            height: MediaQuery.of(context).size.width*0.6,
                            child:PdfView(path: pdfpath),
                          )
                        ]

                    ),
                    padding: const EdgeInsets.all(5.0),
                  ),
                  // Container(
                  //   decoration: new BoxDecoration(color: Colors.grey.shade300,border: Border.all(color: Colors.blueAccent),borderRadius: BorderRadius.all(Radius.circular(20))),
                  //   height: MediaQuery.of(context).size.width*0.6,
                  //   width: MediaQuery.of(context).size.width*0.6,
                  //   child:
                  //   Center(child:
                  //   Column(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       Icon(Icons.upload, color: Colors.blueAccent,size: MediaQuery.of(context).size.width*0.1,),
                  //       Text(filenn,style: LatinFonts.aBeeZee(color:Colors.grey),textAlign: TextAlign.center,)
                  //     ],
                  //   ),
                  //   ),
                  // ),
                  _isLoading?
                  CircularProgressIndicator():
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width*0.35,
                          decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 2),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6),bottomLeft:Radius.circular(6), bottomRight: Radius.circular(6) ),),
                          margin: EdgeInsets.all(5),
                          child:
                          TextButton.icon(
                            icon: Icon(Icons.delete_rounded,color: Colors.red,),
                            onPressed: () {
                              setState(() {
                                filename="";
                                Navigator.pop(this.context);

                                showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => bottomSheet()),
                                );
                              });
                              },
                            label: Text("Remove",style: LatinFonts.aBeeZee(color: Colors.red,fontSize:12),),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width*0.35,
                          decoration: BoxDecoration(border: Border.all(color: Colors.green,width: 2),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6),bottomLeft:Radius.circular(6), bottomRight: Radius.circular(6) ),),
                          margin: EdgeInsets.all(5),
                          child:
                          TextButton.icon(
                            icon: Icon(Icons.upload,color: Colors.green,),
                            onPressed: () {
                              setState(() {
                                _isLoading=true;
                              });
                              _submit(filename);
                            },
                            label: Text("Submit",style: LatinFonts.aBeeZee(color: Colors.green,fontSize:12),),
                          ),
                        ),

                      ])
                ],
              )
        :
      Column(
        children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Resume",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              Text(
                "only HRs on AapJob can view",
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          TextButton.icon(
            icon: Icon(Icons.clear),
            onPressed: () {
              Navigator.of(context).pop();
            },
            label: Text("Close"),
          ),
        ]),
          // Container(
          //   decoration: new BoxDecoration(color: Colors.grey.shade300,border: Border.all(color: Colors.blueAccent),borderRadius: BorderRadius.all(Radius.circular(20))),
          //   height: MediaQuery.of(context).size.width*0.6,
          //   width: MediaQuery.of(context).size.width*0.6,
          //   child:
          //   Center(child:
          //
          //   // Column(
          //   //   crossAxisAlignment: CrossAxisAlignment.center,
          //   //   mainAxisAlignment: MainAxisAlignment.center,
          //   //   children: <Widget>[
          //   //   //  Icon(Icons.import_contacts, color: Colors.green,size: MediaQuery.of(context).size.width*0.1,),
          //   //     new Image.asset(
          //   //       'assets/images/pdficon.png',
          //   //       fit: BoxFit.contain,
          //   //       height: MediaQuery.of(context).size.width*0.1,
          //   //       width: MediaQuery.of(context).size.width*0.1,
          //   //     ),
          //   //     Text(Provider.of<ProfileProvider>(context, listen: false).getResumeName(),style: LatinFonts.aBeeZee(color:Colors.grey),textAlign: TextAlign.center,)
          //   //   ],
          //   // ),
          //   ),
          // ),
          Container(
            // height: MediaQuery.of(context).size.width*0.6,
            width: MediaQuery.of(context).size.width*0.5,
            child:
            strarray.last.toString().split(".").last.toString()=="jpg" ?
            Container(
               // decoration: new BoxDecoration(border: Border.all(color:Colors.black,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                width:MediaQuery.of(context).size.width*0.5,
                height: MediaQuery.of(context).size.width*0.5,
                child:CachedNetworkImage(
                  width:MediaQuery.of(context).size.width*0.5,
                  height:MediaQuery.of(context).size.width*0.5,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  imageUrl: AppConstants.BASE_URL+Provider.of<ProfileProvider>(context, listen: false).getResumeString(),
                )
            )
                :
            strarray.last.toString().split(".").last.toString()=="pdf"
                ?
            Container(
            //  decoration: new BoxDecoration(border: Border.all(color:Colors.black,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
              width:MediaQuery.of(context).size.width*0.5,
              height:MediaQuery.of(context).size.width*0.5,
              child:PdfView(path: pdfFlePath!),
            )

                :
            Container(),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width*0.35,
                    decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 2),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6),bottomLeft:Radius.circular(6), bottomRight: Radius.circular(6) ),),
                    margin: EdgeInsets.all(5),
                    child:
                TextButton.icon(
                  icon: Icon(Icons.delete_rounded,color: Colors.red,),
                  onPressed: () {
                    setState(() {
                      filename="";
                      filenn="";
                      _removeresume();
                      Navigator.pop(this.context);
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet()),
                      );
                    });
                  },
                  label: Text("Reupload",style: LatinFonts.aBeeZee(color: Colors.red,fontSize:12),),
                ),),
                Container(
                    width: MediaQuery.of(context).size.width*0.35,
                    decoration: BoxDecoration(border: Border.all(color: Colors.green,width: 2),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6),bottomLeft:Radius.circular(6), bottomRight: Radius.circular(6) ),),
                    margin: EdgeInsets.all(5),
                    child:
                TextButton.icon(
                  icon: Icon(Icons.download_for_offline_rounded,color: Colors.green,),
                  onPressed: () {
                   // _downloadAndSaveFile(Provider.of<ProfileProvider>(context, listen: false).getResumeString(),Provider.of<ProfileProvider>(context, listen: false).getResumeName());
                    requestDownload(AppConstants.BASE_URL+Provider.of<ProfileProvider>(context, listen: false).getResumeString(),Provider.of<ProfileProvider>(context, listen: false).getResumeName());
                  },
                  label: Text("Download",style: LatinFonts.aBeeZee(color: Colors.green,fontSize:12),),
                ),
                ),
              ])
        ],
      ),

    );
  }

  static Future<void> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    print("path:"+filePath);
    final Response response = await Dio().get(AppConstants.BASE_URL+url, options: Options(responseType: ResponseType.bytes));
    final File file = File(filePath);
    await file.writeAsBytes(response.data);
    List<String> strarray = filePath.split("/");
    CommonFunctions.showSuccessToast(strarray.last+" downloaded successfully");
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
      ).then((value) async {
        bool waitTask = true;
        while (waitTask) {
          String query = "SELECT * FROM task WHERE task_id='" + value! + "'";
          var _tasks =
          await FlutterDownloader.loadTasksWithRawQuery(query: query);
          String taskStatus = _tasks![0].status.toString();
          int taskProgress = _tasks[0].progress;
          if (taskStatus == "DownloadTaskStatus(3)" && taskProgress == 100) {
            waitTask = false;
          }
        }
        await FlutterDownloader.open(taskId: value!);
      });
      CommonFunctions.showSuccessToast("Resume is Downloading...");
      Navigator.pop(context);
    //  final Uri _vrl = Uri.parse(_url);
     // _launched = _launchInWebViewOrVC(_vrl);
    }
    else
    {
      CommonFunctions.showInfoDialog("Permission not Granted for downloding", context);
    }

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

  // void takePhoto(ImageSource source) async {
  //   final sharedPreferences = await SharedPreferences.getInstance();
  //   final pickedFile = await _picker.getImage(
  //     source: source,
  //   );
  //   setState(() {
  //     if(pickedFile!=null) {
  //       _imageFile = pickedFile;
  //       Navigator.pop(context);
  //     }
  //   });
  // }
  void _fileipload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg','pdf'],
    );
    setState(() {
    if (result != null) {
      String? resumepath = result.files.single.path;
        filename=resumepath!;
        filenn=result.files.single.name;
      file=File(resumepath);
      if(result.files.single.extension=="jpg")
      {
        certificatepath=result.files.single.path!;
        pdfpath="";
      }
      else
      {
        certificatepath="";
        pdfpath=result.files.single.path!;
        print("Path: "+pdfpath);
      }
      Navigator.pop(context);
      showModalBottomSheet(
        context: context,
        builder: ((builder) => bottomSheet()),
      );
    }
    });
  }
}