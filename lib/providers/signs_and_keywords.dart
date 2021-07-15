import 'package:feelm/constants.dart';
import 'package:feelm/models/keyword.dart';
import 'package:feelm/models/sign.dart';

Future<List<Keyword>> getKeywords() async {
  final x = await kFirestore.collection('keywords').snapshots().first;
  return List<Keyword>.generate(
      x.docs.length, (index) => Keyword.fromJson(x.docs[index].data()));
}

Future<List<ZodiacSign>> getSigns() async {
  final x = await kFirestore.collection('signs').snapshots().first;
  return List<ZodiacSign>.generate(
    x.docs.length,
    (index) => ZodiacSign.fromMap(
      x.docs[index].data(),
    ),
  );
}
