import 'dart:typed_data';
//2.10.4
import 'package:Sticker3D/db/thumbnail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/widgets/ar_view.dart';
import 'package:Sticker3D/ar/bleList.dart';
import 'package:Sticker3D/ar/stickerMenu.dart';
import 'package:Sticker3D/map/googlemap.dart';
import 'package:Sticker3D/network/callApi.dart';
import 'package:gallery_saver/gallery_saver.dart';

//
// import './arPackage/ar_flutter_plugin.dart';
// import './arPackage/managers/ar_location_manager.dart';
// import './arPackage/managers/ar_session_manager.dart';
// import './arPackage/managers/ar_object_manager.dart';
// import './arPackage/managers/ar_anchor_manager.dart';
// import './arPackage/models/ar_anchor.dart';
import 'package:Sticker3D/ar/arManager.dart';
import 'package:Sticker3D/map/HeaderTile.dart';
import 'package:flutter/material.dart';

// import './arPackage/ar_flutter_plugin.dart';
// import './arPackage/datatypes/config_planedetection.dart';
// import './arPackage/datatypes/node_types.dart';
// import './arPackage/datatypes/hittest_result_types.dart';
// import './arPackage/models/ar_node.dart';
// import './arPackage/models/ar_hittest_result.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:screenshot/screenshot.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';

import '../db/manageSqlflite.dart';
import '../sameArea/newBottomBar.dart';
import 'showList.dart';
import '../sameArea/bottomBar.dart';

class ArtWidget extends StatefulWidget {
  ArtWidget({Key? key}) : super(key: key);

  @override
  _ArtWidgetState createState() => _ArtWidgetState();
}

class _ArtWidgetState extends State<ArtWidget> {
  var storage = FlutterSecureStorage();
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;
  Map<String, dynamic> beaconNow = Get.arguments;

  //Screenshot Controller
  ScreenshotController screenshotController = ScreenshotController();
  static GlobalKey previewContainer = GlobalKey();
  late Uint8List _imageFile;
  late ARNode selectedNode;
  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];
  final getController = Get.put(ArManager());
  String maxScale = '100';
  String minScale = '10';
  final List<String> _scales = [
    '10',
    '20',
    '30',
    '40',
    '50',
    '60',
    '70',
    '80',
    '90',
    '100'
  ];

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
              dispose();
              Get.offAndToNamed('/map');
            },
            child: Text('네'),
          ),
        ],
      ),
    )) ??
        false;
  }

  void printPhotoList() {
    //TODO: 나중에 정보 넣기
    Beacon beacon = Beacon(0);
    var beaconList = beacon.getBeaconList();
    Get.dialog(
      AlertDialog(
        content: Container(
          child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: beaconList.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) return HeaderTile();
                //return showList();
                return showList(
                    title: beacon.getDeviceName(beaconList[index - 1]),
                    info: "내용");
              }),
          height: 400.h,
          width: 300.w,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1.w,
                  //color: Colors.green
                  color: Color(0xFFF633))),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void dispose() {
    print("asdashdkajshflkakhfasjkhfkshkf");
    arSessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            // actions: <Widget>[
            //   Padding(
            //     padding: EdgeInsets.only(right: 20.0),
            //     child: IconButton(
            //       icon: Icon(Icons.menu),
            //       onPressed: () {
            //         printPhotoList();
            //       },
            //     ),
            //   ),
            // ],
          ),
          bottomNavigationBar: newBottomBar(1, 0),
          body: Container(
              child: Stack(children: [
                ARView(
                  onARViewCreated: onARViewCreated,
                  planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
                ),
                Positioned(
                  child: FloatingActionButton(
                    //캡쳐하기
                    child: const Icon(Icons.photo_camera),
                    heroTag: "btn1",
                    onPressed: () async {
                      await onTakeScreenshot();
                    },
                    // icon: const Icon(Icons.arrow_back_outlined),
                  ),
                  bottom: 70.h,
                  right: 20.w,
                ),
                Obx(() => Positioned(
                  child: FloatingActionButton(
                    //캡쳐하기
                    child: getController.isChangingSize.value
                        ? const Icon(Icons.toggle_off)
                        : const Icon(Icons.toggle_on),
                    heroTag: "btn1",
                    onPressed: () async {
                      getController.setSizing = !getController.getSizing;
                      print(
                          "asdasdasdasdasd${getController.isChangingSize.value}");
                      // await onTakeScreenshot();
                    },
                    // icon: const Icon(Icons.arrow_back_outlined),
                  ),
                  bottom: 125.h,
                  right: 20.w,
                )),
                Positioned(
                  child: FloatingActionButton(
                    //캡쳐하기
                    child: const Icon(Icons.menu_sharp),
                    heroTag: "btn1",
                    onPressed: () async {
                      showScreenMenu();
                    },
                    // icon: const Icon(Icons.arrow_back_outlined),
                  ),
                  bottom: 15.h,
                  right: 20.w,
                ),
                Positioned(
                  child: FloatingActionButton(
                    //다 삭제하기
                    child: const Icon(Icons.delete_forever_sharp),
                    heroTag: "btn1",
                    onPressed: onRemoveEverything,
                    // icon: const Icon(Icons.arrow_back_outlined),
                  ),
                  top: 15.h,
                  right: 20.w,
                ),
              ]))),
      onWillPop: _onWillPop,
    );
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
    // this.arObjectManager.re
  }

  Future<void> onRemoveEverything() async {
    /*nodes.forEach((node) {
      this.arObjectManager.removeNode(node);
    });*/
    anchors.forEach((anchor) {
      this.arAnchorManager.removeAnchor(anchor);
    });
    getController.removeNodeData();
    anchors = [];
  }

  // 스크린샷 버튼 눌렀을때 작동 되는 기능
  Future<void> onTakeScreenshot() async {
    var image = await arSessionManager.snapshot();
    // Get.back();
    showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return SafeArea(
              child: Stack(
                children: <Widget>[
                  Screenshot(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                            image:
                            DecorationImage(image: image, fit: BoxFit.cover)),
                      ),
                      controller: screenshotController),
                  Positioned(
                    child: FloatingActionButton.extended(
                      heroTag: "btn2",
                      onPressed: () async {
                        // await saveImage(storeImage);
                        CallApi.circularLoading(context, "저장중...");
                        screenshotController.capture().then((capturedImage) async {
                          await saveImage(capturedImage!);
                          Get.back();
                          Get.back();
                          // ShowCapturedWidget(context, capturedImage!);
                        }).catchError((onError) {
                          print("$onError");
                        });
                      },
                      label: Text('저장하기'),
                      icon: const Icon(Icons.save_outlined),
                    ),
                    bottom: 10.h,
                    right: 20.w,
                  ),
                  Positioned(
                    child: FloatingActionButton(
                      //뒤로가기
                      child: const Icon(Icons.arrow_back_outlined),
                      heroTag: "btn1",
                      onPressed: () {
                        Get.back();
                      },
                      // icon: const Icon(Icons.arrow_back_outlined),
                    ),
                    bottom: 10.h,
                    left: 20.w,
                  ),
                ],
              ));
        });
  }

  //image저장
  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = 'screenshot_$time';
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    return result['filePath'];
  }

  //slider 만드는 함수
  Widget buildSlider({
    required String angle,
    required int divisions,
    required String node,
    Color color = Colors.green,
    double enabledThumbRadius = 10.0,
    double elevation = 1.0,
  }) {
    String axisAngle = "rotate" + angle;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              thumbColor: color,
              activeTickMarkColor: color,
              valueIndicatorColor: color,
              thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: enabledThumbRadius, elevation: elevation),
              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            ),
            child: Obx(() => Slider(
              value: getController.nodeData[node]![axisAngle]!.value,
              min: 0.0,
              max: 360.0,
              divisions: divisions,
              label: getController.nodeData[node]![axisAngle]!.value
                  .round()
                  .toString(),
              onChanged: (double newValue) {
                if (angle == 'X') {
                  getController.setRotateX(node, newValue);
                } else if (angle == 'Y') {
                  getController.setRotateY(node, newValue);
                } else if (angle == 'Z') {
                  getController.setRotateZ(node, newValue);
                }
                var newRotationAxisX = vector.Vector3(1.0, 0, 0);
                var newRotationAxisY = vector.Vector3(0, 1.0, 0);
                var newRotationAxisZ = vector.Vector3(0, 0, 1.0);
                final newTransform = Matrix4.identity();
                newTransform.scale(int.parse(getController.getScale(node)) *
                    0.004 *
                    0.025);
                newTransform.rotate(newRotationAxisX,
                    getController.getRotateX(node) * (6.27 / 360));
                newTransform.rotate(newRotationAxisY,
                    getController.getRotateY(node) * (6.27 / 360));
                newTransform.rotate(newRotationAxisZ,
                    getController.getRotateZ(node) * (6.27 / 360));
                selectedNode.transform = newTransform;
              },
            ))));
  }

  void showScreenMenu() async {
    String gmail_id = await storage.read(key: 'id') ?? '';
    print("gggggggggggg${getController.episode}");
    getController.episodes = -1;
    print("gggggggggggg${getController.episode}");

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StickerMenu(
              beacon_mac: beaconNow['mac_addr'], gmail_id: gmail_id);
        });
  }

  void showBottomPopupEpisodes(ARNode selectedNode) async {
    String node = selectedNode.name;
    int episodeId = getController.nodeData[node]!['episode_id']!.value.toInt();
    List<ThumbNail> temp = await ManageSqlflite.singleton.selectOne(episodeId);
    ThumbNail data = temp[0];
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0.r),
                topRight: Radius.circular(30.0.r))),
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 20)),
              const SizedBox(
                child: Center(
                    child: Text(
                      '제목',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )),
                height: 40,
              ),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 20),),
                  Expanded(child: Text(
                    data.title,style: TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis, maxLines: 5,
                  ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 20),),

                ],
              ),

              // Container(
              //   width: 500,
              //   child: Row(children: [
              //     // Padding(padding: EdgeInsets.only(left: 20)),
              //     // Container(child: Center(child: Text(data.title,style: TextStyle(fontSize: 18),),),),
              //     Flexible(child: RichText(
              //         maxLines: 2,
              //         overflow: TextOverflow.ellipsis,
              //         strutStyle: StrutStyle(fontSize: 16.0),
              //         text: TextSpan(
              //             text:"zdjlalfjsdljflksdjfklsdjklfjsdlkfjskldjfklsdjflsdjlflk",
              //             style: TextStyle(fontSize: 18)))),
              //
              //     // Padding(padding: EdgeInsets.only(right: 20)),
              //   ]),
              // ),
              Padding(padding: EdgeInsets.only(top: 20)),




              const SizedBox(
                child: Center(
                    child: Text(
                      '내용',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )),
                height: 40,
              ),

              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 20),),
                  Expanded(child: Text(
                    data.content,style: TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis, maxLines: 5,
                  ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 20),),

                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20))
            ],
          );
        });
  }

  void showBottomPopupSizing(ARNode selectedNode) {
    String node = selectedNode.name;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0.r),
                topRight: Radius.circular(30.0.r))),
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20.w)),
                    Text('크기(50이 처음 주어진 사이즈입니다.) : '),
                    Obx(
                          () => DropdownButton(
                        value: getController
                            .nodeData[node]!["scaleSelectedValue"]!.value
                            .toInt()
                            .toString(),
                        items: _scales.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          // setState(() {
                          getController.setScale(node, value.toString());
                          var newRotationAxisX = vector.Vector3(1.0, 0, 0);
                          var newRotationAxisY = vector.Vector3(0, 1.0, 0);
                          var newRotationAxisZ = vector.Vector3(0, 0, 1.0);
                          final newTransform = Matrix4.identity();
                          newTransform.scale(
                              int.parse(getController.getScale(node)) *
                                  0.004 *
                                  0.025);
                          newTransform.rotate(newRotationAxisX,
                              getController.getRotateX(node) * (6.27 / 360));
                          newTransform.rotate(newRotationAxisY,
                              getController.getRotateY(node) * (6.27 / 360));
                          newTransform.rotate(newRotationAxisZ,
                              getController.getRotateZ(node) * (6.27 / 360));
                          selectedNode.transform = newTransform;
                          // });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 20.w)),
                        Text('회전'),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 20.w)),
                        Text('양 옆 회전'),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildSlider(
                            node: node,
                            angle: 'X',
                            divisions: 36,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 20.w)),
                        Text('제자리 회전'),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildSlider(
                            node: node,
                            angle: 'Y',
                            divisions: 36,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 20.w)),
                        Text('위 아래 회전'),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildSlider(
                            node: node,
                            angle: 'Z',
                            divisions: 36,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  //this will work when i touch it ok?
  Future<void> onNodeTapped(List<String> nodes) async {
    var number = nodes.length;
    selectedNode =
    this.nodes.firstWhereOrNull((element) => element.name == nodes.first)!;

    getController.isChangingSize.value
        ? showBottomPopupSizing(selectedNode)
        : showBottomPopupEpisodes(selectedNode); // => bottom bar출력
    var newScale = 0.1; //max 0.2 ~ >0
    var newTranslationAxis = Random().nextInt(3); // 0 1 2
    var newTranslationAmount = Random().nextDouble() / 3;
    var newTranslation = vector.Vector3(0, 0, 0);
    newTranslation[newTranslationAxis] = newTranslationAmount;
    var newRotationAxisIndex =
    1; // 0=>x축을 기준으로 yz평면에 회전 1y축을 기준으로 xz평면에 회전 2 z축을 기준으로 xy평면에 회전
    var newRotationAmount =
    2.0; //-6.27~6.27 (-시 x좌표기준 y의 음의 방향으로회전 +시 양의 방향으로회전)
    var newRotationAxis = vector.Vector3(0, 0, 0);
    var newRotationAxisX = vector.Vector3(0, 0, 0);
    newRotationAxisX[0] = 1.0;
    newRotationAxis[newRotationAxisIndex] = 1.0;

    // final newTransform = Matrix4.identity();

    // newTransform.setTranslation(newTranslation);

    // newTransform.rotate(newRotationAxis, newRotationAmount);
    // newTransform.rotate(newRotationAxisX, newRotationAmount);
    // newTransform.scale(0.2);
    // selectedNode.transform = newTransform;
    // this.arAnchorManager.removeAnchor(anchor);
    // arObjectManager.removeNode(selectedNode);
    // print("${nodes.first} hummfuck");
    // this.arSessionManager.onError("Tapped $number node(s)");
  }

  Future<void> onShufflePressed() async {
    var newScale = Random().nextDouble() / 3;
    var newTranslationAxis = Random().nextInt(3);
    var newTranslationAmount = Random().nextDouble() / 3;
    var newTranslation = vector.Vector3(0, 0, 0);
    newTranslation[newTranslationAxis] = newTranslationAmount;
    var newRotationAxisIndex = Random().nextInt(3);
    var newRotationAmount = Random().nextDouble();
    var newRotationAxis = vector.Vector3(0, 0, 0);
    newRotationAxis[newRotationAxisIndex] = 1.0;

    final newTransform = Matrix4.identity();

    newTransform.setTranslation(newTranslation);
    newTransform.rotate(newRotationAxis, newRotationAmount);
    newTransform.scale(newScale);
    print(nodes.length);
    print(anchors.length);
    for (ARNode i in nodes) {
      i.transform = newTransform;
    }

    // this.localObjectNode.transform = newTransform;
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    print("ggggggggggggggggg${getController.glbUrl}");
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
            uri: getController.glbUrl.value,
            // "https://github.com/namhyo01/Boxiting/blob/master/card.glb?raw=true",
            scale: vector.Vector3(0.005, 0.005, 0.005),
            position: vector.Vector3(0.0, 0.0, 0.0),
            rotation: vector.Vector4(1.0, 0.0, 0.0, 0.0));
        getController.setNodeData(
            newNode.name, getController.episodeId.value.toDouble());
        bool? didAddNodeToAnchor =
        await arObjectManager.addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor!) {
          nodes.add(newNode);
        } else {
          nodes.add(newNode);
          // this.arSessionManager.onError("Adding Node to Anchor failed");
        }
      } else {
        // this.arSessionManager.onError("Adding Anchor failed");
      }
    }
  }
}
