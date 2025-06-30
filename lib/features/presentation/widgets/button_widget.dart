
 import 'package:flutter/material.dart';
class ButtonWidget extends StatelessWidget {
  final Color? color;
  final String? text;
  final VoidCallback? onTapListener;

  const ButtonWidget({
    super.key,
    this.color,
    this.text,
    this.onTapListener,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTapListener,
      child: Container(
        width: width * 0.32, // roughly 120 on standard screen
        height: width * 0.13, // maintains 50 height proportionally
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(width * 0.05), // responsive border radius
        ),
        child: Center(
          child: Text(
            "$text",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: width * 0.045, // responsive font size
            ),
          ),
        ),
      ),
    );
  }
}
