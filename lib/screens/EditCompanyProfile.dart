import 'dart:convert';
import 'dart:io';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/hrhomepage.dart';
import 'package:Aap_job/screens/select_language.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Aap_job/providers/auth_provider.dart';
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
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:video_player/video_player.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:http/http.dart' as http;

class EditCompanyProfile extends StatefulWidget {
  EditCompanyProfile({Key? key}) : super(key: key);
  @override
  _EditCompanyProfileState createState() => new _EditCompanyProfileState();
}

class _EditCompanyProfileState extends State<EditCompanyProfile> {

  String? Imagepath, certificatepath="",pdfpath="";
  bool? fileselected, myexp;
  bool showoption=true,showgst=true,showpan=true,showfssai=true,showcomp=true,showshop=true,showmsme=true;
  bool selectedgst=false,selectedpan=false,selectedfssai=false,selectedcomp=false,selectedshop=false,selectedmsme=false;
  String filename="";
  String _hinttext="";
  String HrWebsite="";
  String Certificatetype="";
  String HrName="", HrCity="", HrAddress="", HrCompanyName="", HrLocality="";
  TextEditingController _gstController = TextEditingController();

  bool loaded=false;
  String pt="",emaile="";
  bool? _profileuploaded;
  File? file;
  Color button=Colors.amber;
  String? cityid;
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;
  bool _hasData=false;
  bool _hasLocation=false;
  String pathe="";
  var _isLoading=false;
  List<String> strarray =[];
  SharedPreferences? sharedPreferences;
  String? pdfFlePath;

  final ImagePicker _picker = ImagePicker();
  ImageCropper imageCropper= ImageCropper();
  PickedFile? _imageFile;
  CroppedFile? _cropedFile;
  @override
  void initState() {
    initializePreference().whenComplete((){
      setState(() {
        fileselected=false;
        _profileuploaded=false;
        button=Colors.amber;
        strarray = Provider.of<AuthProvider>(context, listen: false).getHrCompanyCertificate().split("/");
        if(strarray.last.toString().split(".").last.toString()=="pdf"){
          loadPdf();}
      });
    });

    super.initState();
  }

  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
  }
  TextEditingController _companyNameController = TextEditingController();

  Future<void> _fileipload() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf'],
    );

    if (result != null) {
      String? resumepath = result.files.single.path;

      setState(() {
        fileselected=true;
        filename=result.files.single.name;
        pt=resumepath!;
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
          print("Path: ${pdfpath}");
        }

      });
    } else {
      CommonFunctions.showInfoDialog("Please Select a file", context);
    }

  }


  _submit(String certificateno) async {
    setState(() {
      _isLoading=true;
    });
    file = File(pt);
    http.StreamedResponse response =  await updateHrCompanyProfile(file!,certificateno,_companyNameController.text);
    print("edit company response- ${response}");
  }


  Future<http.StreamedResponse> updateHrCompanyProfile(File file,String certificateno, String CompanyName) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.UPDATE_HR_COMPANY_PROFILE}'));
    request.files.add(await http.MultipartFile.fromPath("image", file.path));
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{'userid':Provider.of<AuthProvider>(context, listen: false).getUserid(),'companyname':CompanyName});
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print("response : ${value}");
      if (response.statusCode == 200) {
        if(response.toString()!="Failed")
        {
          sharedPreferences!.setString("HrCompanyCertificate", value.toString());
          sharedPreferences!.setString("HrCompanyName", CompanyName);
          sharedPreferences!.setString("HrGst", certificateno);
          setState(() {
            _profileuploaded=true;
            button=Colors.green;
            _isLoading=false;
          });
          Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context)=> HrHomePage()));
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

  Future<void> _savestep4() async {
    if(selectedgst) {
      if (_gstController.text
          .trim()
          .length == 15) {
        _submit(_gstController.text);

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
        _submit(_gstController.text);
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
        _submit(_gstController.text);
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
        _submit(_gstController.text);

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
        _submit(_gstController.text);
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
        _submit(_gstController.text);

      }
      else {
        setState(() {
          _isLoading = false;
          CommonFunctions.showSuccessToast('Please Enter a Valid MSME Number.');
        });
      }
    }

  }

  Future<String> downloadAndSavePdf() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${strarray.last}');
    if (await file.exists()) {
      print("existpath->"+file.path);
      return file.path;
    }
    String dfile=AppConstants.BASE_URL+Provider.of<AuthProvider>(context, listen: false).getHrCompanyCertificate();
    final response = await http.get(Uri.parse(dfile));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  void loadPdf() async {
    pdfFlePath = await downloadAndSavePdf();
    setState(() {
      loaded=true;
    });
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
                child: Text(getTranslated('EDIT_COMP_PROF', context)!,maxLines:2,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
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
                            Container(
                              width: deviceSize.width*0.4,
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
                                          Text(getTranslated('COMP_NAME', context)!,style: LatinFonts.aBeeZee(fontSize: 10,color: Primary,fontWeight: FontWeight.w900),),
                                        ]
                                    ),
                                    new Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            // width: MediaQuery.of(context).size.width*0.7,
                                            child:
                                            Text(Provider.of<AuthProvider>(context, listen: false).getHrCompanyName(),style: TextStyle(fontSize: 10,color: Primary,fontWeight: FontWeight.w900),),
                                          ),
                                        ]
                                    ),
                                    new Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(getTranslated('CERT_NO', context)!,style: LatinFonts.aBeeZee(fontSize: 10,color: Primary,fontWeight: FontWeight.w900),),
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
                                            Text(Provider.of<AuthProvider>(context, listen: false).getHrGST(),style: TextStyle(fontSize: 10,color: Primary,fontWeight: FontWeight.w900),maxLines: 4,),
                                          ),
                                        ]
                                    ),
                                    new Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(getTranslated('CERT_FILE', context)!,style: LatinFonts.aBeeZee(fontSize: 12,color: Primary,fontWeight: FontWeight.w900),maxLines: 4,),
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
                                            Text(strarray.last,style: TextStyle(fontSize: 12,color: Primary,fontWeight: FontWeight.w900),maxLines: 4,),
                                          ),
                                        ]
                                    ),
                                  ]
                              ),
                            ),
                            Container(
                              width: deviceSize.width*0.4,
                              child:

                              strarray.last.toString().split(".").last.toString()=="jpg" ?
                              Container(
                                //  decoration: new BoxDecoration(border: Border.all(color:Colors.black,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                                  width:deviceSize.width*0.3,
                                  height: deviceSize.width*0.3,
                                  child:CachedNetworkImage(
                                  width:deviceSize.width*0.3,
                                  height:deviceSize.width*0.3,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  imageUrl: AppConstants.BASE_URL+Provider.of<AuthProvider>(context, listen: false).getHrCompanyCertificate(),
                                )
                              )
                                  :
                                        strarray.last.toString().split(".").last.toString()=="pdf"
                                            ?
                                            loaded?
                                                  Container(
                                  //        decoration: new BoxDecoration(border: Border.all(color:Colors.black,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                                          width:deviceSize.width*0.3,
                                          height: deviceSize.width*0.3,
                                          child:PdfView(path: pdfFlePath!),
                                        )
                                                    :
                                            Container(
                                              //  decoration: new BoxDecoration(border: Border.all(color:Colors.black,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                                                width:deviceSize.width*0.3,
                                                height: deviceSize.width*0.3,
                                                child:CachedNetworkImage(
                                                  width:deviceSize.width*0.3,
                                                  height:deviceSize.width*0.3,
                                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                                  imageUrl:"https://app.aapjob.com/uploads/users/1.png",
                                                )
                                            )
                                            :
                            Container(),
                            ),
                          ]
                      ),

                    ),
                    SizedBox(height: 20,),
                    Container(
                      width: MediaQuery.of(context).size.width*0.6,
                      child: Text(getTranslated('ENTER_NEW_DETAILS', context)!,maxLines:2,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                      ),
                    ),
                    new Padding(
                      child:
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: CustomTextField(
                                  hintText: "Company Name",
                                  textInputType: TextInputType.text,
                                  isName: true,
                                  isOtp: false,
                                  maxLine: 1,
                                  capitalization: TextCapitalization.words,
                                  controller: _companyNameController,
                                  isValidator: true,
                                  validatorMessage: "Please Enter Company Name",
                                )),
                          ]
                      ),
                      padding: const EdgeInsets.all(5.0),
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
                            Text(getTranslated('NO_PERSONAL_DETAILS', context)!,style: TextStyle(color: Colors.white,fontSize: 10),),
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
                                              Text(getTranslated('VERIFICATION_REQUIRED', context)!,style: LatinFonts.aBeeZee(color: Primary,fontSize: 14,fontWeight: FontWeight.w600),),
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
                                              Text(getTranslated('MAKE_JOB_ACTIVE', context)!,style: LatinFonts.aBeeZee(color: Primary,fontSize: 10,fontWeight: FontWeight.w600),),
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
                                              Text(getTranslated('START_REC_CANDIDATE', context)!,style: LatinFonts.aBeeZee(color: Primary,fontSize: 10,fontWeight: FontWeight.w600),),
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
                                              Text(getTranslated('HELP_TO_MAINTAIN', context)!,style: LatinFonts.aBeeZee(color: Primary,fontSize: 10,fontWeight: FontWeight.w600),),
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
                                    isName: false,
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
                                child: fileselected! ? Text('Select Another File'):Text('Select file to Upload'),
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
                                      child: const Text('Update Details'),
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
                                          CommonFunctions.showInfoDialog('Please Enter Certificate Details Or Select file to upload',context);
                                        });

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
}