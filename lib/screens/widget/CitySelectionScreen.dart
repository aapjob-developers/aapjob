import 'dart:convert';
import 'dart:io';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/providers/cities_provider.dart';
import 'package:Aap_job/widgets/show_loading_dialog.dart';
import 'package:Aap_job/widgets/show_location_dialog.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/models/CitiesModel.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';


class CitySelectionScreen extends StatefulWidget {
  CitySelectionScreen({Key? key}) : super(key: key);
  @override
  _CitySelectionScreenState createState() => new _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {

 double latitude = 0;
 double longitude = 0;
 var addressline_2 = "";
 var city = "";

  List<CityModel> duplicateItems = <CityModel>[];
  var items = <CityModel>[];

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    duplicateItems.addAll(Provider.of<CitiesProvider>(context, listen: false).cityModelList);
    items.addAll(duplicateItems);
    //_getLocation();
     //LocationManager.shared.getCurrentLocation();
    super.initState();
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


 _getAddressFromCurrentLocation(LatLng coordinate) async {
   // var coordinate = await SharedManager.shared.getLocationCoordinate();
    print("Stored Location:$coordinate");
    var addresses=await placemarkFromCoordinates(coordinate.latitude, coordinate.longitude);
    Navigator.pop(context);
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
            Platform.isIOS?Container():
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
            )
          ],
        ),
      ),
    );
  }
}
