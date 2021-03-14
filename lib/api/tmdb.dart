import 'package:dio/dio.dart';
import 'package:feelm/constants.dart';
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
    response =
        await tmdb.get('/3/trending/movie/day?api_key=${env['TMDB_KEY']}');
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
        '/3/search/movie?api_key=${env['TMDB_KEY']}&language=en-US&query=$term&page=1&include_adult=false');
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
Future getMovie(int id) async {
  Response response;
  try {
    response = await tmdb
        .get('/3/movie/$id?api_key=${env['TMDB_KEY']}&language=en-US');
    kLog.i('Searching movie with ID : $id.');
  } on DioError catch (e) {
    kLog.e(e);
    return e.type;
  }
  // ignore: omit_local_variable_types
  MovieDetailed detailedMovie = MovieDetailed.fromMap(response.data);
  return detailedMovie;
}

/// Returns the cast and crew for a movie with [id].
Future getCredits(int id) async {
  Response response;
  try {
    response =
        await tmdb.get('/3/movie/$id/credits?api_key=${env['TMDB_KEY']}');
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
        '/3/movie/upcoming?api_key=${env['TMDB_KEY']}&language=en-US&page=1');
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

/// Returns the latest movie created in the database.
Future getLatest() async {
  Response response;
  try {
    response = await tmdb
        .get('/3/movie/latest?api_key=${env['TMDB_KEY']}&language=en-US');
    kLog.i('Getting latest movie added');
  } on DioError catch (e) {
    kLog.e(e);
    return e.type;
  }
  return response.data;
}
