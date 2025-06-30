import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:lumeo/features/presentation/cubit/credential/cubit/credential_cubit.dart';
import 'package:lumeo/features/presentation/page/credentials/main_screen/main_screen.dart';
import 'package:lumeo/features/presentation/widgets/button_widget.dart';
import 'package:lumeo/features/presentation/widgets/form_container_widget.dart';
import 'package:lumeo/features/presentation/widgets/widget_profile.dart';
import 'package:lumeo/validator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  File? _profileImage;

  Future selectImage() async {
    try {
      // ignore: invalid_use_of_visible_for_testing_member
      final pickedFile = await ImagePicker.platform.getImageFromSource(
        source: ImageSource.gallery,
      );
      setState(() {
        if (pickedFile != null) {
          _profileImage = File(pickedFile.path);
        } else {
          if (kDebugMode) {
            print('no image has been selected');
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }
          if (credentialState is CredentialFailure) {
            toast("Invalid Email and password");
          }
        },
        builder: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return MainScreen(uid: authState.uid);
                } else {
                  return _bodyWidget();
                }
              },
            );
          }
          return _bodyWidget();
        },
      ),
    );
  }


_bodyWidget() {
  final size = MediaQuery.of(context).size;
  final height = size.height;
  final width = size.width;

  return SingleChildScrollView(
    child: SizedBox(
      height: height,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
          children: [
            const Spacer(flex: 1),

            /// Logo
            Center(
              child: Center(
  child: SizedBox(
    width: width * 0.30,
    height: width * 0.25,
    child: Image.asset(
      Theme.of(context).brightness == Brightness.dark
          ? 'assets/dark_logo-removebg-preview.png'
          : 'assets/white_logo-removebg-preview.png',
      fit: BoxFit.contain,
      height: 60,
    ),
  ),
),

            ),

            SizedBox(height: height * 0.015),

            /// Profile Picker
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: width * 0.18,
                    height: width * 0.18,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(width * 0.09),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(width * 0.09),
                      child: profilewidget(image: _profileImage),
                    ),
                  ),
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(Icons.add_a_photo, color: blueColor, size: width * 0.06),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.02),

            /// Form Fields
            FormContainerWidget(
              controller: _usernameController,
              hintText: "Username",
            ),
            SizedBox(height: height * 0.02),
            FormContainerWidget(
              controller: _emailController,
              hintText: "Email",
            ),
            SizedBox(height: height * 0.02),
            FormContainerWidget(
              controller: _bioController,
              hintText: "Bio",
            ),
            SizedBox(height: height * 0.02),
            FormContainerWidget(
              controller: _passwordController,
              hintText: "Password",
              isPasswordField: true,
            ),

            SizedBox(height: height * 0.02),

            /// SignUp Button
            ButtonWidget(
              color: blueColor,
              onTapListener: _signUpUser,
              text: "SignUp",
            ),

            SizedBox(height: height * 0.02),

            /// Loading indicator
            _isSignUp
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Please wait",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: width * 0.03),
                      SizedBox(
                        width: width * 0.05,
                        height: width * 0.05,
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),

            const Spacer(flex: 1),

            /// Navigation to Login
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: width * 0.035),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        PageConst.loginPage,
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: width * 0.035,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  void _signUpUser() {
      final emailError = Validators.email(_emailController.text);
  final passwordError = Validators.password(_passwordController.text);
    final bioError = Validators.bio(_bioController.text);
  final usernameError = Validators.username(_usernameController.text);

  if (emailError != null) {
    _showErrorSnackBar(emailError);
    return;
  }

  if (passwordError != null) {
    _showErrorSnackBar(passwordError);
    return;
  }

  if (bioError != null) {
    _showErrorSnackBar(bioError);
    return;
  }

  if (usernameError != null) {
    _showErrorSnackBar(usernameError);
    return;
  }
    setState(() {
      _isSignUp = true;
    });
    BlocProvider.of<CredentialCubit>(context)
        .signUpUser(
          user: UserEntity(
            email: _emailController.text.trim(),
            username: _usernameController.text.trim(),
            password: _passwordController.text.trim(),
            bio: _bioController.text,
            totalPosts: 0,
            totalFollowers: 0,
            totalFollowing: 0,
            followers: [],
            following: [],
            link: "",
            profileUrl: "",
            name: "",
            uid: null,
            profileImageFile: _profileImage
          ),
        )
        .then((onValue) {
          return clear();
        });
  }

  clear() {
    setState(() {
      _usernameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _bioController.clear();
      _isSignUp = false;
    });
  }
    void _showErrorSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}
}
