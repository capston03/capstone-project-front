import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path/path.dart';
// make bottom bar


class BottomBar extends StatelessWidget{
  int type = 0;
  late String route;
  Map<String, Icon> _category =
    {
      'camera' : Icon(Icons.camera_alt),
      'map' : Icon(Icons.map),
      'profile' : Icon(Icons.account_circle),
      'home' : Icon(Icons.home),
      'stickerUpload' : Icon(Icons.work_outline)
    };
  BottomBar(this.type, {Key? key}) : super(key: key);

  Widget makeButton(String kind,{bool chose = false}){
    return Expanded(
      child: InkWell(
        child: Container(
          padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 6.h),
          child: IconButton(
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(0),
            icon: _category[kind]??const Icon(Icons.home), onPressed: null,
            iconSize: 50,
          ),
          height: 60.h,
          color: chose?Colors.lightGreenAccent:null,
        ),
        onTap: (){
          if(kind=='map'){
            if(!chose){
              Get.offAndToNamed('/map');
              // Get.toNamed('/map');
            }
          }else if(kind =='profile'){
            if(!chose){
              Get.offAndToNamed('/profile');
            }
          }else if(kind == 'home'){
            if(!chose){
              Get.offAndToNamed('/test');
              // Get.toNamed('/test');
            }
          }else if(kind == 'camera'){
            if(!chose){
              Get.offAndToNamed('/upload');
              // Get.toNamed('/upload');
            }
          }else if(kind =='stickerUpload'){
            if(!chose){
              Get.offAndToNamed('/stickerUpload');

              // Get.toNamed('/stickerUpload');
            }
          }
        },

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    route = Get.currentRoute;
    return BottomAppBar(
      child: Row(
        children: [
          if(type==0) ...[

            route == '/GMapSample'||route=='/map'?makeButton("map",chose: true):makeButton("map",chose: false),
            makeButton("profile"),
          ] else ...[
            route=='/test'?makeButton("home",chose: true):makeButton("home",chose: false),
            route == '/upload'?makeButton("camera",chose: true):makeButton("camera",chose: false),
            route == '/stickerUpload'?makeButton("stickerUpload",chose: true):makeButton("stickerUpload",chose: false),
            route == '/profile'?makeButton("profile",chose: true):makeButton("profile",chose: false),
          ]

        ],
      ),

    );
  }

}

