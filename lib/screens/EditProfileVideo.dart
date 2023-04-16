import 'dart:convert';
import 'dart:io';
import 'package:Aap_job/helper/uploader.dart';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/hrhomepage.dart';
import 'package:Aap_job/screens/select_language.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Aap_job/models/CitiesModel.dart';
import 'package:Aap_job/models/LocationModel.dart';
import 'package:Aap_job/models/common_functions.dart';

import 'package:Aap_job/screens/LocationSelectionScreen.dart';
import 'package:Aap_job/screens/hrloginscreen.dart';
import 'package:Aap_job/screens/loginscreen.dart';
import 'package:Aap_job/screens/profile_exp.dart';
import 'package:Aap_job/screens/widget/CitySelectionScreen.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/utill/dimensions.dart';
import 'package:Aap_job/view/basewidget/animated_custom_dialog.dart';
import 'package:Aap_job/view/basewidget/textfield/custom_textfield.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:http/http.dart' as http;

class EditProfileVideo extends StatefulWidget {
  EditProfileVideo({Key? key, required this.path, required this.usertype}) : super(key: key);
  final String path;
  final String usertype;

  @override
  _EditProfileVideoState createState() => new _EditProfileVideoState();
}

class _EditProfileVideoState extends State<EditProfileVideo> {
  VideoPlayerController? _controller;

  String pt="",emaile="";
  bool _profileuploaded=false;
  File? file;
  Color button=Colors.amber;
  String cityid="0";
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;
  bool _hasData=false;
  bool _hasLocation=false;
  String pathe="";
  var _isLoading=false;

  final ImagePicker _picker = ImagePicker();
  ImageCropper imageCropper= ImageCropper();
  PickedFile? _imageFile, _videoFile;
  SharedPreferences? sharedPreferences;
  bool isselect=false;

  @override
  void initState() {
    initializePreference().whenComplete((){
      setState(() {
        _profileuploaded=false;
        button=Colors.amber;
        if(pathe!="") {
          _controller = VideoPlayerController.file(File(pathe))
            ..initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setState(() {});
            });
          file = File(pathe);
        }
      });
    });

    super.initState();
  }

  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      pathe=widget.path;
    });
  }

  uploadFileVideo() async {

  }

  _submit(String path) async {
    setState(() {
      _isLoading=true;
    });
    print("path=${path}");
    file = File(path);
   http.StreamedResponse response =  await updateHrProfileVideo(file!);
   print("Edit Profile Response: ${response}");
   //  print("uploading to: "+AppConstants.SAVE_HR_PROFILE_VIDEO_DATA_URI);
   //  String taskId = await BackgroundUpload`er.uploadEnqueue(AppConstants.SAVE_HR_PROFILE_VIDEO_DATA_URI,file,Provider.of<AuthProvider>(context, listen: false).getUserid(),widget.usertype,"video");
   //  if (taskId != null) {
   //  } else {
   //    BackgroundUploader.uploader.cancelAll();
   //  }
    String pthe="";
  }

  Future<http.StreamedResponse> updateHrProfileVideo(File file) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.SAVE_HR_PROFILE_VIDEO_DATA_URI}'));
    request.files.add(await http.MultipartFile.fromPath("video", file.path));
    int userid=sharedPreferences!.getInt("userid")?? 0;
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{'userid':userid.toString(), 'usertype':widget.usertype,});
    request.fields.addAll(_fields);
    print("usertype-: "+widget.usertype);
    http.StreamedResponse response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print("response : "+value);
      if (response.statusCode == 200) {
        if(response.toString()!="Failed")
        {

          sharedPreferences!.setString("profileVideo", value);
          print("res->"+value);
          setState(() {
            _profileuploaded=true;
            button=Colors.green;
            _isLoading=false;
          });
          // Navigator.of(context).pop();
          if(widget.usertype=="HR")
            {
              print("back to :"+widget.usertype);
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context)=> HrHomePage()));
            }
          else
            {
              print("back to :"+widget.usertype);
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context)=> HomePage()));
            }

        }
        else
        {
          setState(() {
            _profileuploaded=true;
            _isLoading=false;
            CommonFunctions.showErrorDialog("Error in Uploading File", context);
          });
        }

      } else
      {
        setState(() {
          _isLoading=false;
        });

        print('${response.statusCode} ${response.reasonPhrase}');
        CommonFunctions.showErrorDialog("Error in Connection", context);
      }
    });
    return response;
  }


  // Future<void> _showSimpleDialog() async {
  //   await showDialog<void>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return SimpleDialog( // <-- SEE HERE
  //           title: const Text('Please Select file or Record Video'),
  //           children: <Widget>[
  //             SimpleDialogOption(
  //               padding: EdgeInsets.all(10.0),
  //               onPressed: () {
  //                 _fileipload();
  //               },
  //               child: const Text('Select From Gallery'),
  //             ),
  //             SimpleDialogOption(
  //               padding: EdgeInsets.all(10.0),
  //               onPressed: () {
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (builder) => CameraPage(path:widget.usertype)));
  //               },
  //               child: const Text('Record With Camera'),
  //             ),
  //             SimpleDialogOption(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('Cancel'),
  //             ),
  //           ],
  //         );
  //       });
  // }


  // Future<void> _fileipload() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['avi', 'mp4', 'mpeg','mov','3gp'],
  //   );
  //
  //   if (result != null) {
  //     String? resumepath = result.files.single.path;
  //     setState(() {
  //       pathe=resumepath!;
  //       if(pathe!="") {
  //         _controller = VideoPlayerController.file(File(pathe))
  //           ..initialize().then((_) {
  //             // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
  //             setState(() {});
  //           });
  //         file = File(pathe);
  //       }
  //     });
  //    Navigator.of(context).pop();
  //     // Navigator.push(
  //     //     context,
  //     //     MaterialPageRoute(
  //     //         builder: (builder) => EditProfileVideo(
  //     //           path: resumepath,
  //     //         )));
  //   } else {
  //    // Navigator.of(context).pop();
  //     CommonFunctions.showErrorDialog("Please Select a file", context);
  //   }
  //
  // }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    final TextStyle? textStyle = Theme
        .of(context)
        .textTheme
        .caption;

    return Container(
      decoration: new BoxDecoration(color: Primary),
      width: deviceSize.width-40,
      margin: EdgeInsets.all(5.0),
      child:
      SafeArea(
        child: Scaffold(
        appBar: AppBar(
    leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
        onPressed:()=>
           // Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => SelectLanguage(isHome: false,)),),),
        Navigator.of(context).pop(),),
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
                child: Text(getTranslated('EDIT_PROFILE_VIDEO', context)!,maxLines:2,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),

                ),
              ),
            ]
        ),
        ),
        backgroundColor: Colors.transparent,
        body:
        Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child:
              SingleChildScrollView(
                child:
                new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20,),
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          pathe==""?
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) => bottomSheet2()),
                              );
                            },
                            child: Container(
                                decoration: new BoxDecoration(color: Color.fromARGB(
                                    255, 204, 204, 204)),
                                width: deviceSize.width*0.8,
                                height: deviceSize.width*0.8,
                                padding: EdgeInsets.all(20.0),
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.upload,size: 50,color: Colors.white,),
                                      Text(getTranslated("CLICK_TO_UPLOAD_VIDEO", context)!),
                                    ]
                                )
                            ),
                          ):
                          Stack(
                            children: [
                              Container(
                                width: deviceSize.width*0.7,
                                height: deviceSize.width*0.7,
                                child: _controller!.value.isInitialized
                                    ? AspectRatio(
                                  aspectRatio: _controller!.value.aspectRatio,
                                  child: VideoPlayer(_controller!),
                                )
                                    : Container(),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _controller!.value.isPlaying
                                          ? _controller!.pause()
                                          : _controller!.play();
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 33,
                                    backgroundColor: Colors.black38,
                                    child: Icon(
                                      _controller!.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]
                    ),
                    pathe==""? Container(): new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: deviceSize.width-40,
                            padding: EdgeInsets.all(3.0),
                            child:
                            new Padding(
                              child:
                              new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    _isLoading? CircularProgressIndicator():
                                    ElevatedButton(
                                      child: const Text('Submit'),
                                      onPressed: () {
                                        _submit(pathe);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: new Size(deviceSize.width * 0.3,20),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16)),
                                          primary: button,
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          textStyle:
                                          const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

                                    ),

                                   _isLoading?Container(): ElevatedButton(
                                      child: const Text('Re Enter'),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: ((builder) => bottomSheet2()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: new Size(deviceSize.width * 0.3,20),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16)),
                                          primary: Colors.amber,
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          textStyle:
                                          const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

                                    ),
                                  ]

                              ),
                              padding: const EdgeInsets.all(10.0),
                            ),
                          ),
                        ]
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),),
    );
  }
  Widget bottomSheet2() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Please Select file or Record Video",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap:
                      () {
                    takeVideo(ImageSource.camera);
                  },
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Image.asset('assets/images/cemara.png',width: 30,height: 30,),
                    Text("Camera"),
                  ]),
                ),
                SizedBox(
                  width: 50,
                ),
                InkWell(
                  onTap:
                      () {
                    takeVideo(ImageSource.gallery);
                  },
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Image.asset('assets/images/gallery.png',width: 30,height: 30,),
                    Text("Gallery"),
                  ]),
                ),
              ])
        ],
      ),
    );
  }
  void takeVideo(ImageSource source) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final pickedFile = await _picker.getVideo(
      source: source,
      maxDuration: Duration(minutes:2),
    );
    if(pickedFile!=null) {
      String resumepath = pickedFile.path;
      final f = File(resumepath);
      int sizeInBytes = f.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      if (sizeInMb > 10)
      {
        setState(() {
          isselect=false;
        });
        CommonFunctions.showInfoDialog("Video Resume Size is more than 10 MB. Please Uplaod a resume less than 10 MB", context);
      }
      else {
        setState(() {
          _profileuploaded=false;
          print("_profileuploaded->"+_profileuploaded.toString());
          isselect=true;
          _videoFile = pickedFile;
          pathe=resumepath;
          sharedPreferences.setString("profileVideo", _videoFile!.path);
          if(pathe!="") {
            _controller = VideoPlayerController.file(File(pathe))
              ..initialize().then((_) {
                // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                setState(() {});
              });
            file = File(pathe);
          }
        });
        Navigator.pop(context);
      }
    }
    else
    {
      CommonFunctions.showInfoDialog("Please Select a file", context);
    }

  }
}