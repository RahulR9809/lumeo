

import 'package:flutter/material.dart';

class ProfileFormWidget extends StatelessWidget {
  const ProfileFormWidget({super.key, this.title, this.controller});
  final String? title;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: height * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: width * 0.045,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: height * 0.007),
          TextFormField(
            controller: controller,
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
              fontSize: width * 0.042,
            ),
            decoration: InputDecoration(
              hintText: "Enter $title",
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.primary,
              contentPadding: EdgeInsets.symmetric(
                vertical: height * 0.018,
                horizontal: width * 0.04,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
