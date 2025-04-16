import 'package:flutter/material.dart';
import 'package:lumeo/consts.dart';
class ButtonWidget extends StatelessWidget {
  final Color? color;
  final String? text;
  final VoidCallback? onTapListener;
  const ButtonWidget({super.key,
   this.color, this.text, this.onTapListener});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapListener,
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Center(child:Text("$text",style: TextStyle(color:primaryColor,fontWeight: FontWeight.w600,fontSize: 19),)),
      ));
  }
}
 