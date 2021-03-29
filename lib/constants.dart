import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:logger/logger.dart';

var kLog = Logger();

TextStyle kStyleLight = const TextStyle(
  fontSize: 20,
  fontFamily: 'JosefinSans',
  fontWeight: FontWeight.w100,
);

Future<AccessToken?> signInWithFacebook() async {
  var result = await FacebookAuth.instance
      .login(); // Request email and the public profile
  if (result.status == LoginStatus.success) {
    // get the user data
    // by default we get the userId, email,name and picture
    var userData = await FacebookAuth.instance.getUserData();
    // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
    kLog.i(userData);
    kLog.i(result.accessToken?.token);
    return result.accessToken;
  }

  kLog.e(result.status);
  kLog.e(result.message);
  return null;
}
