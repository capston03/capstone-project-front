import 'package:capstone_android/sameArea/newBottomBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../sameArea/bottomBar.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class profileMain extends StatelessWidget{
  int type = 0;

  profileMain(int type){
    this.type = type;
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    if (type == 0){
      index = 1;
    }else {
      index = 2;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: body(),
      bottomNavigationBar: newBottomBar(type,index),
    );
  }

}

class body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: Icons.account_box,
            press: () => {},
          ),
          ProfileMenu(
            text: "My Photo",
            icon: Icons.photo,
            press: () {},
          ),
          ProfileMenu(
            text: "My Place",
            icon: Icons.place,
            press: () {},
          ),
          ProfileMenu(
            text: "My Sticker",
            icon: Icons.archive_rounded,
            press: () {Get.toNamed('/photoGrid');},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: Icons.logout,
            press: () {},
          ),
        ],
      ),
    );
  }
}