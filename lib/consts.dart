import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const backGroundColor = Colors.black;
const whiteColor = Colors.white;
const blueColor = Colors.blue;
const primaryColor = Colors.black;
const secondaryColor = Colors.grey;
const darkGreyColor = Color.fromARGB(255, 92, 92, 92);

Widget sizeVer(double height) {
  return SizedBox(height: height);
}

Widget sizeHor(double width) {
  return SizedBox(width: width);
}

class PageConst {
  static const String editProfilepage = "editProfilepage";
  static const String updatePost = "UpdatePost";
  static const String commentPage = "commentPage";
  static const String loginPage = "LoginPage";
  static const String signUpPage = "SignUpPage";
}

class FirebaseConst {
  static const String users = "users";
  static const String posts = "posts";
  static const String comment = "comment";
  static const String replay = "replay";
}

// void toast(String message){
//   Fluttertoast.showToast(msg: message,
//   toastLength: Toast.LENGTH_SHORT,
//   gravity: ToastGravity.BOTTOM,
//   timeInSecForIosWeb: 1,
//   textColor: Colors.white,
//   fontSize: 16.0);
// }

// void toast(String? message) {
//   if (message == null || message.isEmpty) {
//     debugPrint("Toast message is null or empty, skipping.");
//     return;
//   }
  
//   Fluttertoast.showToast(
//     msg: message,
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.BOTTOM,
//     timeInSecForIosWeb: 1,
//     textColor: Colors.white,
//     fontSize: 16.0,
//   );
// }




void toast(String? message) {
  if (message == null || message.isEmpty) {
    debugPrint("Toast message is null or empty, skipping.");
    return;
  }

  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black87, // ✅ Added backgroundColor
    textColor: Colors.white,
    fontSize: 16.0,
  );
}