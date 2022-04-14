
import 'package:capstone_android/sameArea/bottomBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

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
    initBle();
  }

  void initBle() {
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  /*스캔 시작/정지 */
  scan() async{
    if (!_isScanning){
      scanResultList.clear();
      flutterBlue.startScan(timeout: Duration(seconds: 2));
      flutterBlue.scanResults.listen((results) {
        scanResultList = results;
        setState(() {});
      });
    }else{
      flutterBlue.stopScan();
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
        onPressed: scan,
        child: Icon(_isScanning ? Icons.stop : Icons.search),
      ),
    );
  }}

