import 'dart:math';

import 'package:feelm/constants.dart';
import 'package:feelm/models/keyword.dart';
import 'package:feelm/models/sign.dart';
import 'package:feelm/models/user.dart';
import 'package:feelm/pages/landing_page.dart';
import 'package:feelm/providers/signs_and_keywords.dart';
import 'package:feelm/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:fluttericon/mfg_labs_icons.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? themeController;

  late var random;

  void checkUser() async {
    if (kAuth.currentUser == null) {
      await Get.to(() => const LandingPage());
    }
  }

  @override
  void initState() {
    random = Random().nextInt(10);
    themeController = AnimationController(
      vsync: this,
      duration: 900.milliseconds,
    );

    WidgetsBinding.instance!.addPostFrameCallback((_) => checkUser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          MirrorAnimation<double>(
            tween: 0.0.tweenTo(-350.0),
            duration: 55.seconds,
            builder: (context, child, value) => Positioned.fill(
              bottom: 0,
              top: 0,
              left: value,
              child: Image.asset(
                'assets/collage$random.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // A smooth color layer at top of the background image
          Positioned.fill(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.4),
            ),
          ),
          Positioned(
            top: 25,
            right: 0,
            child: GestureDetector(
              onTap: () {
                if (themeController?.value == 0.5) {
                  themeController?.animateTo(0);
                  Get.changeTheme(lightTheme);
                } else {
                  themeController?.animateTo(0.5);
                  Get.changeTheme(darkTheme);
                }
                kLog.wtf(themeController?.value);
              },
              child: Lottie.asset(
                'assets/theme_switcher.json',
                height: 60,
                controller: themeController,
                onLoaded: (composition) {
                  themeController?.animateTo(1);
                },
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 25,
            child: GestureDetector(
              onTap: () async {
                await kAuth.signOut();
                await Get.offAll(
                  () => MultiProvider(
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
                      ),
                      ChangeNotifierProvider<UserProvider>(
                        create: (_) => UserProvider(
                          currentUser: GuruUser(),
                        ),
                      ),
                    ],
                    child: const LandingPage(),
                  ),
                );
              },
              child: Icon(MfgLabs.logout),
            ),
          ),
        ],
      ),
    );
  }
}
