import 'dart:convert';

import 'package:capstone_android/login/manageSignUp.dart';
import 'package:capstone_android/network/callApi.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../db/manageSqlflite.dart';
import '../db/thumbnail.dart';

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
  Future<List<String>> apiImage() async{
    CallApi post = CallApi();
    List<String> image = [];
    var map = <String, dynamic>{};
    map['gmail_id'] = gmail_id;
    map['beacon_mac'] = beacon_mac;
    try {
      var response = await post.RequestHttp(
          '/episode/find_episodes_nearby_beacon', jsonEncode(map));
      var data = response['result'] as Map<String, dynamic>;
      await ManageSqlflite.singleton.remove();

      for(int i=0;i<data.length;i++){
        ThumbNail info = ThumbNail(title: data[i.toString()]['title'], content: data[i.toString()]['content'], uploader_gmail_id: data[i.toString()]['uploader_gmail_id'],
            upload_time: data[i.toString()]['upload_time'], beacon_mac: data[i.toString()]['beacon_mac'], identifier: data[i.toString()]['identifier'],
            heart_rate: data[i.toString()]['heart_rate']);
        await ManageSqlflite.singleton.insert(info);
        map['episode_id'] = data[i.toString()]['identifier'];
        var response_thumbnail = await post.RequestHttp('/image/thumbnail/download', jsonEncode(map));

        image.add(response_thumbnail["result"]["download_url"]);
      }
      print("ddddddddddddddddddddd${image.length}");
      return image;
    }catch(e){

      print("ccccccccccccccccccccccccccc$e");
      return [];
    }

  }
  _getImage() => FutureBuilder(
      future: apiImage(),
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasData){
          return CarouselSlider.builder(
            itemCount: snapshot.data!.length,
            carouselController: controller,
            itemBuilder: (BuildContext context, int itemIdx, int pageViewIdx){
              return CachedNetworkImage(
                errorWidget: (context, url, error) => Icon(Icons.error),
                placeholder: (context, url) => CircularProgressIndicator(),
                imageUrl: snapshot.data![itemIdx],);
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
