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
    return SizedBox(
      child: ElevatedButton(
        onPressed: onTapListener,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.black),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
