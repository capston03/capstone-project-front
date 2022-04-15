
import 'package:flutter_blue/flutter_blue.dart';

class BleFind{

  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResultList = [];
  bool _isScanning = false;


  void initBle() {
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
    });
  }

  /*스캔 시작/정지 */
  scan() async{
    if (!_isScanning){
      scanResultList.clear();
      flutterBlue.startScan(timeout: Duration(seconds: 2));
      flutterBlue.scanResults.listen((results) {
        scanResultList = results;
      });
    }else{
      flutterBlue.stopScan();
    }
  }
}