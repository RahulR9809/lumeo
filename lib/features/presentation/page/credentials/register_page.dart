import 'dart:io';

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
import 'package:lumeo/widget_profile.dart';

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
      final pickedFile = await ImagePicker.platform.getImageFromSource(
        source: ImageSource.gallery,
      );
      setState(() {
        if (pickedFile != null) {
          _profileImage = File(pickedFile.path);
        } else {
          print('no image has been selected');
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(flex: 2, child: Container()),
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          sizeVer(10),
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: ClipRRect(borderRadius: BorderRadius.circular(35),child:profilewidget(image: _profileImage, ),),
                ),
                Positioned(
                  right: -15,
                  bottom: -13,
                  child: IconButton(
                    onPressed: () {
                        selectImage();
                    },
                    icon: Icon(Icons.add_a_photo, color: blueColor),
                  ),
                ),
              ],
            ),
          ),
          sizeVer(15),
          FormContainerWidget(
            controller: _usernameController,
            hintText: "Username",
          ),
          sizeVer(20),
          FormContainerWidget(controller: _emailController, hintText: "Email"),
          sizeVer(20),
          FormContainerWidget(controller: _bioController, hintText: "Bio"),
          sizeVer(20),
          FormContainerWidget(
            controller: _passwordController,
            hintText: "Password",
            isPasswordField: true,
          ),
          sizeVer(20),
          ButtonWidget(
            color: blueColor,
            onTapListener: () {
              _signUpUser();
            },
            text: "SignUp",
          ),
          _isSignUp == true
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Please wait",
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  sizeVer(10),
                  CircularProgressIndicator(),
                ],
              )
              : SizedBox(width: 0, height: 0),
          Flexible(flex: 2, child: Container()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(color: whiteColor),
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
                      color: whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _signUpUser() {
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
            totalPost: 0,
            totalFollowers: 0,
            totalfollowing: 0,
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
}
