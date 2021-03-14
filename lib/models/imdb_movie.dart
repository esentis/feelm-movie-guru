// To parse this JSON data, do
//
//     final imdbMovie = imdbMovieFromMap(jsonString);

import 'dart:convert';

ImdbMovie imdbMovieFromMap(String str) => ImdbMovie.fromMap(json.decode(str));

String imdbMovieToMap(ImdbMovie data) => json.encode(data.toMap());

class ImdbMovie {
  ImdbMovie({
    this.title,
    this.year,
    this.rated,
    this.released,
    this.runtime,
    this.genre,
    this.director,
    this.writer,
    this.actors,
    this.plot,
    this.language,
    this.country,
    this.awards,
    this.poster,
    this.ratings,
    this.metascore,
    this.imdbRating,
    this.imdbVotes,
    this.imdbId,
    this.type,
    this.dvd,
    this.boxOffice,
    this.production,
    this.website,
    this.response,
  });

  String title;
  String year;
  String rated;
  String released;
  String runtime;
  String genre;
  String director;
  String writer;
  String actors;
  String plot;
  String language;
  String country;
  String awards;
  String poster;
  List<Rating> ratings;
  String metascore;
  String imdbRating;
  String imdbVotes;
  String imdbId;
  String type;
  String dvd;
  String boxOffice;
  String production;
  String website;
  String response;

  factory ImdbMovie.fromMap(Map<String, dynamic> json) => ImdbMovie(
        title: json['Title'] ?? '',
        year: json['Year'] ?? '',
        rated: json['Rated'] ?? '',
        released: json['Released'] ?? '',
        runtime: json['Runtime'] ?? '',
        genre: json['Genre'] ?? '',
        director: json['Director'] ?? '',
        writer: json['Writer'] ?? '',
        actors: json['Actors'] ?? '',
        plot: json['Plot'] ?? '',
        language: json['Language'] ?? '',
        country: json['Country'] ?? '',
        awards: json['Awards'] ?? '',
        poster: json['Poster'] ?? '',
        ratings: json['Ratings'] == null
            ? null
            : List<Rating>.from(json['Ratings'].map((x) => Rating.fromMap(x))),
        metascore: json['Metascore'] ?? '',
        imdbRating: json['imdbRating'] ?? '',
        imdbVotes: json['imdbVotes'] ?? '',
        imdbId: json['imdbID'] ?? '',
        type: json['Type'] ?? '',
        dvd: json['DVD'] ?? '',
        boxOffice: json['BoxOffice'] ?? '',
        production: json['Production'] ?? '',
        website: json['Website'] ?? '',
        response: json['Response'] ?? '',
      );

  factory ImdbMovie.error() => ImdbMovie();

  Map<String, dynamic> toMap() => {
        // ignore: unnecessary_null_in_if_null_operators
        'Title': title ?? '',
        // ignore: unnecessary_null_in_if_null_operators
        'Year': year ?? '',
        // ignore: unnecessary_null_in_if_null_operators
        'Rated': rated ?? '',
        'Released': released ?? '',
        'Runtime': runtime ?? '',
        'Genre': genre ?? '',
        'Director': director ?? '',
        'Writer': writer ?? '',
        'Actors': actors ?? '',
        'Plot': plot ?? '',
        'Language': language ?? '',
        'Country': country ?? '',
        'Awards': awards ?? '',
        'Poster': poster ?? '',
        'Ratings': ratings == null
            ? []
            : List<dynamic>.from(ratings.map((x) => x.toMap())),
        'Metascore': metascore ?? '',
        'imdbRating': imdbRating ?? '',
        'imdbVotes': imdbVotes ?? '',
        'imdbID': imdbId ?? '',
        'Type': type ?? '',
        'DVD': dvd ?? '',
        'BoxOffice': boxOffice ?? '',
        'Production': production ?? '',
        'Website': website ?? '',
        'Response': response ?? '',
      };
}

class Rating {
  Rating({
    this.source,
    this.value,
  });

  String source;
  String value;

  factory Rating.fromMap(Map<String, dynamic> json) => Rating(
        source: json['Source'] ?? '',
        value: json['Value'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'Source': source ?? '',
        'Value': value ?? '',
      };
}
