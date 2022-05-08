import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:capstone_android/ble.dart';
import 'package:capstone_android/login/signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'ar/photoUpload.dart';
import 'ar/test.dart';
import 'login/login.dart';
import 'map/googlemap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //arcore is ok?

  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyApp createState()=>_MyApp();
}

class _MyApp extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();

  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await ArFlutterPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

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
              '/test':(context)=>ScreenshotWidget(),
              '/upload':(context)=>PhotoUpload(),
            },
            title: 'TRACER',
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            builder: (context, widget) {
              // ScreenUtil.defaultSize(context);
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
