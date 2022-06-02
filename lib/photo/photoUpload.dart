import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import '../sameArea/bottomBar.dart';
import 'dart:async';

import '../sameArea/newBottomBar.dart';

class PhotoUpload extends StatefulWidget {
  const PhotoUpload({Key? key}) : super(key: key);

  @override
  State<PhotoUpload> createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {
  final picker = ImagePicker();
  late File imageFile1; //이미지 파일 저장 변수
  bool image_pick1 = false; // 이미지를 골랐는지 안했는지를 체크
  List<File> imageFiles = [];
  Map<String, dynamic> beacon = Get.arguments;
  final List<TextEditingController> controller = List.generate(
      2, (index) => TextEditingController()); // text edit controller부여

  //핸드폰 뒤로가기 눌렀을 때 다이얼로그 표출 및 셋팅 저장
  Future<bool> _onWillPop() async {
    return (await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: Text("지도 화면으로 이동하시겠습니까?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('아니오'),
              ),
              TextButton(
                onPressed: () {
                  Get.offAndToNamed('/map');
                },
                child: Text('네'),
              ),
            ],
          ),
        )) ??
        false;
  }

  //이미지를 갤러리 공간에서 가져옵니다.
  _getFromGallery() async {
    var status = await ph.Permission.storage.status;
    if (status.isDenied) {
      // You can request multiple permissions at once.
      Map<ph.Permission, ph.PermissionStatus> statuses = (await [
        ph.Permission.storage,
      ].request())
          .cast<ph.Permission, ph.PermissionStatus>();
      print(statuses[
          ph.Permission.storage]); // it should print PermissionStatus.granted
    }
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image_pick1 = true;
        imageFile1 = File(pickedFile.path);
        imageFiles.add(imageFile1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Upload'),
          centerTitle: true,
          elevation: 0.0,
        ),
        bottomNavigationBar: newBottomBar(1,1),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          // padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
              color: Colors.white,
              width: 337.w,
              // height: 483.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(padding: EdgeInsets.only(top: 20.h)),
                  Container(
                    padding: EdgeInsets.all(0),
                    // height: 216.h,
                    width: 282.w,
                    height: !image_pick1 ? 108.h : null,
                    child: !image_pick1
                        ? IconButton(
                            onPressed: () {
                              _getFromGallery();
                            },
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(0),
                            icon: Image.asset(
                              "asset/icons/image_upload.png",
                              color:const Color.fromRGBO(255, 255, 255, 0.5),
                              colorBlendMode: BlendMode.modulate,
                              width: 70.w,
                              height: 54.h,
                            ),
                          )
                        : GestureDetector(
                            child: Image.file(
                              //그 이미지를 직접적으로 보여주어야 합니다.
                              imageFile1, //내가 고른 이미지
                              fit: BoxFit.fill,
                              color:const Color.fromRGBO(255, 255, 255, 0.5),
                              // height: 216.h,
                            ),
                            onTap: () {
                              _getFromGallery();
                            },
                          ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.h)),
                  Padding(
                    padding: EdgeInsets.only(left: 50.h),
                    child: Text('위 이미지를 클릭하여 사진을 업로드 해 주세요.'),
                  ),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 20.w)),
                      SizedBox(
                        child: IconButton(
                          onPressed: null,
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(0),
                          icon: Image.asset(
                            "asset/icons/googleMap.png",
                            width: 38.w,
                            height: 38.h,
                          ),
                        ),
                        height: 38.h,
                        width: 38.w,
                      ),
                      Padding(padding: EdgeInsets.only(left: 10.w)),
                      Text(beacon['detail_location']),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.h)),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 20.w)),
                      Expanded(
                        child: TextField(
                          maxLength: 100,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: controller[0],
                          decoration: InputDecoration(
                            hintText: '제목',
                            hintStyle: TextStyle(fontSize: 15.sp),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  width: 0.5,
                                )),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 20.w)),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.h)),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 20.w)),
                      Expanded(
                        child: TextField(
                          maxLength: 300,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: controller[1],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15, bottom: 150),
                            hintText: '내용',
                            hintStyle: TextStyle(fontSize: 15.sp),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  width: 0.5,
                                )),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 20.w)),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.h)),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 20.w)),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end:Alignment.bottomRight,
                                  colors: [
                                    Colors.lightGreenAccent,
                                    Colors.lightGreen,
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                            ),
                            child: Center(
                              child: Text(
                                '업로드',
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            height: 42.h,
                          ),
                          onTap: null,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 20.w)),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.h)),
                ],
              ),
            ),
          ),
          height: double.infinity,
          width: double.infinity,
        ),
      ),
      onWillPop: _onWillPop,
    );
  }
}
