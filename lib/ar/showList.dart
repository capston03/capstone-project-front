import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class showList extends StatelessWidget {
  const showList({Key? key, required this.title,required this.info}) : super(key: key);
  final String title;
  final Map<String,dynamic> info;

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

      },
    );
  }
  
}
