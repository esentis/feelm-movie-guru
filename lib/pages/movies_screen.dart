import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:feelm/api/tmdb.dart';
import 'package:feelm/constants.dart';
import 'package:feelm/models/keyword.dart';
import 'package:feelm/models/sign.dart';
import 'package:feelm/models/user.dart';
import 'package:feelm/pages/landing_page.dart';
import 'package:feelm/pages/movie_details_screen.dart';
import 'package:feelm/providers/signs_and_keywords.dart';
import 'package:feelm/theme_config.dart';
import 'package:feelm/widgets/feelm_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? themeController;

  late var random;
  late List<Keyword> words;
  late List<ZodiacSign> signs;
  late GuruUser? currentGuruUser;
  late ZodiacSign usersSign;
  List<dynamic> recommendedMovies = ['', ''];
  int page = 1;

  final ScrollController _movieScrollController = ScrollController();

  String concatKeywords = '';

  Future<void> checkUser({bool firstStart = false}) async {
    if (kAuth.currentUser == null) {
      await Get.to(() => const LandingPage());
    }
    if (firstStart) {
      signs = await getSigns();
      currentGuruUser = await getGuruUser(kAuth.currentUser!.email!);
      usersSign = signs
          .firstWhere((element) => element.name == currentGuruUser?.zodiacSign);

      var keywordIds = List.generate(
        usersSign.keywords.length,
        (index) => usersSign.keywords[index].id.toString(),
      );
      concatKeywords = keywordIds.join('|');
      recommendedMovies = await discoverMovies(concatKeywords, page: page);
      feelmSnackbar(status.SUCCESS, 'Welcome back', kAuth.currentUser!.email!);
      setState(() {});
    } else {
      recommendedMovies = [];
      recommendedMovies = await discoverMovies(concatKeywords, page: page);
      setState(() {});
    }
  }

  @override
  void initState() {
    random = Random().nextInt(10);
    themeController = AnimationController(
      vsync: this,
      duration: 900.milliseconds,
    );

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await checkUser(firstStart: true);
    });
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
              color: Get.theme.brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.8)
                  : Colors.white.withOpacity(0.8),
            ),
          ),
          Positioned(
            top: 25,
            right: 0,
            child: GestureDetector(
              onTap: () {
                kLog.wtf(Get.theme.brightness);
                if (Get.theme.brightness == Brightness.dark) {
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
                  Get.theme.brightness == Brightness.light
                      ? themeController?.animateTo(0.5)
                      : themeController?.animateTo(0);
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
                    providers: kProviders,
                    child: const LandingPage(),
                  ),
                );
              },
              child: const Icon(MfgLabs.logout),
            ),
          ),
          Positioned(
            top: 80,
            right: 10,
            left: 10,
            bottom: 0,
            child: Column(
              children: [
                Text(
                  'Total pages ${recommendedMovies[1]}',
                  style: kStyleLight,
                ),
                Text(
                  'Current page $page',
                  style: kStyleLight.copyWith(
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: page <= 1
                          ? null
                          : () async {
                              kLog.wtf('Getting next page results');
                              page--;
                              await _movieScrollController.animateTo(0,
                                  duration: 500.milliseconds,
                                  curve: Curves.easeIn);
                              await checkUser();
                            },
                      child: Text(
                        'Previous',
                        style: kStyleLight.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        page++;
                        await _movieScrollController.animateTo(0,
                            duration: 500.milliseconds, curve: Curves.easeIn);
                        await checkUser();
                      },
                      child: Text(
                        'Next',
                        style: kStyleLight.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Get.theme.brightness == Brightness.light
                          ? Colors.white
                          : Colors.black,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    child: ListView.builder(
                      controller: _movieScrollController,
                      itemCount: recommendedMovies[0].length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () async {
                          context.loaderOverlay.show();
                          var videos =
                              await getVideos(recommendedMovies[0][index].id!);
                          await Get.to(
                            () => MovieDetailsScreen(
                              movie: recommendedMovies[0][index],
                              videos: videos!,
                            ),
                          );
                          context.loaderOverlay.hide();
                        },
                        title: Text(
                          recommendedMovies[0][index].title!,
                          style: kStyleLight.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        subtitle: Text(
                          formatDate(recommendedMovies[0][index].releaseDate,
                              [d, ' ', MM, ' ', yyyy]),
                          style: kStyleLight.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        leading: recommendedMovies[0][index].posterPath == null
                            ? Image.network(
                                'https://i.imgur.com/ajjPdCO.png',
                                width: 40,
                                height: 120,
                              )
                            : Image.network(baseImgUrl +
                                recommendedMovies[0][index].posterPath!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
