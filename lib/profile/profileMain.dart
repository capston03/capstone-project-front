import 'dart:convert';

import 'package:Sticker3D/sameArea/newBottomBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

import '../network/callApi.dart';
import '../login/googleLogin.dart';
import '../sameArea/bottomBar.dart';
import '../sameArea/deviceInfo.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class profileMain extends StatelessWidget{
  int type = 0;

  profileMain(int type){
    this.type = type;
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    if (type == 0){
      index = 1;
    }else {
      index = 2;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: body(),
      bottomNavigationBar: newBottomBar(type,index),
    );
  }

}

class body extends StatelessWidget {
  String model = "";
  String androidId = "";
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Photo",
            icon: Icons.photo,
            press: () {},
          ),
          ProfileMenu(
            text: "My Place",
            icon: Icons.place,
            press: () {},
          ),
          ProfileMenu(
            text: "My Sticker",
            icon: Icons.archive_rounded,
            press: () {Get.toNamed('/photoGrid');},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: Icons.logout,
            press: () async {
              //Get.toNamed('/map');
              print("logout");
              await _checkUser();
            },
          ),
        ],
      ),
    );
  }


  _checkUser() async{

    String id = "";

    try{

      id = await storage.read(key: 'id')??"";
      await GoogleSignInApi.logout();

    }catch(e){
      print(e);
      Get.dialog(
          AlertDialog(
            title: const Text('로그아웃 오류'),
            content: const Text('로그아웃에 실패하였습니다.\n인터넷 연결을 확인해주세요.'),
            actions: [
              TextButton(
                  onPressed: (){
                    Get.back();
                  },
                  child: const Text("닫기"))
            ],
          )
      );
    }

    if(id == ""){
      return;
    }
    // getDeviceInfo();
    Map<String, dynamic> map = {};
    //map['user_gmail_id'] = id;
    map['gmail_id'] = id;
    //map['android_id'] = androidId;
    //map['device_model'] = model;

    CallApi post = CallApi();
    try{
      var test = await post.RequestHttp('/user/account/logout', json.encode(map));
      await storage.delete(key: 'id');

      Get.dialog(
        AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('로그아웃 되었습니다.\n홈 페이지로 이동합니다.'),
          actions: [
            TextButton(
                onPressed: (){
                  Get.offAllNamed('/');
                  // Get.toNamed('/');
                },
                child: const Text("닫기"))
          ],
        )
      );
    }catch(e){
      Get.dialog(
          AlertDialog(
            title: const Text('로그아웃 오류'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                  onPressed: (){
                    Get.back();
                  },
                  child: const Text("닫기"))
            ],
          )
      );
    }

  }

  void getDeviceInfo() async{
    DeviceInfo a = DeviceInfo();
    await a.initPlatformState();
    model = a.getData()['model'];
    androidId = a.getData()['androidId'];
  }


}