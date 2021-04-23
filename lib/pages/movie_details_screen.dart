import 'package:date_format/date_format.dart';
import 'package:extended_image/extended_image.dart';
import 'package:feelm/api/tmdb.dart';
import 'package:feelm/constants.dart';
import 'package:feelm/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;
  final MovieVideos videos;
  const MovieDetailsScreen({
    required this.movie,
    required this.videos,
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
      backgroundColor:
          Get.theme.brightness == Brightness.dark ? Colors.black : Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.blue,
            toolbarHeight: 250,
            expandedHeight: 450,
            pinned: false,
            floating: true,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: ExtendedImage.network(
                    baseImgUrl + widget.movie.posterPath!,
                    cache: true,
                    fit: BoxFit.cover,
                    enableLoadState: true,
                    // ignore: missing_return
                    loadStateChanged: (state) {
                      if (state.extendedImageLoadState == LoadState.loading) {
                        return kSpinkit;
                      }
                    },
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Get.theme.brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
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
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      widget.movie.title != widget.movie.originalTitle
                          ? Text(
                              widget.movie.originalTitle!,
                              style: kStyleLight.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox(),
                      Text(
                        formatDate(
                            widget.movie.releaseDate!, [d, ' ', MM, ' ', yyyy]),
                        style: kStyleLight.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
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
                        widget.movie.overview!,
                        style: kStyleLight.copyWith(
                          color: Get.theme.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (widget.videos.results.isNotEmpty)
                      YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
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
