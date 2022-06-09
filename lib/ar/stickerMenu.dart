import 'dart:convert';

import 'package:capstone_android/login/manageSignUp.dart';
import 'package:capstone_android/network/callApi.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../db/manageSqlflite.dart';
import '../db/thumbnail.dart';
import 'arManager.dart';

class StickerMenu extends GetView<ArManager> {
  CarouselController _controller = CarouselController();
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

  Future<List<List<dynamic>>> apiImage() async {
    List<ThumbNail> dbThumbnail = await ManageSqlflite.singleton.findBeaconList(beacon_mac);

    if(dbThumbnail.isEmpty) { //처음 받을떄
      CallApi post = CallApi();
      List<List<dynamic>> images = [];
      var map = <String, dynamic>{};
      map['gmail_id'] = gmail_id;
      map['beacon_mac'] = beacon_mac;
      try {
        var response = await post.RequestHttp(
            '/episode/find_episodes_nearby_beacon', jsonEncode(map));
        var data = response['result'] as Map<String, dynamic>;
        await ManageSqlflite.singleton.remove();
        for (int i = 0; i < data.length; i++) {
          map['episode_id'] = data[i.toString()]['identifier'];
          var response_thumbnail = await post.RequestHttp(
              '/image/thumbnail/download', jsonEncode(map));
          List<dynamic> image = [];
          ThumbNail info = ThumbNail(
              title: data[i.toString()]['title'],
              content: data[i.toString()]['content'],
              uploader_gmail_id: data[i.toString()]['uploader_gmail_id'],
              upload_time: data[i.toString()]['upload_time'],
              beacon_mac: data[i.toString()]['beacon_mac'],
              identifier: data[i.toString()]['identifier'],
              heart_rate: data[i.toString()]['heart_rate'],
              download_url: response_thumbnail["result"]["download_url"]);
          await ManageSqlflite.singleton.insert(info);
          image.add(response_thumbnail["result"]["download_url"]);
          image.add(map['episode_id']);
          images.add(image);
        }
        return images;
      } catch (e) { //한번이라도 받은 적이 있는 case
        print("$e");
        return [];
      }
    }else{ //
      List<List<dynamic>> images = [];
      List<dynamic> episode_id = [];
      for(ThumbNail a in dbThumbnail){
        List<dynamic> image = [];
        image.add(a.download_url);
        image.add(a.identifier);
        episode_id.add(a.identifier);
        images.add(image);
      }

      //episode id 네트워크 호출




      return [];
    }
  }

  downloadSticker(int episode_id) async {
    CallApi post = CallApi();
    var map = <String, dynamic>{};
    map['episode_id'] = episode_id;
    try {
      var response =
          await post.RequestHttp('/image/sticker/download', jsonEncode(map));

      String data = response['result']['download_url'];
      print("asdjlsdjfilsjdlkfjslkd$data");
      controller.glburl = data;
    } catch (e) {
      print("fdjligasflkdhgkdfskghd");
      print(e);
    }
  }

  _getImage() => FutureBuilder(
      future: apiImage(),
      builder: (context, AsyncSnapshot<List<List<dynamic>>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length == 0) {
            return Container(
              child: Center(
                child: Text(
                  '업로드 된 스티커가 없습니다',
                  style: TextStyle(
                    fontSize: 20.sp,
                  ),
                ),
              ),
            );
          }
          return Stack(
            children: [
              CarouselSlider.builder(
                itemCount: snapshot.data!.length,
                carouselController: _controller,
                itemBuilder:
                    (BuildContext context, int itemIdx, int pageViewIdx) {
                  return GestureDetector(
                    child: CachedNetworkImage(
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      imageUrl: snapshot.data![itemIdx][0].toString(),
                    ),
                    onTap: () async {
                      controller.episodes = snapshot.data![itemIdx][1];
                      await downloadSticker(controller.episode);
                      Get.back();
                    },
                  );
                  // return Image.network(images[itemIdx], width: double.infinity, height: 200, fit: BoxFit.fill);
                },
                options: CarouselOptions(
                    // height: 200.h,
                    aspectRatio: 16 / 9,
                    initialPage: 0,
                    viewportFraction: 0.9,
                    reverse: false,
                    scrollDirection: Axis.horizontal),
              ),
              Positioned(
                // top: 10.h,

                right: 10.w,
                child:GestureDetector(child:  Container(
                  padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 6.h),
                  child: const IconButton(
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.refresh),
                    onPressed: null,
                    iconSize: 30,
                  ),
                  height: 30.h,
                ),
                  onTap: (){
                    //여기에 새로고침 기술 넣자
                  },

                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return SafeArea(
              child: Center(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text("네트워크 에러 발생")],
          )));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      });
}
