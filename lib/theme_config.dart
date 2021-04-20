import 'package:feelm/constants.dart';
import 'package:flutter/material.dart';

// Dark theme color pallette.
Color purpleDark = const Color(0xff312c51);
Color purpleLight = const Color(0xff312c51);
Color pink = const Color(0xffe9b0df);

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: purpleDark,
  scaffoldBackgroundColor: purpleLight,
  hintColor: kColorMain,
  errorColor: kColorMain,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: kColorMain,
  ),
  iconTheme: IconThemeData(
    color: pink,
  ),
  appBarTheme: AppBarTheme(
    shadowColor: cielDark.withOpacity(0.5),
    elevation: 2,
    centerTitle: true,
    textTheme: TextTheme(
      // The default TextStyle for Material
      headline6: TextStyle(
        color: whiteLight,
        fontSize: 20,
        fontFamily: 'JosefinSans',
      ),
    ),
  ),
  textTheme: TextTheme(
    // The default TextStyle for Material
    bodyText2: TextStyle(
      color: pink,
      fontSize: 20,
    ),
  ),
);

// Light theme color pallette.
Color whiteLight = const Color(0xfff4f9f9);
Color cielLight = const Color(0xffccf2f4);
Color cielDark = const Color(0xffa4ebf3);

ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: purpleDark,
  scaffoldBackgroundColor: cielDark,
  // TextInput hint color
  hintColor: kColorMain,
  errorColor: purpleDark,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: purpleDark,
  ),
  iconTheme: IconThemeData(
    color: purpleDark,
  ),
  appBarTheme: AppBarTheme(
    shadowColor: purpleDark.withOpacity(0.5),
    elevation: 2,
    centerTitle: true,
    textTheme: TextTheme(
      // The default TextStyle for Material
      headline6: TextStyle(
        color: purpleDark,
        fontSize: 20,
        fontFamily: 'JosefinSans',
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
);
