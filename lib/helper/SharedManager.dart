
import 'package:Aap_job/helper/LocationManager.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SharedManager {
  static final SharedManager shared = SharedManager._internal();

  factory SharedManager() {
    return shared;
  }

  SharedManager._internal();

  var latitude = 0.0;
  var longitude = 0.0;

  storeLocationCoordinate(LatLng coordinates) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (coordinates.latitude != 0.0 || coordinates.longitude != 0.0) {
      await prefs.setDouble("latitude", coordinates.latitude);
      await prefs.setDouble("longitude", coordinates.longitude);
    }
  }

  Future<LatLng> getLocationCoordinate() async {
    await LocationManager.shared.getCurrentLocation();
    this.latitude = await LocationManager.shared.latitude!;
    this.longitude = await LocationManager.shared.longitude!;
    var latlong = LatLng(latitude, longitude);
   return latlong;
  }

}