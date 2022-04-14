

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageSignUp extends GetxController{
  var isjungbok = false.obs; //중복검사여부
  var isOkayNick = false.obs; //닉네임
  var isOkayBirth = false.obs; //생년월일
  var isOkayPos = false.obs; //신분
  var prevNick = "".obs;
  var tryToJungbok = false.obs;
  var birthday = "".obs;
  var selectedValue = 'Select'.obs; // 초기값
  final List<Rx<TextEditingController>> controller = List.generate(
      5, (index) => TextEditingController().obs); // text edit controller부여

  void setValue(String value){
    selectedValue.value = value;
  }
  String getValue(){
    return selectedValue.value;
  }

  void setFalseJungbok(){
    isjungbok.value = false;
  }
  void setTrueJungbok(){
    isjungbok.value = true;
  }
  void setFalseNick(){
    isOkayNick.value = false;
  }
  void setTrueNick(){
    isOkayNick.value = true;
  }
  void setFalseBirth(){
    isOkayBirth.value = false;
  }
  void setTrueBirth(){
    isOkayBirth.value = true;
  }
  void setFalsePos(){
    isOkayPos.value = false;
  }
  void setTruePos(){
    isOkayPos.value = true;
  }
  void setprevNick(String word){
    prevNick.value = word;
  }
  void setTrueTryJungbok(){
    tryToJungbok.value = true;
  }
  void setFalseTryJungbok(){
    tryToJungbok.value = false;
  }
}