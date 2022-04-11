import 'package:flutter/material.dart';
import 'package:flutter_kakao_map/flutter_kakao_map.dart';
import 'package:flutter_kakao_map/kakao_maps_flutter_platform_interface.dart';

class kMapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _kMapPage();
  
}

class _kMapPage extends State<kMapPage>{
  late KakaoMapController mapController;
  MapPoint _visibleRegion = MapPoint(37.503572, 126.957104);
  CameraPosition _kInitialPosition = CameraPosition(target: MapPoint(37.503572, 126.957104), zoom: 5);

  void onMapCreated(KakaoMapController controller) async{
    final MapPoint visibleRegion = await controller.getMapCenterPoint();
    setState(() {
      mapController = controller;
      _visibleRegion = visibleRegion;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter KakaoMap Test')),
      body:Column(
        children: [
          Center(
            child: SizedBox(
              width: 300.0,
              height: 500.0,
              child: KakaoMap(
                onMapCreated: onMapCreated,
                initialCameraPosition: _kInitialPosition,
              )
            ),
          )
        ],
      ));

  }
  
}