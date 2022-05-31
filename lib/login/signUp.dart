import 'dart:convert';
import 'dart:ui';

import 'package:capstone_android/network/callApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';

import 'login.dart';
import 'loginEnum.dart';
import 'manageSignUp.dart';

class SignUp extends StatelessWidget {
  final List<String> _menuList = [
    'Select',
    'Student',
    'Professor',
    'Manager',
    'Else'
  ]; //dropdown메뉴 리스트

  final getController = Get.put(ManageSignUp());

  SignUp({Key? key}) : super(key: key);

  void reset(){
    getController.setFalseJungbok();
    getController.setFalsePos();
    getController.setFalseBirth();
    getController.setFalseNick();
    getController.setFalseTryJungbok();
    for(int i=0;i<5;i++){
      getController.controller[i].value.text = "";
    }
    getController.setValue('Select');
  }

  void checkNick() {
    getController.setFalseTryJungbok(); //중복검사를 비활성화 => 닉네임을 수정한 것이니
    getController.setFalseJungbok(); // 중복검사로 통과한것도 비활성화
    if (getController.controller[0].value.text.length >= 5) {
      getController.setTrueTryJungbok(); //중복검사버튼을 누를수 있게해준다.
    }
  }

  void checkDuplicateNick() async {
    Map<String, dynamic> map = {};
    map['nickname'] = getController.controller[0].value.text; //닉네임을 받는다
    CallApi post = CallApi();
    var response = await post.RequestHttp('/user/account/check_nickname', json.encode(map));
    response = response['result'];
    if (response == Nick.EXISTED.value) {
      getController.setFalseJungbok();
      //닉네임 중복됨
      Get.dialog(AlertDialog(
        title: const Text(''),
        content: const Text('닉네임이 중복됩니다\n다른 닉네임으로 신청해주세요'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("닫기"))
        ],
      ));
    } else if (response == Nick.NOT_EXISTED.value) {
      // 닉네임 중복 x
      Get.dialog(AlertDialog(
        title: const Text(''),
        content: const Text('사용가능한 닉네임입니다.'),
        actions: [
          TextButton(
              onPressed: () {
                getController.setTrueJungbok();
                Get.back();
              },
              child: const Text("닫기"))
        ],
      ));
    } else {
      Get.dialog(AlertDialog(
        title: const Text('Error'),
        content: const Text('무언가의 오류가 존재합니다\n다시 시도 부탁드립니다.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("닫기"))
        ],
      ));
    }
  }

  /* DatePicker 띄우기 */
  void showDatePickerPop(context) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime(2300), onChanged: (date) {
      //data가변하고있다.
      getController.controller[1].value.text = date.toString().split(' ')[0];
      getController.setTrueBirth();
    }, onConfirm: (date) {
      //user가 확정
      getController.controller[1].value.text = date.toString().split(' ')[0];
      getController.setTrueBirth();
    }, currentTime: DateTime.now(), locale: LocaleType.ko);
  }

  void popup(String title, String content, {bool type = false}) {
    Get.dialog(AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
              if (type) {
                reset();
                Get.offAll(() => SignInDemo());
              } //이전 페이지 기록 다 삭제
            },
            child: const Text("닫기"))
      ],
    ));
  }

  void doSignUp() async {
    String email = Get.arguments; //이메일 받아오기

    if (!getController.isjungbok.value) {
      popup('Error', '닉네임 중복검사를 해주시기 바랍니다');
      return;
    }

    if (!getController.isOkayBirth.value) {
      popup('Error', '생년월일을 입력해주시기 바랍니다');
      return;
    }
    if (!getController.isOkayPos.value) {
      popup('Error', '신분을 입력해주시기 바랍니다');
      return;
    }
    Map<String, dynamic> map = {};
    map['nickname'] = getController.controller[0].value.text;
    map['gmail_id'] = email;
    map['birthday'] = getController.controller[1].value.text;
    map['identity'] = getController.selectedValue.value;

    CallApi post = CallApi();
    try {
      var response = await post.RequestHttp('/user/account/signup', json.encode(map));

      response = response['result'];
      print(response);
      if (response == Signup.SIGNUP_SUCCESS.value) {
        popup('성공', '회원가입 성공\n 로그인 화면으로 이동합니다', type: true);
        //이전페이지 이동
      } else if (response == Signup.NICKNAME_IS_ALREADY_USED.value) {
        popup('Error', '회원가입 실패\n 이미 사용중인 닉네임입니다.\n 다른 닉네임으로 시도해주시기 바랍니다');
        getController.setFalseJungbok();
      } else if (response == Signup.ACCOUNT_IS_ALREADY_EXISTED.value) {
        popup('Error', '회원가입 실패\n 이미 등록된 계정입니다.\n 등록된 아이디로 로그인해주세요',
            type: true);
      } else if (response == Signup.NOT_VALID_USER_INFO.value) {
        popup('Error', '회원가입 실패\n 누락된 데이터가 존재합니다');
        return;
      } else {
        popup('Error', '회원가입 실패');
        return;
      }
    } catch (e) {
      popup('Error', '서버와의 연결 상태가 좋지 않습니다\n 인터넷을 확인하신 후 다시 시도 부탁드립니다');
    }
  }

  @override
  Widget build(BuildContext context) {

    getController.controller[0].value.addListener(checkNick);

    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              reset();
              Get.offAll(() => SignInDemo());
            },
          ),
          title: Text('회원가입'),
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
            child: Container(
          // padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 0),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 40.h)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 20.w)),
                  makeLeftLine("닉네임"),
                  Obx(
                    () => Expanded(
                      child: TextField(
                        maxLength: 15,
                        controller: getController.controller[0].value,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: getController.isjungbok.value
                                      ? Colors.blueAccent
                                      : Colors.black)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: getController.isjungbok.value
                                      ? Colors.blueAccent
                                      : Colors.black)),
                          counterText: "",
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 5.w)),
                  Obx(
                    () => GestureDetector(
                      child: Container(
                        child: Center(
                          child: Text(
                            '중복검사',
                            style: TextStyle(fontSize: 15.sp),
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.w,
                                color: getController.tryToJungbok.value
                                    ? Colors.lightBlueAccent
                                    : Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.r)),
                            color: getController.tryToJungbok.value
                                ? Colors.lightBlueAccent
                                : Colors.grey),
                        height: 40.h,
                      ),
                      onTap: () {
                        if (getController.tryToJungbok.value) {
                          //중복검사 클릭가능
                          checkDuplicateNick();
                        } else {
                          Get.dialog(AlertDialog(
                            title: const Text(''),
                            content: const Text('닉네임을 5~15글자로 입력해주시기 바랍니다'),
                            actions: [
                              TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text("닫기"))
                            ],
                          ));
                        }
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 20.w)),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20.h)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 20.w)),
                  makeLeftLine("생년월일"),
                  Obx(
                    () => Expanded(
                      child: InkWell(
                        child: IgnorePointer(
                          child: TextField(
                            readOnly: true,
                            controller: getController.controller[1].value,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: getController.isOkayBirth.value
                                          ? Colors.blueAccent
                                          : Colors.black)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: getController.isOkayBirth.value
                                          ? Colors.blueAccent
                                          : Colors.black)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: getController.isOkayBirth.value
                                          ? Colors.blueAccent
                                          : Colors.black)),
                            ),
                          ),
                        ),
                        onTap: () {
                          showDatePickerPop(context);
                        },
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 20.w)),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20.h)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 20.w)),
                  makeLeftLine("신분"),
                  Obx(
                    () => Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10.w),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            items: _menuList.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            value: getController.selectedValue.value,
                            onChanged: (String? value) {
                              getController.setValue(value ?? 'Select');
                              value == 'Select'
                                  ? getController.setFalsePos()
                                  : getController
                                      .setTruePos(); //Select일땐 False, 그 외엔 True
                            },
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: getController.isOkayPos.value
                                  ? Colors.blueAccent
                                  : Colors.black),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 20.w)),
                ],
              ),
              const Spacer(),
              Obx(
                () => GestureDetector(
                  child: Container(
                    height: 60.h,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        '회원가입',
                        style: TextStyle(color: Colors.white, fontSize: 20.sp),
                      ),
                    ),
                    color: getController.isOkayPos.value &&
                            getController.isOkayBirth.value &&
                            getController.isjungbok.value
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  onTap: () {
                    //회원가입 신청
                    doSignUp();
                  },
                ),
              ),
            ],
          ),
        )),
      ),
      onWillPop: () {
        reset();
        Get.offAll(() => SignInDemo());
        return Future(() => false);
      },
    );
  }

  Widget makeLeftLine(String content) {
    return Container(
      child: Text(
        content,
        style: TextStyle(fontSize: 20.sp, color: Colors.black),
      ),
      width: 90.w,
      height: 40.h,
      padding: EdgeInsets.only(top: 10.h),
    );
  }
}
