import 'package:feelm/models/user.dart';
import 'package:feelm/pages/landing_page.dart';
import 'package:feelm/pages/movies_screen.dart';
import 'package:feelm/pages/test_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load();
  final currentUser = await FirebaseAuth.instance.currentUser?.toGuruUser();
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
  runApp(
    GetMaterialApp(
      title: 'Feelm Movie Guru',
      debugShowCheckedModeBanner: false,
      home: FeelMeRoot(currentUser),
    ),
  );
}

class FeelMeRoot extends StatelessWidget {
  final GuruUser? user;
  const FeelMeRoot(this.user);
  @override
  Widget build(BuildContext context) {
    return user == null
        ? const LandingPage()
        // If user has not been tested yet we prompt him to the test page.
        : user!.tested == null || !user!.tested!
            ? TestPage(
                user: user,
              )
            : MoviesScreen();
  }
}
