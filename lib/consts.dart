import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// const backGroundColor = Colors.black;
// const whiteColor = Colors.white;
// const primaryColor = Colors.black;
// const secondaryColor = Colors.grey;
const darkGreyColor = Color.fromARGB(255, 92, 92, 92);




const blueColor = Colors.blue;

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.black,
  colorScheme: const ColorScheme.light(
    surface: Colors.white,
    primary: Colors.black,
    secondary: Colors.grey,
    
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  primaryColor: Colors.white,
  colorScheme: const ColorScheme.dark(
    surface: Colors.black,
    primary: Colors.white,
    secondary: Colors.grey,
  ),
);




Widget sizeVer(double height) {
  return SizedBox(height: height);
}

Widget sizeHor(double width) {
  return SizedBox(width: width);
}

class PageConst {
  static const String editProfilepage = "editProfilepage";
  static const String updatePost = "UpdatePost";
  static const String updateCommentPage = "updateCommentPage";
  static const String commentPage = "commentPage";
  static const String loginPage = "LoginPage";
  static const String signUpPage = "SignUpPage";
  static const String postDetailPage = "postDetailPage";
  static const String singleProfilePage = "singleProfilePage";
  static const String savedPostpage = "savedPostpage";
  static const String followingPage = "followingPage";
  static const String followersPage = "followersPage";
    static const String chatPage = "chatPage";
      static const String videoCallPage = "videoCallPage";
  static const String userListPage = "userListPage";
  static const String aboutPage = "aboutPage";
  static const String forgotPasswordPage = 'forgotPasswordPage';

}

class FirebaseConst {
  static const String users = "users";
  static const String posts = "posts";
  static const String comment = "comment";
  static const String replay = "replay";
    static const String chats = "chats";
    static const String messages = "messages";

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

const snackbar = SnackBar(content: Text('Post Saved'));

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
