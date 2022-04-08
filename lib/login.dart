import 'package:capstone_android/ble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'count.dart';

class LoginPage extends StatelessWidget {
  final String title = '응애';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CountController());

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            GetBuilder<CountController>(builder: (controller) {
              return Text(
                '${controller.count}',
                style: Theme.of(context).textTheme.headline4,
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(BLEPage());
          },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
