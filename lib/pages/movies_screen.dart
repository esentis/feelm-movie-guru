import 'dart:math';
import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:extended_image/extended_image.dart';
import 'package:feelm/api/tmdb.dart';
import 'package:feelm/constants.dart';
import 'package:feelm/models/favorites.dart';
import 'package:feelm/models/keyword.dart';
import 'package:feelm/models/sign.dart';
import 'package:feelm/models/user.dart';
import 'package:feelm/pages/favorites_page.dart';
import 'package:feelm/pages/landing_page.dart';
import 'package:feelm/pages/movie_details_screen.dart';
import 'package:feelm/providers/signs_and_keywords.dart';
import 'package:feelm/widgets/feelm_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late var random;
  late List<Keyword> words;
  late List<ZodiacSign> signs;
  late GuruUser? currentGuruUser;
  late ZodiacSign usersSign;
  List<dynamic> recommendedMovies = ['', ''];
  List<Favorite> userFavorites = [];
  int page = 1;

  final ScrollController _movieScrollController = ScrollController();

  String concatKeywords = '';

  Future<void> checkUser({bool firstStart = false}) async {
    if (kAuth.currentUser == null) {
      await Get.to(() => const LandingPage());
    }
    if (firstStart) {
      signs = await getSigns();
      userFavorites = await getUserFavorites();
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

  Future checkIfFavorited() async {
    userFavorites = await getUserFavorites();
  }

  @override
  void initState() {
    random = Random().nextInt(10);
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
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          Positioned(
            top: 40,
            left: 25,
            child: GestureDetector(
              onTap: () async {
                await kAuth.signOut();
                await Get.offAll(
                  () => const LandingPage(),
                );
              },
              child: Icon(
                MfgLabs.logout,
                color: kColorMain,
                size: 35,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 25,
            child: GestureDetector(
              onTap: () async {
                await Get.to(
                  () => FavoritesScreen(
                    userFavorites: userFavorites,
                  ),
                );
              },
              child: Icon(
                MfgLabs.heart,
                color: kColorMain,
                size: 35,
              ),
            ),
          ),
          Positioned(
            top: 80,
            right: 0,
            left: 0,
            bottom: 0,
            child: Column(
              children: [
                Text(
                  'Total pages ${recommendedMovies[1]}',
                  style: kStyleLight.copyWith(
                    color: kColorMain,
                  ),
                ),
                Text(
                  'Current page $page',
                  style: kStyleLight.copyWith(
                    fontSize: 16,
                    color: kColorMain,
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
                          color: page == 1
                              ? kColorMain.withOpacity(0.5)
                              : kColorMain,
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
                          color: page == recommendedMovies[1]
                              ? kColorMain.withOpacity(0.5)
                              : kColorMain,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5,
                        sigmaY: 5,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: 'ffc93c'.toColor().withOpacity(0.2),
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
                              var videos = await getVideos(
                                  recommendedMovies[0][index].id!);
                              context.loaderOverlay.hide();
                              await Get.to(
                                () => MovieDetailsScreen(
                                  movie: recommendedMovies[0][index],
                                  videos: videos!,
                                ),
                              );
                            },
                            title: Text(
                              recommendedMovies[0][index].title!,
                              style: kStyleLight.copyWith(
                                fontWeight: FontWeight.bold,
                                color: kColorMain,
                                fontSize: 17,
                              ),
                            ),
                            subtitle: Text(
                              formatDate(
                                  recommendedMovies[0][index].releaseDate,
                                  [d, ' ', MM, ' ', yyyy]),
                              style: kStyleLight.copyWith(
                                fontWeight: FontWeight.bold,
                                color: kColorGrey,
                                fontSize: 13,
                              ),
                            ),
                            leading: recommendedMovies[0][index].posterPath ==
                                    null
                                ? ExtendedImage.network(
                                    'https://i.imgur.com/ajjPdCO.png',
                                    width: 40,
                                    height: 120,
                                    loadStateChanged: (state) {
                                      if (state.extendedImageLoadState ==
                                          LoadState.loading) {
                                        return kSpinkit;
                                      }
                                    },
                                  )
                                : ExtendedImage.network(
                                    baseImgUrl +
                                        recommendedMovies[0][index].posterPath!,
                                    borderRadius: BorderRadius.circular(8),
                                    width: 40,
                                    height: 120,
                                    shape: BoxShape.rectangle,
                                    loadStateChanged: (state) {
                                      if (state.extendedImageLoadState ==
                                          LoadState.loading) {
                                        return kSpinkit;
                                      }
                                    },
                                  ),
                            trailing: IconButton(
                              onPressed: () async {
                                await toggleFavorite(
                                  Favorite(
                                    email: kAuth.currentUser!.email!,
                                    movieId: recommendedMovies[0][index].id,
                                  ),
                                );
                                await checkIfFavorited();
                                setState(() {});
                              },
                              icon: Icon(
                                MfgLabs.heart,
                                color: userFavorites.any((fav) =>
                                        fav.movieId ==
                                        recommendedMovies[0][index].id)
                                    ? Colors.red
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
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
