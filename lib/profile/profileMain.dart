import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../sameArea/bottomBar.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class profileMain extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: body(),
      bottomNavigationBar: BottomBar(1),
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