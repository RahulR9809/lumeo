import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/presentation/widgets/bottom_container_widget.dart';
import 'package:lumeo/features/presentation/widgets/form_container_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late TextEditingController emailController;

  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      // final size = MediaQuery.of(context).size;
  // final height = size.height;
  // final width = size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      // appBar: AppBar(
        
      //         backgroundColor: Theme.of(context).colorScheme.primary,

      // ),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color:Theme.of(context).colorScheme.surface ,)),
  backgroundColor: Theme.of(context).colorScheme.primary,
  centerTitle: true,
  title: SizedBox(
    height: kToolbarHeight+20 ,
    child: Image.asset(
      Theme.of(context).brightness == Brightness.dark
          ? 'assets/dark_logo-removebg-preview.png'
          : 'assets/white_logo-removebg-preview.png',
      fit: BoxFit.contain,
    ),
  ),
),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                //  Center(
                //    child: Container(
                //      width: width * 0.30,
                //      height: width * 0.25,
                //      child: Image.asset(
                //        Theme.of(context).brightness == Brightness.dark
                //            ? 'assets/dark_logo-removebg-preview.png'
                //            : 'assets/white_logo-removebg-preview.png',
                //        fit: BoxFit.contain,
                //        height: 60,
                //      ),
                //    ),
                //  ),
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Enter your email and we will sent the password to your email',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18,color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w500),
              ),
            ),
            sizeVer(10),
            FormContainerWidget(
              controller: emailController,
              labelText: "Enter your email",
              hintText: "Enter your email",
            ),
            sizeVer(10),
            BottomContainerWidget(
                text: "Reset Password",
                color: blueColor,
                onTapListener: () => resetPassword())
          ],
        ),
      ),
    );
  }

  Future resetPassword() async {
    try {
      String email = emailController.text.trim();

      var userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isEmpty) {
        toast('User not found');
      }
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      toast('email sent successfully');
    } on FirebaseException catch (error) {
      toast('Please double check your email');
      if (kDebugMode) {
        print(error);
      }
    }
  }
}
