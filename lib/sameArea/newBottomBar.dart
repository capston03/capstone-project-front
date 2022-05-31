import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class newBottomBar extends StatefulWidget {
  int type = 0;
  int index = 0;
  newBottomBar(this.type, this.index) {
    this.type = type;
    this.index = index;
  }

  @override
  State<StatefulWidget> createState() => _newBottomBar(type, index);

}

class _newBottomBar extends State<newBottomBar>{
  int type = 0;
  int index = 0;
  late String route;

  _newBottomBar(int type, int index){
    this.type = type;
    this.index = index;
  }

  @override
  Widget build(BuildContext context) {
    var _currentIndex = index;
    route = Get.currentRoute;
    return SalomonBottomBar(
      currentIndex: _currentIndex,
      onTap: (i){
        setState(() => _currentIndex = i);
        if(type==0){
          switch (i){
            case 0:
              Get.offAndToNamed('/map');
              break;
            case 1:
              Get.offAndToNamed('/profile');
              break;
          }
        }else{
          switch (i){
            case 0:
              Get.offAndToNamed('/test');
              break;
            case 1:
              Get.offAndToNamed('/upload');
              break;
            case 2:
              Get.offAndToNamed('/stickerUpload');
              break;
            case 3:
              Get.offAndToNamed('/profile_in');
              break;

          }
        }
      } ,
      items: [

        if(type==0) ...[
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("홈"),
            selectedColor: Colors.lightGreen,

          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("프로필"),
            selectedColor: Colors.lightGreen,
          ),

        ]else ...[

          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("홈"),
            selectedColor: Colors.purple,

          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.camera_alt),
            title: Text("카메라"),
            selectedColor: Colors.pink,
          ),
          /// Sticker
          SalomonBottomBarItem(
            icon: Icon(Icons.star),
            title: Text("스티커"),
            selectedColor: Colors.teal,
          ),
          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("프로필"),
            selectedColor: Colors.orange,
          ),
        ],
      ],
    );

  }
}