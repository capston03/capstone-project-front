import 'dart:collection';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapFunctions{
  List<Marker> bMarkers = [];
  double start_my_latitude =0, start_my_longitude = 0;
  double my_latitude = 0, my_longitude = 0;
  double rangeData = 100;
  late Marker My;
  double calDistance(double a,double b,double c,double d){
    return Geolocator.distanceBetween(a,b,c,d);
  }

  void addMeMarker(){
    My = Marker(
        markerId: MarkerId("0"),
        draggable: true,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        onTap: () => print("User Marker Made"),
        position: LatLng(my_latitude, my_longitude));
  }

  /// add marker (with building Sticker)
  void addMarker(LinkedHashMap<String, dynamic> buildingList) {
    bMarkers = [];
    for (final bBuilding in buildingList.values) {
      if(calDistance(my_latitude,my_longitude,bBuilding['latitude'],bBuilding['longitude'])<=rangeData) {
        bMarkers.add(Marker(
            markerId: MarkerId(bBuilding['id'].toString()),
            draggable: false,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),
            onTap: () => print(bBuilding['name']),
            position: LatLng(bBuilding['latitude'], bBuilding['longitude'])));
      }
    }
    addMeMarker();
    bMarkers.insert(0, My);
  }




}