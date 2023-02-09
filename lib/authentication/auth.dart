import 'package:flutter/material.dart';
import 'package:meal_planner/views/login_view.dart';
import 'package:meal_planner/views/register_view.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool showLoginPage = true;

  void toggleScreens(){
    setState((){showLoginPage = !showLoginPage;});
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginView(showRegisterView: toggleScreens);
    }else{
      return RegisterView(showLoginView: toggleScreens);
    }
  }
}
