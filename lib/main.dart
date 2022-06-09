import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:capstone_android/ble.dart';
import 'package:capstone_android/login/signUp.dart';
import 'package:capstone_android/photo/photoDetail.dart';
import 'package:capstone_android/sticker/photoGrid.dart';
import 'package:capstone_android/sticker/stickerUpload.dart';
import 'package:capstone_android/profile/profileMain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'ar/ar.dart';
import 'ar/test.dart';
import 'photo/photoUpload.dart';
import 'login/login.dart';
import 'map/googlemap.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //arcore is ok?
  // await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]);
  } // Platform messages are asynchronous, so we initialize in an async method.
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
    final platform = Theme.of(context).platform;
    return ScreenUtilInit(
        designSize: Size(360, 640),
        minTextAdapt: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: ()=>SignInDemo(),transition: Transition.rightToLeft),
              GetPage(name: '/signup', page: ()=>SignUp(),transition: Transition.rightToLeft),
              GetPage(name: '/map', page: ()=>GMapSample(),transition: Transition.rightToLeft),
              GetPage(name: '/ble', page: ()=>BLEPage(),transition: Transition.rightToLeft),
              GetPage(name: '/test', page: ()=>ArtWidget(),transition: Transition.rightToLeft),
              GetPage(name: '/upload', page: ()=>PhotoUpload(),transition: Transition.rightToLeft),
              GetPage(name: '/stickerUpload', page: ()=>StickerUpload(),transition: Transition.rightToLeft),
              GetPage(name: '/profile', page: ()=>profileMain(0),transition: Transition.rightToLeft),
              GetPage(name: '/profile_in', page: ()=>profileMain(1),transition: Transition.rightToLeft),
              GetPage(name: '/photoGrid', page: ()=>PhotoGrid(),transition: Transition.rightToLeft),
              GetPage(name: '/test123', page: ()=>MyHomePage(title:'sex',platform:platform),transition: Transition.rightToLeft),
            ],
            // routes: {
            //   // '/' : (context) => const MyApp(),
            //   '/': (context) => SignInDemo(),
            //   '/signup': (context) => SignUp(),
            //   '/map': (context) => GMapSample(),
            //   '/ble': (context) => BLEPage(),
            //   '/test':(context)=> ArtWidget(),
            //   '/upload':(context)=>PhotoUpload(),
            //   '/stickerUpload' : (context) =>StickerUpload(),
            //   '/profile' : (context) => profileMain(0),
            //   '/profile_in' : (context) => profileMain(1),
            //   // '/photoDetail': (context)=>PhotoDetail(),
            //   '/photoGrid' : (context) => PhotoGrid(),
            // },
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