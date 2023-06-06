import 'dart:convert';
import 'dart:io';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/main.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/providers/content_provider.dart';
import 'package:Aap_job/screens/HrVerificationScreen.dart';
import 'package:Aap_job/screens/hrhomepage.dart';
import 'package:Aap_job/screens/select_language.dart';
import 'package:Aap_job/screens/widget/VideoPopup.dart';
import 'package:Aap_job/widgets/show_loading_dialog.dart';
import 'package:Aap_job/widgets/show_location_dialog.dart';
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
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Aap_job/helper/LocationManager.dart';
import 'package:Aap_job/helper/SharedManager.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import '../models/ContentModel.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

import '../providers/cities_provider.dart';

class HrSaveProfile extends StatefulWidget {
  HrSaveProfile({Key? key, required this.path}) : super(key: key);
  final String path;
  @override
  _HrSaveProfileState createState() => new _HrSaveProfileState();
}

class _HrSaveProfileState extends State<HrSaveProfile> {
  VideoPlayerController? _controller;
  int _value = 0;
  String pt="";
  bool _profileuploaded=false, _profileImageuploaded=false;
  File? file;
  Color button=Colors.amber;
  String? cityid;
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;
  bool _hasData=false;
  bool _hasLocation=false;
  String pathe="", status="0";
  var _isLoading=false;
  final ImagePicker _picker = ImagePicker();
  ImageCropper imageCropper= ImageCropper();
  PickedFile? _imageFile, _videoFile;
  CroppedFile? _cropedFile;
  String Imagepath="";
  double latitude = 0;
  double longitude = 0;
  var addressline_2 = "";
  var city = "";
  bool isselect=false;
  var contentdata;
  final _formKey = GlobalKey<FormState>();

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
  //
  // getcities() async {
  //   try {
  //     Response response = await _dio.get(_baseUrl + AppConstants.CITIES_URI);
  //     apidata = response.data;
  //     print('City List: ${apidata}');
  //     List<dynamic> data=json.decode(apidata);
  //
  //     if(data.toString()=="[]")
  //     {
  //       duplicateItems=[];
  //     }
  //     else
  //     {
  //       data.forEach((city) =>
  //           duplicateItems.add(CityModel.fromJson(city)));
  //     }
  //     print('City List: ${duplicateItems}');
  //
  //   } on DioError catch (e) {
  //     // The request was made and the server responded with a status code
  //     // that falls out of the range of 2xx and is also not 304.
  //     if (e.response != null) {
  //       print('Dio error!');
  //       print('STATUS: ${e.response?.statusCode}');
  //       print('DATA: ${e.response?.data}');
  //       print('HEADERS: ${e.response?.headers}');
  //     } else {
  //       // Error due to setting up or sending the request
  //       print('Error sending request!');
  //       print(e.message);
  //     }
  //   }
  //
  // }

  getlocation() async {
    duplicatelocation.clear();
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.CITY_LOCATION_URI+cityid!);
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

  _getLocation() async {
    final coordinate = await SharedManager.shared.getLocationCoordinate();
    this.latitude = coordinate.latitude;
    this.longitude = coordinate.longitude;
    _getAddressFromCurrentLocation( await SharedManager.shared.getLocationCoordinate());
  //  await _getCurrentPosition();
  }

  // String? _currentAddress;
  // Position? _currentPosition;
  //
  // Future<bool> _handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location services are disabled. Please enable the services')));
  //     return false;
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Location permissions are denied')));
  //       return false;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location permissions are permanently denied, we cannot request permissions.')));
  //     return false;
  //   }
  //   return true;
  // }
  //
  // Future<void> _getCurrentPosition() async {
  //   final hasPermission = await _handleLocationPermission();
  //   if (!hasPermission) return;
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) {
  //     setState(() => _currentPosition = position);
  //     var latlong = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
  //     _getAddressFromCurrentLocation(latlong);
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  _getAddressFromCurrentLocation(LatLng coordinate) async {
   // var coordinate = await SharedManager.shared.getLocationCoordinate();
    Navigator.pop(context);
    print("Stored Location:$coordinate");
    var addresses=await placemarkFromCoordinates(coordinate.latitude, coordinate.longitude);
    var first = addresses.reversed.last;
    print('adminArea: ${first.administrativeArea}');
    print('locality: ${first.locality}');
    print('addressLine: ${first.name}');
    print('featureName: ${first.street}');
    print('subAdminArea: ${first.subAdministrativeArea}');
    print('subLocality: ${first.subLocality}');
    print('subThoroughfare: ${first.subThoroughfare}');
    print('thoroughfare: ${first.thoroughfare}');
    if(first.locality!=null)
    {
      this.city = first.locality!;
    }
    if(this.addressline_2!=null)
    {
      this.addressline_2 = first.postalCode!;
    }
    setState(() {
      print("Final Address:---->$first");
    });
    // ;
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
      CityModel city = filterSearchResult(cityname);

      if (city.id != "0"){
        cityid = (city.id==null?city.id:"0")!;
      }
      else {
        CommonFunctions.showInfoDialog("Your City is not in list. Please select a near by city from City List", context);
      }

      if (cityname != first.locality && first.locality != null) {
        _localityController.text = first.locality!;
        _jobloczController.text = first.name!+", "+first.street!+", "+first.locality!;
      } else if (cityname != first.subLocality && first.subLocality != null) {
        _localityController.text = first.subLocality!;
        _jobloczController.text = first.name!+", "+first.street!+", "+first.locality!;
      }
      else {
        _localityController.text = cityname;
        _jobloczController.text = first.name!+", "+first.street!+", "+first.locality!;
      }
    }
    else
    {
      CommonFunctions.showInfoDialog(getTranslated('NO_LOCATION', context)!, context);
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

  @override
  void initState() {
    initializePreference().whenComplete((){
      setState(() {
        status=sharedPreferences!.getString("status")?? "0";
        _nameController.text= sharedPreferences!.getString("HrName")=="no Name"||sharedPreferences!.getString("HrName")==null?"":sharedPreferences!.getString("HrName")?? "";
        _companyNameController.text= sharedPreferences!.getString("HrCompanyName")=="no Company Name"||sharedPreferences!.getString("HrCompanyName")==null?"":sharedPreferences!.getString("HrCompanyName")?? "";
        _jobcityController.text= sharedPreferences!.getString("HrCity")=="no City"||sharedPreferences!.getString("HrCity")==null?"":sharedPreferences!.getString("HrCity")?? "";
        _jobloczController.text= sharedPreferences!.getString("HrAddress")=="no address"||sharedPreferences!.getString("HrAddress")==null?"":sharedPreferences!.getString("HrAddress")?? "";
        _localityController.text= sharedPreferences!.getString("HrLocality")=="no Locality"||sharedPreferences!.getString("HrLocality")==null?"":sharedPreferences!.getString("HrLocality")?? "";
        _websiteController.text= sharedPreferences!.getString("HrWebsite")=="no website"||sharedPreferences!.getString("HrWebsite")==null?"":sharedPreferences!.getString("HrWebsite")?? "";
        Imagepath=sharedPreferences!.getString("profileImage")?? "";
        if(Imagepath!=""&&Imagepath!="no profileImage")
        {
          _profileImageuploaded=true;
        }
        if(pathe!="")
        {
          _profileuploaded=true;
        }

        //getcities();
        button=Colors.amber;
        //LocationManager.shared.getCurrentLocation();
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
    await  Provider.of<ContentProvider>(context, listen: false).getContent(context);
    setState(() {
      pathe=widget.path;
      duplicateItems.addAll(Provider.of<CitiesProvider>(context, listen: false).cityModelList);
    });

  }

  _submit(String path) async {
    print(path);
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences!.setString("profileVideo", path);
    setState(() {
      _profileuploaded=true;
      button=Colors.green;
      file = File(path);
    });
  }




  Future<void> _savestep2() async {

    setState(() {
      _isLoading=true;
    });

    if(pathe=="") {
      String _Name = _nameController.text.trim();
      String _jobcity = _jobcityController.text.trim();
      String _address = _jobloczController.text.trim();
      String _companyname = _companyNameController.text.trim();
      String _locality = _localityController.text.trim();
      String _website = _websiteController.text.trim().isEmpty?"":_websiteController.text.trim();

      if (_Name.isEmpty || _jobcity.isEmpty || _address.isEmpty ||
          _companyname.isEmpty || _locality.isEmpty || _locality.isEmpty) {
        CommonFunctions.showInfoDialog("Please fill All Details", context);
      } else if(_cropedFile == null)
        {
          CommonFunctions.showInfoDialog("Please Upload a profile Photo to continue.", context);
        }
      else {
        http.StreamedResponse response =  await updateHrProfileDetails(_website,_address,_Name,_companyname,_jobcity,_locality);
      }
    }
    else
      {
        if(_CheckUpload())
        {
          String _Name = _nameController.text.trim();
          String _jobcity = _jobcityController.text.trim();
          String _address = _jobloczController.text.trim();
          String _companyname = _companyNameController.text.trim();
          String _locality = _localityController.text.trim();
          String _website = _websiteController.text.trim().isEmpty?"":_websiteController.text.trim();

          if (_Name.isEmpty || _jobcity.isEmpty || _address.isEmpty ||
              _companyname.isEmpty || _locality.isEmpty || _locality.isEmpty) {
            CommonFunctions.showInfoDialog("Please fill All Details", context);
          }
          else {
          http.StreamedResponse response =  await updateHrProfileDetails(_website,_address,_Name,_companyname,_jobcity,_locality);
          }
        }
        else
        {
          CommonFunctions.showInfoDialog("You have selected a video resume . Please Submit it first", context);
        }
      }
    setState(() {
      _isLoading=false;
    });



  }

  Future<http.StreamedResponse> updateHrProfileDetails(String HrWebsite,String HrAddress,String HrName,String HrCompanyName,String HrCity,String HrLocality) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.SAVE_HR_PROFILE_DETAIL_DATA_URI}'));
    //int userid=sharedPreferences!.getInt("userid")?? "0";
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'userid':Provider.of<AuthProvider>(context, listen: false).getUserid(),
      'HrWebsite':HrWebsite,
      'HrAddress':HrAddress,
      'HrName':HrName,
      'HrCompanyName':HrCompanyName,
      'HrCity':HrCity,
      'HrLocality':HrLocality,
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
          sharedPreferences!.setBool("step3", true);
          sharedPreferences!.setString("HrName", HrName);
          sharedPreferences!.setString("HrCity", HrCity);
          sharedPreferences!.setString("HrAddress", HrAddress);
          sharedPreferences!.setString("HrCompanyName", HrCompanyName);
          sharedPreferences!.setString("HrLocality", HrLocality);
          sharedPreferences!.setString("HrWebsite", HrWebsite);
          Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context)=> HrVerificationScreen()));
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


  _navigateAndDisplaySelection(BuildContext context) async {
    _hasData = duplicateItems.length > 1;
    final CityModel result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CitySelectionScreen()),
    );

    if (result !=null)
      {
        _jobcityController.text=result.name!;
        locationnode.requestFocus();
        cityid=result.id;
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


  Future<void> _fileipload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['avi', 'mp4', 'mpeg','mov','3gp'],
    );

    if (result != null) {
      String? resumepath = result.files.single.path;
      setState(() {
        pathe=resumepath!;
        if(pathe!="") {
          _controller = VideoPlayerController.file(File(pathe))
            ..initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setState(() {});
            });
        }
        file = File(pathe);
      });
     Navigator.of(context).pop();
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (builder) => HrSaveProfile(
      //           path: resumepath,
      //         )));
    } else {
     // Navigator.of(context).pop();
      CommonFunctions.showInfoDialog("Please Select a file", context);
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
      SafeArea(child: Scaffold(
        appBar: AppBar(
     leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
         onPressed:()=> Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => SelectLanguage(isHome: false,)),),),
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
                            Flexible(child:
                            Text("Welcome, Recruiter! Please Upload Your Company Profile.",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),),
                            ),
                          ]
                      ),
                      padding: const EdgeInsets.all(15.0),
                    ),
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
                              VideoPopup(title:Provider.of<ContentProvider>(context, listen: false).contentList[1].internalVideoSrc!).show(context);
                            },
                            child:
                            FadeInImage.assetNetwork(
                              width: MediaQuery.of(context).size.width*0.9,
                              height: MediaQuery.of(context).size.width*0.2,
                              placeholder: 'assets/images/no_data.png',
                              image:AppConstants.BASE_URL+Provider.of<ContentProvider>(context, listen: false).contentList[1].imgSrc!,
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
                                  isName: true,
                                  isOtp: false,
                                  maxLine: 1,
                                  capitalization: TextCapitalization.words,
                                  controller: _nameController,
                                  isValidator: true,
                                  validatorMessage: "Please Enter Name",
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
                                  hintText: "Full Company Name",
                                  textInputType: TextInputType.text,
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
                    Platform.isIOS ? Container():
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                      GestureDetector(
                        onTap:(){
                          // showLoadingDialog(
                          //   context: context,
                          //   message: "Getting Your Current Location. Please Wait.",
                          // );
                          showLocationDialog(
                            context: context,
                            message: 'assets/lottie/location-permissions.json',
                          );
                          _getLocation();
                        },
                        child:
                        Container(
                          padding: const EdgeInsets.all(5.0),
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Select City Name';
                                  }
                                  return null;
                                },
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Select Locality';
                                  }
                                  return null;
                                },
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
                                  isValidator: true,
                                  validatorMessage: "Please Enter Full Address",
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
                      child: new Row(
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
                      ),
                    ),
                    // pathe==""? Container(): new Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     mainAxisSize: MainAxisSize.max,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: <Widget>[
                    //       Container(
                    //         width: deviceSize.width-40,
                    //         padding: EdgeInsets.all(3.0),
                    //         child:
                    //         new Padding(
                    //           child:
                    //           new Row(
                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //               mainAxisSize: MainAxisSize.max,
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: <Widget>[
                    //                 _profileuploaded==true?
                    //                 Container()
                    //                     :
                    //                 ElevatedButton(
                    //                   child: const Text('Submit'),
                    //                   onPressed: () {
                    //                     _submit(pathe);
                    //                   },
                    //                   style: ElevatedButton.styleFrom(
                    //                       minimumSize: new Size(deviceSize.width * 0.3,20),
                    //                       shape: RoundedRectangleBorder(
                    //                           borderRadius: BorderRadius.circular(16)),
                    //                       primary: button,
                    //                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    //                       textStyle:
                    //                       const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    //
                    //                 ),
                    //                 ElevatedButton(
                    //                   child: const Text('Re Enter'),
                    //                   onPressed: () {
                    //                     //  _showSimpleDialog();
                    //                     showModalBottomSheet(
                    //                       context: context,
                    //                       builder: ((builder) => bottomSheet2()),
                    //                     );
                    //                   },
                    //                   style: ElevatedButton.styleFrom(
                    //                       minimumSize: new Size(deviceSize.width * 0.3,20),
                    //                       shape: RoundedRectangleBorder(
                    //                           borderRadius: BorderRadius.circular(16)),
                    //                       primary: Colors.amber,
                    //                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    //                       textStyle:
                    //                       const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    //
                    //                 ),
                    //               ]
                    //
                    //           ),
                    //           padding: const EdgeInsets.all(10.0),
                    //         ),
                    //       ),
                    //     ]
                    // ),
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
                                    child: const Text('Next'),
                                    onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _CheckImageUpload()
                                          // _checkdetails()
                                              ?
                                          _savestep2()
                                              :
                                          CommonFunctions.showInfoDialog('Please Submit Your Profile Image',context);                                        }
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
                ),),
              ),
            ),

          ],
        ),
      ),),
    );
  }

  // Widget imageProfile() {
  //   return Center(
  //     child: Stack(children: <Widget>[
  //       _cropedFile == null&&Imagepath==""
  //           ?
  //       Lottie.asset(
  //         'assets/lottie/profilene.json',
  //         height: 150,
  //         width: 150,
  //         animate: true,)
  //           :
  //       Imagepath=="no profileImage"?
  //       Lottie.asset(
  //         'assets/lottie/profilene.json',
  //         height: 150,
  //         width: 150,
  //         animate: true,)
  //           :
  //       Imagepath==""?
  //             _cropedFile == null ? CircleAvatar(radius: 80.0, backgroundImage: AssetImage("assets/appicon.png")):CircleAvatar(radius: 80.0, backgroundImage:FileImage(File(_cropedFile!.path)),)
  //           :
  //       CircleAvatar(
  //         radius: 80.0,
  //         backgroundImage: _cropedFile == null
  //             ? FileImage(File(Imagepath))
  //             : FileImage(File(_cropedFile!.path)),
  //       ),
  //       Positioned(
  //         bottom: 20.0,
  //         right: 20.0,
  //         child: InkWell(
  //           onTap: () {
  //             showModalBottomSheet(
  //               context: context,
  //               builder: ((builder) => bottomSheet()),
  //             );
  //           },
  //           child: Icon(
  //             Icons.camera_alt,
  //             color: Colors.teal,
  //             size: 28.0,
  //           ),
  //         ),
  //       ),
  //     ]),
  //   );
  // }
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
          // Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          //   FlatButton.icon(
          //     icon: Icon(Icons.camera),
          //     onPressed: () {
          //       takePhoto(ImageSource.camera);
          //     },
          //     label: Text("Camera"),
          //   ),
          //   FlatButton.icon(
          //     icon: Icon(Icons.image),
          //     onPressed: () {
          //       takePhoto(ImageSource.gallery);
          //     },
          //     label: Text("Gallery"),
          //   ),
          // ])
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

  //
  // void takePhoto(ImageSource source) async {
  //   final sharedPreferences = await SharedPreferences.getInstance();
  //   final pickedFile = await _picker.getImage(
  //     source: source,
  //   );
  //   if(pickedFile!=null) {
  //     final CroppedFile? croppedFile= await imageCropper.cropImage (
  //       sourcePath: pickedFile.path,
  //       cropStyle: CropStyle.circle,
  //       compressQuality: 30,
  //     );
  //     setState(() {
  //       if(croppedFile!=null) {
  //         _cropedFile = croppedFile;
  //         sharedPreferences!.setString("profileImage", _cropedFile!.path);
  //         print(_cropedFile!.path);
  //         _profileImageuploaded=true;
  //         Navigator.pop(context);
  //       }
  //     });
  //   }
  // }

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
          sharedPreferences!.setString("profileVideo", _videoFile!.path);
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