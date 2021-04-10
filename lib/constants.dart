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

String getSign(DateTime birthDate) {
  // Checking for Aries
  if ((birthDate.month == 3 && birthDate.day >= 21) ||
      (birthDate.month == 4 && birthDate.day <= 19)) {
    return 'Aries';
  }
  // Checking for Taurus
  if ((birthDate.month == 4 && birthDate.day >= 20) ||
      (birthDate.month == 5 && birthDate.day <= 20)) {
    return 'Taurus';
  }
  // Checking for Gemini
  if ((birthDate.month == 5 && birthDate.day >= 21) ||
      (birthDate.month == 6 && birthDate.day <= 20)) {
    return 'Gemini';
  }
  // Checking for Cancer
  if ((birthDate.month == 6 && birthDate.day >= 21) ||
      (birthDate.month == 7 && birthDate.day <= 22)) {
    return 'Cancer';
  }
  // Checking for Leo
  if ((birthDate.month == 7 && birthDate.day >= 23) ||
      (birthDate.month == 8 && birthDate.day <= 22)) {
    return 'Leo';
  }
  // Checking for Virgo
  if ((birthDate.month == 8 && birthDate.day >= 23) ||
      (birthDate.month == 9 && birthDate.day <= 22)) {
    return 'Virgo';
  }
  // Checking for Libra
  if ((birthDate.month == 9 && birthDate.day >= 23) ||
      (birthDate.month == 10 && birthDate.day <= 21)) {
    return 'Libra';
  }
  // Checking for Scorpio
  if ((birthDate.month == 10 && birthDate.day >= 23) ||
      (birthDate.month == 11 && birthDate.day <= 21)) {
    return 'Scorpio';
  }
  // Checking for Sagittarius
  if ((birthDate.month == 11 && birthDate.day >= 22) ||
      (birthDate.month == 12 && birthDate.day <= 21)) {
    return 'Sagittarius';
  }
  // Checking for Capricorn
  if ((birthDate.month == 12 && birthDate.day >= 22) ||
      (birthDate.month == 1 && birthDate.day <= 18)) {
    return 'Capricorn';
  }
  // Checking for Pisces
  if ((birthDate.month == 2 && birthDate.day >= 19) ||
      (birthDate.month == 3 && birthDate.day <= 20)) {
    return 'Pisces';
  }
  return 'ok';
}
