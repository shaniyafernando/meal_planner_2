import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:meal_planner/style_fragments.dart';

import '../controllers/authentication_service.dart';
import '../fragments/button.dart';
import '../fragments/text__field.dart';

class RegisterView extends StatefulWidget {
  final VoidCallback showLoginView;
  const RegisterView({Key? key, required this.showLoginView}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  double symmetricHorizontalPadding = 25.0, fontSize = 45.0;
  late Size screenSize;
  late double width;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future signUp() async {
    if (passwordConfirmed()) {
      AuthenticationService(FirebaseAuth.instance).signUpWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          context: context);
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    width = screenSize.width;

    if (width < 500) {
      symmetricHorizontalPadding;
      fontSize;
    } else if (width < 900) {
      symmetricHorizontalPadding = 100.0;
      fontSize = 60.0;
    } else if (width < 1100) {
      symmetricHorizontalPadding = 200.0;
      fontSize = 60.0;
    } else if (width < 1280) {
      symmetricHorizontalPadding = 300.0;
      fontSize = 60.0;
    } else {
      symmetricHorizontalPadding = 400.0;
      fontSize = 70.0;
    }

    return Scaffold(
        backgroundColor: Colors.lime,
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
                  child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('foodnertize', style: dosisFont(fontSize)),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Register',
              style: TextStyle(
                  fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            InputField(
                  symmetricHorizontalPadding: symmetricHorizontalPadding,
                  hintText: 'Email',
                  controller: _emailController,
                  obscureText: false),
            const SizedBox(
              height: 10,
            ),
            InputField(
                  symmetricHorizontalPadding: symmetricHorizontalPadding,
                  hintText: 'Password',
                  controller: _passwordController,
                  obscureText: true),
            const SizedBox(
              height: 10,
            ),
            InputField(
                  symmetricHorizontalPadding: symmetricHorizontalPadding,
                  hintText: 'Confirm Password',
                  controller: _confirmPasswordController,
                  obscureText: true),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: symmetricHorizontalPadding),
              child: Button(
                    colour: Colors.black54,
                    textColour: Colors.white,
                    buttonText: 'Sign Up',
                    fontSize: 16.0,
                    buttonTapped: signUp),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  const Text('I am a member!',
                      style: TextStyle(color: Colors.white)),
                  GestureDetector(
                    onTap: widget.showLoginView,
                    child: const Text(' Login now',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 50.0,),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: SignInButton(
                Buttons.Google,
                text: "Sign up with Google",
                onPressed: () {
                  AuthenticationService(FirebaseAuth.instance).
                  signInWithGoogle(context);
                },
              ),
            )
          ],
        ),
                ))));
  }
}
