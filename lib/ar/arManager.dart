import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/material.dart';

class SliderController{
  double sliderValue;
  SliderController(this.sliderValue);

}

class ArManager extends GetxController{
  // var transformationData = {"scaleSelectedValue":50, "rotateX":0,"rotateY":0,"rotateZ":0}.obs;
  RxMap<String,RxMap<String, RxDouble>> nodeData = {"null":{"scaleSelectedValue":50.0.obs, "rotateX":0.0.obs,"rotateY":0.0.obs,"rotateZ":0.0.obs}.obs }.obs;
  var scaleSelectedValue = '50'.obs;
  var controller = SliderController(0.0).obs;

  //erase or all Node data
  void removeNodeData(){
    nodeData.clear();
  }
  void setNodeData(String node){
    nodeData[node] = {"scaleSelectedValue":50.0.obs, "rotateX":0.0.obs,"rotateY":0.0.obs,"rotateZ":0.0.obs}.obs;
  }
  Map<String, RxDouble> getNodeData(String node){
    return nodeData[node]!.value;
  }
  void setScale(String node, String scale){
    // var temp =nodeData[node];
    nodeData[node]!["scaleSelectedValue"]!.value = double.parse(scale);
    // scaleSelectedValue.value = scale;
  }
  // String getScale(){
  //   return scaleSelectedValue.value;
  // }
  String getScale(String node){
    int data = nodeData[node]!["scaleSelectedValue"]?.value.toInt()??50;
    return data.toString();
  }

  void setRotateX(String node, double x){
    nodeData[node]!["rotateX"]?.value = x;
  }
  double getRotateX(String node){
    return nodeData[node]!["rotateX"]?.value??0;
  }
  void setRotateY(String node, double y){
    nodeData[node]!["rotateY"]?.value = y;
  }
  double getRotateY(String node){
    return nodeData[node]!["rotateY"]?.value??0;
  }
  void setRotateZ(String node, double z){
    nodeData[node]!["rotateZ"]?.value = z;
  }
  double getRotateZ(String node){
    return nodeData[node]!["rotateZ"]?.value??0;
  }
}