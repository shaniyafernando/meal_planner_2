import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:meal_planner/views/authentication/forgot_password_view.dart';
import '../../controllers/authentication_controller.dart';
import '../../fragments/button.dart';
import '../../fragments/text__field.dart';
import '../../style_fragments.dart';

class LoginView extends StatefulWidget {
  final VoidCallback showRegisterView;
  const LoginView({super.key, required this.showRegisterView});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signIn(){
    AuthenticationController(FirebaseAuth.instance).signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    double symmetricHorizontalPadding = 25.0, fontSize = 45.0;
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;

    if(width < 500){
      symmetricHorizontalPadding;
      fontSize;
    }else if(width < 900){
      symmetricHorizontalPadding = 100.0;
      fontSize = 60.0;
    }else if(width < 1100){
      symmetricHorizontalPadding = 200.0;
      fontSize = 60.0;
    }else if(width < 1280){
      symmetricHorizontalPadding = 300.0;
      fontSize = 60.0;
    }else{
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

                Text('foodnertize', style: dosisFont(fontSize),),
                const SizedBox(height: 10,),

                const Text('Login', style: TextStyle(fontSize: 20,),),
                const SizedBox(height: 50,),

                InputField(
                    symmetricHorizontalPadding: symmetricHorizontalPadding,
                    hintText: 'Email',
                    controller: _emailController,
                    obscureText: false),
                const SizedBox(height: 10,),

                InputField(
                    symmetricHorizontalPadding: symmetricHorizontalPadding,
                    hintText: 'Password',
                    controller: _passwordController,
                    obscureText: true),
                const SizedBox(height: 10,),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: symmetricHorizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:[
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return const ForgotPasswordView();
                          }));},
                        child: const Text('Forgot password?',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold
                            )
                        ),
                      ) ,
                    ]
                  )
                ),
                const SizedBox(height: 10,),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: symmetricHorizontalPadding),
                  child: Button(
                      colour: Colors.black54,
                      textColour: Colors.white,
                      buttonText: 'Sign In',
                      fontSize: 16.0,
                      buttonTapped: signIn),
                ),
                const SizedBox(height: 25,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not a member?',
                        style: TextStyle(
                            color: Colors.white
                        )
                    ),
                    GestureDetector(
                      onTap: widget.showRegisterView,
                      child: const Text(' Register now',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold
                          )
                      ) ,
                    )

                  ],
                ),
                const SizedBox(height: 30.0,),
                ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child:  SignInButton(
                        Buttons.Google,
                        text: "Sign in with Google",
                        onPressed: () {
                          AuthenticationController(FirebaseAuth.instance).
                          signInWithGoogle(context);
                        },
                      ),
                  ),
                
              ],
            ),
          ),
        )
      )
    );
  }
}
