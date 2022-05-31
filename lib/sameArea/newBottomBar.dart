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

  Map<String, Icon> _category =
  {
    'camera' : Icon(Icons.camera_alt),
    'map' : Icon(Icons.map),
    'profile' : Icon(Icons.account_circle),
    'home' : Icon(Icons.home),
    'stickerUpload' : Icon(Icons.work_outline)
  };

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
              Get.offAndToNamed('/test',arguments: Get.arguments);
              break;
            case 1:
              Get.offAndToNamed('/upload',arguments: Get.arguments);
              break;
            case 2:
              Get.offAndToNamed('/stickerUpload',arguments: Get.arguments);
              break;
            case 3:
              Get.offAndToNamed('/profile_in',arguments: Get.arguments);
              break;

          }
        }
      } ,
      items: [

        if(type==0) ...[
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Colors.lightGreen,

          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.lightGreen,
          ),

        ]else ...[

          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Colors.purple,

          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.camera_alt),
            title: Text("Camera"),
            selectedColor: Colors.pink,
          ),
          /// Sticker
          SalomonBottomBarItem(
            icon: Icon(Icons.star),
            title: Text("Sticker"),
            selectedColor: Colors.teal,
          ),
          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.orange,
          ),
        ],
      ],
    );

  }
}