import 'package:Aap_job/models/common_functions.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Aap_job/helper/SharedManager.dart';


 class LocationManager {
   static final LocationManager shared = LocationManager._internal();

  factory LocationManager() {
    return shared;
  }

   LocationManager._internal();

  var latitude = 0.00;
  var longitude = 0.00;

   Future<Position> _determinePosition() async {
     bool serviceEnabled;
     LocationPermission permission;

     // Test if location services are enabled.
     serviceEnabled = await Geolocator.isLocationServiceEnabled();
     if (!serviceEnabled) {
       return Future.error('Location services are disabled.');
     }

     permission = await Geolocator.checkPermission();
     if (permission == LocationPermission.denied) {
       permission = await Geolocator.requestPermission();
       if (permission == LocationPermission.denied) {
         return Future.error('Location permissions are denied');
       }
     }
     if (permission == LocationPermission.deniedForever) {
       // Permissions are denied forever, handle appropriately.
       return Future.error(
           'Location permissions are permanently denied, we cannot request permissions.');
     }

     // When we reach here, permissions are granted and we can
     // continue accessing the position of the device.
     return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
   }



  getCurrentLocation()async{
    //var location = new Location();
    Position position = await _determinePosition();
// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      var currentLocation = position;
     // print("Location data:${currentLocation.longitude}");
      this.latitude = currentLocation.latitude!;
      this.longitude = currentLocation.longitude!;
    } on PlatformException  catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
       // CommonFunctions.showInfoDialog("You have denied location permission", context)
        return false;
      }
    }
    if(this.latitude!=0 && this.longitude!=0)
      {
        var coordinate =LatLng(this.latitude, this.longitude);
        SharedManager.shared.storeLocationCoordinate(coordinate);
      }
  }
//
 }