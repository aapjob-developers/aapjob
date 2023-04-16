import 'dart:convert';
import 'dart:io';
import 'package:Aap_job/localization/language_constrants.dart';
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
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:http/http.dart' as http;

class EditProfileImage extends StatefulWidget {
  EditProfileImage({Key? key, required this.usertype}) : super(key: key);
  final String usertype;

  @override
  _EditProfileImageState createState() => new _EditProfileImageState();
}

class _EditProfileImageState extends State<EditProfileImage> {


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


  SharedPreferences? sharedPreferences;

  final ImagePicker _picker = ImagePicker();
  ImageCropper imageCropper= ImageCropper();
  PickedFile? _imageFile;
  CroppedFile? _cropedFile;

  @override
  void initState() {
    initializePreference().whenComplete((){
      setState(() {
        _profileuploaded=false;
        button=Colors.amber;

      });
    });

    super.initState();
  }

  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
  }

  _submit(String path) async {
    setState(() {
      _isLoading=true;
    });

    print(path);
    // final sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences!.setString("profileVideo", path);
    file = File(path);
    http.StreamedResponse response =  await updateHrProfileVideo(file!);
    print(response.toString());
    String pthe="";
  }

  Future<http.StreamedResponse> updateHrProfileVideo(File file) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.SAVE_HR_PROFILE_IMAGE_DATA_URI}'));
    request.files.add(await http.MultipartFile.fromPath("image", file.path));
    int userid=sharedPreferences!.getInt("userid")?? 0;
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{'userid':userid.toString(), 'usertype':widget.usertype,});
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print("response : "+value);
      if (response.statusCode == 200) {
        if(response.toString()!="Failed")
        {
          sharedPreferences!.setString("profileImage", value.toString());
          setState(() {
            _profileuploaded=true;
            button=Colors.green;
            _isLoading=false;
          });
          // Navigator.of(context).pop();
          if(widget.usertype=="HR")
            {
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context)=> HrHomePage()));
            }
          else
            {
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

      } else {

        setState(() {
          _isLoading=false;
        });

        print('${response.statusCode} ${response.reasonPhrase}');

        CommonFunctions.showErrorDialog("Error in Connection", context);
      }
    });
    return response;
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
                child: Text(getTranslated('EDIT_PROFILE_DETAILS', context)!,maxLines:2,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),

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
                    imageProfile(),
                    _cropedFile==null
                        ?
                          Container()
                            :
                          new Row(
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    _isLoading? CircularProgressIndicator():
                                    ElevatedButton(
                                      child: const Text('Submit'),
                                      onPressed: () {
                                        _submit(_cropedFile!.path);
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

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        _cropedFile == null
            ?
        Lottie.asset(
          'assets/lottie/profilene.json',
          animate: true,)
            :

        CircleAvatar(
          radius: 150.0,
          backgroundImage:
          // _cropedFile == null
          //     ? AssetImage("assets/appicon.png")
          //     :
          FileImage(File(_cropedFile!.path)),
        ),
        Positioned(
          bottom: 50.0,
          right: 50.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 35.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
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
            "Choose Profile photo",
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
           takePhoto(ImageSource.camera);
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
                    takePhoto(ImageSource.gallery);
              },
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                Image.asset('assets/images/gallery.png',width: 30,height: 30,),
                Text("Gallery"),
              ]),
            ),

            // FlatButton.icon(
            //   icon: Icon(Icons.camera),
            //   onPressed: () {
            //     takePhoto(ImageSource.camera);
            //   },
            //   label: Text("Camera"),
            // ),
            // FlatButton.icon(
            //   icon: Icon(Icons.image),
            //   onPressed: () {
            //     takePhoto(ImageSource.gallery);
            //   },
            //   label: Text("Gallery"),
            // ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final pickedFile = await _picker.getImage(
      source: source,
    );
      if(pickedFile!=null) {
        final CroppedFile? croppedFile= await imageCropper.cropImage (
          sourcePath: pickedFile.path,
          cropStyle: CropStyle.circle,
          compressQuality: 30,
        );
        setState(() {
          if(croppedFile!=null) {
            _cropedFile = croppedFile;
            Navigator.pop(context);
          }
      });
    }
  }
}