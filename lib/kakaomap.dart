import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KmapPage extends StatelessWidget{
  WebViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(height: 600, child: Kmap(controller)),
      ],),
    );
  }

}


class Kmap extends StatelessWidget {
  String url = "";
  Set<JavascriptChannel>? channel;
  WebViewController? controller;

  Kmap(this.controller){
    channel = {JavascriptChannel(
        name: 'map',
        onMessageReceived: (message){
          print('javascript run');
        Fluttertoast.showToast(msg: message.message);
    })
    };
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: url,
      onWebViewCreated: (controller){
        this.controller = controller;
        _onHTMLgetExample(controller, context);
      },
      javascriptChannels: channel,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }

  void _onHTMLgetExample(WebViewController controller, BuildContext context) async {
    String _fileText = await rootBundle.loadString('asset/Kakaomap.html');
    final String contentBase64 = base64Encode(const Utf8Encoder().convert(_fileText));
    await controller.loadUrl('data:text/html;base64,$contentBase64');
    print("js get");
  }
}
