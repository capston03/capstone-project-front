import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class showList extends StatelessWidget {
  const showList({required this.title, required this.info});
  final String title;
  final String info;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.image),
      title: Text(title),
      shape: Border(
          bottom: BorderSide(
              color: Colors.lightGreen
          )
      ),
      onTap: (){
        Get.offNamed('/test', arguments: info);
      },
    );
  }
  
}
