import 'dart:typed_data';

import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:capstone_android/ar/bleList.dart';
import 'package:capstone_android/map/HeaderTile.dart';
import 'package:capstone_android/sameArea/newBottomBar.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';

import 'showList.dart';
import '../sameArea/bottomBar.dart';

class ScreenshotWidget extends StatefulWidget {
  ScreenshotWidget({Key? key}) : super(key: key);
  @override
  _ScreenshotWidgetState createState() => _ScreenshotWidgetState();
}

class _ScreenshotWidgetState extends State<ScreenshotWidget> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;
  //Screenshot Controller
  ScreenshotController screenshotController = ScreenshotController();
  static GlobalKey previewContainer = GlobalKey();
  late Uint8List _imageFile;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

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

  void printPhotoList(){
    Beacon beacon = new Beacon(1);

    //TODO: 나중에 정보 넣기
    Get.dialog(
        AlertDialog(
          content: Container(
            child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: beacon.scanResultList.length+1,
                itemBuilder: (BuildContext context, int index){
                  if(index == 0) return HeaderTile();
                  //return showList();
                  return beacon.listItem(beacon.scanResultList[index-1]);
                }),
            height: 400.h,
            width: 300.w,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.w,
                //color: Colors.green
                color: Color(0xFFF633)
              )
            ),
          ),
        ),
        barrierDismissible: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
    arSessionManager.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
        appBar: AppBar(
          title: Text("Screenshot"),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: (){
                    printPhotoList();
                },
              ),
            ),
          ],
          ),
        bottomNavigationBar: newBottomBar(1, 0),
        body: Container(
            child: Stack(children: [
                Screenshot(
                controller: screenshotController,
                child: ARView(
                onARViewCreated: onARViewCreated,
                planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
              )),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      ElevatedButton(
                          onPressed: onShufflePressed,
                          child: Text("Test Scailing")),
                      ElevatedButton(
                          onPressed: onRemoveEverything,
                          child: Text("Remove Everything")),
                      ElevatedButton(
                          onPressed: () async {
                            onTakeScreenshot();
                            }, child: Text("Take Screenshot"),
                      ),
                    ]),
              )
            ]))),onWillPop: _onWillPop,);
  }



  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: false, //하얀색점
      customPlaneTexturePath: "Images/triangle.png",
      showWorldOrigin: false,
    );

    this.arObjectManager.onInitialize();

    this.arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager.onNodeTap = onNodeTapped;
  }

  Future<void> onRemoveEverything() async {
    /*nodes.forEach((node) {
      this.arObjectManager.removeNode(node);
    });*/
    anchors.forEach((anchor) {
      this.arAnchorManager.removeAnchor(anchor);
    });
    anchors = [];
  }

  Future<void> onTakeScreenshot() async {
    var image = await arSessionManager.snapshot();
    await showDialog(
        context: context,
        builder: (_) => Dialog(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: image, fit: BoxFit.cover)),
          ),
        ));
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) async {
    return await showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return SafeArea(child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: capturedImage != null
                    ? Image.memory(capturedImage)
                    : Container(child: Text('ㅇㄴㅇㄹ'),)),
          ));
        }
    );

  }


  Future<String> saveImage(Uint8List bytes) async{
    await [Permission.storage].request();
    final time = DateTime.now()
          .toIso8601String()
          .replaceAll('.','-')
          .replaceAll(':', '-');
    final name = 'screenshot_$time';
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    return result['filePath'];
  }

  Future<void> onNodeTapped(List<String> nodes) async {
    var number = nodes.length;
    // this.arSessionManager.onError("Tapped $number node(s)");
  }

  Future<void> onShufflePressed() async{
    var newScale = Random().nextDouble() / 3;
    var newTranslationAxis = Random().nextInt(3);
    var newTranslationAmount = Random().nextDouble() / 3;
    var newTranslation = Vector3(0, 0, 0);
    newTranslation[newTranslationAxis] = newTranslationAmount;
    var newRotationAxisIndex = Random().nextInt(3);
    var newRotationAmount = Random().nextDouble();
    var newRotationAxis = Vector3(0, 0, 0);
    newRotationAxis[newRotationAxisIndex] = 1.0;

    final newTransform = Matrix4.identity();

    newTransform.setTranslation(newTranslation);
    newTransform.rotate(newRotationAxis, newRotationAmount);
    newTransform.scale(newScale);
    print(nodes.length);
    print(anchors.length);
    for(ARNode i in nodes){
      i.transform = newTransform;
      // i.transformation = newTransform;
    }
    // this.localObjectNode.transform = newTransform;
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
            (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
      var newAnchor =
      ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool didAddAnchor = await arAnchorManager.addAnchor(newAnchor) ?? false;
      if (didAddAnchor) {
        this.anchors.add(newAnchor);
        // Add note to anchor
        var newNode = ARNode(
            type: NodeType.webGLB,
            uri:
            "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
            scale: Vector3(0.2, 0.2, 0.2),
            position: Vector3(0.0, 0.0, 0.0),
            rotation: Vector4(1.0, 0.0, 0.0, 0.0));
        bool? didAddNodeToAnchor =
        await this.arObjectManager.addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor!) {
          nodes.add(newNode);
        } else {
          nodes.add(newNode);
          // this.arSessionManager.onError("Adding Node to Anchor failed");
        }
      } else {
        // this.arSessionManager.onError("Adding Anchor failed");
      }
      /*
      // To add a node to the tapped position without creating an anchor, use the following code (Please mind: the function onRemoveEverything has to be adapted accordingly!):
      var newNode = ARNode(
          type: NodeType.localGLTF2,
          uri: "Models/Chicken_01/Chicken_01.gltf",
          scale: Vector3(0.2, 0.2, 0.2),
          transformation: singleHitTestResult.worldTransform);
      bool didAddWebNode = await this.arObjectManager.addNode(newNode);
      if (didAddWebNode) {
        this.nodes.add(newNode);
      }*/
    }
  }
}