import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  final TextEditingController controller;
  const Search({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity,
    height: 45,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(15)
    ),
    child: TextFormField(
      controller: controller,
      style: TextStyle(color: Theme.of(context).colorScheme.surface),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search,color: Theme.of(context).colorScheme.surface,),
        hintText: "Search",
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary,fontSize: 15)
      ),
    ),
    );
  }
}