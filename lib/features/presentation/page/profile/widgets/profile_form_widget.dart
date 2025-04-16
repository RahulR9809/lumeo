import 'package:flutter/material.dart';
import 'package:lumeo/consts.dart';

class ProfileFormWidget extends StatelessWidget {
  const ProfileFormWidget({super.key, this.title, this.controller});
  final String? title;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title", style: TextStyle(color: secondaryColor, fontSize: 16)),
        sizeVer(18),
        TextFormField(
          controller: controller,
          style: TextStyle(color: secondaryColor),
        ),
        Container(width: double.infinity, height: 1, color: secondaryColor),
      ],
    );
  }
}
