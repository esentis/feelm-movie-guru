import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelm/constants.dart';
import 'package:feelm/models/keyword.dart';

var references = kFirestore.collection('references');

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
        image: map['image'],
        keywords: List<Keyword>.generate(
          map['keywords'].length,
          (index) => Keyword.fromJson(map['keywords'][index]),
        ),
        name: map['name'],
      );
}

Future<List<MovieReference>> getReferences() async {
  // ignore: omit_local_variable_types
  List<MovieReference> refs = [];
  await references.get().then(
    (qs) {
      if (qs.docs.isNotEmpty) {
        // ignore: omit_local_variable_types

        qs.docs.forEach(
          (snap) {
            refs.add(MovieReference.fromMap(snap.data()!));
          },
        );
      }
    },
  );
  return refs;
}

Stream<QuerySnapshot> getReferencesStream() {
  return references.snapshots();
}
