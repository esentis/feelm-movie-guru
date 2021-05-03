class KeywordResults {
  KeywordResults({
    required this.keywords,
  });

  List<Keyword> keywords;

  factory KeywordResults.fromJson(Map<String, dynamic> json) => KeywordResults(
        keywords:
            List<Keyword>.from(json['results'].map((x) => Keyword.fromJson(x))),
      );

  factory KeywordResults.error() => KeywordResults(keywords: []);
}

class Keyword {
  Keyword({
    required this.name,
    required this.id,
  });

  String name;
  String id;

  factory Keyword.fromJson(Map<String, dynamic>? json) => Keyword(
        name: json!['name'],
        id: json['id'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
      };
}
