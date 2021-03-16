import 'dart:math';
import 'dart:ui';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:feelm/constants.dart';
import 'package:feelm/theme_clipper.dart';
import 'package:feelm/theme_config.dart';
import 'package:feelm/widgets/feelm_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

void main() => runApp(MyApp());

enum AniProps { width, height, color }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isPlatformDark =
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    final initTheme = isPlatformDark ? darkTheme : lightTheme;
    return ThemeProvider(
      initTheme: initTheme,
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeProvider.of(context),
          home: MyHomePage(),
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double left = 0;
  int random;

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    var result = await FacebookAuth.instance.login();

    // Create a credential from the access token
    FacebookAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
  }

  @override
  void initState() {
    random = Random().nextInt(10);
    signInWithFacebook();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Stack(
        children: [
          MirrorAnimation<double>(
            tween: 0.0.tweenTo(-350.0),
            duration: 55.seconds,
            builder: (context, child, value) => Positioned(
              bottom: 0,
              top: 0,
              left: value,
              child: Image.asset(
                'assets/collage$random.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
              child: Container(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
          )),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 25,
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Feelm',
                      ),
                      ThemeSwitcher(
                        clipper: const ThemeCustomClipper(),
                        builder: (context) => IconButton(
                          onPressed: () {
                            kLog.wtf(WidgetsBinding
                                .instance.window.platformBrightness);
                            ThemeSwitcher.of(context).changeTheme(
                              theme: ThemeProvider.of(context).brightness ==
                                      Brightness.light
                                  ? darkTheme
                                  : lightTheme,
                            );
                          },
                          tooltip: 'Change theme',
                          icon: FaIcon(
                            ThemeProvider.of(context).brightness ==
                                    Brightness.light
                                ? FontAwesomeIcons.moon
                                : FontAwesomeIcons.sun,
                            color: ThemeProvider.of(context).brightness ==
                                    Brightness.light
                                ? purpleDark
                                : Colors.yellow,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: PlayAnimation<double>(
                          tween: 0.0.tweenTo(200.0),
                          duration: 500.milliseconds,
                          curve: Curves.easeInOut,
                          builder: (context, child, value) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(
                                30,
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 5,
                                  sigmaY: 5,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: cielLight.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ),
                                  ),
                                  width: value * 1.1,
                                  height: value * .7,
                                  child: AnimatedOpacity(
                                    opacity: value == 200 ? 1 : 0,
                                    duration: 2.seconds,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: FeelmTextField(
                                              context: context,
                                              label: 'Username',
                                            ),
                                          ),
                                          Flexible(
                                            child: FeelmTextField(
                                              context: context,
                                              label: 'Password',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
