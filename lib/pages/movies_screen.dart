import 'dart:math';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:extended_image/extended_image.dart';
import 'package:feelm/api/omdb.dart';
import 'package:feelm/api/tmdb.dart';
import 'package:feelm/constants.dart';
import 'package:feelm/models/favorites.dart';
import 'package:feelm/models/keyword.dart';
import 'package:feelm/models/movie.dart';
import 'package:feelm/models/sign.dart';
import 'package:feelm/models/user.dart';
import 'package:feelm/pages/favorites_page.dart';
import 'package:feelm/pages/landing_page.dart';
import 'package:feelm/pages/movie/movie_details_screen.dart';
import 'package:feelm/pages/search_page.dart';
import 'package:feelm/providers/signs_and_keywords.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:fluttericon/mfg_labs_icons.dart';

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
  int page = 1;

  bool isLoading = false;

  static const _pageSize = 20;

  final PagingController<int, Movie> _pagingController =
      PagingController(firstPageKey: 1);

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
      // feelmSnackbar(status.SUCCESS, 'Welcome back', kAuth.currentUser!.email!);
      setState(() {});
    } else {
      recommendedMovies = [];
      recommendedMovies = await discoverMovies(concatKeywords, page: page);
      setState(() {});
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // ignore: omit_local_variable_types
      List<Movie> newItems = await discoverMovies(concatKeywords, page: page);
      var isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        kLog.w('Got to last page !');
        _pagingController.appendLastPage(newItems);
      } else {
        var nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
        page++;
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    random = Random().nextInt(10);
    // ignore: unnecessary_lambdas
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await checkUser(firstStart: true);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: getUserFavoritesStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return kSpinkit;
          }
          // ignore: omit_local_variable_types
          List<Favorite> favs = [];
          snapshot.data!.docs.forEach(
            (qsDocument) {
              favs.add(Favorite.fromMap(qsDocument.data()!));
            },
          );
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
                  right: 75,
                  child: OpenContainer(
                    transitionType: ContainerTransitionType.fadeThrough,
                    openBuilder: (BuildContext context, VoidCallback _) {
                      return SearchPage();
                    },
                    closedElevation: 6.0,
                    closedColor: Colors.transparent,
                    closedBuilder:
                        (BuildContext context, VoidCallback openContainer) {
                      return Icon(
                        MfgLabs.search,
                        color: kColorMain.withOpacity(0.5),
                        size: 35,
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 25,
                  child: GestureDetector(
                    onTap: () async {
                      await Get.to(
                        () => FavoritesScreen(
                          userFavorites: favs,
                        ),
                      );
                    },
                    child: const Icon(
                      MfgLabs.heart,
                      color: Colors.red,
                      size: 35,
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 125,
                  left: 125,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5,
                        sigmaY: 5,
                      ),
                      child: AnimatedOpacity(
                        opacity: MediaQuery.of(context).viewInsets.bottom == 0
                            ? 1
                            : 0,
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
                                height: 50,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 120,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      Flexible(
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
                              child: PagedListView<int, Movie>(
                                pagingController: _pagingController,
                                builderDelegate:
                                    PagedChildBuilderDelegate<Movie>(
                                  newPageProgressIndicatorBuilder: (context) =>
                                      kSpinkit,
                                  firstPageProgressIndicatorBuilder:
                                      (context) => kSpinkit,
                                  itemBuilder: (context, movie, index) =>
                                      StatefulBuilder(
                                    builder: (context, stateSetter) {
                                      return Container(
                                        width: 250,
                                        height: 70,
                                        child: ModalProgressHUD(
                                          inAsyncCall: isLoading,
                                          progressIndicator: kSpinkit,
                                          child: ListTile(
                                            onTap: () async {
                                              stateSetter(() {
                                                isLoading = !isLoading;
                                              });
                                              var videos =
                                                  await getVideos(movie.id!);
                                              var detailedMovie =
                                                  await getMovies(movie.id!);
                                              var imdbMovie =
                                                  await getImdbMovie(
                                                      detailedMovie.imdbId!);
                                              stateSetter(() {
                                                isLoading = !isLoading;
                                              });
                                              await Get.to(
                                                () => MovieDetailsScreen(
                                                  movie: detailedMovie,
                                                  imdbMovie: imdbMovie,
                                                  videos: videos!,
                                                ),
                                              );
                                            },
                                            title: Text(
                                              movie.title!,
                                              style: kStyleLight.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: kColorMain,
                                                fontSize: 17,
                                              ),
                                            ),
                                            subtitle: Text(
                                              formatDate(movie.releaseDate!,
                                                  [d, ' ', MM, ' ', yyyy]),
                                              style: kStyleLight.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: kColorGrey,
                                                fontSize: 13,
                                              ),
                                            ),
                                            leading: movie.posterPath == null
                                                ? ExtendedImage.network(
                                                    'https://i.imgur.com/ajjPdCO.png',
                                                    width: 40,
                                                    height: 120,
                                                    loadStateChanged: (state) {
                                                      if (state
                                                              .extendedImageLoadState ==
                                                          LoadState.loading) {
                                                        return kSpinkit;
                                                      }
                                                    },
                                                  )
                                                : ExtendedImage.network(
                                                    baseImgUrl +
                                                        movie.posterPath!,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    width: 40,
                                                    height: 120,
                                                    shape: BoxShape.rectangle,
                                                    loadStateChanged: (state) {
                                                      if (state
                                                              .extendedImageLoadState ==
                                                          LoadState.loading) {
                                                        return kSpinkit;
                                                      }
                                                    },
                                                  ),
                                            trailing: IconButton(
                                              onPressed: () async {
                                                await toggleFavorite(
                                                  Favorite(
                                                    email: kAuth
                                                        .currentUser!.email!,
                                                    movieId: movie.id!,
                                                  ),
                                                );
                                              },
                                              icon: Icon(
                                                MfgLabs.heart,
                                                color: favs.any((fav) =>
                                                        fav.movieId == movie.id)
                                                    ? Colors.red
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
