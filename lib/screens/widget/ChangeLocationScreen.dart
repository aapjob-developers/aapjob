import 'dart:convert';

import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/providers/category_provider.dart';
import 'package:Aap_job/screens/LocationSelectionScreen.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/widget/CitySelectionScreen.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/models/CitiesModel.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/LocationModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Aap_job/helper/LocationManager.dart';
import 'package:Aap_job/helper/SharedManager.dart';
//import 'package:geocoder/geocoder.dart';
import 'package:lottie/lottie.dart';
import '../hrhomepage.dart';
import 'package:geocoding/geocoding.dart';


class ChangeLocationScreen extends StatefulWidget {
  ChangeLocationScreen({Key? key,required this.CurrentCity, required this.CurrentLocation,required this.usertype}) : super(key: key);
  String CurrentCity ;
  String CurrentLocation;
  String usertype;
  @override
  _ChangeLocationScreenState createState() => new _ChangeLocationScreenState();
}

class _ChangeLocationScreenState extends State<ChangeLocationScreen> {
  int _value = 0;
  String pt="",emaile="";
  Color button=Colors.amber;
  String cityid="";
  bool _profileuploaded=false;
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
  String address = "";
  String companyname = "";
  String locality = "";
  String website = "";

  String gender = "";
  String dob = "";

  final _formKey = GlobalKey<FormState>();

  SharedPreferences? sharedPreferences;

  TextEditingController _jobcityController = TextEditingController();
  TextEditingController _localityController = TextEditingController();

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


  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
    _jobcityController.text=widget.CurrentCity;
    _localityController.text=widget.CurrentLocation;

    if(widget.usertype=="HR") {
      emaile = sharedPreferences!.getString("email") ?? "no mail";
      Name = sharedPreferences!.getString("HrName") ?? "no mail";
      jobcity = sharedPreferences!.getString("HrCity") ?? "no mail";
      address = sharedPreferences!.getString("HrAddress") ?? "no mail";
      companyname = sharedPreferences!.getString("HrCompanyName") ?? "no mail";
      locality = sharedPreferences!.getString("HrLocality") ?? "no mail";
      website = sharedPreferences!.getString("HrWebsite") ?? "no mail";
    }
    else
      {
        Name= sharedPreferences!.getString("name")?? "no Name";
        jobcity= sharedPreferences!.getString("jobcity")?? "no jobcity";
        locality= sharedPreferences!.getString("joblocation")?? "no joblocation";
        gender= sharedPreferences!.getString("gender")?? "no gender";
        dob= sharedPreferences!.getString("dob")?? "Enter Date of Birth";
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
  void initState() {
    initializePreference().whenComplete((){
      //LocationManager.shared.getCurrentLocation();
      setState(() {
        getcities();
        button=Colors.amber;
      });
    });

    super.initState();
  }



  Future<void> _savestep2() async {
    setState(() {
      _isLoading = true;
    });
    if (widget.usertype == "HR") {
      String _Name = Name;
      String _jobcity = _jobcityController.text.trim();
      String _address = address;
      String _companyname = companyname;
      String _locality = _localityController.text.trim();
      String _website = website;
      if (_Name.isEmpty || _jobcity.isEmpty || _address.isEmpty ||
          _companyname.isEmpty || _locality.isEmpty) {
        CommonFunctions.showInfoDialog("Please fill All Details", context);
        setState(() {
          _isLoading = false;
        });
      }
      else {
        http.StreamedResponse response = await updateHrProfileDetails(
            _website, _address, _Name, _companyname, _jobcity, _locality);
      }
    }
    else {
      String _Name = Name;
      String _jobcity = _jobcityController.text.trim();
      String _locality = _localityController.text.trim();
      String _dob = dob;
      String _gender = gender;

      if (_Name.isEmpty || _jobcity.isEmpty || _locality.isEmpty) {
        CommonFunctions.showInfoDialog("Please fill All Details", context);
        setState(() {          _isLoading = false;        });
      }
      else {
        http.StreamedResponse response = await updateProfileDetails(_Name, _jobcity, _locality, _gender, _dob);
      }
    }
  }

  Future<http.StreamedResponse> updateHrProfileDetails(String HrWebsite,String HrAddress,String HrName,String HrCompanyName,String HrCity,String HrLocality) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.SAVE_HR_PROFILE_DETAIL_DATA_URI}'));
    int userid=sharedPreferences!.getInt("userid")??0;
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
         // Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context)=> HrHomePage()),(route) => false);
          Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context)=> HrHomePage()));
        }
        else
        {
          setState(() {
            _profileuploaded=true;
            _isLoading=false;
            CommonFunctions.showInfoDialog("Error in Updating Details", context);
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

  Future<http.StreamedResponse> updateProfileDetails(String Name,String City,String Locality,String gender,String dob) async {
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
          // Navigator.of(context).pop();
          Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context)=> HomePage()),(route) => false);
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
    if(_jobcityController.text.isNotEmpty&&_localityController.text.isNotEmpty)
    {
      return true;
    }
    else
    {
      return false;
    }
  }

  _getLocation() async {
    // final coordinate = await SharedManager.shared.getLocationCoordinate();
    // this.latitude = coordinate.latitude;
    // this.longitude = coordinate.longitude;
    // _getAddressFromCurrentLocation( await SharedManager.shared.getLocationCoordinate());
    await _getCurrentPosition();
  }

  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
        .then((Position position) {
      setState(() => _currentPosition = position);
      var latlong = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      _getAddressFromCurrentLocation(latlong);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  _getAddressFromCurrentLocation(LatLng coordinate) async {
   // var coordinate = await SharedManager.shared.getLocationCoordinate();
    print("Stored Location:$coordinate");
    //final coordinates =   new Coordinates(coordinate.latitude, coordinate.longitude);
    // final coordinates =   new Coordinates(28.426830769483015, 77.32730148765563);
    // var addresses =
    // await Geocoder.local.findAddressesFromCoordinates(coordinates);
    //var addresses=await placemarkFromCoordinates(coordinate.latitude, coordinate.latitude);
    var addresses=await placemarkFromCoordinates(28.7658685, 77.3283171);

    var first = addresses.first;
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
      CityModel? city = filterSearchResult(cityname);

      if (city.id != "0"){
        cityid = (city.id==null?city.id:"0")!;
    }
    else {
      CommonFunctions.showInfoDialog("Your City is not in list. Please select a near by city from City List", context);
      }

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
      // if(!found) {
      //   CommonFunctions.showInfoDialog(
      //       "Your Location is not in list. Please Select a city from list",
      //       context);
      // }

    } else {
      CommonFunctions.showErrorDialog("Your Location is not in list. Please Select a city from list", context);
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
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Primary,
        title: new Text(getTranslated("CHANGE_YOUR_LOCATION", context)!),
      ),
      body: Container(
        decoration: new BoxDecoration(color: Colors.black12),
        child:
        Container(
          decoration: new BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(15))),
         padding: EdgeInsets.all(10),
         margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                GestureDetector(
                  onTap:(){
                    //  CommonFunctions.showSuccessToast("");
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
                        child: Text(getTranslated("CURRENT_CITY", context)!),
                      ),

                    ]
                ),
                padding: const EdgeInsets.all(5.0),
              ),
              SizedBox(height: 10,),
              new Padding(
                child:
                new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: deviceSize.width-50,
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
              SizedBox(height: 10,),
              new Padding(
                child:
                new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: deviceSize.width-50,
                        child: Text(getTranslated("CURRENT_LOCA", context)!),
                      ),

                    ]
                ),
                padding: const EdgeInsets.all(5.0),
              ),
              SizedBox(height: 10,),
              new Padding(
                child:
                new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: deviceSize.width-50,
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
              SizedBox(height: 50,),
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
                              child: const Text('Save'),
                              onPressed: () {
                                _checkdetails()
                                    ?
                                _savestep2()
                                    :
                                CommonFunctions.showErrorDialog('Please Enter City and Locality',context);
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
    );
  }
}
