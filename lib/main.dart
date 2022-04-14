import 'dart:convert';

import 'package:capstone_android/googlemap.dart';
import 'package:capstone_android/kakaomap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'login/Login.dart';
import 'testlogin.dart';




Future<void> main() async {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360,640),
        minTextAdapt: true,
        builder: (){
                return GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  initialRoute: '/',
                  routes: {
                    // '/' : (context) => const MyApp(),
                    '/':(context) => GMapSample(),
                  },
                  title: 'TRACER',
                  theme: ThemeData(
                    primarySwatch: Colors.green,
                  ),
                  builder: (context,widget){
                    ScreenUtil.setContext(context);
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: widget!,
                    );
                  },
                  // home: LoginPage(),
                );
              }
          );
        }


  }

