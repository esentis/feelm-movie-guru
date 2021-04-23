import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelm/models/keyword.dart';
import 'package:feelm/models/sign.dart';
import 'package:feelm/providers/signs_and_keywords.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:feelm/models/user.dart';

String baseImgUrl = 'https://image.tmdb.org/t/p/w600_and_h900_bestv2';

FirebaseFirestore kFirestore = FirebaseFirestore.instance;
var kLog = Logger();
var kAuth = FirebaseAuth.instance;

TextStyle kStyleLight = const TextStyle(
  fontSize: 20,
  fontFamily: 'JosefinSans',
  fontWeight: FontWeight.w100,
);

Color kColorMain = const Color(0xfff9a821);

Future<UserCredential?> signInWithFacebook() async {
  var result = await FacebookAuth.instance
      .login(); // Request email and the public profile

  if (result.status == LoginStatus.success) {
    // Create a credential from the access token
    var facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);
    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  kLog.e(result.status);
  kLog.e(result.message);
  return null;
}

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

Future<UserCredential?> googleSign() async {
  try {
    // Trigger the authentication flow
    var googleUser = await googleSignIn.signIn();
    // Obtain the auth details from the request
    var googleAuth = await googleUser?.authentication;
    // Create a new credential
    var credential = GoogleAuthProvider.credential(
      accessToken: googleAuth!.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    var user = await FirebaseAuth.instance.signInWithCredential(credential);
    return user;
  } catch (error) {
    kLog.e(error);
  }
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

var kProviders = [
  FutureProvider<List<Keyword>>(
    initialData: [],
    catchError: (context, x) {
      kLog.e(x);
      return [];
    },
    create: (_) => getKeywords(),
  ),
  FutureProvider<List<ZodiacSign>>(
    initialData: [],
    catchError: (context, x) {
      kLog.e(x);
      return [];
    },
    create: (_) => getSigns(),
  ),
  ChangeNotifierProvider<UserProvider>(
    create: (_) => UserProvider(
      currentUser: GuruUser(),
    ),
  ),
];
