
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'rahuldev9809@gmail.com',
      query: 'subject=Lumeo Feedback',
    );

    try {
      await launchUrl(emailUri);
    } catch (e) {
      debugPrint('Could not launch email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About LumeoApp',
          style: TextStyle(fontSize: width * 0.05),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.03),

            // App logo
         Container(
  width: width * 0.3,
  height: width * 0.3,
  decoration: BoxDecoration(
    color: Theme.of(context).primaryColor,
    shape: BoxShape.circle,
    image: DecorationImage(
      image: AssetImage('assets/icon.png'), // or use NetworkImage(...)
      fit: BoxFit.cover,
      
    ),
  ),
),


            SizedBox(height: height * 0.03),

            // App name
            Text(
              'LumeoApp',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.065,
                  ),
            ),

            SizedBox(height: height * 0.01),

            // App version
            Text(
              'Version 1.0.0',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: width * 0.045,
                  ),
            ),

            SizedBox(height: height * 0.04),

            // App description
            Text(
              'LumeoApp helps you stay connected with friends and family through seamless messaging and video calls.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: width * 0.04),
            ),

            SizedBox(height: height * 0.04),

            // Developer info
            Text(
              'Developed by',
              style: TextStyle(fontSize: width * 0.04),
            ),

            SizedBox(height: height * 0.01),

            Text(
              'Rahul R',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.05,
                  ),
            ),

            SizedBox(height: height * 0.03),

            // Contact button
            ElevatedButton.icon(
              onPressed: _launchEmail,
              icon: Icon(Icons.email_outlined, size: width * 0.06),
              label: Text(
                'Contact Developer',
                style: TextStyle(fontSize: width * 0.042),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06,
                  vertical: height * 0.015,
                ),
              ),
            ),

            SizedBox(height: height * 0.05),

            // Privacy and terms
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // Navigate to privacy policy
                  },
                  child: Text(
                    'Privacy Policy',
                    style: TextStyle(fontSize: width * 0.04),
                  ),
                ),
                SizedBox(width: width * 0.04),
                TextButton(
                  onPressed: () {
                    // Navigate to terms of service
                  },
                  child: Text(
                    'Terms of Service',
                    style: TextStyle(fontSize: width * 0.04),
                  ),
                ),
              ],
            ),

            SizedBox(height: height * 0.02),

            // Copyright
            Text(
              '© ${DateTime.now().year} LumeoApp. All rights reserved.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: width * 0.035,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }
}
