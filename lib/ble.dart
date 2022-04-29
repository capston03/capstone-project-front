
import 'package:capstone_android/sameArea/bottomBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';

class BLEPage extends StatefulWidget{
  final String title = 'Beacon 연결';

  @override
  State<StatefulWidget> createState() => _BLEPageState();
}

class _BLEPageState extends State<BLEPage>{
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResultList = [];
  bool _isScanning = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
    initBle();
  }
  getPermission() async{
    var status = await Permission.location.status;
    if(status.isGranted){
      print('허락됨');
    } else if (status.isDenied){
      print('거절됨');
      Permission.location.request(); // 허락해달라고 팝업띄우는 코드
    }
  }
  @override
  void dispose(){

    super.dispose();
  }
  Future<bool> checkPermission() async {
    //권한설정 물어보기
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetoothScan
    ].request(); //여러가지 퍼미션을하고싶으면 []안에 추가하면된다. (팝업창이뜬다)
    bool per = true;
    statuses.forEach((permission, permissionStatus) {
      if (!permissionStatus.isGranted) {
        Get.dialog(AlertDialog(
          title: const Text('경고'),
          content: Text(
              '${permission.toString().split('.')[1]}권한을 거부 하셨습니다. \n추후 실행이 안되는 기능이 있을 수 있습니다.'),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                  // Get.to(GMapSample());
                },
                child: const Text("닫기"))
          ],
        ));
        per = false; //하나라도 허용이안됐으면 false
      }
    });
    return per;
  }
  void initBle() {
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      if(mounted) {
        setState(() {});
      }
    });
  }

  /*스캔 시작/정지 */
  scan() async{
    bool bluetooth = await flutterBlue.isOn;

    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.location,
    //   Permission.bluetoothScan
    // ].request();
    if(bluetooth) {
      if (!_isScanning) {
        if (mounted) {
          scanResultList.clear();
          flutterBlue.startScan(timeout: Duration(seconds: 2));
          flutterBlue.scanResults.listen((results) {
            print(results.length);
            scanResultList = results;
            // setState(() {});
          });
        }
      } else {
        flutterBlue.stopScan();
      }
    }else{
      Get.dialog(AlertDialog(
        title: const Text('경고'),
        content: const Text('블루투스가 꺼져있습니다.\n블루투스를 켜주시기 바랍니다.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("닫기"))
        ],
      ));
    }
  }

  Widget deviceSignal(ScanResult r){
    return Text(r.rssi.toString());
  }
  Widget deviceMACAddr(ScanResult r){
    return Text(r.device.id.id);
  }
  Widget deviceName(ScanResult r){
    String name = '';

    if(r.device.name.isNotEmpty){
      name = r.device.name;
    }else if (r.advertisementData.localName.isNotEmpty){
      name = r.advertisementData.localName;
    }else{
      name = 'N/A';
    }
    return Text(name);
  }
  Widget? leading(ScanResult r){
    return const CircleAvatar(
      child: Icon(
        Icons.bluetooth,
        color:Colors.white,
      ),
      backgroundColor: Colors.cyan,
    );
  }

  void onTap(ScanResult r){
    print('${r.device.name}');
  }

  Widget listItem(ScanResult r){
    return ListTile(
      onTap: () => onTap(r),
      leading: leading(r),
      title: deviceName(r),
      subtitle: deviceMACAddr(r),
      trailing: deviceSignal(r),
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomBar(0),
      body: Center(
        child: ListView.separated(
            itemBuilder: (context, index) {
              return listItem(scanResultList[index]);
            },
            separatorBuilder: (BuildContext context, int index){
              return Divider();
            }, itemCount: scanResultList.length
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        onPressed: scan,
        child: Icon(_isScanning ? Icons.stop : Icons.search),
      ),
    );
  }}

