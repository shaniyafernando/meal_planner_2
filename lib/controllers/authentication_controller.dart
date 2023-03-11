import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utils.dart';

class AuthenticationController{

  final FirebaseAuth _auth;

  AuthenticationController(this._auth);


  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    try{
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await sendEmailVerification(context);
    } on FirebaseAuthException catch(error){
      showSnackBar(context, error.message!);
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    try{
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if(!_auth.currentUser!.emailVerified){
        await sendEmailVerification(context);
      }
    } on FirebaseAuthException catch(error){
      showSnackBar(context, error.message!);
    }
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification has been sent!');
    } on FirebaseAuthException catch (error) {
      showSnackBar(context, error.message!);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      if(kIsWeb){
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        googleAuthProvider.addScope("https://www.googleapis.com/auth/user.emails.read");
        await _auth.signInWithPopup(googleAuthProvider);
      }else{

        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

        if(googleAuth?.accessToken != null && googleAuth?.idToken != null) {
          final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth?.accessToken,
              idToken: googleAuth?.idToken
          );
          UserCredential userCredential =
          await _auth.signInWithCredential(credential);
          if (userCredential.user != null) {
            if (userCredential.additionalUserInfo!.isNewUser) {
            //Out of scope. Do if there is more time.
              }}
        }
      }

    } on FirebaseAuthException catch (error) {
      showSnackBar(context, error.message!);
    }
  }

  signOut(BuildContext context){
    _auth.signOut();
    showSnackBar(context,'Logout successful!');
  }

  Future resetPassword(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: email);
      showSnackBar(context,'Check your email to access the reset password link!');

    } on FirebaseAuthException catch (error){
      showSnackBar(context, error.message!);
    }
  }

}
