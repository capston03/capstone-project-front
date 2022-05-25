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
import 'ar/hmm.dart';
import 'ar/local.dart';
import 'photo/photoUpload.dart';
import 'login/login.dart';
import 'map/googlemap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //arcore is ok?
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
              '/test':(context)=> ArtWidget(),
              '/upload':(context)=>PhotoUpload(),
              '/local' :(context)=>LocalAndWebObjectsWidget(),
              '/hmm' : (context) =>ObjectsOnPlanesWidget(),
              '/stickerUpload' : (context) =>StickerUpload(),
              '/profile' : (context) => profileMain(),
              // '/photoDetail': (context)=>PhotoDetail(),
              '/photoGrid' : (context) => PhotoGrid(),
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
// import 'dart:io';
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_crop/image_crop.dart';
// import 'package:image_picker/image_picker.dart';
//
// void main() {
//   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent,
//     statusBarBrightness: Brightness.dark,
//     statusBarIconBrightness: Brightness.light,
//     systemNavigationBarIconBrightness: Brightness.light,
//   ));
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => new _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   final cropKey = GlobalKey<CropState>();
//   File? _file = null;
//   File? _sample = null;
//   File? _lastCropped = null;
//
//   @override
//   void dispose() {
//     super.dispose();
//     _file?.delete();
//     _sample?.delete();
//     _lastCropped?.delete();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SafeArea(
//         child: Container(
//           color: Colors.black,
//           padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
//           child: _sample == null ? _buildOpeningImage() : _buildCroppingImage(),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOpeningImage() {
//     return Center(child: _buildOpenImage());
//   }
//
//   Widget _buildCroppingImage() {
//     return Column(
//       children: <Widget>[
//         Expanded(
//           child: Crop.file(_sample!, key: cropKey),
//         ),
//         Container(
//           padding: const EdgeInsets.only(top: 20.0),
//           alignment: AlignmentDirectional.center,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               TextButton(
//                 child: Text(
//                   'Crop Image',
//                   style: Theme.of(context)
//                       .textTheme
//                       .button!
//                       .copyWith(color: Colors.white),
//                 ),
//                 onPressed: () => _cropImage(),
//               ),
//               _buildOpenImage(),
//             ],
//           ),
//         )
//       ],
//     );
//   }
//
//   Widget _buildOpenImage() {
//     return TextButton(
//       child: Text(
//         'Open Image',
//         style: Theme.of(context).textTheme.button!.copyWith(color: Colors.white),
//       ),
//       onPressed: () => _openImage(),
//     );
//   }
//
//   Future<void> _openImage() async {
//     final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
//     final file = File(pickedFile!.path);
//     final sample = await ImageCrop.sampleImage(
//       file: file,
//       preferredSize: context.size!.longestSide.ceil(),
//     );
//
//     _sample?.delete();
//     _file?.delete();
//
//     setState(() {
//       _sample = sample;
//       _file = file;
//     });
//   }
//
//   Future<void> _cropImage() async {
//     final scale = cropKey.currentState!.scale;
//     final area = cropKey.currentState!.area;
//
//     print(area);
//     print(scale);
//     if (area == null) {
//       // cannot crop, widget is not setup
//       return;
//     }
//
//     // scale up to use maximum possible number of pixels
//     // this will sample image in higher resolution to make cropped image larger
//     final sample = await ImageCrop.sampleImage(
//       file: _file!,
//       preferredSize: (2000 / scale).round(),
//     );
//     print(area);
//     final file = await ImageCrop.cropImage(
//       file: sample,
//       area: area,
//     );
//
//     sample.delete();
//
//     _lastCropped?.delete();
//     _lastCropped = file;
//
//     debugPrint('$file');
//   }
// }