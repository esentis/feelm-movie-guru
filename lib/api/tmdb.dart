import 'package:dio/dio.dart';
import 'package:feelm/constants.dart';
import 'package:feelm/models/keyword.dart';
import 'package:feelm/models/movie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

BaseOptions dioTmdbOptions = BaseOptions(
  baseUrl: 'https://api.themoviedb.org',
  receiveDataWhenStatusError: true,
  connectTimeout: 6 * 1000, // 6 seconds
  receiveTimeout: 6 * 1000, // 6 seconds
);
Dio tmdb = Dio(dioTmdbOptions);

/// Returns movies based on a search [term].
Future getTrending() async {
  Response response;
  try {
    response = await tmdb.get(
      '/3/trending/movie/day',
      queryParameters: {
        'api_key': env['TMDB_KEY'],
      },
    );
    kLog.i('Getting trending movies.');
  } on DioError catch (e) {
    kLog.e(e);
    return e.type;
  }
  // ignore: omit_local_variable_types
  List<Movie> trendingMovies = [];
  response.data['results'].forEach((jsonMovie) {
    trendingMovies.add(Movie.fromMap(jsonMovie));
  });
  return trendingMovies;
}

/// Returns movies based on a search [term].
Future searchMovies(String term) async {
  Response response;
  try {
    response = await tmdb.get(
      '/3/search/movie',
      queryParameters: {
        'api_key': env['TMDB_KEY'],
        'language': 'en-US',
        'include_adult': false,
        'page': 1,
        'query': term,
      },
    );
    kLog.i('Searching $term in movies.');
  } on DioError catch (e) {
    kLog.e(e);
    return e.type;
  }
  // ignore: omit_local_variable_types
  MovieSearchResults searchResults = MovieSearchResults.fromMap(response.data);

  return searchResults;
}

/// Returns movies based on [id].
Future<MovieDetailed> getMovies(int id) async {
  Response response;
  try {
    response = await tmdb.get(
      '/3/movie/$id',
      queryParameters: {
        'api_key': env['TMDB_KEY'],
        'language': 'el-GR',
      },
    );
  } on DioError catch (e) {
    kLog.e(e);
    return Future.value(null);
  }
  // ignore: omit_local_variable_types
  MovieDetailed detailedMovie = MovieDetailed.fromMap(response.data);
  return detailedMovie;
}

/// Returns the cast and crew for a movie with [id].
Future getCredits(int id) async {
  Response response;
  try {
    response = await tmdb.get(
      '/3/movie/$id/credits',
      queryParameters: {
        'api_key': env['TMDB_KEY'],
      },
    );
    kLog.i('Getting credings for movie with ID : $id.');
  } on DioError catch (e) {
    kLog.e(e);
    return e.type;
  }
  // ignore: omit_local_variable_types
  MovieCredits movieCredits = MovieCredits.fromMap(response.data);
  return movieCredits;
}

/// Returns the upcoming movies.
Future getUpcoming() async {
  Response response;
  try {
    response = await tmdb.get(
      '/3/movie/upcoming',
      queryParameters: {
        'api_key': env['TMDB_KEY'],
        'language': 'en-US',
        'include_adult': false,
        'page': 1,
      },
    );
    kLog.i('Getting upcoming movies');
  } on DioError catch (e) {
    kLog.e(e);
    return e.type;
  }
  // ignore: omit_local_variable_types
  List<Movie> upcomingMovies = [];
  response.data['results'].forEach((jsonMovie) {
    upcomingMovies.add(Movie.fromMap(jsonMovie));
  });
  return upcomingMovies;
}

/// Search for movie keywords associated with a specific [term].
Future<KeywordResults> getKeywords(String term) async {
  try {
    var response = await tmdb.get(
      '/3/search/keyword',
      queryParameters: {
        'api_key': env['TMDB_KEY'],
        'query': term,
      },
    );

    return KeywordResults.fromJson(response.data);
  } on DioError catch (e) {
    kLog.e(e.message);
    return KeywordResults.error();
  }
}

/// Discover movies with [keywords]. [keywords] is a string with concatinated Keyword ids.
///
/// Keyword ids can be created by searching keywords with:
/// ```dart
/// getKeywords(String term)
/// ```
/// which returns a list of keywords used by movies.
Future<List<dynamic>> discoverMovies(String keywords, {int page = 1}) async {
  try {
    var response = await tmdb.get(
      '/3/discover/movie',
      queryParameters: {
        'api_key': env['TMDB_KEY'],
        'with_keywords': keywords,
        'page': page,
        'language': 'el-GR',
      },
    );
    var discoveredMovies = <Movie>[];
    response.data['results'].forEach(
      (jsonMovie) {
        discoveredMovies.add(Movie.fromMap(jsonMovie));
      },
    );
    return List<dynamic>.generate(
        2,
        (index) =>
            index == 0 ? discoveredMovies : response.data['total_pages']);
  } on DioError catch (e) {
    kLog.e(e.message);
    return [];
  }
}

/// Discover movies with [keywords]. [keywords] is a string with concatinated Keyword ids.
///
/// Keyword ids can be created by searching keywords with:
/// ```dart
/// getKeywords(String term)
/// ```
/// which returns a list of keywords used by movies.
Future<MovieVideos?> getVideos(int id) async {
  try {
    var response = await tmdb.get(
      '/3/movie/$id/videos',
      queryParameters: {
        'api_key': env['TMDB_KEY'],
        'language': 'el-GR',
      },
    );

    return MovieVideos.fromJson(response.data);
  } on DioError catch (e) {
    kLog.e(e.message);
    return null;
  }
}
