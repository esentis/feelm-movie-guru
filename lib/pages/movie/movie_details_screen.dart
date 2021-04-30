import 'package:date_format/date_format.dart';
import 'package:extended_image/extended_image.dart';
import 'package:feelm/api/tmdb.dart';
import 'package:feelm/constants.dart';
import 'package:feelm/models/imdb_movie.dart';
import 'package:feelm/models/movie.dart';
import 'package:feelm/pages/movie/widgets/info_container.dart';
import 'package:feelm/widgets/esentis_icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:supercharged/supercharged.dart';

class MovieDetailsScreen extends StatefulWidget {
  final MovieDetailed movie;
  final ImdbMovie imdbMovie;
  final MovieVideos videos;
  const MovieDetailsScreen({
    required this.movie,
    required this.videos,
    required this.imdbMovie,
  });
  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late YoutubePlayerController _controller;
  Future<String?> movieVideos() async {
    var x = await getVideos(widget.movie.id!);
    kLog.wtf(x?.results.first.key);
    return x?.results.first.key;
  }

  @override
  void initState() {
    if (widget.videos.results.isNotEmpty) {
      _controller = YoutubePlayerController(
        initialVideoId: widget.videos.results.first.key,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
        ),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            shadowColor: kColorMain.withOpacity(0.5),
            elevation: 10,
            floating: true,
            pinned: false,
            toolbarHeight: 250,
            expandedHeight: 450,
            leading: IconButton(
              onPressed: Get.back,
              icon: Icon(
                MfgLabs.left_fat,
                color: kColorMain,
                size: 35,
              ),
            ),
            actions: [
              IconButton(
                // ${baseImgUrl + widget.movie.posterPath!}
                onPressed: () async {
                  await Share.share(
                    widget.movie.overview!.isEmpty
                        ? 'Ημ/νια κυκλοφορίας : \n${formatDate(widget.movie.releaseDate!, [
                            d,
                            ' ',
                            MM,
                            ' ',
                            yyyy
                          ])}\n\n${widget.imdbMovie.plot!}\n${baseImgUrl + widget.movie.posterPath!}'
                        : '${widget.movie.overview!} ${baseImgUrl + widget.movie.posterPath!}',
                    subject: widget.movie.title!,
                  );
                },
                icon: Icon(
                  MfgLabs.link,
                  color: kColorMain,
                  size: 35,
                ),
              )
            ],
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: widget.movie.posterPath == null
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
                          baseImgUrl + widget.movie.posterPath!,
                          cache: true,
                          fit: BoxFit.cover,
                          enableLoadState: true,
                          // ignore: missing_return
                          loadStateChanged: (state) {
                            if (state.extendedImageLoadState ==
                                LoadState.loading) {
                              return kSpinkit;
                            }
                          },
                        ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  right: 0,
                  left: 0,
                  child: Column(
                    children: [
                      Text(
                        widget.movie.title!,
                        style: kStyleLight.copyWith(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                          color: 'ffc93c'.toColor(),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      widget.movie.title != widget.movie.originalTitle
                          ? Text(
                              widget.movie.originalTitle!,
                              style: kStyleLight.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: 'ffc93c'.toColor(),
                              ),
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InfoContainer(
                              icon: FontAwesome5.imdb,
                              iconSize: 55,
                              iconColor: kColorMain,
                              text: '${widget.imdbMovie.imdbRating!}/10',
                              subtitleText: widget.imdbMovie.imdbVotes!,
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            InfoContainer(
                              icon: CustomIcons.tmdb,
                              iconSize: 43,
                              iconColor: '#2ABBD1'.toColor(),
                              text: '${widget.movie.voteAverage}/10',
                              subtitleText: widget.movie.voteCount
                                  .toString()
                                  .replaceAllMapped(
                                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                      (Match m) => '${m[1]},'),
                              space: 25,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        widget.imdbMovie.runtime!,
                        style: kStyleLight.copyWith(
                          fontSize: 18,
                          color: kColorMain,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        widget.imdbMovie.genre!,
                        style: kStyleLight.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kColorGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        formatDate(
                            widget.movie.releaseDate!, [d, ' ', MM, ' ', yyyy]),
                        style: kStyleLight.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kColorGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        // ignore: unnecessary_string_interpolations
                        widget.movie.overview!.isEmpty
                            ? widget.imdbMovie.plot!
                            : widget.movie.overview!,
                        style: kStyleLight.copyWith(
                          color: kColorGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Movie's Box Office information if present
                    if (widget.imdbMovie.boxOffice != 'N/A')
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Box Office',
                              style: kStyleLight.copyWith(
                                fontSize: 16,
                                color: kColorMain,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.imdbMovie.boxOffice!,
                              style: kStyleLight.copyWith(
                                color: kColorGrey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    // Movie's original poster
                    if (widget.imdbMovie.poster != 'N/A')
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Original poster',
                              style: kStyleLight.copyWith(
                                fontSize: 16,
                                color: kColorMain,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            ExtendedImage.network(
                              widget.imdbMovie.poster!,
                              loadStateChanged: (state) {
                                if (state.extendedImageLoadState ==
                                    LoadState.loading) {
                                  return kSpinkit;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    // Movie's production countries
                    if (widget.imdbMovie.country != 'N/A')
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Χώρα παραγωγής',
                              style: kStyleLight.copyWith(
                                fontSize: 16,
                                color: kColorMain,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.imdbMovie.country!,
                              style: kStyleLight.copyWith(
                                color: kColorGrey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                    // All movie Awards if any
                    if (widget.imdbMovie.awards != 'N/A')
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Βραβεία',
                              style: kStyleLight.copyWith(
                                fontSize: 16,
                                color: kColorMain,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.imdbMovie.awards!,
                              style: kStyleLight.copyWith(
                                color: kColorGrey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    // Trailer if provided from API
                    if (widget.videos.results.isNotEmpty)
                      YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                      ),
                    // Movie's directors
                    if (widget.imdbMovie.director != 'N/A')
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Σκηνοθέτες',
                              style: kStyleLight.copyWith(
                                fontSize: 16,
                                color: kColorMain,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.imdbMovie.director!,
                              style: kStyleLight.copyWith(
                                color: kColorGrey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    // Actors
                    if (widget.imdbMovie.actors != 'N/A')
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Ηθοποιοί',
                              style: kStyleLight.copyWith(
                                fontSize: 16,
                                color: kColorMain,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.imdbMovie.actors!,
                              style: kStyleLight.copyWith(
                                color: kColorGrey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
