import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:logger/logger.dart';

var kLog = Logger();

TextStyle kStyleLight = const TextStyle(
  fontSize: 20,
  fontFamily: 'JosefinSans',
  fontWeight: FontWeight.w100,
);

// ignore: missing_return
Future<UserCredential?> signInWithFacebook() async {
  try {
    // Trigger the sign-in flow
    var result = await FacebookAuth.instance.login();
    // Create a credential from the access token
    var facebookAuthCredential =
        FacebookAuthProvider.credential(result.token) as FacebookAuthCredential;
    // ignore: omit_local_variable_types
    UserCredential user = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    // Once signed in, return the UserCredential
    return user;
  } on FacebookAuthException catch (e) {
    kLog.e(e.message);
  }
}
