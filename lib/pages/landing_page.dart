import 'dart:math';
import 'dart:ui';

import 'package:feelm/constants.dart';
import 'package:feelm/models/keyword.dart';
import 'package:feelm/models/user.dart';
import 'package:feelm/pages/movies_screen.dart';
import 'package:feelm/theme_config.dart';
import 'package:feelm/widgets/feelm_snackbar.dart';
import 'package:feelm/widgets/feelm_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/zocial_icons.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:provider/provider.dart';
import 'package:feelm/models/sign.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  double left = 0;
  bool showLogin = true;
  int? random;

  CustomAnimationControl _loginContainerAnimationController =
      CustomAnimationControl.PLAY_REVERSE;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AnimationController? themeController;

  Future<String> showPickerDate(BuildContext context) async {
    var sign = '';
    await Picker(
      backgroundColor: Colors.transparent,
      height: 150,
      hideHeader: true,
      adapter: DateTimePickerAdapter(),
      title: Text(
        'Birthdate',
        style: kStyleLight.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: kColorMain,
        ),
      ),
      textStyle: kStyleLight.copyWith(
        color: Theme.of(context).errorColor,
      ),
      cancelTextStyle: kStyleLight.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.red,
      ),
      confirmTextStyle: kStyleLight.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: kColorMain,
      ),
      selectedTextStyle: kStyleLight.copyWith(
        fontWeight: FontWeight.bold,
        color: kColorMain,
      ),
      onConfirm: (Picker picker, List value) {
        var date = (picker.adapter as DateTimePickerAdapter).value;
        kLog.wtf(getSign(date!));
        sign = getSign(date);
      },
    ).showDialog(context);
    return sign;
  }

  @override
  void initState() {
    // To randomize the background image
    random = Random().nextInt(10);
    themeController = AnimationController(
      vsync: this,
      duration: 900.milliseconds,
    );
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => Get.changeTheme(lightTheme));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var words = Provider.of<List<Keyword>>(context);
    var signs = Provider.of<List<ZodiacSign>>(context);

    signs.sort((a, b) =>
        a.from.millisecondsSinceEpoch.compareTo(b.from.millisecondsSinceEpoch));
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // He
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

          Stack(
            children: [
              Positioned(
                top: 75,
                left: 70,
                right: 70,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: AnimatedOpacity(
                      opacity:
                          MediaQuery.of(context).viewInsets.bottom == 0 ? 1 : 0,
                      duration: 200.milliseconds,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Get.theme == darkTheme
                              ? Colors.black.withOpacity(0.3)
                              : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/logo.png',
                            height: 100,
                          ),
                        ),
                      ),
                    ),
                  ),
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
                      kLog.wtf(lightTheme);
                      kLog.wtf(Get.isDarkMode);
                      kLog.wtf('${Get.theme == lightTheme}');
                      Get.theme == lightTheme
                          ? themeController?.animateTo(0.5)
                          : themeController?.animateTo(0);
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 40,
                left: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CustomAnimation<double>(
                      tween: 0.0.tweenTo(400.0),
                      duration: 900.milliseconds,
                      curve: Curves.easeInOut,
                      builder: (context, child, value2) {
                        return CustomAnimation<double>(
                          tween: 0.0.tweenTo(200.0),
                          control: _loginContainerAnimationController,
                          duration: 500.milliseconds,
                          curve: Curves.easeInOut,
                          builder: (context, child, value) {
                            return Column(
                              children: [
                                ClipRRect(
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
                                      height: value,
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
                                                  controller: _emailController,
                                                  label: 'Email',
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Flexible(
                                                child: FeelmTextField(
                                                  context: context,
                                                  isPassword: true,
                                                  controller:
                                                      _passwordController,
                                                  label: 'Password',
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Flexible(
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    // var user = FirebaseAuth
                                                    //     .instance.currentUser;
                                                    // if (user != null) {
                                                    //   await users
                                                    //       .where('email',
                                                    //           isEqualTo:
                                                    //               user.email)
                                                    //       .get()
                                                    //       .then((qs) {
                                                    //     kLog.wtf(qs.docs.first
                                                    //         .data());
                                                    //   }).catchError(
                                                    //     // ignore: return_of_invalid_type_from_catch_error
                                                    //     (error) => kLog.e(
                                                    //       error.toString(),
                                                    //     ),
                                                    //   );
                                                    // }

                                                    if (showLogin) {
                                                      try {
                                                        var user = await kAuth
                                                            .signInWithEmailAndPassword(
                                                                email:
                                                                    _emailController
                                                                        .text,
                                                                password:
                                                                    _passwordController
                                                                        .text);
                                                        kLog.wtf(
                                                            user.user?.uid);
                                                        await Get.offAll(() =>
                                                            MoviesScreen());
                                                      } on FirebaseAuthException catch (e) {
                                                        feelmSnackbar(
                                                          status.ERROR,
                                                          'Error',
                                                          e.message!,
                                                        );
                                                      }
                                                    } else {
                                                      try {
                                                        var sign =
                                                            await showPickerDate(
                                                                context);
                                                        if (sign.isNotEmpty) {
                                                          var userCredential = await kAuth
                                                              .createUserWithEmailAndPassword(
                                                                  email:
                                                                      _emailController
                                                                          .text,
                                                                  password:
                                                                      _passwordController
                                                                          .text);
                                                          createUser(
                                                            GuruUser(
                                                              email:
                                                                  userCredential
                                                                      .user!
                                                                      .email,
                                                              zodiacSign: sign,
                                                              joinDate: DateTime
                                                                  .now(),
                                                            ),
                                                          );
                                                          await Get.offAll(
                                                            () =>
                                                                MoviesScreen(),
                                                          );
                                                        } else {
                                                          feelmSnackbar(
                                                            status.INFO,
                                                            'Registration cancelled',
                                                            'You must choose your birthdate.',
                                                          );
                                                        }
                                                      } on FirebaseAuthException catch (e) {
                                                        feelmSnackbar(
                                                          status.ERROR,
                                                          'Error',
                                                          e.message!,
                                                        );
                                                      }
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .resolveWith(
                                                      (states) =>
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                      (states) => kColorMain,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    showLogin
                                                        ? 'Login'
                                                        : 'Register',
                                                    style: kStyleLight,
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(
                                                      () {
                                                        showLogin
                                                            ? showLogin =
                                                                !showLogin
                                                            : showLogin =
                                                                !showLogin;
                                                      },
                                                    );
                                                  },
                                                  child: Text(
                                                    showLogin
                                                        ? 'Register'
                                                        : 'Login',
                                                    style: kStyleLight.copyWith(
                                                      color: Theme.of(context)
                                                          .errorColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        //showPickerDate(context);
                                        setState(
                                          () {
                                            _loginContainerAnimationController ==
                                                    CustomAnimationControl.PLAY
                                                ? _loginContainerAnimationController =
                                                    CustomAnimationControl
                                                        .PLAY_REVERSE
                                                : _loginContainerAnimationController =
                                                    CustomAnimationControl.PLAY;
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Elusive.user,
                                        size: 35,
                                        color: kColorMain,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () async {
                                          var user = await signInWithFacebook();
                                          if (user != null) {
                                            if (await checkMail(
                                                user.user!.email)) {
                                              kLog.i(
                                                  '${user.user!.email} is not a user');
                                              var sign =
                                                  await showPickerDate(context);
                                              if (sign.isNotEmpty) {
                                                createUser(
                                                  GuruUser(
                                                    email: user.user!.email,
                                                    zodiacSign: sign,
                                                    joinDate: DateTime.now(),
                                                  ),
                                                );
                                                await Get.offAll(
                                                  () => MoviesScreen(),
                                                );
                                              } else {
                                                feelmSnackbar(
                                                  status.INFO,
                                                  'Registration cancelled',
                                                  'You must choose your birthdate.',
                                                );
                                              }
                                            }
                                          } else {
                                            feelmSnackbar(
                                              status.ERROR,
                                              'Cancelled',
                                              'Facebook login cancelled.',
                                            );
                                          }
                                        },
                                        child: Icon(
                                          Elusive.facebook,
                                          size: 35,
                                          color: '#087AEA'.toColor(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () async {
                                          var user = await googleSign();
                                          if (user != null) {
                                            if (await checkMail(
                                                user.user!.email)) {
                                              kLog.i(
                                                  '${user.user!.email} is not a user');
                                              var sign =
                                                  await showPickerDate(context);
                                              if (sign.isNotEmpty) {
                                                createUser(
                                                  GuruUser(
                                                    email: user.user!.email,
                                                    zodiacSign: sign,
                                                    joinDate: DateTime.now(),
                                                  ),
                                                );
                                                await Get.offAll(
                                                  () => MoviesScreen(),
                                                );
                                              } else {
                                                feelmSnackbar(
                                                  status.INFO,
                                                  'Registration cancelled',
                                                  'You must choose your birthdate.',
                                                );
                                              }
                                            } else {
                                              await Get.offAll(
                                                () => MoviesScreen(),
                                              );
                                            }
                                          } else {
                                            feelmSnackbar(
                                              status.INFO,
                                              'Cancelled',
                                              'Google login cancelled.',
                                            );
                                          }
                                        },
                                        child: Icon(
                                          Zocial.google,
                                          size: 35,
                                          color: '#EA4335'.toColor(),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
