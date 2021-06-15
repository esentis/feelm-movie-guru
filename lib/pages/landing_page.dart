import 'dart:math';
import 'dart:ui';

import 'package:feelm/constants.dart';
import 'package:feelm/models/user.dart';
import 'package:feelm/pages/movie/widgets/custom_picker.dart';
import 'package:feelm/pages/movies_screen.dart';
import 'package:feelm/pages/test_page.dart';
import 'package:feelm/widgets/feelm_snackbar.dart';
import 'package:feelm/widgets/feelm_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/zocial_icons.dart';
import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

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
    await CustomPicker(
      height: 150,
      hideHeader: true,
      headerColor: Colors.red,
      backgroundColor: Colors.black,
      adapter: DateTimePickerAdapter(
        yearBegin: 1940,
        yearEnd: 2002,
      ),
      title: Text(
        'Birthdate',
        style: kStyleLight.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: kColorMain,
        ),
      ),
      textStyle: kStyleLight.copyWith(
        color: kColorMain,
        fontSize: 20,
      ),
      magnification: 1.3,
      cancelTextStyle: kStyleLight.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.red,
      ),
      confirmTextStyle: kStyleLight.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: kColorMain,
      ),
      selectedTextStyle: kStyleLight.copyWith(
        fontWeight: FontWeight.bold,
        color: kColorMain,
        fontSize: 20,
      ),
      onConfirm: (CustomPicker picker, List value) {
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
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          Stack(
            children: [
              Positioned(
                top: 75,
                left: 70,
                right: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
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
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Hero(
                            tag: 'logo',
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
                                        color:
                                            'ffc93c'.toColor().withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(
                                          12,
                                        ),
                                      ),
                                      width: value * 1.5,
                                      height: value * 1.3,
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
                                                        var guruUser =
                                                            await getGuruUser(
                                                                user.user!
                                                                    .email!);
                                                        kLog.wtf(
                                                            guruUser!.tested);
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
                                                        if (_emailController
                                                                .text
                                                                .isNotEmpty &&
                                                            _passwordController
                                                                .text
                                                                .isNotEmpty) {
                                                          var sign =
                                                              await showPickerDate(
                                                                  context);
                                                          if (sign.isNotEmpty) {
                                                            var userCredential =
                                                                await kAuth.createUserWithEmailAndPassword(
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
                                                                zodiacSign:
                                                                    sign,
                                                                joinDate:
                                                                    DateTime
                                                                        .now(),
                                                              ),
                                                            );
                                                            await Get.offAll(
                                                              () => TestPage(
                                                                user: GuruUser(
                                                                  email:
                                                                      userCredential
                                                                          .user!
                                                                          .email,
                                                                  zodiacSign:
                                                                      sign,
                                                                  joinDate:
                                                                      DateTime
                                                                          .now(),
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            feelmSnackbar(
                                                              status.INFO,
                                                              'Registration cancelled',
                                                              'You must choose your birthdate.',
                                                            );
                                                          }
                                                        } else {
                                                          feelmSnackbar(
                                                            status.ERROR,
                                                            'Error',
                                                            'Τα πεδία του email και του κωδικού δε πρέπει να είναι κενά !',
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
                                                      color: kColorGrey,
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
                                                  () => TestPage(
                                                    user: GuruUser(
                                                      email: user.user!.email,
                                                      zodiacSign: sign,
                                                      joinDate: DateTime.now(),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                feelmSnackbar(
                                                  status.INFO,
                                                  'Registration cancelled',
                                                  'You must choose your birthdate.',
                                                );
                                              }
                                            } else {
                                              var guruUser = await getGuruUser(
                                                  user.user!.email!);
                                              if (!guruUser!.tested!) {
                                                await Get.offAll(
                                                  () => TestPage(
                                                    user: guruUser,
                                                  ),
                                                );
                                              } else {
                                                await Get.offAll(
                                                  () => MoviesScreen(),
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
                                                  () => TestPage(
                                                    user: GuruUser(
                                                      email: user.user!.email,
                                                      zodiacSign: sign,
                                                      joinDate: DateTime.now(),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                feelmSnackbar(
                                                  status.INFO,
                                                  'Registration cancelled',
                                                  'You must choose your birthdate.',
                                                );
                                              }
                                            } else {
                                              var guruUser = await getGuruUser(
                                                  user.user!.email!);
                                              kLog.wtf(guruUser!.tested);
                                              if (!guruUser.tested!) {
                                                await Get.to(
                                                  () => TestPage(
                                                    user: guruUser,
                                                  ),
                                                );
                                              } else {
                                                await Get.offAll(
                                                  () => MoviesScreen(),
                                                );
                                              }
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
