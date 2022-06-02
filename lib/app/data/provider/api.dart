import 'dart:convert';
import 'dart:io';

import '../model/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class StickerMenuApi{
  final String dns =
      'http://ec2-3-36-253-81.ap-northeast-2.compute.amazonaws.com:8000';
  getAll(String uri, map) async{
    try{
      var response = await http
          .post(Uri.parse(uri),
          headers: {"Content-Type": "application/json"}, body: map)
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw Exception('네트워크 접속 지연');
      }); // 통신
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        print(statusCode);
        print('통신 오류 statusCode 확인 부탁');
      }
      print(response);
      Iterable jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<StickerMenuModel> listStickerMenuModel = jsonResponse.map((e) => StickerMenuModel.fromJson(e)).toList();
      return json.decode(utf8.decode(response.bodyBytes));

    }catch(_){}
  }
}