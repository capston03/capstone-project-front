import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class StickerMenuModel{
    // late String gmail_id;
    // late String beacon_mac;
    late List<Map<String,String>> result; //id, url

    StickerMenuModel({required this.result});

    StickerMenuModel.fromJson(Map<String, dynamic> json){
      result = json['result'];
    }
    Map<String, dynamic> toJson(String gmail_id, String beacon_mac){
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['gmail_id'] = gmail_id;
      data['beacon_mac'] = beacon_mac;
      return data;
    }
}