import 'dart:convert';
import 'dart:io';

import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/screens/LocationSelectionScreen.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/widget/CitySelectionScreen.dart';
import 'package:Aap_job/widgets/show_location_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/models/CitiesModel.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/LocationModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cities_provider.dart';
import '../hrhomepage.dart';
import 'package:geocoding/geocoding.dart';


class ChangeLocationScreen extends StatefulWidget {
  ChangeLocationScreen({Key? key,required this.CurrentCity, required this.CurrentLocation,required this.usertype}) : super(key: key);
  final String CurrentCity ;
  final String CurrentLocation;
  final String usertype;
  @override
  _ChangeLocationScreenState createState() => new _ChangeLocationScreenState();
}

class _ChangeLocationScreenState extends State<ChangeLocationScreen> {
  Color button=Colors.amber;
  String cityid="";
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;
  bool _hasLocation=false;
  var _isLoading=false;
  double latitude = 0;
  double longitude = 0;
  var addressline_2 = "";
  var city = "";
  String jobcity = "";
  String locality = "";
  SharedPreferences? sharedPreferences;

  TextEditingController _jobcityController = TextEditingController();
  TextEditingController _localityController = TextEditingController();

  FocusNode locationnode = FocusNode();
  FocusNode addressnode = FocusNode();

  List<CityModel> duplicateItems = <CityModel>[];
  List<LocationModel> duplicatelocation = <LocationModel>[];

  @override
  void initState() {
    initializePreference().whenComplete((){

    });
    super.initState();
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
    duplicateItems.addAll(Provider.of<CitiesProvider>(context, listen: false).cityModelList);
    jobcity = widget.CurrentCity;
    locality = widget.CurrentLocation;
  }

  _navigateAndDisplaySelection(BuildContext context) async {
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

  Future<void> _savestep2() async {
    setState(() {
      _isLoading = true;
    });
    if (widget.usertype == "HR") {
      String _jobcity = _jobcityController.text.trim();
      String _locality = _localityController.text.trim();
      if (_jobcity.isEmpty ||_locality.isEmpty) {
        CommonFunctions.showInfoDialog("Please Select City and Location Both", context);
        setState(() {
          _isLoading = false;
        });
      }
      else {
        // await updateHrProfileDetails(_jobcity, _locality);
        FormData formData = new FormData.fromMap({'userid':Provider.of<AuthProvider>(context, listen: false).getUserid(),'HrCity':_jobcity, 'HrLocality':_locality});
        try {
          Response response = await _dio.post('${AppConstants.BASE_URL}${AppConstants.SAVE_HR_CITY_DATA_URI}',data:formData );
          // apiresponse= response.data;
          // print('Save Response: ${apiresponse}');
          if(response.data.toString()=="updated")
          {
            setState(() {
              _isLoading=false;
            });
            sharedPreferences!.setString("HrCity", _jobcity);
            sharedPreferences!.setString("HrLocality", _locality);
            Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context)=> HrHomePage()));
          }
          else
          {
            CommonFunctions.showInfoDialog("Sorry! There is an error in saving prefered city", context);
          }
        }
        on DioError catch (e)
        {
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
    }
    else {
      String _jobcity = _jobcityController.text.trim();
      String _locality = _localityController.text.trim();

      if (_jobcity.isEmpty || _locality.isEmpty) {
        CommonFunctions.showInfoDialog("Please Select City and Location Both", context);
        setState(() {  _isLoading = false; });
      }
      else {
        // await updateProfileDetails(_jobcity, _locality);
        FormData formData = new FormData.fromMap({'userid':Provider.of<AuthProvider>(context, listen: false).getUserid(), 'City':_jobcity,'Locality':_locality});
        try {
          Response response = await _dio.post('${AppConstants.BASE_URL}${AppConstants.SAVE_CITY_DATA_URI}',data:formData );
          // apiresponse= response.data;
          print('Save Response: ${response.data.toString()}');
          if(response.data.toString()=="updated")
          {
            setState(() {
              _isLoading=false;
            });
            sharedPreferences!.setString("jobcity",_jobcity);
            sharedPreferences!.setString("joblocation", _locality);
            Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context)=> HomePage()),(route) => false);
          }
          else
          {
            CommonFunctions.showInfoDialog("Sorry! There is an error in saving prefered city", context);
          }
        }
        on DioError catch (e)
        {
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
    }
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

  String _currentAddress = 'Tap the button to get your address';

  Future<void> _getCurrentAddress() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission==LocationPermission.unableToDetermine||permission == LocationPermission.deniedForever) {
      // Open app settings when permission is denied or denied forever
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever|| permission==LocationPermission.unableToDetermine) {
        // User denied the permission or denied forever
        print("pp1 $permission");
        // Navigator.pop(context);
        _getCurrentAddress();
        return;
      }
      else
      {
        //   Navigator.pop(context);
        _getCurrentAddress();
      }
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
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
              _localityController.text = first.locality!;
            }
            if (cityname != first.locality && first.locality != null) {
              _localityController.text = first.locality!;
            } else if (cityname != first.subLocality && first.subLocality != null) {
              _localityController.text = first.subLocality!;
            }
            else {
              _localityController.text = cityname;
            }
          }
          setState(() {
            _currentAddress =
            '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
          });
          Navigator.pop(context);
        } else {
          setState(() {
            _currentAddress = 'Address not found';
          });
          Navigator.pop(context);
        }
        print(" _currentAddress ${ _currentAddress}");
      } catch (e) {
        print(e.toString());
        setState(() {
          _currentAddress = 'Error getting location or address';
        });
        Navigator.pop(context);
      }
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
      CommonFunctions.showErrorDialog("Your Location is not in list. Please Select a city from list", context);
    }
    return city;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
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
                                  minimumSize: new Size(deviceSize.width * 0.5,20), backgroundColor: Colors.amber,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
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