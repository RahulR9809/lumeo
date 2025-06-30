
import 'package:flutter/material.dart';

class BottomContainerWidget extends StatelessWidget {
  final Color? color;
  final String? text;
  final VoidCallback? onTapListener;

  const BottomContainerWidget({
    super.key,
    this.color,
    this.text,
    this.onTapListener,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: onTapListener,
      child: Container(
        width: double.infinity,
        height: height * 0.060, // ~50px at 768px screen height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width * 0.025),
          color: color,
        ),
        child: Center(
          child: Text(
            '$text',
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
              fontSize: width * 0.040, // ~18px at 400px width
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
