import 'dart:math';
import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:extended_image/extended_image.dart';
import 'package:feelm/api/omdb.dart';
import 'package:feelm/api/tmdb.dart';
import 'package:feelm/constants.dart';
import 'package:feelm/models/imdb_movie.dart';
import 'package:feelm/models/movie.dart';
import 'package:feelm/pages/movie/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late var random = 0;

  final TextEditingController _searchController = TextEditingController();

  bool isLoading = false;

  bool tappedMovie = false;

  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    random = Random().nextInt(10);
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
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.9),
              ),
            ),
            Positioned(
              top: 45,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TypeAheadField(
                        debounceDuration: 500.milliseconds,
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _searchController,
                          focusNode: searchFocus
                            ..addListener(() {
                              if (!searchFocus.hasFocus && !tappedMovie) {
                                Get.back();
                              }
                            }),
                          autofocus: true,
                          style: kStyleLight.copyWith(
                            color: kColorMain,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 20,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(60),
                              borderSide: BorderSide(
                                color: kColorMain,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              borderSide: BorderSide(
                                color: kColorMain.withOpacity(0.2),
                                width: 3,
                              ),
                            ),
                            labelStyle: kStyleLight.copyWith(
                              color: kColorGrey,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          return searchMovies(pattern);
                        },
                        suggestionsBoxVerticalOffset: 0,
                        noItemsFoundBuilder: (context) => Container(
                          height: 40,
                          child: Center(
                            child: Text(
                              _searchController.text.isEmpty
                                  ? 'Αρχίστε να πληκτρολογείται για να αρχίσει η αναζήτηση...'
                                  : 'Δεν βρέθηκαν αποτελέσματα',
                              style: kStyleLight.copyWith(
                                fontWeight: FontWeight.bold,
                                color: kColorMain,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        itemBuilder: (context, Movie movie) {
                          return Container(
                            color: Colors.white,
                            width: 250,
                            height: 70,
                            child: ListTile(
                              tileColor: Colors.transparent,
                              selectedTileColor: Colors.transparent,
                              onTap: () async {
                                setState(() {
                                  isLoading = !isLoading;
                                  tappedMovie = !tappedMovie;
                                });
                                var videos = await getVideos(movie.id!);
                                var detailedMovie = await getMovies(movie.id!);
                                var imdbMovie = ImdbMovie();
                                if (detailedMovie.imdbId != null) {
                                  imdbMovie =
                                      await getImdbMovie(detailedMovie.imdbId!);
                                }

                                setState(() {
                                  isLoading = !isLoading;
                                });
                                await Get.off(
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
                                        if (state.extendedImageLoadState ==
                                            LoadState.loading) {
                                          return kSpinkit;
                                        }
                                      },
                                    )
                                  : ExtendedImage.network(
                                      baseImgUrl + movie.posterPath!,
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
                            ),
                          );
                        },
                        onSuggestionSelected: (movie) {
                          kLog.i('tapped');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
