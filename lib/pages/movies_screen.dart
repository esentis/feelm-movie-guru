import 'dart:math';

import 'package:feelm/api/tmdb.dart';
import 'package:feelm/constants.dart';
import 'package:feelm/models/keyword.dart';
import 'package:feelm/models/movie.dart';
import 'package:feelm/models/sign.dart';
import 'package:feelm/models/user.dart';
import 'package:feelm/pages/landing_page.dart';
import 'package:feelm/providers/signs_and_keywords.dart';
import 'package:feelm/theme_config.dart';
import 'package:feelm/widgets/feelm_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/iconic_icons.dart';
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
  late List<Keyword> words;
  late List<ZodiacSign> signs;
  late GuruUser? currentGuruUser;
  late ZodiacSign usersSign;
  List<Movie> recommendedMovies = [];
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
      kLog.wtf('User\s zodiac sign is ${currentGuruUser?.zodiacSign}');
      usersSign = signs
          .firstWhere((element) => element.name == currentGuruUser?.zodiacSign);
      kLog.wtf('Final sign is ${usersSign.name}');

      var keywordIds = List.generate(
        usersSign.keywords.length,
        (index) => usersSign.keywords[index].id.toString(),
      );

      kLog.wtf(
        List.generate(usersSign.keywords.length,
            (index) => usersSign.keywords[index].name),
      );

      concatKeywords = keywordIds.join('|');
      kLog.wtf(concatKeywords);
      recommendedMovies = await discoverMovies(concatKeywords, page: page);
      kLog.wtf(
        List.generate(recommendedMovies.length,
            (index) => recommendedMovies[index].title),
      );
      feelmSnackbar(status.SUCCESS, 'Welcome back', kAuth.currentUser!.email!);
      setState(() {});
    } else {
      recommendedMovies = [];
      kLog.wtf('Looking for $concatKeywords at page $page');
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
                  Get.theme == lightTheme
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
                IconButton(
                    onPressed: () async {
                      kLog.wtf('Getting next page results');
                      page++;
                      await _movieScrollController.animateTo(0,
                          duration: 500.milliseconds, curve: Curves.easeIn);
                      await checkUser();
                    },
                    icon: Icon(Iconic.ok)),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        )),
                    child: ListView.builder(
                      controller: _movieScrollController,
                      itemCount: recommendedMovies.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          recommendedMovies[index].title!,
                          style: kStyleLight.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        subtitle: Text(
                          '${recommendedMovies[index].releaseDate!.day}-${recommendedMovies[index].releaseDate!.month}-${recommendedMovies[index].releaseDate!.year}',
                          style: kStyleLight.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        leading: recommendedMovies[index].posterPath == null
                            ? Image.network(
                                'https://i.imgur.com/ajjPdCO.png',
                                width: 40,
                                height: 120,
                              )
                            : Image.network(baseImgUrl +
                                recommendedMovies[index].posterPath!),
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
