import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/material.dart';

class arManager extends GetxController{
  var scaleSelectedValue = '50'.obs;
  void setScale(String scale){
    scaleSelectedValue.value = scale;
  }
  String getScale(){
    return scaleSelectedValue.value;
  }
}