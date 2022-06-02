import 'dart:convert';

import 'package:capstone_android/network/callApi.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StickerMenu extends StatelessWidget {
  CarouselController controller = CarouselController();
  String gmail_id;
  String beacon_mac;
  StickerMenu({required this.gmail_id, required this.beacon_mac});
  List<String> images = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTIZccfNPnqalhrWev-Xo7uBhkor57_rKbkw&usqp=CAU",
    "https://wallpaperaccess.com/full/2637581.jpg"
  ];
  @override
  Widget build(BuildContext context) {
    return _getImage();
  }
  Future<List<Map<String,dynamic>>> apiImage() async{
    CallApi post = CallApi();
    var map = <String, dynamic>{};
    map['gmail_id'] = gmail_id;
    map['beacon_mac'] = beacon_mac;
    try {
      var response = await post.RequestHttp(
          '/episode/find_episodes_nearby_beacon', jsonEncode(map));
      response = response['result'];
      print("aaaaaaaaaaaaaaaaaa$response");
      print("bbbbbbbbbbbbbb${response.length}");
      return response;
    }catch(e){
      print(e);
      return [];
    }

  }
  _getImage() => FutureBuilder(
      future: apiImage(),
      builder: (context, snapshot) {
        if (snapshot.hasData){
          return CarouselSlider.builder(
            itemCount: 2,
            carouselController: controller,
            itemBuilder: (BuildContext context, int itemIdx, int pageViewIdx){
              return CachedNetworkImage(
                errorWidget: (context, url, error) => Icon(Icons.error),
                placeholder: (context, url) => CircularProgressIndicator(),
                imageUrl: images[itemIdx],);
              // return Image.network(images[itemIdx], width: double.infinity, height: 200, fit: BoxFit.fill);
            }, options: CarouselOptions(
              height: 200.h,
              aspectRatio: 16/9,
              initialPage: 0, viewportFraction: 0.9,
              reverse: false,
              scrollDirection: Axis.horizontal
          ),

          );
        }else if (snapshot.hasError) {
          return SafeArea(
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Text("네트워크 에러 발생")],
                  )));
        }else{
          return const Center(child:CircularProgressIndicator());
        }
      });

}
