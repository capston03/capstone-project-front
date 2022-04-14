import 'package:capstone_android/ble.dart';
import 'package:capstone_android/login/signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'login/login.dart';
import 'map/googlemap.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 640),
        minTextAdapt: true,
        builder: (_) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              // '/' : (context) => const MyApp(),
              '/': (context) => SignInDemo(),
              '/signup': (context) => SignUp(),
              '/map': (context) => GMapSample(),
              '/ble': (context) => BLEPage(),
            },
            title: 'TRACER',
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            builder: (context, widget) {
              ScreenUtil.setContext(context);
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              );
            },
            // home: LoginPage(),
          );
        });
  }
}
