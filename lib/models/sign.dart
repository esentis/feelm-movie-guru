import 'package:feelm/models/keyword.dart';

class ZodiacSign {
  String name;
  String image;
  List<Keyword> keywords;
  DateTime from;
  DateTime to;
  ZodiacSign({
    required this.from,
    required this.keywords,
    required this.name,
    required this.to,
    required this.image,
  });

  factory ZodiacSign.fromMap(Map<String, dynamic>? map) => ZodiacSign(
        from: map!['from'].toDate(),
        keywords: List.generate(
          map['keywords'].length,
          (index) => Keyword.fromJson(
            map['keywords'][index],
          ),
        ),
        name: map['name'],
        to: map['to'].toDate(),
        image: map['image'] ?? '',
      );

  factory ZodiacSign.error() => ZodiacSign(
      from: DateTime.now(),
      keywords: [],
      name: 'Error',
      to: DateTime.now(),
      image: '');
}
