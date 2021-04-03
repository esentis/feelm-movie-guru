import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelm/models/keyword.dart';
import 'package:feelm/models/sign.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<List<Keyword>> getKeywords() async {
  var x = await firestore.collection('keywords').snapshots().first;
  return List<Keyword>.generate(
      x.docs.length, (index) => Keyword.fromJson(x.docs[index].data()));
}

Future<List<ZodiacSign>> getSigns() async {
  var x = await firestore.collection('signs').snapshots().first;
  return List<ZodiacSign>.generate(
    x.docs.length,
    (index) => ZodiacSign.fromMap(
      x.docs[index].data(),
    ),
  );
}
