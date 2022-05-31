import 'package:capstone_android/sameArea/bottomBar.dart';
import 'package:flutter/material.dart';

import '../sameArea/newBottomBar.dart';

class PhotoGrid extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PhotoGrid> {

  final List<String> _listItem = [
    'asset/images/two.jpg',
    'asset/images/three.jpg',
    'asset/images/four.jpg',
    'asset/images/five.jpg',
    'asset/images/one.jpg',
    'asset/images/two.jpg',
    'asset/images/three.jpg',
    'asset/images/four.jpg',
    'asset/images/five.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("사진 부분 선택"),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              width: 36,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.green[800],
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(child: Text("0")),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: _listItem.map((item) => Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: AssetImage(item),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                    )).toList(),
                  )
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: newBottomBar(1,2),
    );
  }
}