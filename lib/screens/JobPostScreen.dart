import 'dart:convert';
import 'dart:io';
import 'package:Aap_job/helper/SharedManager.dart';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/providers/jobtitle_provider.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Aap_job/models/CitiesModel.dart';
import 'package:Aap_job/models/JobCategoryModel.dart';
import 'package:Aap_job/models/JobTitleModel.dart';
import 'package:Aap_job/models/LocationModel.dart';
import 'package:Aap_job/models/common_functions.dart';

import 'package:Aap_job/screens/JobPostScreen2.dart';
import 'package:Aap_job/screens/LocationSelectionScreen.dart';
import 'package:Aap_job/screens/hrloginscreen.dart';
import 'package:Aap_job/screens/loginscreen.dart';
import 'package:Aap_job/screens/profile_exp.dart';
import 'package:Aap_job/screens/widget/CitySelectionScreen.dart';
import 'package:Aap_job/screens/widget/JobTitleSelectionScreen.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/utill/dimensions.dart';
import 'package:Aap_job/view/basewidget/animated_custom_dialog.dart';
import 'package:Aap_job/view/basewidget/textfield/custom_textfield.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:google_language_fonts/google_language_fonts.dart';

import 'widget/JobCategorySelectionScreen.dart';

class JobPostScreen extends StatefulWidget {
  JobPostScreen({Key? key}) : super(key: key);
  @override
  _JobPostScreenState createState() => new _JobPostScreenState();
}

class _JobPostScreenState extends State<JobPostScreen> {
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata, apidatacat;
  String openings="",jobcityid="0";
  SharedPreferences? sharedPreferences;
  String jobtitle="",JobCategory="",jobtype="",joblocation="",jobcity="",edu="",openingssaved="",Jobcatid="",Jobcityid="";
  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
    await Provider.of<JobtitleProvider>(context, listen: false).getJobTitleModelList(false, context);
  }
  final _formKey = GlobalKey<FormState>();
  String address="n";

  @override
  void initState() {
    initializePreference().whenComplete((){
      setState(() {
        jobtitle= sharedPreferences!.getString("JobTitle")?? "no Job Title";
        JobCategory= sharedPreferences!.getString("JobCategory")?? "no JobCategory";
        openingssaved= sharedPreferences!.getString("openings")?? "no openings";
        jobtype= sharedPreferences!.getString("jobtype")?? "no jobtype";
        workplace= sharedPreferences!.getString("workplace")?? "In Office";
        contract= sharedPreferences!.getString("contract")?? "Permanant";
        Gender= sharedPreferences!.getString("Gender")?? "no Gender";
        joblocation= sharedPreferences!.getString("joblocation")?? "no JobLocation";
        address= sharedPreferences!.getString("address")?? "no JobLocation";
        edu= sharedPreferences!.getString("education")?? "no Job Title";
        jobcity= sharedPreferences!.getString("jobcity")?? "no JobCity";

        Jobcatid= sharedPreferences!.getString("Jobcatid")?? "no Jobcatid";

        Jobcityid= sharedPreferences!.getString("jobcityid")?? "0";

        if(jobtitle!="no Job Title")
          {
            _jobtitleController.text=jobtitle;
          }

        if(JobCategory!="no JobCategory")
        {
          _jobcategoryController.text=JobCategory;
          jobcatid=Jobcatid;
        }

        if(openingssaved!="no openings")
        {
          _openingController.text=openingssaved;
          openings=openingssaved;
        }

        if(jobcity!="no JobCity")
        {
         _jobcityController.text=jobcity;
         jobcityid=Jobcityid;
        }

        if(joblocation!="no JobLocation")
        {
          _localityController.text=joblocation;
        }
        if(address!="n"&&address!="no JobLocation")
        {
          addressController.text=address;
        }
        duplicateJobTitle= Provider.of<JobtitleProvider>(context, listen: false).jobtitleList;
        //getJobTitles();
        getJobCategory();
        getcities();
      });
    });

    super.initState();
  }

///////////////////////////////////job titles ////////////////////

  bool _hasJobTitle=false;

  TextEditingController _jobtitleController = TextEditingController();

  List<JobTitleModel> duplicateJobTitle = <JobTitleModel>[];

  double latitude = 0;
  double longitude = 0;
  var addressline_2 = "";
  var city = "";

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
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
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
    var addresses=await placemarkFromCoordinates(coordinate.latitude, coordinate.latitude);
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
      CityModel city = filterSearchResult(cityname);

      if (city.id != "0"){
        cityid = (city.id==null?city.id:"0")!;
      }
      else {
        CommonFunctions.showInfoDialog("Your City is not in list. Please select a near by city from City List", context);
      }

      jobcityid=cityid!;
      if (cityname != first.locality && first.locality != null) {
        _localityController.text = first.locality!;
      } else if (cityname != first.subLocality && first.subLocality != null) {
        _localityController.text = first.subLocality!;
      }
      else {
        _localityController.text = cityname;
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

  _JobtitleDisplaySelection(BuildContext context) async {
    _hasJobTitle = duplicateJobTitle.length >= 1;
    if(_hasJobTitle) {
      final JobTitleModel result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            JobTitleSelectionScreen()),
      );
      if (result !=null)
      {
        _jobtitleController.text=result.name;
        //addressnode.requestFocus();
      }
    }
    else
      {
        CommonFunctions.showInfoDialog("No data in List", context);
      }



  }

///////////////////////////////////////////////////////


///////////////////////////////////job Category ////////////////////

  bool _hasCategories=false;
  String jobcatid="0";
  TextEditingController _jobcategoryController = TextEditingController();

  List<JobCategoryModel> duplicateJobCategory = <JobCategoryModel>[];

  getJobCategory() async {
    duplicateJobCategory.clear();
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.CATEGORY_URI);
      apidatacat = response.data;
      print('JobCategory : ${apidatacat}');
      List<dynamic> data=json.decode(apidatacat);
      if(data.toString()=="[]")
      {
        duplicateJobCategory=[];
        setState(() {
          _hasCategories = false;
        });
      }
      else
      {
        data.forEach((jobcat) =>
            duplicateJobCategory.add(JobCategoryModel.fromJson(jobcat)));
        setState(() {
          _hasCategories=true;
        });
      }
      print('JobCat List: ${duplicateJobCategory}');

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

  _JobcategoryDisplaySelection(BuildContext context) async {
    _hasJobTitle = duplicateJobCategory.length >= 1;
    if(_hasJobTitle) {
      final JobCategoryModel result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            JobCategorySelectionScreen(
              duplicate: duplicateJobCategory, hasdata: _hasJobTitle,)),
      );
      if (result !=null)
      {
        _jobcategoryController.text=result.name;
        jobcatid=result.id;
        //addressnode.requestFocus();
      }
    }
    else
    {
      CommonFunctions.showInfoDialog("No data in List", context);
    }



  }

///////////////////////////////////////////////////////

/////////////////Job Type
  bool showfulltime=true,showparttime=true;
  bool selectedfulltime=false,selectedparttime=false;
String Jobtype="";

  ///////////////////////

  //////////// work from home
  bool value = false;
  String workplace="In Office";

  //////////// contract
  bool contractvalue = false;
  String contract="Permanant";
  ///////////////

  //////// job city and Location
  bool _hasData=false;
  bool _hasLocation=false;

  var apidatacity;
  var apidatalocation;

  FocusNode locationnode = FocusNode();
  FocusNode addressnode = FocusNode();
  FocusNode jobtitlenode = FocusNode();
  FocusNode jobcategorynode = FocusNode();
  FocusNode opeingnode = FocusNode();
  FocusNode fulladdressnode = FocusNode();

  TextEditingController _jobcityController = TextEditingController();
  TextEditingController _localityController = TextEditingController();
  TextEditingController _openingController = TextEditingController();
  TextEditingController addressController = TextEditingController();


  String? cityid;

  List<CityModel> duplicateItems = <CityModel>[];
  List<LocationModel> duplicatelocation = <LocationModel>[];
  getcities() async {
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.CITIES_URI);
      apidatacity= response.data;
      print('City List: ${apidatacity}');
      List<dynamic> data=json.decode(apidatacity);

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
      Response response = await _dio.get(_baseUrl + AppConstants.CITY_LOCATION_URI+cityid!);
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

  _navigateAndDisplaySelection(BuildContext context) async {
    _hasData = duplicateItems.length > 1;
    final CityModel result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CitySelectionScreen(duplicate: duplicateItems,hasdata: _hasData,)),
    );

    if (result !=null)
    {
      _jobcityController.text=result.name!;
      jobcityid=result.id!;
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
  ////////////////

  /////////////////Job Gender
  bool showAny=true,showMale=true, showFemale=true;
  bool selectedAny=false,selectedMale=false,selectedFemale=false ;
  String Gender="";

  ///////////////////////

  //////////////////////////// Qualification
  var education = [
    'Select Your Education',
    '10th or Below 10th',
    '12th Passed',
    'Diploma',
    'ITI',
    'Graduate',
    'Post Graduate'
  ];
  String eduvalue = 'Select Your Education';
/////////////////////
  bool _isLoading=false;

  _savedata(){
    setState(() {
      _isLoading=true;
    });
    if(eduvalue!='Select Your Education')
    {
      String _Jobtitle = _jobtitleController.text.trim();
      String _jobcategory = _jobcategoryController.text.trim();
      String _jobcity = _jobcityController.text.trim();
      String _joblocation = _localityController.text.trim();
      String _address = addressController.text;

      if (Jobtype == "" || Gender == "")
        // if(false)
          {
        setState(() {
          _isLoading = false;
        });
        CommonFunctions.showInfoDialog(
            "Please Select Job Type and Gender", context);
      }
      else {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences!.setString("jobcityid", jobcityid);
        sharedPreferences!.setString("JobTitle", _Jobtitle);
        sharedPreferences!.setString("JobCategory", _jobcategory);
        sharedPreferences!.setString("Jobcatid", jobcatid);
        sharedPreferences!.setString("openings", openings);
        sharedPreferences!.setString("jobtype", Jobtype);
        if (value) {
          workplace = "Work from Home";
        } else {
          workplace = "In Office";
        }
        sharedPreferences!.setString("workplace", workplace);
        sharedPreferences!.setString("contract", contract);
        sharedPreferences!.setString("jobcity", _jobcity);
        sharedPreferences!.setString("joblocation", _joblocation);

        sharedPreferences!.setString("Gender", Gender);
        sharedPreferences!.setString("education", eduvalue);
        sharedPreferences!.setBool("postjobstep1", true);
        sharedPreferences!.setString("address", _address);
        Navigator.push(context, MaterialPageRoute(builder: (context) => JobPostScreen2()));
      }
    }
    else
      {
        setState(() {
          _isLoading=false;
        });
        CommonFunctions.showInfoDialog("Please Select minimum Education Required", context);
      }

  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return Container(
      decoration: new BoxDecoration(color: Colors.white),

      child:
      SafeArea(child:
      Scaffold(
        backgroundColor: Colors.transparent,
        body:
        SingleChildScrollView(
          child:
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child:new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width:deviceSize.width,
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10.0),
                          decoration: new BoxDecoration(color: Colors.pink.shade300),
                          child:
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.file_copy_sharp,size: 30,color: Colors.white,),
                                  SizedBox(width: 5,),
                                  Text(getTranslated('POST_A_JOB', context)!,style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
                                ]

                            ),

                        ),
                        //////Job title
                        SizedBox(height: 10,),
                        new Padding(
                          child:
                          Text.rich(
                              TextSpan(
                                  text: 'Job Title',
                                style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: '*',
                                      style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.red),
                                    )
                                  ]
                              )
                          ),
                          // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                          padding: const EdgeInsets.all(10.0),
                        ),
                        new Padding(
                          child:
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
                                _JobtitleDisplaySelection(context);
                              },
                              controller: _jobtitleController,
                              focusNode: jobtitlenode,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  jobtitlenode.requestFocus();
                                  return 'Please Select Job Title';

                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText:"Job Title",
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
                          padding: const EdgeInsets.all(10.0),
                        ),
/////////// Job Category

                        new Padding(
                          child:
                          Text.rich(
                              TextSpan(
                                  text: 'Job Category',
                                  style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: '*',
                                      style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.red),
                                    )
                                  ]
                              )
                          ),
                          // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                          padding: const EdgeInsets.all(10.0),
                        ),

                        new Padding(
                          child:
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
                              focusNode: jobcategorynode,
                              readOnly: true,
                              onTap: () {
                                _JobcategoryDisplaySelection(context);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  jobcategorynode.requestFocus();
                                  return 'Please Select Job Category';
                                }
                                return null;
                              },
                              controller: _jobcategoryController,
                              decoration: InputDecoration(
                                hintText:"Job Category",
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
                          padding: const EdgeInsets.all(10.0),
                        ),
 ///////////////// No. of Openings
                        new Padding(
                          child:
                          Text.rich(
                              TextSpan(
                                  text: 'Number of Openings',
                                  style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: '*',
                                      style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.red),
                                    )
                                  ]
                              )
                          ),
                          // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                          padding: const EdgeInsets.all(10.0),
                        ),
                        Container(
                          width:deviceSize.width*0.7,
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10.0),
                          child:
                           TextFormField(
                             focusNode: opeingnode,
                             validator: (value) {
                               if (value == null || value.isEmpty) {
                                 opeingnode.requestFocus();
                                 return 'Please Enter Total No. of Jobs Openings';
                               }
                               return null;
                             },
                             keyboardType: TextInputType.phone,
                              controller: _openingController,
                              onChanged: (value) {
                          setState(() {
                            openings=value;
                          });

                              },
                              // controller: editingController,
                              decoration: InputDecoration(
                                filled: true,
                                  fillColor: Colors.white,
                                  // labelText:"Number of Openings",
                                  hintText:"e.g. 1",
                                  prefixIcon: Icon(Icons.numbers),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                            ),
                        ),
////////////////// Job Type
                        new Padding(
                          child:
                          Text.rich(
                              TextSpan(
                                  text: 'Job Type',
                                  style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: '*',
                                      style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.red),
                                    )
                                  ]
                              )
                          ),
                          // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                          padding: const EdgeInsets.all(10.0),
                        ),
                        new Padding(
                          child:
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[

                                showfulltime?
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      showfulltime=false;
                                      showparttime=false;
                                      selectedfulltime=true;
                                      selectedparttime=false;
                                      Jobtype="Full Time";
                                    });
                                  },
                                  child:
                                  Container(
                                    decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                    margin: EdgeInsets.all(5),
                                    width: deviceSize.width*0.3,
                                    child:
                                    Text("Full Time",style: TextStyle(color: Primary,fontSize: 14),),
                                  ),

                                ):
                                selectedfulltime? Container(
                                  decoration: new BoxDecoration(color: Colors.pink.shade200,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  margin: EdgeInsets.all(5),
                                  width: deviceSize.width*0.3,
                                  child:
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(" Full Time",style: TextStyle(color: Primary,fontSize: 14),),
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              showfulltime=true;
                                              showparttime=true;
                                              selectedfulltime=false;
                                              selectedparttime=false;
                                              Jobtype="";
                                            });
                                          },
                                          child:
                                          Icon(Icons.highlight_off_sharp,size: 20,color: Colors.black,),
                                        ),
                                      ]
                                  ),
                                ):Container(),
                                showparttime?
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      showfulltime=false;
                                      showparttime=false;
                                      selectedfulltime=false;
                                      selectedparttime=true;
                                      Jobtype="Part Time";
                                    });
                                  },
                                  child:
                                  Container(
                                    decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                    margin: EdgeInsets.all(5),
                                    width: deviceSize.width*0.3,
                                    child:
                                    Text("Part Time",style: TextStyle(color: Primary,fontSize: 14),),
                                  ),

                                ):
                                selectedparttime? Container(
                                  decoration: new BoxDecoration(color: Colors.pink.shade200,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  margin: EdgeInsets.all(5),
                                  child:
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                          Text("  Part Time",style: TextStyle(color: Primary,fontSize: 14),),
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              showfulltime=true;
                                              showparttime=true;
                                              selectedfulltime=false;
                                              selectedparttime=false;
                                              Jobtype="";
                                            });
                                          },
                                          child:
                                          Icon(Icons.highlight_off_sharp,size: 20,color: Colors.black,),
                                        ),
                                      ]
                                  ),
                                ):Container(),

                              ]
                          ),
                          // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                          padding: const EdgeInsets.all(5.0),
                        ),
  ////////////////////////////////// Work From Home
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child:
                              Row(
                                children: [
                                  Checkbox(
                                    value: this.value,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        this.value = value!;
                                        if(value==true)
                                        {
                                          workplace="Work from Home";
                                        }
                                        else
                                        {
                                          workplace="In Office";

                                        }
                                      });
                                    },
                                  ),
                                   Text(' This is a Work from Home Job',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                                ],
                              )
                          //Checkbox
                        ),
                        ////////////////////////////////// Contract
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child:
                            Row(
                              children: [
                                Checkbox(
                                  value: this.contractvalue,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      this.contractvalue = value!;
                                      if(value==true)
                                      {
                                        contract="Contract";
                                      }
                                      else
                                      {
                                        contract="Permanant";

                                      }
                                    });
                                  },
                                ),
                                Text(' This is a Contract Job',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                              ],
                            )
                          //Checkbox
                        ),
  ////////////////////// Job city and Location
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
                          Text.rich(
                              TextSpan(
                                  text: 'Job City',
                                  style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: '*',
                                      style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.red),
                                    )
                                  ]
                              )
                          ),
                          // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                          padding: const EdgeInsets.all(10.0),
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
                                    focusNode: locationnode,
                                    onTap: () {
                                      _navigateAndDisplaySelection(context);
                                    },
                                    controller: _jobcityController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        locationnode.requestFocus();
                                        return 'Please Select Job City';
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
                          Text.rich(
                              TextSpan(
                                  text: 'Job Location',
                                  style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: '*',
                                      style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.red),
                                    )
                                  ]
                              )
                          ),
                          // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                          padding: const EdgeInsets.all(10.0),
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
                                    focusNode: addressnode,
                                    controller: _localityController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        addressnode.requestFocus();
                                        return 'Please Enter Job Locality';
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
                        //////////////////////////////////// Address
                        new Padding(
                          child:
                          Text.rich(
                              TextSpan(
                                  text: 'Full Interview Address',
                                  style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: '*',
                                      style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.red),
                                    )
                                  ]
                              )
                          ),
                          // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                          padding: const EdgeInsets.all(10.0),
                        ),
                        Container(
                          width:deviceSize.width*0.9,
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10.0),
                          child:
                          TextFormField(
                            maxLines: 3,
                            controller: addressController,
                            keyboardType: TextInputType.multiline,
                            onChanged: (value) {
                              setState(() {
                                address=value;
                              });

                            },
                            // controller: editingController,
                            focusNode: fulladdressnode,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                fulladdressnode.requestFocus();
                                return 'Please Enter Interview Address';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                isDense:true,
                                filled: true,
                                fillColor: Colors.white,
                                // labelText:"Number of Openings",
                                hintText:"Enter Interview Address",
                                // prefixIcon: Icon(Icons.numbers),
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                          ),
                        ),
////////////////// Gender
                        new Padding(
                          child:
                          Text.rich(
                              TextSpan(
                                  text: 'Gender',
                                  style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: '*',
                                      style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.red),
                                    )
                                  ]
                              )
                          ),
                          // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                          padding: const EdgeInsets.all(10.0),
                        ),
                        new Padding(
                          child:
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                //////////Any
                                showAny?
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      showAny=false;
                                      showMale=false;
                                      showFemale=false;
                                      selectedAny=true;
                                      selectedMale=false;
                                      selectedFemale=false;
                                      Gender="Both";
                                    });
                                  },
                                  child:
                                  Container(
                                    decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                    margin: EdgeInsets.all(5),
                                    width: deviceSize.width*0.25,
                                    child:
                                    Text("Both",style: TextStyle(color: Primary,fontSize: 14),),
                                  ),

                                ):
                                selectedAny? Container(
                                  decoration: new BoxDecoration(color: Colors.pink.shade200,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  margin: EdgeInsets.all(5),
                                  width: deviceSize.width*0.25,
                                  child:
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Both",style: TextStyle(color: Primary,fontSize: 14),),
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              showAny=true;
                                              showMale=true;
                                              showFemale=true;
                                              selectedAny=false;
                                              selectedMale=false;
                                              selectedFemale=false;
                                              Gender="";
                                            });
                                          },
                                          child:
                                          Icon(Icons.highlight_off_sharp,size: 20,color: Colors.black,),
                                        ),
                                      ]
                                  ),
                                ):Container(),
                                //////////Male
                                showMale?
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      showAny=false;
                                      showMale=false;
                                      showFemale=false;
                                      selectedAny=false;
                                      selectedMale=true;
                                      selectedFemale=false;
                                      Gender="Male";
                                    });
                                  },
                                  child:
                                  Container(
                                    decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                    margin: EdgeInsets.all(5),
                                    width: deviceSize.width*0.25,
                                    child:
                                    Text(getTranslated("MALE", context)!,style: TextStyle(color: Primary,fontSize: 14),),
                                  ),

                                ):
                                selectedMale? Container(
                                  decoration: new BoxDecoration(color: Colors.pink.shade200,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  margin: EdgeInsets.all(5),
                                  width: deviceSize.width*0.25,
                                  child:
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(getTranslated("MALE", context)!,style: TextStyle(color: Primary,fontSize: 14),),
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              showAny=true;
                                              showMale=true;
                                              showFemale=true;
                                              selectedAny=false;
                                              selectedMale=false;
                                              selectedFemale=false;
                                              Gender="";
                                            });
                                          },
                                          child:
                                          Icon(Icons.highlight_off_sharp,size: 20,color: Colors.black,),
                                        ),
                                      ]
                                  ),
                                ):Container(),
                                //////////Female
                                showFemale?
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      showAny=false;
                                      showMale=false;
                                      showFemale=false;
                                      selectedAny=false;
                                      selectedMale=false;
                                      selectedFemale=true;
                                      Gender="Female";
                                    });
                                  },
                                  child:
                                  Container(
                                    decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                    margin: EdgeInsets.all(5),
                                    width: deviceSize.width*0.25,
                                    child:
                                    Text(getTranslated("FEMALE", context)!,style: TextStyle(color: Primary,fontSize: 14),),
                                  ),

                                ):
                                selectedFemale? Container(
                                  decoration: new BoxDecoration(color: Colors.pink.shade200,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  margin: EdgeInsets.all(5),
                                  width: deviceSize.width*0.25,
                                  child:
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(getTranslated("FEMALE", context)!,style: TextStyle(color: Primary,fontSize: 14),),
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              showAny=true;
                                              showMale=true;
                                              showFemale=true;
                                              selectedAny=false;
                                              selectedMale=false;
                                              selectedFemale=false;
                                              Gender="";
                                            });
                                          },
                                          child:
                                          Icon(Icons.highlight_off_sharp,size: 20,color: Colors.black,),
                                        ),
                                      ]
                                  ),
                                ):Container(),

                              ]
                          ),
                          // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                          padding: const EdgeInsets.all(5.0),
                        ),
//////////////////////////////// Minimum Qualification required
                        new Padding(
                          child:
                          Text.rich(
                              TextSpan(
                                  text: 'Minimum Qualification Required',
                                  style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: '*',
                                      style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.red),
                                    )
                                  ]
                              )
                          ),
                          // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                          padding: const EdgeInsets.all(10.0),
                        ),
                        new Padding(
                          child:
                          Container(
                            width: deviceSize.width-20,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Primary),
                              borderRadius: BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6),bottomLeft:Radius.circular(6), bottomRight: Radius.circular(6) ),
                              boxShadow: [
                                BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: Offset(0, 1)) // changes position of shadow
                              ],
                            ),
                            child:
                            DropdownButton(
                              alignment: AlignmentDirectional.bottomCenter,
                              isExpanded:true,
                              focusColor: Colors.white,
                              value: eduvalue,
                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),
                              // Array list of items
                              items: education.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  eduvalue= newValue!;
                                });
                                // if(newValue!="10th or Below 10th"&&newValue!="12th Passed")
                                // {
                                //   setState(() {
                                //     showextraedu= true;
                                //   });
                                // }
                                // else
                                // {
                                //   setState(() {
                                //     showextraedu= false;
                                //   });
                                // }
                              },
                            ),
                          ),
                          // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                          padding: const EdgeInsets.all(10.0),
                        ),
////////////////////////////////////////////// Next Button
                        new Padding(
                          child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _isLoading?
                                      CircularProgressIndicator()
                                      :
                                  ElevatedButton(
                                    child: const Text('Next'),
                                    onPressed: () {
    if (_formKey.currentState!.validate()) {
      _savedata();
    }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: new Size(deviceSize.width * 0.4,20),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16)),
                                        primary: Colors.amber,
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        textStyle:
                                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),

                          // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                          padding: const EdgeInsets.all(10.0),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

}



