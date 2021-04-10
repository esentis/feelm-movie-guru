import 'dart:ui';
import 'package:feelm/constants.dart';
import 'package:feelm/models/keyword.dart';
import 'package:feelm/models/sign.dart';
import 'package:feelm/pages/landing_page.dart';
import 'package:feelm/providers/signs_and_keywords.dart';
import 'package:feelm/theme_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  var isPlatformDark =
      WidgetsBinding.instance!.window.platformBrightness == Brightness.dark;

  var initTheme = isPlatformDark ? darkTheme : lightTheme;
  runApp(
    GetMaterialApp(
      title: 'Feelm Movie Guru',
      theme: initTheme,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
        )
      ],
      child: const LandingPage(),
    );
  }
}
