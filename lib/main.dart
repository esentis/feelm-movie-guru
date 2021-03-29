import 'dart:ui';
import 'package:feelm/pages/landing_page.dart';
import 'package:feelm/theme_config.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  await DotEnv.load(fileName: '.env');
  // check if is running on Web
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    FacebookAuth.instance.webInitialize(
      appId: '1392210321147845', //<-- YOUR APP_ID
      cookie: true,
      xfbml: true,
      version: 'v9.0',
    );
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isPlatformDark =
        WidgetsBinding.instance!.window.platformBrightness == Brightness.dark;
    var initTheme = isPlatformDark ? darkTheme : lightTheme;
    return MaterialApp(
      title: 'Feelm Movie Guru',
      theme: initTheme,
      home: const LandingPage(),
    );
  }
}
