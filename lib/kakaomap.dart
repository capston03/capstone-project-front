import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:permission_handler/permission_handler.dart';

const String kakaoMapKey = '0be3854ccf27d809bb65b9dbb2dd0453';

class KMapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KmapPage();
}

class _KmapPage extends State<KMapPage>{
  var _mapController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('KakaoMap Test')),
      body: Column(
        children: [
          KakaoMapView(
              width: size.width,
              height: 500,
              kakaoMapKey: kakaoMapKey,
              lat: 37.503617624592685, lng: 126.95704083575833,
              showMapTypeControl: true,
              showZoomControl: true,
              draggableMarker: true,
              mapType: MapType.BICYCLE,
              mapController: (controller){
                _mapController = controller;
              },
              markerImageURL:
            'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
              onTapMarker: (message){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.message)));
              },
              zoomChanged: (message){
                debugPrint('current zoom level : ${message.message}');
              },
            cameraIdle: (message){
                KakaoMapUtil util = KakaoMapUtil();
                KakaoLatLng latlng = util.getLatLng(message.message);
                debugPrint('current lat lng :  ${latlng.lat}, ${latlng.lng}');
            },),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    _mapController.runJavascript(
                        'map.setLevel(map.getLevel() - 1, {animate: true})');
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _mapController.runJavascript(
                        'map.setLevel(map.getLevel() + 1, {animate: true})');
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ElevatedButton(
            child: Text('Kakao map screen'),
            onPressed: () async{
              await _openKakaoMapScreen(context);
            },
          )
        ],
      ),
    );
  }

  Future<void> _openKakaoMapScreen(BuildContext context) async {
    KakaoMapUtil util = KakaoMapUtil();

    // String url = await util.getResolvedLink(
    //     util.getKakaoMapURL(37.402056, 127.108212, name: 'Kakao 본사'));

    /// This is short form of the above comment
    String url =
    await util.getMapScreenURL(37.503617624592685, 126.95704083575833, name: 'Kakao 본사');

    debugPrint('url : $url');

    Navigator.push(
        context, MaterialPageRoute(builder: (_) => KakaoMapScreen(url: url)));
  }

  Widget _testingCustomScript(
      {required Size size, required BuildContext context}) {
    return KakaoMapView(
        width: size.width,
        height: 400,
        kakaoMapKey: kakaoMapKey,
        lat: 33.450701,
        lng: 126.570667,
        customScript: '''
    var markers = [];
    
    function addMarker(position) {
    
      var marker = new kakao.maps.Marker({position: position});

      marker.setMap(map);
    
      markers.push(marker);
    }
    
    for(var i = 0 ; i < 3 ; i++){
      addMarker(new kakao.maps.LatLng(33.450701 + 0.0003 * i, 126.570667 + 0.0003 * i));

      kakao.maps.event.addListener(markers[i], 'click', (function(i) {
        return function(){
          onTapMarker.postMessage('marker ' + i + ' is tapped');
        };
      })(i));
    }
    
		  var zoomControl = new kakao.maps.ZoomControl();
      map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
   
      var mapTypeControl = new kakao.maps.MapTypeControl();
      map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
              ''',
        onTapMarker: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        });
  }
}