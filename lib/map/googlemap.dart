import 'dart:async';

import 'package:capstone_android/sameArea/bottomBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class GMapSample extends StatefulWidget {
  @override
  State<GMapSample> createState() => _GMapSample();
}

class _GMapSample extends State<GMapSample> {
  Completer<GoogleMapController> _controller = Completer();
  late Future<LatLng> currentLocation;
  late LatLng temp;
  double my_latitude=0,my_longitude=0;
  final List<Marker> bMarkers = [];
  double rangeData = 100;

  Future<bool> checkPermission() async { //권한설정 물어보기
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request(); //여러가지 퍼미션을하고싶으면 []안에 추가하면된다. (팝업창이뜬다)

    bool per = true;

    statuses.forEach((permission, permissionStatus) {
      if (!permissionStatus.isGranted) {
        Get.dialog(AlertDialog(
          title: const Text('경고'),
          content: Text(
              '${permission.toString()}권한을 거부 하셨습니다. \n추후 실행이 안되는 기능이 있을 수 있습니다.'),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                  Get.to(GMapSample());
                },
                child: const Text("닫기"))
          ],
        ));
        per = false; //하나라도 허용이안됐으면 false
      }
    });
    return per;
  }


  Future<LatLng> getLocation() async {

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _getCurrentLocation();
    setState(() {
      my_latitude = position.latitude;
      my_longitude = position.longitude;
    });
    bMarkers.add(Marker(
        markerId: MarkerId("1"),
        draggable: true,
        onTap: () => print("Marker!"),
        position: LatLng(my_latitude, my_longitude)));
    temp = LatLng(position.latitude, position.longitude);
    return LatLng(position.latitude, position.longitude);
  }

  @override
  void initState() {
    checkPermission();
    currentLocation = getLocation();

  }
  //
  // Set<Circle> circles = Set.from([Circle(
  //   circleId: CircleId('currentCircle'),
  //   center: LatLng(latitude, longitude),
  //   radius: 4000,
  //   fillColor: Colors.blue.shade100.withOpacity(0.5),
  //   strokeColor: Colors.blue.shade100.withOpacity(0.1),
  // )]);

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
                    },
                  circles: {Circle(
                    circleId: CircleId('currentCircle'),
                    center: LatLng(my_latitude, my_longitude),
                    radius: rangeData,
                    fillColor: Colors.blue.shade100.withOpacity(0.5),
                    strokeColor: Colors.blue.shade100.withOpacity(0.1),
                  )},
                ),
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
                Positioned(
                  child: Slider(
                    activeColor: Colors.green,
                    inactiveColor: Color(0xff8fb0c6),
                    max: 500, value: rangeData,min: 100,divisions: 4,
                    label:  rangeData.round().toString(),
                    onChanged: (double val){
                      setState(() {
                        rangeData = val;
                      });
                    },
                  ),
                  right: 10.w,
                  top: 50.h,
                )
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
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: await getLocation(), zoom: 18.0)));
  }

  void _getCurrentLocation() {
    Future.delayed(Duration(seconds: 10)).then((_) {
      setState(() {
        currentLocation = getLocation();
        print("user current location changed");
      });
      _getCurrentLocation();
    });
  }
}
