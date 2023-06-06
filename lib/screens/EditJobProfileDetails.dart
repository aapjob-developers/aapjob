import 'dart:convert';
import 'dart:io';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/providers/cities_provider.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/hrhomepage.dart';
import 'package:Aap_job/screens/select_language.dart';
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
import 'package:video_player/video_player.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Aap_job/helper/LocationManager.dart';
import 'package:Aap_job/helper/SharedManager.dart';
//import 'package:geocoder/geocoder.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class EditJobProfileDetails extends StatefulWidget {
  EditJobProfileDetails({Key? key}) : super(key: key);
  @override
  _EditJobProfileDetailsState createState() => new _EditJobProfileDetailsState();
}

class _EditJobProfileDetailsState extends State<EditJobProfileDetails> {

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

  double latitude = 0;
  double longitude = 0;
  var addressline_2 = "";
  var city = "";

  String Name = "";
  String jobcity = "";
  String locality = "";
  String gender = "";
  String dob = "";

  final _formKey = GlobalKey<FormState>();

  SharedPreferences? sharedPreferences;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _jobcityController = TextEditingController();
  TextEditingController _localityController = TextEditingController();


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
        //getcities();
        button=Colors.amber;
        _nameController.text=Name;
        _jobcityController.text=jobcity;
        _localityController.text=locality;
         _dobController.text=dob;
        if(gender=="Male")
        {
          _value=0;
        }
        else
        {
          _value=1;
        }

      });
    });

    super.initState();
  }

  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
    emaile= sharedPreferences!.getString("email")?? "No Email";
    Name= sharedPreferences!.getString("name")?? "no Name";
    jobcity= sharedPreferences!.getString("jobcity")?? "no jobcity";
    locality= sharedPreferences!.getString("joblocation")?? "no joblocation";
    gender= sharedPreferences!.getString("gender")?? "no gender";
    dob= sharedPreferences!.getString("dob")?? "Enter Date of Birth";
    duplicateItems.addAll(Provider.of<CitiesProvider>(context, listen: false).cityModelList);
  }


  Future<void> _savestep2() async {
    setState(() {
      _isLoading=true;
    });

    String _Name = _nameController.text.trim();
    String _jobcity = _jobcityController.text.trim();
    String _locality = _localityController.text.trim();
    String _dob = _dobController.text.trim();
    String _email = _emailController.text.trim();

    if (_Name.isEmpty||_jobcity.isEmpty||_locality.isEmpty||_dob.isEmpty||_dob=="Enter Date of Birth")
    {
      CommonFunctions.showInfoDialog("Please fill All Details", context);
      setState(() {
        _isLoading=false;
      });
    }
    else{
      String gg="";
      if(_value==0)
      {
        gg= "Male";
      }
      else
      {
        gg= "Female";
      }
      http.StreamedResponse response =  await updateProfileDetails(_Name,_jobcity,_locality,gg,_dob,_email);
    }

  }
  Future<http.StreamedResponse> updateProfileDetails(String Name,String City,String Locality,String gender,String dob,String email) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.SAVE_PROFILE_DETAIL_DATA_URI}'));
    int userid=sharedPreferences!.getInt("userid")?? 0;
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'userid':userid.toString(),
      'Name':Name,
      'City':City,
      'Locality':Locality,
      'Gender':gender,
      'dob':dob,
      'email':email,
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
          sharedPreferences!.setString("name", Name);
          sharedPreferences!.setString("jobcity",City);
          sharedPreferences!.setString("joblocation", Locality);
          sharedPreferences!.setString("gender", gender);
          sharedPreferences!.setString("dob", dob);
          sharedPreferences!.setString("email", email);
          // Navigator.of(context).pop();
          Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context)=> HomePage()));
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
    if(_nameController.text.isNotEmpty&&_jobcityController.text.isNotEmpty&&_localityController.text.isNotEmpty&&_dobController.text.isNotEmpty&&_dobController.text!="Enter Date of Birth")
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
      MaterialPageRoute(builder: (context) => CitySelectionScreen()),
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

  _getLocation() async {

    final coordinate = await SharedManager.shared.getLocationCoordinate();
    this.latitude = coordinate.latitude;
    this.longitude = coordinate.longitude;
    _getAddressFromCurrentLocation( await SharedManager.shared.getLocationCoordinate());
    // await _getCurrentPosition();
  }

  // String? _currentAddress;
  // Position? _currentPosition;
  //
  // Future<bool> _handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
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
    //var coordinate = await SharedManager.shared.getLocationCoordinate();
    print("Stored Location:$coordinate");
    var addresses=await placemarkFromCoordinates(coordinate.latitude, coordinate.longitude);
    Navigator.pop(context);
    var first = addresses.first;
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
    // CityModel city=filterSearchResult(cityname);
    //
    // if (city.id != "0"){
    //   cityid = (city.id==null?city.id:"0")!;
    // }
    // else {
    //   CommonFunctions.showInfoDialog("Your City is not in list. Please select a near by city from City List", context);
    // }

    if(cityname!=first.locality&&first.locality!=null) {
      _localityController.text = first.locality!;
    } else if(cityname!=first.subLocality&&first.subLocality!=null)
    {
      _localityController.text = first.subLocality!;
    }
    }
    else
    {
      CommonFunctions.showInfoDialog(getTranslated('NO_LOCATION', context)!, context);
    }
    // _localityController.text=first.addressLine;
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
                    child: Text(getTranslated('EDIT_BASIC_DETAILS', context)!,maxLines:2,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
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
                            Container(
                              width: deviceSize.width-50,
                              child: Text("Full Name",style: LatinFonts.aBeeZee(color: Colors.white),),
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
                            Container(
                              width: deviceSize.width-50,
                              child: Text("Email Id",style: LatinFonts.aBeeZee(color: Colors.white),),
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
                                  hintText: "Enter Email Id",
                                  textInputType: TextInputType.emailAddress,
                                  isName: false,
                                  isOtp: false,
                                  maxLine: 1,
                                  capitalization: TextCapitalization.none,
                                  controller: _emailController,
                                )),
                          ]
                      ),
                      padding: const EdgeInsets.all(5.0),
                    ),
    Platform.isIOS ? Container():
                    new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                      GestureDetector(
                        onTap:(){
                          showLocationDialog(
                            context: context,
                            message: 'assets/lottie/location-permissions.json',
                          );
                          _getLocation();
                        },
                        child:
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          margin: EdgeInsets.only(left: 10.0,top: 5.0,right: 10.0,bottom: 5.0),
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
                                height: MediaQuery.of(context).size.width*0.1,
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
                              width: deviceSize.width-50,
                              child: Text(getTranslated("CURRENT_CITY", context)!,style: LatinFonts.aBeeZee(color: Colors.white),),
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
                              width: deviceSize.width-50,
                              child: Text(getTranslated("CURRENT_LOCA", context)!,style: LatinFonts.aBeeZee(color: Colors.white),),
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
                                  hintText: _hasLocation?"Locality in your city":" No Location in this city",
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
                            Container(
                              width: deviceSize.width-50,
                              child: Text("Gender",style: LatinFonts.aBeeZee(color: Colors.white),),
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
                                    Text("Male", style: LatinFonts.anton(fontWeight: FontWeight.w500) ,),
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
                    new Padding(
                      child:
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: deviceSize.width-50,
                              child: Text(getTranslated("DOB", context)!,style: LatinFonts.aBeeZee(color: Colors.white),),
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
                                // child: TextField(
                                //   hintText: "Enter date",
                                //   textInputType: TextInputType.text,
                                //   isOtp: false,
                                //   maxLine: 1,
                                //   capitalization: TextCapitalization.words,
                                //   controller: _dobController,
                                // )),
                          child:
                          Container(
                            padding: EdgeInsets.all(5),
                            width: deviceSize.width-20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6),bottomLeft:Radius.circular(6), bottomRight: Radius.circular(6) ),
                              boxShadow: [
                                BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: Offset(0, 1)) // changes position of shadow
                              ],
                            ),
                            child:
                            TextField(
                                  controller: _dobController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          hintText: "Enter Date of birth",
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                          isDense: true,
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                          errorStyle: TextStyle(height: 1.5),
                          border: InputBorder.none,
                        ),
                                  readOnly: true,  //set it true, so that user will not able to edit text
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context, initialDate: DateTime(2000),
                                        firstDate: DateTime(1950), //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2005)
                                    );
                                    if(pickedDate != null ){
                                      print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                                      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                      //you can implement different kind of Date Format here according to your requirement

                                      setState(() {
                                        _dobController.text = formattedDate; //set output date to TextField value.
                                      });
                                    }else{
                                      print("Date is not selected");
                                    }
                                  },
                                ),
                    )
                            )
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
    if (_formKey.currentState!.validate()) {
      _checkdetails()
          ?
      _savestep2()
          :
      CommonFunctions.showInfoDialog("Please Enter date of Birth", context);
    }
                                    
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
            ),

          ],
        ),
      ),),
    );
  }
}