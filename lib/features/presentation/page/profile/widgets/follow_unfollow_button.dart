
import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final VoidCallback onTapListener;
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const FollowButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onTapListener,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width * 0.35,
      height: 42,
      child: ElevatedButton(
        onPressed: onTapListener,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: backgroundColor),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: width * 0.04,
              color: textColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
