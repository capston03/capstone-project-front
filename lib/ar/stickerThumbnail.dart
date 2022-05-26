import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StickerThumbnail{



  String showThumbnail(BuildContext context){
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0.r), topRight: Radius.circular(30.0.r))
        ),
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20.w)),
                    Text('크기(50이 처음 주어진 사이즈입니다.) : '),

                  ],
                ),
              ),

            ],
          );
        });
    return ""; // TODO 후에 glb주소 받을 예정
  }

  // void showBottomPopupSizing(ARNode selectedNode) {
  //   String node = selectedNode.name;
  //   showModalBottomSheet(
  //       backgroundColor: Colors.white,
  //       context: context,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0.r), topRight: Radius.circular(30.0.r))
  //       ),
  //       builder: (context) {
  //         return Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             SizedBox(
  //               child: Row(
  //                 children: [
  //                   Padding(padding: EdgeInsets.only(left: 20.w)),
  //                   Text('크기(50이 처음 주어진 사이즈입니다.) : '),
  //                   Obx(
  //                         () => DropdownButton(
  //                       value: getController
  //                           .nodeData[node]!["scaleSelectedValue"]!.value
  //                           .toInt()
  //                           .toString(),
  //                       items: _scales.map((value) {
  //                         return DropdownMenuItem(
  //                           value: value,
  //                           child: Text(value),
  //                         );
  //                       }).toList(),
  //                       onChanged: (value) {
  //                         // setState(() {
  //                         getController.setScale(node, value.toString());
  //                         var newRotationAxisX = vector.Vector3(1.0, 0, 0);
  //                         var newRotationAxisY = vector.Vector3(0, 1.0, 0);
  //                         var newRotationAxisZ = vector.Vector3(0, 0, 1.0);
  //                         final newTransform = Matrix4.identity();
  //                         newTransform.scale(
  //                             int.parse(getController.getScale(node)) * 0.004);
  //                         newTransform.rotate(newRotationAxisX,
  //                             getController.getRotateX(node) * (6.27 / 360));
  //                         newTransform.rotate(newRotationAxisY,
  //                             getController.getRotateY(node) * (6.27 / 360));
  //                         newTransform.rotate(newRotationAxisZ,
  //                             getController.getRotateZ(node) * (6.27 / 360));
  //                         selectedNode.transform = newTransform;
  //                         // });
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Padding(padding: EdgeInsets.only(left: 20.w)),
  //                       Text('회전'),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       Padding(padding: EdgeInsets.only(left: 20.w)),
  //                       Text('양 옆 회전'),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: buildSlider(
  //                           node: node,
  //                           angle: 'X',
  //                           divisions: 36,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       Padding(padding: EdgeInsets.only(left: 20.w)),
  //                       Text('제자리 회전'),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: buildSlider(
  //                           node: node,
  //                           angle: 'Y',
  //                           divisions: 36,
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       Padding(padding: EdgeInsets.only(left: 20.w)),
  //                       Text('위 아래 회전'),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: buildSlider(
  //                           node: node,
  //                           angle: 'Z',
  //                           divisions: 36,
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             )
  //           ],
  //         );
  //       });
  // }
}