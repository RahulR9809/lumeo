import 'package:flutter/material.dart';
import 'package:lumeo/consts.dart';

class Search extends StatelessWidget {
  final TextEditingController controller;
  const Search({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity,
    height: 45,
    decoration: BoxDecoration(
      color: secondaryColor,
      borderRadius: BorderRadius.circular(15)
    ),
    child: TextFormField(
      controller: controller,
      style: TextStyle(color: whiteColor),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search,color: whiteColor,),
        hintText: "Search",
        hintStyle: TextStyle(color: secondaryColor,fontSize: 15)
      ),
    ),
    );
  }
}