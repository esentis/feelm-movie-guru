import 'dart:math';
import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:extended_image/extended_image.dart';
import 'package:feelm/api/omdb.dart';
import 'package:feelm/api/tmdb.dart';
import 'package:feelm/constants.dart';
import 'package:feelm/models/favorites.dart';
import 'package:feelm/models/movie.dart';
import 'package:feelm/pages/movie/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:fluttericon/mfg_labs_icons.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Favorite> userFavorites;
  const FavoritesScreen({
    required this.userFavorites,
  });
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late var random;

  int page = 1;

  bool isLoading = true;

  final ScrollController _movieScrollController = ScrollController();

  String concatKeywords = '';

  List<MovieDetailed> favoritedMovies = [];

  Future<void> getFavoriteMovies() async {
    if (favoritedMovies.isNotEmpty) {
      favoritedMovies = [];
    }

    for (var fav in widget.userFavorites) {
      var detailedMovie = await getMovies(fav.movieId);
      favoritedMovies.add(detailedMovie);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    random = Random().nextInt(10);

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await getFavoriteMovies();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: kSpinkit,
      child: Scaffold(
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
                  Get.back();
                },
                child: Icon(
                  MfgLabs.left_fat,
                  color: kColorMain,
                  size: 35,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 25,
              child: GestureDetector(
                onTap: () async {},
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
                    'Total favorited movies ${widget.userFavorites.length}',
                    style: kStyleLight.copyWith(
                      color: kColorMain,
                    ),
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
                            itemCount: favoritedMovies.length,
                            itemBuilder: (context, index) => ListTile(
                              onTap: () async {
                                setState(() {
                                  isLoading = !isLoading;
                                });
                                var videos =
                                    await getVideos(favoritedMovies[index].id!);
                                var imdbMovie = await getImdbMovie(
                                    favoritedMovies[index].imdbId!);
                                setState(() {
                                  isLoading = !isLoading;
                                });
                                await Get.to(
                                  () => MovieDetailsScreen(
                                    movie: favoritedMovies[index],
                                    imdbMovie: imdbMovie,
                                    videos: videos!,
                                  ),
                                );
                              },
                              title: Text(
                                favoritedMovies[index].title!,
                                style: kStyleLight.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: kColorMain,
                                  fontSize: 17,
                                ),
                              ),
                              subtitle: Text(
                                formatDate(favoritedMovies[index].releaseDate!,
                                    [d, ' ', MM, ' ', yyyy]),
                                style: kStyleLight.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: kColorGrey,
                                  fontSize: 13,
                                ),
                              ),
                              leading: favoritedMovies[index].posterPath == null
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
                                          favoritedMovies[index].posterPath!,
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
                                      movieId: favoritedMovies[index].id!,
                                    ),
                                  );

                                  setState(() {
                                    favoritedMovies.remove(
                                        favoritedMovies.firstWhere((movie) =>
                                            movie.id ==
                                            favoritedMovies[index].id));
                                  });
                                },
                                icon: const Icon(
                                  MfgLabs.heart,
                                  color: Colors.red,
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
      ),
    );
  }
}
