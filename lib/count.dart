import 'package:get/get.dart';

class CountController extends GetxController {
  final count = 0.obs;

  void increment() {
    count.value++;
    update();
    // count(count.value + 1);
  }
}