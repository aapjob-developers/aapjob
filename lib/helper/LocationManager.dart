import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Aap_job/helper/SharedManager.dart';
// import 'package:location/location.dart';

//
// class LocationManager {
//   static final LocationManager shared = LocationManager._internal();
//
//   factory LocationManager() {
//     return shared;
//   }
//
//   LocationManager._internal();
//
//   var latitude = 0.00;
//   var longitude = 0.00;
//
//   getCurrentLocation()async{
//
//     //var location = new Location();
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
// // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       var currentLocation = position;
//       print("Location data:${currentLocation.longitude}");
//       this.latitude = currentLocation.latitude!;
//       this.longitude = currentLocation.longitude!;
//     } on PlatformException  catch (e) {
//       if (e.code == 'PERMISSION_DENIED') {
//         print("error occured");
//         return;
//       }
//     }
//     // position.onLocationChanged.listen((LocationData currentLocation) {
//     //   print("Updated Latitude--->:${currentLocation.latitude}");
//     //   print("Updated Longitude--->:${currentLocation.longitude}");
//     //
//     //   this.latitude = currentLocation.latitude!;
//     //   this.longitude = currentLocation.longitude!;
//     //   if(this.latitude != 0 && this.longitude != 0){
//     //
//     //   }
//     // });
//   }
//
// }