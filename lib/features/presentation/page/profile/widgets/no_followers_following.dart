
import 'package:flutter/material.dart';

class NoFollowersFollowing extends StatelessWidget {
  final String text;
  final String text2;
  const NoFollowersFollowing({super.key, required this.text, required this.text2});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.06,
          vertical: height * 0.05,
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(width * 0.04),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_off_outlined,
              size: width * 0.15,
              color: Colors.white,
            ),
            SizedBox(height: height * 0.02),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height * 0.012),
            Text(
              text2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: width * 0.035,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
