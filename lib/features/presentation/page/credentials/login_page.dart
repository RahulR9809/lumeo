import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:lumeo/features/presentation/cubit/credential/cubit/credential_cubit.dart';
import 'package:lumeo/features/presentation/page/credentials/main_screen/main_screen.dart';
import 'package:lumeo/features/presentation/page/credentials/widget/google_button.dart';
import 'package:lumeo/features/presentation/widgets/button_widget.dart';
import 'package:lumeo/features/presentation/widgets/form_container_widget.dart';
import 'package:lumeo/validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _hasAttemptedLogin = false;

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
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }
          if (credentialState is CredentialFailure) {
            _showErrorSnackBar("incorect email or password");
          }
        },
        builder: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
        
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return MainScreen(uid: authState.uid);
                } else if (authState is UnAuthenticated && _hasAttemptedLogin) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showErrorSnackBar("incorrect email or password");
                  });
                }
                return _bodyWidget();
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
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         Center(
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

          SizedBox(height: height * 0.015),
          FormContainerWidget(
            hintText: "Email",
            controller: _emailController,
          ),
          SizedBox(height: height * 0.025),
          FormContainerWidget(
            hintText: "Password",
            isPasswordField: true,
            controller: _passwordController,
          ),
          SizedBox(height: height * 0.025),
          ButtonWidget(
            color: blueColor,
            onTapListener: () {
              _logInUser();
            },
            text: "Login",
          ),
          SizedBox(height: height * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'forgotPasswordPage'),
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: blueColor,
                    fontWeight: FontWeight.w400,
                    fontSize: width * 0.03,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.015),
          const Text('or'),
          SizedBox(height: height * 0.02),
          GoogleButton(
            text: 'Sign in with Google',
            color: Theme.of(context).colorScheme.primary,
            onTapListener: () {
              BlocProvider.of<AuthCubit>(context).googleSignIn();
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "If you don't have an account? ",
                  style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: width * 0.035),
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
                    "SignUp",
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
          _isLogIn
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
              : SizedBox.shrink(),
        ],
      ),
    ),
  );
}

  void _logInUser() {
    final emailError = Validators.email(_emailController.text);
    final passwordError = Validators.password(_passwordController.text);

    if (emailError != null) {
      _showErrorSnackBar(emailError);
      return;
    }

    if (passwordError != null) {
      _showErrorSnackBar(passwordError);
      return;
    }

    setState(() {
      _hasAttemptedLogin = true;

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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
