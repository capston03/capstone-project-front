import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';

import '../network/callApi.dart';
import '../sameArea/newBottomBar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StickerUpload extends StatefulWidget {
  const StickerUpload({Key? key}) : super(key: key);

  @override
  State<StickerUpload> createState() => _StickerUploadState();
}

class _StickerUploadState extends State<StickerUpload> {

  final cropKey = GlobalKey<CropState>();
  File? _file;
  File? sample;
  File? _lastCropped;
  final storage = const FlutterSecureStorage();
  Map<String, dynamic> beacon = Get.arguments;
  @override
  void dispose() {
    super.dispose();
    _file?.delete();
    sample?.delete();
    _lastCropped?.delete();
  }

  //핸드폰 뒤로가기 눌렀을 때 다이얼로그 표출 및 셋팅 저장
  Future<bool> _onWillPop() async {
    return (await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title:  Text("지도 화면으로 이동하시겠습니까?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('아니오'),
          ),
          TextButton(
            onPressed: (){
              Get.offAndToNamed('/map');
            },
            child: Text('네'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('스티커 업로드'),
          centerTitle: true,
          elevation: 0.0,
        ),
        bottomNavigationBar: newBottomBar(1,2),
        body: SafeArea(
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
            child: sample == null ? _buildOpeningImage() : _buildCroppingImage(),
          ),
        ),
      )
    );
  }

  Widget _buildOpeningImage() {
    return Center(child: _buildOpenImage());
  }

  Widget _buildCroppingImage() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Crop.file(sample!, key: cropKey),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20.0),
          alignment: AlignmentDirectional.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                child: Text(
                  '스티커 생성',
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(color: Colors.white),
                ),
                onPressed: () {
                  Get.dialog(AlertDialog(
                    title: Text('이 화면으로 스티커를 만드시겠습니까?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            _cropImage();
                          },
                          child: const Text("예")),
                      TextButton(
                          onPressed: () {
                            Get.back();
                            // Get.to(GMapSample());
                          },
                          child: const Text("닫기"))
                    ],
                  ));
                }
              ),
              _buildOpenImage(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildOpenImage() {
    return TextButton(
      child: Text(
        '다른 이미지 열기',
        style: Theme.of(context).textTheme.button!.copyWith(color: Colors.white),
      ),
      onPressed: () => _openImage(),
    );
  }

  Future<void> _openImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    final file = File(pickedFile!.path);
    final _sample = await ImageCrop.sampleImage(
      file: file,
      preferredSize: context.size!.longestSide.ceil(),
    );

    sample?.delete();
    _file?.delete();

    setState(() {
      sample = _sample;
      _file = file;
    });
  }
  ///이미지 잘라 비율을 넘기는 함수
  Future<void> _cropImage() async {
    Get.back();
    CallApi.circularLoading(context, "전송중입니다");
    final area = cropKey.currentState!.area!;
    String uploader_gmail_id = await storage.read(key: 'id')??"";
    Map<String, dynamic> map = {};
    List<double> rectangle = [area.topLeft.dx,area.topLeft.dy,area.topRight.dx - area.topLeft.dx,area.bottomLeft.dy - area.topLeft.dy];
    map['rectangle'] = rectangle;
    map['beacon_mac'] = beacon['mac_addr'];
    map['uploader_gmail_id'] = uploader_gmail_id;
    // List<int> imageBytes = sample!.readAsBytesSync();

    // String base64Image = Base64Encoder(imageBytes);
    map['image'] = sample;
    CallApi post = CallApi();
    var formData = dio.FormData.fromMap({
      'rectangle[]': rectangle,
      'beacon_mac': beacon['mac_addr'],
      'uploader_gmail_id' : uploader_gmail_id,
      'image': await dio.MultipartFile.fromFile(_file!.path, filename: 'temp.png'),
    });
    var response = await post.dioFileTransfer('/image/sticker/upload',formData);
    String result = response["result"];
    if(result=='success'){
      Get.back();
      Get.dialog(AlertDialog(
        title: Text('성공'),
        content: Text('전송 완료'),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
                // Get.to(GMapSample());
              },
              child: const Text("닫기"))
        ],
      ));
    }else{
      Get.back();
      Get.dialog(AlertDialog(
        title: Text('에러 발생'),
        content: Text('다음에 시도해 주시기 바랍니다.'),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
                // Get.to(GMapSample());
              },
              child: const Text("닫기"))
        ],
      ));
    }
    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    // final sample = await ImageCrop.sampleImage(
    //   file: _file!,
    //   preferredSize: (2000 / scale).round(),
    // );
    // print(area);
    // final file = await ImageCrop.cropImage(
    //   file: sample,
    //   area: area,
    // );
    //
    // sample.delete();
    //
    // _lastCropped?.delete();
    // _lastCropped = file;
    //
    // debugPrint('$file');
  }
}

