import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:capstone_android/network/callApi.dart';
import 'package:capstone_android/sameArea/bottomBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../photo/photoDetail.dart';
import '../sameArea/newBottomBar.dart';
import 'BuildingTile.dart';
import 'blefind.dart';
import 'googleMapCalculate.dart';
import 'HeaderTile.dart';

class GMapSample extends StatefulWidget {
  @override
  State<GMapSample> createState() => _GMapSample();
}

class _GMapSample extends State<GMapSample> {
  GoogleMapFunctions func = GoogleMapFunctions();
  Completer<GoogleMapController> _controller = Completer();
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResultList = [];
  bool _isScanning = false;
  // PhotoDetail aa = PhotoDetail(); // TODO 삭제좀해라

  late Future<LatLng> currentLocation;
  var buildingList; //빌딩 건물들 받아와 리스트로 저장

  Future<bool> checkPermission() async {
    //권한설정 물어보기
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetoothScan
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
                  // Get.to(GMapSample());
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
    setState(() {
      func.my_latitude = position.latitude;
      func.my_longitude = position.longitude;
      func.start_my_latitude = func.my_latitude;
      func.start_my_longitude = func.my_longitude;
    });
    func.bMarkers.add(Marker(
        markerId: MarkerId("0"),
        draggable: true,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        onTap: () => print("User Marker Made"),
        position: LatLng(func.my_latitude, func.my_longitude)));

    CallApi post = CallApi();
    var userCurrentLocate = <String, dynamic>{};

    userCurrentLocate['latitude'] = func.my_latitude;
    userCurrentLocate['longitude'] = func.my_longitude;
    userCurrentLocate['range_radius'] = func.rangeData;
    buildingList = await post.RequestHttp(
        '/nearby_building', json.encode(userCurrentLocate));
    // print('aaaaaaaaaaaaaaa$buildingList');
    func.addMarker(buildingList);
    _getCurrentLocation();
    return LatLng(position.latitude, position.longitude);
  }

  @override
  void initState() {
    checkPermission();
    currentLocation = getLocation();
    initBle();
  }

  void initBle() {
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  Future callBLECheck(List a) async {
    CallApi post = CallApi();
    var data = <String, dynamic>{};
    int cnt = 0;
    for (var i in a) {
      var map = <String, dynamic>{};
      map['mac_addr'] = i;
      data[cnt.toString()] = map;
      cnt++;
    }
    Map<String, dynamic> request = await post.RequestHttp(
        '/get_all_nearby_authorized_beacons', json.encode(data));
    print(request);
    print(request.length);
    if (request['result'] == null) {
      Get.dialog(AlertDialog(

        title: Text('정보'),
        content: Text(
            '근처 건물의 비콘을 찾았습니다.\n${request['0']['detail_location']}\n건물에 들어가시겠습니까?'),
        actions: [
          TextButton(
              onPressed: () => Get.offNamed('/test', arguments: request['0']),
              child: const Text("확인")),
          if (request.length > 1) ...[
            TextButton(
                onPressed: () {
                  Get.back();
                  printBuildingList(request);
                  // aa.showPhotoDetail();
                },
                child: const Text("다른 리스트 확인"))
          ],
          TextButton(onPressed: () => Get.back(), child: const Text("닫기"))
        ],
      ),barrierDismissible: false);
    }
  }

  void printBuildingList(Map<String, dynamic> request) {
    Get.dialog(
      AlertDialog(
        // title: Text('정보')
        content: Container(
          child:ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: request.length+1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) return HeaderTile();
            return BuildingTile( title: '${request[(index-1).toString()]['detail_location']}',info: request[(index-1).toString()]);
          },
        ),
          height: 400.h,
          width: 300.w,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.w,
              color: Colors.green
            )
          ),
        ),

      ),
      barrierDismissible: false,
    );
  }

  void infiniteScan() async {
    await scan();
    List<String> candidateBeacon = [];

    /// TODO
    /// 나중에 [0]이 메인 맥주소
    /// 이걸 기준으로 벤 or do something
    Future.delayed(const Duration(seconds: 3)).then((_) async {
      for (ScanResult beacon in scanResultList) {
        String name = beacon.device.name.isNotEmpty
            ? beacon.device.name
            : beacon.advertisementData.localName.isNotEmpty
                ? beacon.advertisementData.localName
                : 'N/A';
        String mac = beacon.device.id.id;
        if (name.startsWith('trc')) {
          candidateBeacon.add(mac);
        }
      }
      if (candidateBeacon.isNotEmpty) {
        await callBLECheck(candidateBeacon);
      }
    });
    //
    // Future.delayed(const Duration(seconds: 3),() async {
    //   for(ScanResult beacon in scanResultList){
    //     String name = beacon.device.name.isNotEmpty?beacon.device.name:beacon.advertisementData.localName.isNotEmpty?beacon.advertisementData.localName:'N/A';
    //     String mac = beacon.device.id.id;
    //     if(name.startsWith('trc')){
    //       candidateBeacon.add(mac);
    //     }
    //   }
    //   if(candidateBeacon.isNotEmpty){
    //     await callBLECheck(candidateBeacon);
    //   }
    // });
  }

  /*스캔 시작/정지 */
  scan() async {
    bool bluetooth = await flutterBlue.isOn;
    if (bluetooth) {
      if (!_isScanning) {
        print('start');
        scanResultList.clear();
        flutterBlue.startScan(timeout: const Duration(seconds: 2));
        flutterBlue.scanResults.listen((results) {
          scanResultList = results;
          // if(mounted) {
          // print(results);
          setState(() {});
          // }
        });
      } else {
        print('stop');
        flutterBlue.stopScan();
      }
    } else {
      Get.dialog(AlertDialog(
        title: const Text('경고'),
        content: const Text('블루투스가 꺼져있습니다.\n블루투스를 켜주시기 바랍니다.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("닫기"))
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map with Beacon"),
        centerTitle: true,
        elevation: 0.0,
      ),
      bottomNavigationBar: newBottomBar(0, 0),
      body: FutureBuilder<LatLng>(
        future: currentLocation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: snapshot.data!, zoom: 18.0),
                  markers: Set.from(func.bMarkers),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  circles: {
                    Circle(
                      circleId: CircleId('currentCircle'),
                      center: LatLng(func.my_latitude, func.my_longitude),
                      radius: func.rangeData,
                      fillColor: Colors.blue.shade100.withOpacity(0.5),
                      strokeColor: Colors.blue.shade100.withOpacity(0.1),
                    )
                  },
                ),
                Positioned(
                  child: FloatingActionButton.extended(
                    heroTag: "btn2",
                    onPressed: () async {
                      final GoogleMapController controller =
                          await _controller.future;
                      controller.animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                              target: await getLocation(), zoom: 18.0)));
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
                    max: 500,
                    value: func.rangeData,
                    min: 100,
                    divisions: 4,
                    label: func.rangeData.round().toString(),
                    onChanged: (double val) {
                      setState(() {
                        func.rangeData = val;
                        func.addMarker(buildingList);
                      });
                    },
                  ),
                  right: 10.w,
                  top: 50.h,
                ),
                Positioned(
                    child: FloatingActionButton(
                      heroTag: "btn3",
                      onPressed: infiniteScan,
                      child: Icon(
                          _isScanning ? Icons.stop : Icons.bluetooth_audio),
                    ),
                    left: 20.w,
                    top: 5.h),
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
              children: const [
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                Padding(
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

  //실시간 자기위치 체크
  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double dis = func.calDistance(func.start_my_latitude,
        func.start_my_longitude, position.latitude, position.longitude);
    setState(() {
      func.my_latitude = position.latitude;
      func.my_longitude = position.longitude;
      if (dis > 5000) {
        func.start_my_longitude = position.longitude;
        func.start_my_latitude = position.latitude;
      }
    });
    print('${position.latitude},${position.longitude}');
    func.addMarker(buildingList);
    if (dis > 5000) {
      // 5KM벗어나면 다시 서버콜해서 빌딩 초기화
      CallApi post = CallApi();
      var userCurrentLocate = <String, dynamic>{};

      userCurrentLocate['latitude'] = func.my_latitude;
      userCurrentLocate['longitude'] = func.my_longitude;
      buildingList = await post.RequestHttp(
          '/nearby_building', json.encode(userCurrentLocate));
    }
    Future.delayed(Duration(seconds: 60)).then((_) async {
      _getCurrentLocation();
    });
  }
}
