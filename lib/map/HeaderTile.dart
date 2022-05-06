import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class HeaderTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child:Center(child: Text('현재 탐색된 장소 리스트',style: TextStyle(fontSize: 20.sp,color: Colors.green),),),
      width: 300.w,
      height: 50.h,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.lightGreen
          )
        )
      ),
    );
  }
}
