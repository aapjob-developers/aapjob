import 'dart:convert';

import 'package:Aap_job/helper/LocationManager.dart';
import 'package:Aap_job/helper/SharedManager.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:dio/dio.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:geocoder/model.dart';
import 'package:Aap_job/models/CitiesModel.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';


class CitySelectionScreen extends StatefulWidget {
  CitySelectionScreen({Key? key,required this.duplicate, required this.hasdata}) : super(key: key);
  List<CityModel> duplicate ;
  bool hasdata;
  @override
  _CitySelectionScreenState createState() => new _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  // final Dio _dio = Dio();
  // final _baseUrl = AppConstants.BASE_URL;
  // var apidata;
 bool _hasData=false;
 double latitude = 0;
 double longitude = 0;
 var addressline_2 = "";
 var city = "";

  List<CityModel> duplicateItems = <CityModel>[];
  var items = <CityModel>[];

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    duplicateItems=widget.duplicate;
    _hasData=widget.hasdata;
    items.addAll(duplicateItems);
    //_getLocation();
     //LocationManager.shared.getCurrentLocation();
    super.initState();
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
   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
       .then((Position position) {
     setState(() => _currentPosition = position);
     var latlong = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
     _getAddressFromCurrentLocation(latlong);
   }).catchError((FlutterError e) {
     debugPrint(e.toString());
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
    filterSearchResult(cityname);
   //filterSearchResult(first.subAdminArea);
 }


 void filterSearchResult(String query) {
    if(query.contains("Division"))
    query=query.toString().trim().substring(0,query.toString().trim().length - 8);

    query=query.toString().trim();
   List<CityModel> dummySearchList = <CityModel>[];
   dummySearchList.addAll(duplicateItems);
   print("Query add:---->$query");
   if(query.isNotEmpty) {
     List<CityModel> dummyListData = <CityModel>[];
     bool found=false;
     dummySearchList.forEach((item) {
       if(item.name!.toUpperCase().contains(query.toUpperCase())) {
         print("found:---->${item.name}");
         found=true;
         dummyListData.add(item);
         Navigator.pop(context,item);
       }
     });
     if(true)
     CommonFunctions.showInfoDialog("Location from GPS is not in list. Please Select a city from list", context);
     return;
   } else {
     CommonFunctions.showErrorDialog("Your Location is not in list. Please Select a city from list", context);
   }

 }

  void filterSearchResults(String query) {
    List<CityModel> dummySearchList = <CityModel>[];
    dummySearchList.addAll(duplicateItems);
    if(query.isNotEmpty) {
      List<CityModel> dummyListData = <CityModel>[];
      dummySearchList.forEach((item) {
        if(item.name!.toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Primary,
        title: new Text("Select Your City"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
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
                        Text("Use my current location", style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.teal),),
                        Lottie.asset(
                          'assets/lottie/gps.json',
                          height: MediaQuery.of(context).size.width*0.1,
                          //width: MediaQuery.of(context).size.width*0.45,
                          animate: true,),
                        //Icon(Icons.gps_fixed_sharp,size: 25,color: Colors.white,),
                      ],
                    ),
                ),
                  ),
            ),
            _hasData?
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (context, index){
                  return Divider(height: 1,);
                },
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: (){
                      Navigator.pop(context,items[index]);
                    },
                    title: Text('${items[index].name}',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                  );
                },
              ),
            ):
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
