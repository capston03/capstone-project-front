import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// make bottom bar
class BottomBar extends StatelessWidget{
  int type = 0;
  Map<String, Icon> _category =
    {
      'camera' : Icon(Icons.camera_alt),
      'map' : Icon(Icons.map),
      'profile' : Icon(Icons.account_circle),
      'home' : Icon(Icons.home)
    };
  BottomBar(this.type, {Key? key}) : super(key: key);
  Widget makeButton(String kind){
    return Expanded(
      child: InkWell(
        child: Container(
          padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 6.h),
          child: IconButton(
            constraints: BoxConstraints(),
            padding: const EdgeInsets.all(0),
            icon: _category[kind]??const Icon(Icons.home), onPressed: null,
            iconSize: 50,
          ),
          height: 60.h,

        ),
        onTap: (){

        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    return BottomAppBar(
      child: Row(
        children: [
          if(type==0) ...[
            makeButton("map"),
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

