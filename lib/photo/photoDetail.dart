import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class PhotoDetail {


  void pushLike(){

  }

  void showPhotoDetail() {
    Get.dialog(
      AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content:
            Container(
              child:  SingleChildScrollView(child:
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.only(top: 26.h)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    ClipRRect(
                      // padding: EdgeInsets.all(0),
                      child: Image.network(
                        'https://picsum.photos/id/421/200/200',
                        width: 246.w,
                        height: 246.h,
                        fit: BoxFit.cover,

                      ),
                      // width: 246.w,
                      // height: 246.h,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ],),

                  Padding(padding: EdgeInsets.only(top: 5.h)),

                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 25.w)),
                      SizedBox(
                        child: Text(
                          '자몽 허니 블랙티',
                          style: TextStyle(fontSize: 20.sp),
                        ),
                        width: 167.w,
                      ),
                      Padding(padding: EdgeInsets.only(left: 5.w)),
                      SizedBox(
                        child: IconButton(
                          onPressed: null, //TODO 클릭기능 추가
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(0),
                          icon: Image.asset(
                            "asset/icons/heart.png",
                            width: 30.w,
                            height: 30.h,
                          ),
                        ),
                        width: 30.w,
                        height: 30.h,
                      ),
                      Padding(padding: EdgeInsets.only(left: 5.w)),
                      const Expanded(
                        child: Text('53 likes'),
                      ),
                    ],
                  ),
                  Row(children: [
                    Padding(padding: EdgeInsets.only(left: 25.w),),
                    Text('2022-04-01')
                  ],),
                  Padding(padding: EdgeInsets.only(top: 10.h),),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Padding(padding: EdgeInsets.only(left: 25.w),),
                      Flexible(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 100,
                          // strutStyle: StrutStyle(fontSize: 16.0),
                          text: TextSpan(
                            text: '잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어잘 지냈지 난 잘먹고있어',
                            style: TextStyle(
                              color: Colors.black,

                            )

                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 30.w),),
                    ],),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.h),),

                ],
              ),
              ),
              height: 400.h,
              width: 300.w,
              // decoration: BoxDecoration(
              //     border: Border.all(
              //         width: 1.w,
              //         color: Colors.black
              //     )
              // ),

          ),
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.w, color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(32.0)))),
    );
  }
}
