import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:lumeo/features/presentation/cubit/credential/cubit/credential_cubit.dart';
import 'package:lumeo/features/presentation/page/credentials/main_screen/main_screen.dart';
import 'package:lumeo/features/presentation/widgets/button_widget.dart';
import 'package:lumeo/features/presentation/widgets/form_container_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
          print(credentialState);
          if (credentialState is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  print(authState);
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
          Flexible(child: Container(), flex: 4),
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
          FormContainerWidget(hintText: "Email", controller: _emailController),
          sizeVer(20),
          FormContainerWidget(
            hintText: "Password",
            isPasswordField: true,
            controller: _passwordController,
          ),
          sizeVer(20),
          ButtonWidget(
            color: blueColor,
            onTapListener: () {
              _logInUser();
            },
            text: "Login",
          ),
          sizeVer(10),
          _isLogIn == true
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
              : Container(width: 0, height: 0),
          Flexible(child: Container(), flex: 2),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "if you dont have an account?",
                  style: TextStyle(color: whiteColor),
                ),

                InkWell(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      PageConst.signUpPage,
                      (route) => false,
                    );
                  },
                  child: Text(
                    "signUp",
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

  void _logInUser() {
    setState(() {
      _isLogIn = true;
    });
    BlocProvider.of<CredentialCubit>(context)
        .sigInUser(
          email: _emailController.text,
          password: _passwordController.text,
        )
        .then((value) => _clear());
  }

  void _clear() {
    _emailController.clear();
    _passwordController.clear();
    _isLogIn = false;
  }
}
