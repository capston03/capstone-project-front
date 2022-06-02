// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert' show json, jsonEncode;
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../ble.dart';

// import '../googleLogi'googleLogin.dart'age:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import '../map/googlemap.dart';
import 'googleLogin.dart';
import 'loginEnum.dart' as LoginEnum;
import '../network/callApi.dart';
import '../sameArea/deviceInfo.dart';
import 'package:permission_handler/permission_handler.dart';

class SignInDemo extends StatefulWidget {
  @override
  State createState() => _SignInDemo();
}

class _SignInDemo extends State<SignInDemo> {
  GoogleSignInAccount? _currentUser;
  String model = "";
  String androidId = "";
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
    checkPermission();
    _asyncCheck();
  }

  _asyncCheck() async{
    String id="";
    try{
      id = await storage.read(key: 'id')??"";
    }catch(e){
      print(e);
      return;
    }
    if(id==""){
      return;
    }
    Map<String, dynamic> map = {};
    map['user_gmail_id'] = id; //이메일 앞글자만 보내기
    map['gmail_id'] = id; //이메일 앞글자만 보내기
    map['android_id'] = androidId; //이메일 앞글자만 보내기
    map['device_model'] = model; //이메일 앞글자만 보내기
    CallApi post = CallApi();
    try {
      var test = await post.RequestHttp('/user/account/logout', json.encode(map));
      var response = await post.RequestHttp('/user/account/login', json.encode(map));
      var result = response['result'];


      loginAfter(id, result);
    }catch(e){
      Get.dialog(AlertDialog(
        title: const Text('오류'),
        content: const Text('서버와의 연결이 끊겼습니다.'),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("닫기"))
        ],
      ));
    }

  }

  Future<void> loginAfter(String email, dynamic result) async {
    if (result['code'] == LoginEnum.Login.LOGIN_SUCCESS.value) {
      await storage.write(key: 'id', value: email);
      await storage.write(key: 'nick', value: result['nick']);

      //login success
      Get.dialog(AlertDialog(
        title: const Text('성공'),
        content: const Text('로그인 성공'),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
                Get.off(() => GMapSample());
              },
              child: const Text("닫기"))
        ],
      ),barrierDismissible: false);
    } else if (result['code'] == LoginEnum.Login.USER_ACCOUNT_IS_NOT_EXISTED.value) {
      //user 계정이 없는 경우.
      await logout();
      Get.toNamed('/signup', arguments: email);
    } else if (result['code'] == LoginEnum.Login.USER_IS_ALREADY_LOGGED_IN.value) {
      //이미 로그인한경우
      //TODO 후에 서logout버에서 연결을 취소하고, 여기선 로그아웃 후 로그인을 보낸다(다이얼로그로 확인 요망)
      //지금은 임시로 성공이라고하겠다

      CallApi post = CallApi();
      var map = <String,dynamic>{};
      map['gmail_id'] = email;
      map['android_id'] = androidId;
      map['device_model'] = model;
      map['user_gmail_id'] = email;
      try {
        await post.RequestHttp('/user/account/logout', json.encode(map));
        await post.RequestHttp('/user/account/login', json.encode(map));
        await storage.write(key: 'id', value: email);
        Get.dialog(
            AlertDialog(
              title: const Text('성공'),
              content: const Text('로그인 성공'),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.back();
                      Get.off(() => GMapSample());
                    },
                    child: const Text("닫기"))
              ],
            ),barrierDismissible: false);
      }catch(e){
        Get.dialog(AlertDialog(
          title: const Text('오류'),
          content: const Text('서버와의 연결이 끊겼습니다'),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("닫기"))
          ],
        ));
      }


    } else {
      Get.dialog(AlertDialog(
        title: const Text('Error'),
        content: const Text('로그인이 제대로 되지 않았습니다\n다시 시도 부탁드립니다.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("닫기"))
        ],
      ));
    }
  }

  Future<bool> checkPermission() async { //권한설정 물어보기
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.location,
      Permission.bluetoothConnect
    ].request(); //여러가지 퍼미션을하고싶으면 []안에 추가하면된다. (팝업창이뜬다)

    bool per = true;

    statuses.forEach((permission, permissionStatus) {
      if (!permissionStatus.isGranted) {
        Get.dialog(AlertDialog(
          title: const Text('경고'),
          content: Text(
              '${permission.toString()}권한을 거부 하셨습니다. \n추후 실행이 안되는 기능이 있을 수 있습니다.'),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                  Get.to(GMapSample());
                },
                child: const Text("닫기"))
          ],
        ));
        per = false; //하나라도 허용이안됐으면 false
      }
    });
    return per;
  }

  void getDeviceInfo() async{
    DeviceInfo a = DeviceInfo();
    await a.initPlatformState();
    model = a.getData()['model'];
    androidId = a.getData()['androidId'];
  }

  Future signIn() async {
    final user = await GoogleSignInApi.login();

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sign in Failed')));
    } else {
      setState(() {
        _currentUser = user;
      });
      /*
        로그인 성공 시 작업.
       */
      String email = user.email.split('@')[0];
      Map<String, dynamic> map = {};
      map['user_gmail_id'] = email; //이메일 앞글자만 보내기
      map['gmail_id'] = email; //이메일 앞글자만 보내기
      map['android_id'] = androidId; //이메일 앞글자만 보내기
      map['device_model'] = model; //이메일 앞글자만 보내기
      CallApi post = CallApi();
      try {
        await post.RequestHttp('/user/account/logout', json.encode(map));
        var response = await post.RequestHttp('/user/account/login', json.encode(map));
        var result = response['result'];
        loginAfter(email, result);
      }catch(e){
        Get.dialog(AlertDialog(
          title: const Text('오류'),
          content: const Text('서버와의 연결이 끊겼습니다'),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("닫기"))
          ],
        ));
      }
    }
  }

  Future logout() async {
    await GoogleSignInApi.logout();
    setState(() {
      _currentUser = null;
    });
  }

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    // if (user != null) {
    //   return Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     children: <Widget>[
    //       ListTile(
    //         leading: GoogleUserCircleAvatar(
    //           identity: user,
    //         ),
    //         title: Text(user.displayName ?? ''),
    //         subtitle: Text(user.email),
    //       ),
    //       const Text('Signed in successfully.'),
    //       ElevatedButton(
    //         child: Text('SIGN OUT'),
    //         onPressed: () async => await logout(),
    //       ),
    //       ElevatedButton(
    //         child: const Text('REFRESH'),
    //         onPressed: () => GoogleSignInApi.login(),
    //       ),
    //     ],
    //   );
    // } else {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 100.h)),
        SizedBox(
          child: Text(
            "소셜 로그인",
            style: TextStyle(fontSize: 40, color: Colors.lightGreen),
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 100.h)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: SignInButton(Buttons.GoogleDark,
                  onPressed: () async =>await signIn()),
              width: 200.w,
              height: 40.h,
            ),
          ],
        ),
      ],
    );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomBar(1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.lightGreen.shade400,
                            Colors.greenAccent,
                            Colors.teal.shade400,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 500),
                      child: const Text(
                        'SwB',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 90,
                          fontFamily: 'vanilla_twilight'
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(85.h,100.h,85.h,370.h),
                      child: Divider(
                        color: Colors.white,
                        thickness: 4.0,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(0, 100.h, 0, 330.h),
                      child: Text(
                        'Sticker with Beacon',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontFamily: 'vanilla_twilight'
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '구글 계정으로 로그인 및 회원가입을 진행해 주세요.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w100,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async => await signIn(),
                            style: ButtonStyle(
                              padding:MaterialStateProperty.all(const EdgeInsets.all(10)),
                              elevation: MaterialStateProperty.all(2),
                              overlayColor:
                                  MaterialStateProperty.all(Colors.black12),
                              shadowColor: MaterialStateProperty.all(
                                  Colors.green.shade50),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),

                            ),
                            child: Row(
                              children: [
                                ImageIcon(
                                  AssetImage('asset/g_logo.png'),
                                  size: 30,
                                  color: Colors.black87,
                                ),
                                const Spacer(),
                                Text(
                                  'Sign In with Google',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    //Container(
    //  child: _buildBody(),
    //));
  }
}
