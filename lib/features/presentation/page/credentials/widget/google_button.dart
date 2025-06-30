import 'package:flutter/material.dart';
import 'package:lumeo/consts.dart';

class GoogleButton extends StatelessWidget {
  final Color? color;
  final String? text;
  final VoidCallback? onTapListener;
  const GoogleButton(
      {super.key, this.color, this.text, this.onTapListener});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapListener,
      child: Container(
        
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color,border: Border.all(color: blueColor)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Image.asset("assets/Google__G__logo.svg.png",height: 30,width: 30,),
               sizeHor(10),
                Text(
                            '$text',
                            style:  TextStyle(color:Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.w500,fontSize: 15),
                          ),
              ],
            ),
          )),
    );
  }
}
