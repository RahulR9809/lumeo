import 'package:flutter/material.dart';

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;
  const FullScreenImagePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: Container(
              width: size.width * 0.85,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                color: Colors.white, // background color for border
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
