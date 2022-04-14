

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMapSample extends StatefulWidget {
  @override
  State<GMapSample> createState() => _GMapSample();
}

class _GMapSample extends State<GMapSample> {
  Completer<GoogleMapController> _controller = Completer();
  late Future<LatLng> currentLocation;
  late LatLng temp;
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.503617624592685, 126.95704083575833),
      tilt: 59.440717697143555,
      zoom: 18);

  Future<LatLng> getLocation() async{
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    temp = LatLng(position.latitude, position.longitude);
    return LatLng(position.latitude, position.longitude);
  }


  @override
  void initState(){
    currentLocation = getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Google Map with Beacon"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: FutureBuilder<LatLng>(
        future: currentLocation,
        builder: (context, snapshot){
          print(snapshot);
          if(snapshot.hasData){
            return GoogleMap(
              initialCameraPosition: CameraPosition(
              target: snapshot.data!,
              zoom: 18.0
              ),
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
              });
            }else if(snapshot.hasError){
              return SafeArea(
                child: Center(child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [ Text("구글 맵 연동 에러")],
                ))
              );
            }else{
                return SafeArea(
                    child: Center(child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                            child: CircularProgressIndicator(),
                            width: 60,
                            height: 60,
                            ),
                            const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('구글 맵 데이터 불러오는 중...'),
                            )],
                ))
                );
          }
      },

    )


      /*GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: getLocation(), zoom: 17),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the University!'),
        icon: Icon(Icons.directions_boat),
      ),
    ); */
    );
  }


}