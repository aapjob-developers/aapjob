import 'dart:convert';
import 'dart:io';
import 'package:Aap_job/localization/language_constrants.dart';
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
import 'package:video_player/video_player.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:http/http.dart' as http;


class EditProfileDetails extends StatefulWidget {
  EditProfileDetails({Key? key}) : super(key: key);
  @override
  _EditProfileDetailsState createState() => new _EditProfileDetailsState();
}

class _EditProfileDetailsState extends State<EditProfileDetails> {

  int _value = 0;
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

  String Name = "";
  String jobcity = "";
  String address = "";
  String companyname = "";
  String locality = "";
  String website = "";

  SharedPreferences? sharedPreferences;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _jobcityController = TextEditingController();
  TextEditingController _jobloczController = TextEditingController();
  TextEditingController _localityController = TextEditingController();
  TextEditingController _websiteController = TextEditingController();

  FocusNode locationnode = FocusNode();
  FocusNode addressnode = FocusNode();

  List<CityModel> duplicateItems = <CityModel>[];
  List<LocationModel> duplicatelocation = <LocationModel>[];

  getcities() async {
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.CITIES_URI);
      apidata = response.data;
      print('City List: ${apidata}');
      List<dynamic> data=json.decode(apidata);

      if(data.toString()=="[]")
      {
        duplicateItems=[];
      }
      else
      {
        data.forEach((city) =>
            duplicateItems.add(CityModel.fromJson(city)));
      }
      print('City List: ${duplicateItems}');

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

  getlocation() async {
    duplicatelocation.clear();
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.CITY_LOCATION_URI+cityid);
      apidata = response.data;
      print('Location : ${apidata}');
      List<dynamic> data=json.decode(apidata);
      if(data.toString()=="[]")
      {
        duplicatelocation=[];
        setState(() {
          _hasLocation = false;
        });
      }
      else
      {
        data.forEach((location) =>
            duplicatelocation.add(LocationModel.fromJson(location)));
      setState(() {
      _hasLocation=true;
      });
      }
      print('Location List: ${duplicatelocation}');

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
    initializePreference().whenComplete((){
      setState(() {
        _profileuploaded=false;
        getcities();
        button=Colors.amber;
        _nameController.text=Name;
        _jobcityController.text=jobcity;
        _jobloczController.text=address;
        _companyNameController.text=companyname;
        _localityController.text=locality;
        _websiteController.text=website;

      });
    });

    super.initState();
  }

  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
    emaile= sharedPreferences!.getString("email")?? "no mail";
    Name= sharedPreferences!.getString("HrName")?? "no mail";
    jobcity= sharedPreferences!.getString("HrCity")?? "no mail";
    address= sharedPreferences!.getString("HrAddress")?? "no mail";
    companyname= sharedPreferences!.getString("HrCompanyName")?? "no mail";
    locality= sharedPreferences!.getString("HrLocality")?? "no mail";
    website= sharedPreferences!.getString("HrWebsite")?? "no mail";
  }


  Future<void> _savestep2() async {
    setState(() {
      _isLoading=true;
    });

    String _Name = _nameController.text.trim();
    String _jobcity = _jobcityController.text.trim();
    String _address = _jobloczController.text.trim();
    String _companyname = _companyNameController.text.trim();
    String _locality = _localityController.text.trim();
    String _website = _websiteController.text.trim();

    if (_Name.isEmpty||_jobcity.isEmpty||_address.isEmpty||_companyname.isEmpty||_locality.isEmpty)
    {
      CommonFunctions.showErrorDialog("Please fill All Details 2", context);
      setState(() {
        _isLoading=false;
      });
    }
    else{

      http.StreamedResponse response =  await updateHrProfileDetails(_website,_address,_Name,_companyname,_jobcity,_locality);

    }

  }




  Future<http.StreamedResponse> updateHrProfileDetails(String HrWebsite,String HrAddress,String HrName,String HrCompanyName,String HrCity,String HrLocality) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.SAVE_HR_PROFILE_DETAIL_DATA_URI}'));
    int userid=sharedPreferences!.getInt("userid")?? 0;
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'userid':userid.toString(),
      'HrWebsite':HrWebsite,
      'HrAddress':HrAddress,
      'HrName':HrName,
      'HrCompanyName':HrCompanyName,
      'HrCity':HrCity,
      'HrLocality':HrLocality
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print("response : "+value);

      if (response.statusCode == 200) {
        if(response.toString()!="Failed")
        {
          setState(() {
            _profileuploaded=true;
            _isLoading=false;
          });
          sharedPreferences!.setString("HrName", HrName);
          sharedPreferences!.setString("HrCity", HrCity);
          sharedPreferences!.setString("HrAddress", HrAddress);
          sharedPreferences!.setString("HrCompanyName", HrCompanyName);
          sharedPreferences!.setString("HrLocality", HrLocality);
          sharedPreferences!.setString("HrWebsite", HrWebsite);
          // Navigator.of(context).pop();
          Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context)=> HrHomePage()));
        }
        else
        {
          setState(() {
            _profileuploaded=true;
            _isLoading=false;
            CommonFunctions.showErrorDialog("Error in Updating Details", context);
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


  bool _checkdetails()
  {
    if(_nameController.text.isNotEmpty&&_jobcityController.text.isNotEmpty&&_jobloczController.text.isNotEmpty&&_localityController.text.isNotEmpty)
    {
      setState(() {
        _isLoading=false;
      });
      return true;
    }
    else
    {
      setState(() {
        _isLoading=false;
      });
      return false;
    }
  }


  _navigateAndDisplaySelection(BuildContext context) async {
    _hasData = duplicateItems.length > 1;
    final CityModel result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CitySelectionScreen(duplicate: duplicateItems,hasdata: _hasData,)),
    );

    if (result !=null)
      {
        _jobcityController.text=result.name!;
        locationnode.requestFocus();
        cityid=result.id!;
        getlocation();
        _localityController.text="";
      }
  }

  _LocationDisplaySelection(BuildContext context) async {
    _hasLocation = duplicatelocation.length > 1;
    final LocationModel result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationSelectionScreen(duplicate: duplicatelocation,hasdata: _hasLocation,)),
    );

    if (result !=null)
    {
      _localityController.text=result.name;
      addressnode.requestFocus();
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

                    new Padding(
                      child:
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: CustomTextField(
                                  hintText: "Full Name",
                                  textInputType: TextInputType.text,
                                  isOtp: false,
                                  maxLine: 1,
                                  capitalization: TextCapitalization.words,
                                  controller: _nameController,
                                )),
                          ]
                      ),
                      padding: const EdgeInsets.all(5.0),
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
                                  isOtp: false,
                                  maxLine: 1,
                                  capitalization: TextCapitalization.words,
                                  controller: _companyNameController,
                                )),
                          ]
                      ),
                      padding: const EdgeInsets.all(5.0),
                    ),
                    new Padding(
                      child:
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: deviceSize.width-20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6),bottomLeft:Radius.circular(6), bottomRight: Radius.circular(6) ),
                                boxShadow: [
                                  BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: Offset(0, 1)) // changes position of shadow
                                ],
                              ),
                              child: TextFormField(
                                readOnly: true,
                                onTap: () {
                                  _navigateAndDisplaySelection(context);
                                },
                                controller: _jobcityController,
                                decoration: InputDecoration(
                                  hintText: "City",
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                                  isDense: true,
                                  counterText: '',
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                                  errorStyle: TextStyle(height: 1.5),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),

                          ]
                      ),
                      padding: const EdgeInsets.all(5.0),
                    ),
                    new Padding(
                      child:
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: deviceSize.width-20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6),bottomLeft:Radius.circular(6), bottomRight: Radius.circular(6) ),
                                boxShadow: [
                                  BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: Offset(0, 1)) // changes position of shadow
                                ],
                              ),
                              child: TextFormField(
                                readOnly: true,
                                enabled: _hasLocation,
                                onTap: () {
                                  _LocationDisplaySelection(context);
                                },
                                focusNode: locationnode,
                                controller: _localityController,
                                decoration: InputDecoration(
                                  hintText: _hasLocation?"Locality In which Company is located":" No Location in this city",
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                                  isDense: true,
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                                  errorStyle: TextStyle(height: 1.5),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),

                          ]
                      ),
                      padding: const EdgeInsets.all(5.0),
                    ),
                    // new Padding(
                    //   child:
                    //   new Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       mainAxisSize: MainAxisSize.max,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: <Widget>[
                    //         Expanded(
                    //             child: CustomTextField(
                    //
                    //               textInputType: TextInputType.text,
                    //                focusNode: locationnode,
                    //               // nextNode: _box2Focus,
                    //               isOtp: false,
                    //               maxLine: 1,
                    //               capitalization: TextCapitalization.words,
                    //
                    //               // textInputAction: TextInputAction.next,
                    //             )),
                    //       ]
                    //   ),
                    //   padding: const EdgeInsets.all(5.0),
                    // ),
                    new Padding(
                      child:
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: CustomTextField(
                                  hintText: "Full Company Address",
                                  textInputType: TextInputType.text,
                                   focusNode: addressnode,
                                  // nextNode: _box2Focus,
                                  isOtp: false,
                                  maxLine: 1,
                                  capitalization: TextCapitalization.words,
                                  controller: _jobloczController,
                                  // textInputAction: TextInputAction.next,
                                )),
                          ]
                      ),
                      padding: const EdgeInsets.all(5.0),
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
                                  hintText: "Website (Optional)",
                                  textInputType: TextInputType.text,
                                  // focusNode: _box1Focus,
                                  // nextNode: _box2Focus,
                                  isOtp: false,
                                  maxLine: 1,
                                  capitalization: TextCapitalization.words,
                                  controller: _websiteController,
                                  // textInputAction: TextInputAction.next,
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
                            width: deviceSize.width-50,
                            padding: EdgeInsets.all(3.0),
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  _isLoading?
                                      CircularProgressIndicator()
                                      :
                                  ElevatedButton(
                                    child: const Text('Update Profile'),
                                    onPressed: () {
                                      _checkdetails()
                                          ?
                                      _savestep2()
                                          :
                                      CommonFunctions.showSuccessToast('Please Fill All Details 1');
                                    },

                                    //     Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context)=> ProfileExp()), (route) => false);
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