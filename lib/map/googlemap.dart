import 'dart:async';

import 'package:capstone_android/sameArea/bottomBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final List<Marker> bMarkers = [];

  Future<LatLng> getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    temp = LatLng(position.latitude, position.longitude);
    return LatLng(position.latitude, position.longitude);
  }

  @override
  void initState() {
    currentLocation = getLocation();
    bMarkers.add(Marker(
        markerId: MarkerId("1"),
        draggable: true,
        onTap: () => print("Marker!"),
        position: LatLng(37.50359, 126.95708)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Map with Beacon"),
        centerTitle: true,
        elevation: 0.0,
      ),
      bottomNavigationBar: BottomBar(0),
      body: FutureBuilder<LatLng>(
        future: currentLocation,
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            return Stack(
              children: [
                GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: snapshot.data!, zoom: 18.0),
                    markers: Set.from(bMarkers),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    }),
                Positioned(
                  child: FloatingActionButton.extended(
                    onPressed: () async{
                      final GoogleMapController controller = await _controller.future;
                      controller.animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(target: await getLocation(), zoom: 18.0)));
                    },
                    label: Text('현재 위치'),
                    icon: Icon(Icons.gps_fixed),
                  ),
                  top: 10.h,
                  right: 20.w,
                ),

              ],

            );
          } else if (snapshot.hasError) {
            return SafeArea(
                child: Center(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text("구글 맵 연동 에러")],
            )));
          } else {
            return SafeArea(
                child: Center(
                    child: Column(
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
                )
              ],
            )));
          }
        },
      ),

    );
  }

  Future<void> getCurrentPosition() async {
    print('asda');
    final GoogleMapController controller = await _controller.future;
    print('asdasdsd');
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: await getLocation(), zoom: 18.0)));
    print('kkkk');
  }
}
