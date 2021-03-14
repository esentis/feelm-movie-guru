// To parse this JSON data, do
//
//     final movie = movieFromMap(jsonString);

import 'dart:convert';

import 'package:feelm/models/cast.dart';
import 'package:feelm/models/country.dart';
import 'package:feelm/models/genre.dart';
import 'package:feelm/models/language.dart';
import 'package:feelm/models/production_company.dart';

Movie movieFromMap(String str) => Movie.fromMap(json.decode(str));

String movieToMap(Movie data) => json.encode(data.toMap());

class Movie {
  Movie({
    this.posterPath,
    this.adult,
    this.overview,
    this.releaseDate,
    this.genreIds,
    this.id,
    this.originalTitle,
    this.originalLanguage,
    this.title,
    this.backdropPath,
    this.popularity,
    this.voteCount,
    this.video,
    this.voteAverage,
  });

  String posterPath;
  bool adult;
  String overview;
  DateTime releaseDate;
  List<int> genreIds;
  int id;
  String originalTitle;
  String originalLanguage;
  String title;
  String backdropPath;
  double popularity;
  int voteCount;
  bool video;
  double voteAverage;

  factory Movie.fromMap(Map<String, dynamic> json) => Movie(
        posterPath: json['poster_path'],
        adult: json['adult'],
        overview: json['overview'],
        releaseDate: DateTime.parse(json['release_date']),
        genreIds: List<int>.from(json['genre_ids'].map((x) => x)),
        id: json['id'],
        originalTitle: json['original_title'],
        originalLanguage: json['original_language'],
        title: json['title'],
        backdropPath: json['backdrop_path'],
        popularity: json['popularity'].toDouble(),
        voteCount: json['vote_count'],
        video: json['video'],
        voteAverage: json['vote_average'].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'poster_path': posterPath,
        'adult': adult,
        'overview': overview,
        'release_date':
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        'genre_ids': List<dynamic>.from(genreIds.map((x) => x)),
        'id': id,
        'original_title': originalTitle,
        'original_language': originalLanguage,
        'title': title,
        'backdrop_path': backdropPath,
        'popularity': popularity,
        'vote_count': voteCount,
        'video': video,
        'vote_average': voteAverage,
      };
}

class MovieSearchResults {
  MovieSearchResults({
    this.page,
    this.results,
    this.totalResults,
    this.totalPages,
  });

  int page;
  List<Movie> results;
  int totalResults;
  int totalPages;

  factory MovieSearchResults.fromMap(Map<String, dynamic> json) =>
      MovieSearchResults(
        page: json['page'],
        results: List<Movie>.from(json['results'].map((x) => Movie.fromMap(x))),
        totalResults: json['total_results'],
        totalPages: json['total_pages'],
      );

  Map<String, dynamic> toMap() => {
        'page': page,
        'results': List<dynamic>.from(results.map((x) => x.toMap())),
        'total_results': totalResults,
        'total_pages': totalPages,
      };
}

class MovieDetailed {
  MovieDetailed({
    this.adult,
    this.backdropPath,
    this.belongsToCollection,
    this.budget,
    this.genres,
    this.homepage,
    this.id,
    this.imdbId,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.productionCompanies,
    this.productionCountries,
    this.releaseDate,
    this.revenue,
    this.runtime,
    this.spokenLanguages,
    this.status,
    this.tagline,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  bool adult;
  String backdropPath;
  dynamic belongsToCollection;
  int budget;
  List<Genre> genres;
  String homepage;
  int id;
  String imdbId;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  dynamic posterPath;
  List<ProductionCompany> productionCompanies;
  List<ProductionCountry> productionCountries;
  DateTime releaseDate;
  int revenue;
  int runtime;
  List<SpokenLanguage> spokenLanguages;
  String status;
  String tagline;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  factory MovieDetailed.fromMap(Map<String, dynamic> json) => MovieDetailed(
        adult: json['adult'],
        backdropPath: json['backdrop_path'],
        belongsToCollection: json['belongs_to_collection'],
        budget: json['budget'],
        genres: List<Genre>.from(json['genres'].map((x) => Genre.fromMap(x))),
        homepage: json['homepage'],
        id: json['id'],
        imdbId: json['imdb_id'],
        originalLanguage: json['original_language'],
        originalTitle: json['original_title'],
        overview: json['overview'],
        popularity: json['popularity'].toDouble(),
        posterPath: json['poster_path'],
        productionCompanies: List<ProductionCompany>.from(
            json['production_companies']
                .map((x) => ProductionCompany.fromMap(x))),
        productionCountries: List<ProductionCountry>.from(
            json['production_countries']
                .map((x) => ProductionCountry.fromMap(x))),
        releaseDate: DateTime.parse(json['release_date']),
        revenue: json['revenue'],
        runtime: json['runtime'],
        spokenLanguages: List<SpokenLanguage>.from(
            json['spoken_languages'].map((x) => SpokenLanguage.fromMap(x))),
        status: json['status'],
        tagline: json['tagline'],
        title: json['title'],
        video: json['video'],
        voteAverage: json['vote_average'].toDouble(),
        voteCount: json['vote_count'],
      );

  Map<String, dynamic> toMap() => {
        'adult': adult,
        'backdrop_path': backdropPath,
        'belongs_to_collection': belongsToCollection,
        'budget': budget,
        'genres': List<dynamic>.from(genres.map((x) => x.toMap())),
        'homepage': homepage,
        'id': id,
        'imdb_id': imdbId,
        'original_language': originalLanguage,
        'original_title': originalTitle,
        'overview': overview,
        'popularity': popularity,
        'poster_path': posterPath,
        'production_companies':
            List<dynamic>.from(productionCompanies.map((x) => x.toMap())),
        'production_countries':
            List<dynamic>.from(productionCountries.map((x) => x.toMap())),
        'release_date':
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        'revenue': revenue,
        'runtime': runtime,
        'spoken_languages':
            List<dynamic>.from(spokenLanguages.map((x) => x.toMap())),
        'status': status,
        'tagline': tagline,
        'title': title,
        'video': video,
        'vote_average': voteAverage,
        'vote_count': voteCount,
      };
}

class MovieCredits {
  MovieCredits({
    this.id,
    this.cast,
    this.crew,
  });

  int id;
  List<Cast> cast;
  List<Cast> crew;

  factory MovieCredits.fromMap(Map<String, dynamic> json) => MovieCredits(
        id: json['id'],
        cast: List<Cast>.from(json['cast'].map((x) => Cast.fromMap(x))),
        crew: List<Cast>.from(json['crew'].map((x) => Cast.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'cast': List<dynamic>.from(cast.map((x) => x.toMap())),
        'crew': List<dynamic>.from(crew.map((x) => x.toMap())),
      };
}
