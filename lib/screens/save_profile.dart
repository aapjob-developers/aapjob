import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Aap_job/helper/uploader.dart';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/CitiesModel.dart';
import 'package:Aap_job/models/LocationModel.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/providers/content_provider.dart';
import 'package:Aap_job/screens/select_language.dart';
import 'package:Aap_job/screens/widget/CitySelectionScreen.dart';
import 'package:Aap_job/screens/widget/VideoPopup.dart';
import 'package:Aap_job/widgets/show_loading_dialog.dart';
import 'package:Aap_job/widgets/show_location_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/screens/profile_exp.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/utill/dimensions.dart';
import 'package:Aap_job/view/basewidget/animated_custom_dialog.dart';
import 'package:Aap_job/view/basewidget/textfield/custom_textfield.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:video_player/video_player.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import '../main.dart';
import '../providers/cities_provider.dart';
import 'LocationSelectionScreen.dart';
import '../models/ContentModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class SaveProfile extends StatefulWidget {
  SaveProfile({Key? key, this.path}) : super(key: key);
  String? path;
  @override
  _SaveProfileState createState() => new _SaveProfileState();
}

class _SaveProfileState extends State<SaveProfile> {
  VideoPlayerController? _controller;
  int _value = 0;
  String pt="";
  bool _profileuploaded=false, _profileImageuploaded=false ;
  File? file;
  Color button=Colors.amber;
  var _isLoading = false;
  var apidata;
  String pathe="";
  final ImagePicker _picker = ImagePicker();
  ImageCropper imageCropper= ImageCropper();
  PickedFile? _imageFile, _videoFile;
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  String Imagepath="";
  bool _hasData=false;
  bool _hasLocation=false;
  CroppedFile? _cropedFile;
  var apidatacity;
  var apidatalocation;
  Connectivity connectivity=new Connectivity();

  String jobcityid="", status="0";

  double latitude = 0;
  double longitude = 0;
  var addressline_2 = "";
  var city = "";

  var contentdata;
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  bool videorecord=false;

  FocusNode locationnode = FocusNode();
  FocusNode addressnode = FocusNode();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _jobcityController = TextEditingController();
  TextEditingController _jobloczController = TextEditingController();
 // TextEditingController _dobController = TextEditingController();
  final _fieldKeys = <GlobalKey>[];
  @override
  void initState() {
    super.initState();
    initializePreference().whenComplete((){
      _fieldKeys.addAll(List.generate(10, (_) => GlobalKey()));
      setState(() {
        status=sharedp.getString("status")?? "0";
        _nameController.text= sharedp.getString("name")=="no Name"?"":sharedp.getString("name")?? "";
        _jobcityController.text= sharedp.getString("jobcity")=="no Jobcity"?"":sharedp.getString("jobcity")?? "";
        _jobloczController.text= sharedp.getString("joblocation")=="no Jobcity"?"":sharedp.getString("joblocation")?? "";
        Imagepath=sharedp.getString("profileImage")?? "";
        pathe=sharedp.getString("profileVideo")?? "";
        if(Imagepath!="")
          {
                if(Imagepath!="No profileImage")
              {
                _profileImageuploaded=true;
              }
        }
        if(pathe!="")
        {
          _profileuploaded=true;
        }
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
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  Future<void> initializePreference() async{
    await  Provider.of<ContentProvider>(context, listen: false).getContent(context);
    duplicateItems.addAll(Provider.of<CitiesProvider>(context, listen: false).cityModelList);
  }


  /////// Job City Selection
  String cityid="";

  List<CityModel> duplicateItems = <CityModel>[];
  List<LocationModel> duplicatelocation = <LocationModel>[];
  getlocation() async {
    duplicatelocation.clear();
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.CITY_LOCATION_URI+cityid);
      apidatalocation = response.data;
      print('Location : ${apidatalocation}');
      List<dynamic> data=json.decode(apidatalocation);
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

  String _currentAddress = 'Tap the button to get your address';

  Future<void> _getCurrentAddress() async {
    LocationPermission permission = await Geolocator.checkPermission();
    print("pp0 $permission");
    if (permission == LocationPermission.denied || permission==LocationPermission.unableToDetermine||permission == LocationPermission.deniedForever) {
      // Open app settings when permission is denied or denied forever
      permission = await Geolocator.requestPermission();
      print("pp1 $permission");
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever|| permission==LocationPermission.unableToDetermine) {
        // User denied the permission or denied forever
        print("pp2 $permission");
       // Navigator.pop(context);
        _getCurrentAddress();
        return;
      }
      else
        {
       //   Navigator.pop(context);
          print("pp3 $permission");
         // _getCurrentAddress();
        }
    }
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      print("pp4 $permission");
      try {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium,);
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        print("location list ${placemarks}");
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          var first = placemark;
          String cityname="Delhi";
          if(first.subAdministrativeArea!=null) {
            String q=first.subAdministrativeArea!;
            if(q.contains("Division"))
              q=q.toString().trim().substring(0,q.toString().trim().length - 8);
            cityname=q.toString().trim();
          } else if(first.locality!=null)
          {
            cityname= first.locality!;
          }

          if(cityname!=null) {
            _jobcityController.text = cityname;
            if(first.locality!=null)
            {
              _jobloczController.text = first.locality!;
            }
            if (cityname != first.locality && first.locality != null) {
              _jobloczController.text = first.locality!;
            } else if (cityname != first.subLocality && first.subLocality != null) {
              _jobloczController.text = first.subLocality!;
            }
            else {
              _jobloczController.text = cityname;
            }
          }
          setState(() {
             _currentAddress =
             '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
          });
          //Navigator.pop(context);
        } else {
          //Navigator.pop(context);
          setState(() {
            _currentAddress = 'Address not found';
          });
        }
        print(" _currentAddress ${ _currentAddress}");
        Navigator.pop(context);
      } catch (e) {
        print(e.toString());
        Navigator.pop(context);
        setState(() {
          _currentAddress = 'Error getting location or address';
        });
      }
    }
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    _hasData = duplicateItems.length > 1;
    final CityModel result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CitySelectionScreen()),
    );

    if (result !=null)
    {
      _jobcityController.text=result.name!;
      jobcityid=result.id!;
      locationnode.requestFocus();
      cityid=result.id!;
      getlocation();
      _jobloczController.text="";
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
      _jobloczController.text=result.name;
      addressnode.requestFocus();
    }

  }

  CityModel filterSearchResult(String query) {

    List<CityModel> dummySearchList = <CityModel>[];
    CityModel city=new CityModel(id:"0",name:"NoLoc",iconSrc: "Src");
    dummySearchList.addAll(duplicateItems);

    if(query.isNotEmpty) {
      bool found=false;
      dummySearchList.forEach((item) {
        if(item.name!.toUpperCase().contains(query.toUpperCase())) {
          found=true;
          print("found");
          city= item;
        }
      });
    } else {
      CommonFunctions.showInfoDialog("Your Location is not in list. Please Select a city from list", context);
    }
    return city;
  }

  _submit(String path) async {
    print(path);
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedp.setString("profileVideo", path);
    setState(() {
      _profileuploaded=true;
      button=Colors.green;
    });
  }

  uploadFile() async {
    String taskId = await BackgroundUploader.uploadEnqueue(AppConstants.SAVE_HR_PROFILE_VIDEO_DATA_URI,file!,Provider.of<AuthProvider>(context, listen: false).getUserid(),"candidate","video");
    if (taskId != null) {
    } else {
      BackgroundUploader.uploader.cancelAll();
    }
  }

  Future<void> _savestep2() async {
    setState(() {
      _isLoading=true;
    });
    String _Name = _nameController.text.trim();
    String _jobcity = _jobcityController.text.trim();
    String _joblocation = _jobloczController.text.trim();
    String _dob = "2000-01-01";

    if (_Name.isEmpty||_jobcity.isEmpty||_joblocation.isEmpty||_dob.isEmpty||_dob=="Enter Date of Birth")
    {
      setState(() {
        _isLoading=false;
      });
      CommonFunctions.showInfoDialog("Please Enter Date of Birth", context);
    }
    else{
      if(pathe!="") {
        if (_CheckUpload()) {
          uploadFile();
           await updateProfileDetails(
              _Name,_jobcity, _joblocation,
              _value == 0 ? "Male" : "Female",
              _dob);
        }
        else {
          CommonFunctions.showInfoDialog(
              "You have selected a video resume . Please Submit it first",
              context);
        }
      }
      else
      {
        await updateProfileDetails(_Name, _jobcity, _joblocation, _value == 0 ? "Male" : "Female", _dob);
      }
    }
  }

  Future<void> _iossavestep2() async {
    setState(() {
      _isLoading=true;
    });
    String _Name = _nameController.text.trim();
    String _jobcity = _jobcityController.text.trim();
    String _joblocation = _jobloczController.text.trim();
    String _dob = "01-01-2000";

    if (_Name.isEmpty||_jobcity.isEmpty||_joblocation.isEmpty||_dob.isEmpty||_dob=="Enter Date of Birth")
    {
      setState(() {
        _isLoading=false;
      });
      CommonFunctions.showInfoDialog("Please Enter Date of Birth", context);
    }
    else{
      if(pathe!="") {
        if (_CheckUpload()) {
          uploadFile();
          await updateProfileDetails(
              _Name,_jobcity, _joblocation, "Other", _dob);
        }
        else {
          CommonFunctions.showInfoDialog(
              "You have selected a video resume . Please Submit it first",
              context);
        }
      }
      else
      {
        await updateProfileDetails(_Name, _jobcity, _joblocation, "Other", _dob);
      }
    }
  }
  Future<http.StreamedResponse> updateProfileDetails(String Name,String City,String Locality,String gender,String dob) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.SAVE_PROFILE_DETAIL_DATA_URI}'));
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'userid':Provider.of<AuthProvider>(context, listen: false).getUserid(),
      'Name':Name,
      'City':City,
      'Locality':Locality,
      'Gender':gender,
      'dob':dob,
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      // print("response : "+value);
      if (response.statusCode == 200) {
        if(response.toString()!="Failed")
        {
          setState(() {
            _profileuploaded=true;
          });
          sharedp.setString("name", Name);

          sharedp.setString("jobcity",City);
          sharedp.setString("joblocation", Locality);
          sharedp.setString("gender", gender);
          sharedp.setString("dob", dob);
          sharedp.setBool("step3", true);
            setState(() {
              _isLoading = false;
            });
            Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context)=> ProfileExp()), (route) => false);
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

  bool _CheckUpload()
  {

    if(_profileuploaded)
    {
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

  bool _CheckImageUpload()
  {

    if(_profileImageuploaded)
    {
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
  bool isselect=false;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return
      Container(
        decoration: new BoxDecoration(color: Primary),
        width: deviceSize.width,
        // margin: EdgeInsets.all(5.0),
        child:
        SafeArea(child: Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
              onPressed:()=> Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => SelectLanguage(isHome: false,)),),
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
                  SizedBox(width: 10,),
                  Container(
                    width: MediaQuery.of(context).size.width*0.6,
                    child: Text(Provider.of<AuthProvider>(context, listen: false).getMobile(),maxLines:2,style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),
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
                  controller: _scrollController,
                  child:
                  Form(
                    key: _formKey,
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
                                Flexible(child:Text(getTranslated("PROFILE_IMAGE", context)!,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                ),
                              ]
                          ),
                          padding: const EdgeInsets.all(5.0),
                        ),
                        imageProfile(),
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap:(){
                                  VideoPopup(
                                      title: Provider.of<ContentProvider>(context, listen: false).contentList[0].internalVideoSrc!).show(context);
                                },
                                child:
                                FadeInImage.assetNetwork(
                                  width: MediaQuery.of(context).size.width*0.9,
                                  height: 80,
                                  placeholder: 'assets/images/appicon.png',
                                  image:AppConstants.BASE_URL+ Provider.of<ContentProvider>(context, listen: false).contentList[0].imgSrc!,
                                  fit: BoxFit.contain,
                                ),
                              )
                            ]),
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
                                      isName:true,
                                      maxLine: 1,
                                      capitalization: TextCapitalization.words,
                                      controller: _nameController,
                                      isValidator: true,
                                      validatorMessage: "Please Enter Full Name",
                                    )),
                              ]
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 25.0),
                        ),
                        Platform.isIOS ? Container():
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          GestureDetector(
                            onTap:(){
                              showLocationDialog(
                                context: context,
                                message: 'assets/lottie/location-permissions.json',
                              );
                              _getCurrentAddress();
                            },
                            child:
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              margin: EdgeInsets.only(left: 1.0,top: 1.0,right: 1.0,bottom: 1.0),
                              decoration: new BoxDecoration(
                                  color: Colors.tealAccent,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              child:
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(getTranslated('USE_MY_CUURENT_LOCATION', context)!, style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.teal),),
                                  Lottie.asset(
                                    'assets/lottie/gps.json',
                                    height: MediaQuery.of(context).size.width*0.05,
                                    //width: MediaQuery.of(context).size.width*0.45,
                                    animate: true,),
                                ],
                              ),
                            ),
                          ),
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
                                    border: Border.all(color: Primary),
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Select City Name';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText:"City",
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
                                    border: Border.all(color: Primary),
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
                                    controller: _jobloczController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Select Locality';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: _hasLocation?"Locality In city is located":" No Location in this city",
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
                        //Platform.isIOS ?
                            //Container()
                           // :
                        // new Padding(
                        //   child:
                        //   new Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       mainAxisSize: MainAxisSize.max,
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: <Widget>[
                        //         Container(
                        //           width: deviceSize.width-20,
                        //           decoration: BoxDecoration(
                        //             color: Colors.white,
                        //             border: Border.all(color: Primary),
                        //             borderRadius: BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6),bottomLeft:Radius.circular(6), bottomRight: Radius.circular(6) ),
                        //             boxShadow: [
                        //               BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: Offset(0, 1)) // changes position of shadow
                        //             ],
                        //           ),
                        //           child: TextFormField(
                        //             controller: _dobController,
                        //             decoration: InputDecoration(
                        //               icon: Icon(Icons.calendar_today),
                        //               hintText: "Enter Date of birth",
                        //               filled: true,
                        //               contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                        //               isDense: true,
                        //               focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                        //               errorStyle: TextStyle(height: 1.5),
                        //               border: InputBorder.none,
                        //             ),
                        //             readOnly: true,  //set it true, so that user will not able to edit text
                        //             onTap: () async {
                        //               DateTime? pickedDate = await showDatePicker(
                        //                   context: context, initialDate: DateTime(2000),
                        //                   firstDate: DateTime(1950), //DateTime.now() - not to allow to choose before today.
                        //                   lastDate: DateTime(2005)
                        //               );
                        //               if(pickedDate != null ){
                        //                 print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                        //                 String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                        //                 print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //                 //you can implement different kind of Date Format here according to your requirement
                        //
                        //                 setState(() {
                        //                   _dobController.text = formattedDate; //set output date to TextField value.
                        //                 });
                        //               }else{
                        //                 print("Date is not selected");
                        //               }
                        //             },
                        //           ),
                        //         ),
                        //
                        //       ]
                        //   ),
                        //   padding: const EdgeInsets.all(5.0),
                        // ),
                        Platform.isIOS ?
                        Container()
                            :
                        new Padding(
                          child:
                          new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => setState(() => _value = 0),
                                  child: Container(
                                    height: 140,
                                    width: 140,
                                    color: _value == 0 ? Colors.green : Colors.white,
                                    child:
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Lottie.asset(
                                          'assets/lottie/profile.json',
                                          height: 100,
                                          width: 100,
                                          animate: true,),
                                        Text(getTranslated("MALE", context)!, style: LatinFonts.anton(fontWeight: FontWeight.w500) ,),
                                      ],
                                    ),

                                  ),
                                ),
                                SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () => setState(() => _value = 1),
                                  child: Container(
                                    height: 140,
                                    width: 140,
                                    color: _value == 0 ? Colors.white : Colors.green,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Lottie.asset(
                                          'assets/lottie/blinkingeyes.json',
                                          height: 100,
                                          width: 100,
                                          animate: true,),
                                        Text(getTranslated("FEMALE", context)!, style: LatinFonts.anton(fontWeight: FontWeight.w500) ,),
                                      ],
                                    ),
                                  ),
                                ),
                              ]
                          ),
                          padding: const EdgeInsets.all(5.0),
                        ),
                        Visibility(
                          visible: false,
                          child: new Padding(
                            child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(child:Text(getTranslated("UPLOAD_VIDEO_RESUME", context)!,style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                                  ),
                                ]
                            ),
                            padding: const EdgeInsets.all(5.0),
                          ),
                        ),
                  Visibility(
                    visible: false,
                    child:
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              pathe==""?
                              GestureDetector(
                                onTap: () {
                                  //  _showSimpleDialog();
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
                        ),),
                  Visibility(
                    visible: false,
                    child:
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
                                        _profileuploaded==true?
                                        Container()
                                            :
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
                                        ElevatedButton(
                                          child: const Text('Re Enter'),
                                          onPressed: () {
                                            //  _showSimpleDialog();
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
                        ),),

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
                                      if (_isLoading)
                                        CircularProgressIndicator()
                                      else
                                        ElevatedButton(
                                          child: const Text('Next'),
                                          onPressed: () {
                                            if (_formKey.currentState!.validate()) {
                                              _CheckImageUpload()
                                                  ?
                                              Platform.isIOS ?
                                              _iossavestep2()
                                                  : _savestep2()
                                                  :
                                              CommonFunctions.showInfoDialog('Please Submit Your Profile Image',context);
                                            }
                                            else
                                              {

                                              }
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

                              ),
                            ]
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child:
              //   Column(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     mainAxisSize: MainAxisSize.max,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: <Widget>[
              //
              //     ],
              //   ),
              //
              // ),
            ],
          ),
        ),),
      )
    ;

  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        _cropedFile == null&&Imagepath=="No profileImage"
            ?
        Lottie.asset(
          'assets/lottie/profilene.json',
          height: 150,
          width: 150,
          animate: true,)
            :
        Imagepath=="No profileImage"?
        _cropedFile == null ?
        CircleAvatar(
        radius: 80.0,
        backgroundImage: AssetImage("assets/appicon.png"),
    )
        : CircleAvatar(
    radius: 80.0,
    backgroundImage: FileImage(File(_cropedFile!.path)),
    )
            :
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _cropedFile == null
              ? FileImage(File(Imagepath))
              : FileImage(File(_cropedFile!.path)),
        ),
        //Text(Imagepath),
        // Lottie.asset(
        //   'assets/lottie/profilene.json',
        //   height: 150,
        //   width: 150,
        //   animate: true,),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
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

              ])
        ],
      ),
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
          sharedp.setString("profileVideo", _videoFile!.path);
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
          sharedp.setString("profileImage", _cropedFile!.path);
          _profileImageuploaded=true;
          Navigator.pop(context);
        }
      });
    }
  }

}