import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BuildingTile extends StatelessWidget {
  const BuildingTile({Key? key, required this.title,required this.info}) : super(key: key);
  final String title;
  final Map<String,dynamic> info;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.arrow_back_ios_outlined),
      title: Text(title),
      shape: Border(
        bottom: BorderSide(
          color: Colors.lightGreen
        )
      ),
      onTap: (){
        //page 이동
        Get.offNamed('/test', arguments: info);
      },
    );
  }
}
