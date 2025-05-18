import 'package:flutter/material.dart';

class LikedPostPage extends StatelessWidget {
  const LikedPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liked Posts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: 5, // Dummy count
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User name and profile pic
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/user_dummy.png'), // Replace with NetworkImage or real one
                    ),
                    title: Text(
                      'user_$index',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Post image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://i.pinimg.com/1200x/52/28/bc/5228bce0ee10d1f635e98773789d63d1.jpg',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Like icon and caption
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: const [
                        Icon(Icons.favorite, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'You liked this post',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
