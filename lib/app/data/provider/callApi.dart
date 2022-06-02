import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

/*
  이 클래스는 API를 호출할때 사용하는 클래스 입니다
  서버와 통신을 하는 경우 이 곳을 통해서 가면 됩니다.

 */


class CallApi {
  // final String dns = 'https://wadis.go.kr/';
  final String dns =
      'http://ec2-3-36-253-81.ap-northeast-2.compute.amazonaws.com:8000'; //여기에 통신을 원하는 주소를 입력하시면 됩니다. 마지막에 '/' 붙이는 것은 필수입니다.
  // final String dns = 'http://210.113.102.147/';

  String getDns() {
    return dns;
  }

  /*
    uri : /없이 주소 넣기
    map : Map형식으로 데이터 넣기
    post형태로 보냅니다
    call하는 대에선 await해서 받아줍니다
   */
  Future<dynamic> RequestHttp(uri, map) async {
    uri = dns + uri;
    try {
      var response = await http
          .post(Uri.parse(uri),
          headers: {"Content-Type": "application/json"}, body: map)
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw Exception('네트워크 접속 지연');

      }); // 통신
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        print(uri);
        print(statusCode);
        print('통신 오류 statusCode 확인 부탁');
      }
      print(response);
      return json.decode(utf8.decode(response.bodyBytes));
    }catch(e){
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa$e");
      Exception(e);
    }

  }

  /*
    uri : /없이 주소 넣기
    gett형태로 보냅니다
    call하는 대에선 await해서 받아줍니다
   */
  Future<http.Response> ResponseGetHttp(uri) async {
    uri = dns + uri;
    var response = await http.get(Uri.parse(uri)); // 통신
    // print('statusCode : ${response.statusCode}');
    // print('header : ${response.headers}');
    // print('body : ${response.body}');
    return response;
  }

  /// 사진 데이터를 처리하기 위한 함수
  /// 이 함수는 의뢰 신청의 사진을 보내기 위헤 만들었습니다
  /// 넣어야 되는 parameter값들은 다른 함수들과 동일 합니다.
  /// 여긴 AI노말과 service에서 사용합니다.
  Future<dynamic> MultipartRequestForDialog(
      uri, Map<String, dynamic> map) async {
    var client = new http.Client();
    try {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(dns + uri));

      ///(사진)을 제외하고서는 request.fields에다가 넣어줍니다
      ///map형식으로 input을 주었기에 iterator를 돌면서 값을 받습니다
      ///r
      for (String key in map.keys) {
        if (!map[key].toString().contains('image')) {
          request.fields[key] = map[key] ?? '';
        }
      }
      //사진 추가 시작
      if (map['image'] != '') {
        //사진이 비어있지 않다면 추가해주어야한다
        File imageFile = File(map['image']); //사진을 File형태로 받아
        var stream = http.ByteStream(imageFile.openRead()); //stream으로 분해
        var length = await imageFile.length(); //파일 ㅅ이즈후
        var multipartFile = http.MultipartFile('image', stream, length,
            filename: basename(imageFile.path)); //넣어줍니다
        request.files.add(multipartFile); //여러개의 사진을 request에 추가
      }
      var response = await request.send().timeout(const Duration(seconds: 20),
          onTimeout: () {
        throw Exception('네트워크 접속 지연');
      }); //request보내고 response받는다
      // print(response);
      ///밑은 동일
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        print(uri);
        print(statusCode);
        print('통신 오류 statusCode 확인 부탁');
      }
      //결과값을 return
      return json.decode(await response.stream.bytesToString());
    } catch (e) {
      print(e);
      Exception(e);
    } finally {
      client.close();
    }
    //오류가 나는 case

    return false;
  }

  /// 사진 데이터를 처리하기 위한 함수
  /// 이 함수는 의뢰 신청의 사진을 보내기 위헤 만들었습니다
  /// 넣어야 되는 parameter값들은 다른 함수들과 동일 합니다.
  /// ASF에서 사용합니다다
  Future<dynamic> MultipartRequestForASF(uri, Map<String, dynamic> map) async {
    var client = new http.Client();
    try {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(dns + uri));

      ///upfile(사진)을 제외하고서는 request.fields에다가 넣어줍니다
      ///map형식으로 input을 주었기에 iterator를 돌면서 값을 받습니다
      for (String key in map.keys) {
        if (!map[key].toString().contains('FILE_NAME')) {
          request.fields[key] = map[key] ?? '';
        }
      }
      File image = File(map['FILE_NAME']);
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile('FILE_NAME', stream, length,
          filename: basename(image.path)); //넣어줍니다

      request.files.add(multipartFile); //여러개의 사진을 request에 추가

      var response = await request.send(); //request보내고 response받는다
      // print(response);
      ///밑은 동일
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        print(uri);
        print(statusCode);
        print('통신 오류 statusCode 확인 부탁');
      }
      //결과값을 return
      return json.decode(await response.stream.bytesToString());
    } catch (e) {
      print(e);
      Exception(e);
    } finally {
      client.close();
    }
    //오류가 나는 case

    return false;
  }

  Future<dynamic> MultipartRequestForOneToOne(
      String filename, String url, int index, Map<String, dynamic> map) async {
    var request = http.MultipartRequest('POST', Uri.parse(dns + url));
    request.files.add(http.MultipartFile('upfile$index',
        File(filename).readAsBytes().asStream(), File(filename).lengthSync(),
        filename: filename.split("/").last));
    request.fields['bbsSubject'] = map['bbsSubject'];
    request.fields['bbsCont'] = map['bbsCont'];
    request.fields['bbsType'] = map['bbsType'];
    var res = await request.send();
  }

  static void circularLoading(BuildContext context, String message) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(left: 7),
            child: Text(message),
          ),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (circularContext) {
        return alert;
      },
      barrierDismissible: false,
    );
  }

  static Future circularWidgetLoading(BuildContext context, String message) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(left: 7),
            child: Text(message),
          ),
        ],
      ),
    );
    return showDialog(
      context: context,
      builder: (circularContext) {
        return alert;
      },
      barrierDismissible: false,
    );
  }
}
