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
Future<List<Movie>?> getTrending() async {
  Response<dynamic> response;
  try {
    response = await tmdb.get(
      '/3/trending/movie/day',
      queryParameters: {
        'api_key': dotenv.env['TMDB_KEY'],
      },
    );
    kLog.i('Getting trending movies.');
  } on DioError catch (e) {
    kLog.e(e);
    return null;
  }
  // ignore: omit_local_variable_types
  final List<Movie> trendingMovies = [];
  response.data['results'].forEach((jsonMovie) {
    trendingMovies.add(Movie.fromMap(jsonMovie));
  });
  return trendingMovies;
}

/// Returns movies based on a search [term].
Future<List<Movie>> searchMovies(String term) async {
  if (term.isEmpty) {
    return [];
  }
  Response<dynamic> response;
  try {
    response = await tmdb.get(
      '/3/search/movie',
      queryParameters: {
        'api_key': dotenv.env['TMDB_KEY'],
        'language': 'el-GR',
        'include_adult': false,
        'page': 1,
        'query': term,
      },
    );
    kLog.i('Searching $term in movies.');
  } on DioError catch (e) {
    kLog.e(e);
    return [];
  }
  // ignore: omit_local_variable_types
  final MovieSearchResults searchResults =
      MovieSearchResults.fromMap(response.data);

  return searchResults.results!;
}

/// Returns movies based on [id].
Future<MovieDetailed> getMovies(int id) async {
  Response<dynamic> response;
  try {
    response = await tmdb.get(
      '/3/movie/$id',
      queryParameters: {
        'api_key': dotenv.env['TMDB_KEY'],
        'language': 'el-GR',
      },
    );
  } on DioError catch (e) {
    kLog.e(e);
    return Future.value(null);
  }
  // ignore: omit_local_variable_types
  final MovieDetailed detailedMovie = MovieDetailed.fromMap(response.data);
  return detailedMovie;
}

/// Returns the cast and crew for a movie with [id].
Future<MovieCredits?> getCredits(int id) async {
  Response<dynamic> response;
  try {
    response = await tmdb.get(
      '/3/movie/$id/credits',
      queryParameters: {
        'api_key': dotenv.env['TMDB_KEY'],
      },
    );
    kLog.i('Getting credings for movie with ID : $id.');
  } on DioError catch (e) {
    kLog.e(e);
    return null;
  }
  // ignore: omit_local_variable_types
  final MovieCredits movieCredits = MovieCredits.fromMap(response.data);
  return movieCredits;
}

/// Returns the upcoming movies.
Future<List<Movie>?> getUpcoming() async {
  Response<dynamic> response;
  try {
    response = await tmdb.get(
      '/3/movie/upcoming',
      queryParameters: {
        'api_key': dotenv.env['TMDB_KEY'],
        'language': 'en-US',
        'include_adult': false,
        'page': 1,
      },
    );
    kLog.i('Getting upcoming movies');
  } on DioError catch (e) {
    kLog.e(e);
    return null;
  }
  // ignore: omit_local_variable_types
  final List<Movie> upcomingMovies = [];
  response.data['results'].forEach((jsonMovie) {
    upcomingMovies.add(Movie.fromMap(jsonMovie));
  });
  return upcomingMovies;
}

/// Search for movie keywords associated with a specific [term].
Future<KeywordResults> getKeywords(String term) async {
  try {
    final response = await tmdb.get(
      '/3/search/keyword',
      queryParameters: {
        'api_key': dotenv.env['TMDB_KEY'],
        'query': term,
      },
    );

    return KeywordResults.fromJson(response.data);
  } on DioError catch (e) {
    kLog.e(e.message);
    return KeywordResults.error();
  }
}

/// Discover movies with [includedKeywords]. [includedKeywords] is a string with concatinated Keyword ids.
///
/// Keyword ids can be created by searching keywords with:
/// ```dart
/// getKeywords(String term)
/// ```
/// which returns a list of keywords used by movies.
Future<List<Movie>> discoverMovies({
  String includedKeywords = '',
  String excludedKeywords = '',
  int page = 1,
}) async {
  kLog.i(
      'Included keywords $includedKeywords\nExcluded keyword $excludedKeywords');
  try {
    final response = await tmdb.get(
      '/3/discover/movie',
      queryParameters: {
        'api_key': dotenv.env['TMDB_KEY'],
        'with_keywords': includedKeywords,
        'without_keywords': excludedKeywords,
        'page': page,
        'language': 'el-GR',
      },
    );
    kLog.i('Current page $page');
    final discoveredMovies = <Movie>[];
    response.data['results'].forEach(
      (jsonMovie) {
        discoveredMovies.add(Movie.fromMap(jsonMovie));
      },
    );
    return discoveredMovies;
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
    final response = await tmdb.get(
      '/3/movie/$id/videos',
      queryParameters: {
        'api_key': dotenv.env['TMDB_KEY'],
        'language': 'el-GR',
      },
    );

    return MovieVideos.fromJson(response.data);
  } on DioError catch (e) {
    kLog.e(e.message);
    return null;
  }
}
