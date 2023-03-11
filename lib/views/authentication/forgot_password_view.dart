import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controllers/authentication_controller.dart';
import '../../fragments/button.dart';
import '../../fragments/text__field.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailController = TextEditingController();
  double symmetricHorizontalPadding = 25.0;
  late dynamic screenSize, width;



  @override
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    screenSize = MediaQuery.of(context).size;
    width = screenSize.width;

    if(width < 500){
      symmetricHorizontalPadding;
    }else if(width < 900){
      symmetricHorizontalPadding = 100.0;
    }else if(width < 1100){
      symmetricHorizontalPadding = 200.0;
    }else if(width < 1280){
      symmetricHorizontalPadding = 300.0;
    }else{
      symmetricHorizontalPadding = 400.0;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text('Reset Password', style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.lime,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              const Text(
                'Enter your email to reset your password.'
              ),
              const SizedBox(height: 20,),
              InputField(
                  symmetricHorizontalPadding: symmetricHorizontalPadding,
                  hintText: 'Email',
                  controller: _emailController,
                  obscureText: false),
              const SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: symmetricHorizontalPadding),
                child: Button(
                    colour: Colors.black54,
                    textColour: Colors.white,
                    buttonText: 'Reset password',
                    fontSize: 16.0,
                    buttonTapped: (){
                      AuthenticationController(FirebaseAuth.instance).resetPassword(context, _emailController.text.trim());
                    }),
              ),
            ],
          ),
        ),
      ) ,
    );
  }
}
