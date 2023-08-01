
import 'dart:convert';
import 'dart:io';

import 'package:Aap_job/helper/uploader.dart';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/JobtypeSelect.dart';
import 'package:Aap_job/screens/profile_exp.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/providers/ads_provider.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/loginscreen.dart';
import 'package:Aap_job/screens/save_profile.dart';
import 'package:Aap_job/screens/videoApp.dart';
import 'package:Aap_job/screens/widget/adsView.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class ReUploadScreen extends StatefulWidget {
  ReUploadScreen({Key? key}) : super(key: key);
  @override
  _ReUploadScreenState createState() => new _ReUploadScreenState();
}

class _ReUploadScreenState extends State<ReUploadScreen> {
  bool fileselected=false;
  String Imagepath="", certificatepath="",pdfpath="";
  String filename="";
  var _isLoading = false;
  File? file;
  final _formKey = GlobalKey<FormState>();
  List<String> strarray =[];

  @override
  initState() {
    super.initState();
  }

  Future<void> _fileipload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
    );
    if (result != null) {
      String? resumepath = result.files.single.path;
      setState(() {
        Imagepath=resumepath!;
        fileselected=true;
        filename=result.files.single.name;
        print("filename:${filename}");
        file=File(resumepath!);
        if(result.files.single.extension=="jpg"||result.files.single.extension=="png"||result.files.single.extension=="jpeg")
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
      });

    } else {
      CommonFunctions.showInfoDialog("Please Select a file", context);
    }
  }

  _submit() async {
    setState(() {
      _isLoading=true;
    });
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
          sharedp.setString("resume", value);
          strarray=value.split('/');
          sharedp.setString("resumeName", strarray.last);
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

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return Container(
    decoration: new BoxDecoration(color: Primary),
    child:
    SafeArea(child: Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
            onPressed:()
            {
              Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => HomePage()),);}
        ),
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
              SizedBox(width: 5,),
              Container(
                width: MediaQuery.of(context).size.width*0.6,
                child: Text("Update Resume",maxLines:2,style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),
                ),
              ),
            ]
        ),
      ),
    backgroundColor: Colors.transparent,
    body:
    Form(
      key: _formKey,
      child: SingleChildScrollView(
        child:new Column(
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
                    Text(getTranslated("UPLOAD_RESUME", context)!,style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                  ]
              ),
              padding: const EdgeInsets.all(5.0),
            ),
            fileselected?
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
                      decoration: new BoxDecoration(border: Border.all(color:Colors.white,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                      width:deviceSize.width*0.9,
                      height: deviceSize.width*0.9,
                      child:PdfView(path: pdfpath),
                    )
                  ]

              ),
              padding: const EdgeInsets.all(5.0),
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
                      ElevatedButton(
                        child: fileselected? Text('Select Another File'):Text('Select file to Upload'),
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
                        child: const Text('Upload Resume'),
                        onPressed: () {
                          setState(() {
                          _isLoading=true;
                          });
                          fileselected
                          ?
                          _submit()
                              :
                          setState(() {
                          _isLoading=false;
                          CommonFunctions.showSuccessToast('Please Select file to upload');
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
    ),
    );

  }
}




