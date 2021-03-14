import 'package:dio/dio.dart';
import 'package:feelm/constants.dart';
import 'package:feelm/models/imdb_movie.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

BaseOptions dioOmdbOptions = BaseOptions(
  baseUrl: 'https://www.omdbapi.com/',
  receiveDataWhenStatusError: true,
  connectTimeout: 6 * 1000, // 6 seconds
  receiveTimeout: 6 * 1000, // 6 seconds
);
Dio omdb = Dio(dioOmdbOptions);

Future<ImdbMovie> getImdbMovie(String id) async {
  try {
    var response = await omdb.get('', queryParameters: {
      'i': id,
      'apiKey': env['OMDB_KEY'],
    });
    return ImdbMovie.fromMap(response.data);
  } on DioError catch (e) {
    kLog.e(e.message);
    return ImdbMovie.error();
  }
}
