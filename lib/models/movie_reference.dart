import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelm/constants.dart';
import 'package:feelm/models/keyword.dart';

CollectionReference<Map<String, dynamic>> references =
    kFirestore.collection('references');

class MovieReference {
  String name;
  List<Keyword> keywords;
  String image;

  MovieReference({
    required this.image,
    required this.keywords,
    required this.name,
  });

  factory MovieReference.fromMap(Map<String, dynamic> map) => MovieReference(
        image: map['image'].toString(),
        keywords: List<Keyword>.generate(
          map['keywords'].length,
          (index) => Keyword.fromJson(map['keywords'][index]),
        ),
        name: map['name'],
      );
}

Future<List<MovieReference>> getReferences() async {
  // ignore: omit_local_variable_types
  final List<MovieReference> refs = [];
  await references.get().then(
    (qs) {
      if (qs.docs.isNotEmpty) {
        for (final snap in qs.docs) {
          refs.add(MovieReference.fromMap(snap.data()));
        }
      }
    },
  );
  return refs;
}

Stream<QuerySnapshot<Map<String, dynamic>>> getReferencesStream() {
  return references.snapshots();
}
