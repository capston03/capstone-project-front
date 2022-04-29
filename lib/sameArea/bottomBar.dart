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
      'home' : Icon(Icons.home)
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
              Get.toNamed('/map');
            }
          }else if(kind =='profile'){
            if(!chose){
              Get.toNamed('/ble');
            }
          }else if(kind == 'home'){

          }else if(kind == 'camera'){

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
            makeButton("home"),
            makeButton("camera"),
            makeButton("profile"),
          ]

        ],
      ),

    );
  }

}

