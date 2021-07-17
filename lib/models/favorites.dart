import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelm/constants.dart';

CollectionReference<Map<String, dynamic>> favorites =
    kFirestore.collection('favorites');

class Favorite {
  String email;
  int movieId;
  Favorite({
    required this.email,
    required this.movieId,
  });

  factory Favorite.fromMap(Map<String, dynamic> map) => Favorite(
        email: map['email'],
        movieId: map['movieId'],
      );
}

Future<List<Favorite>> getUserFavorites() async {
  // ignore: omit_local_variable_types
  final List<Favorite> favList = [];
  await favorites
      .where('email', isEqualTo: kAuth.currentUser!.email)
      .get()
      .then(
    (qs) {
      if (qs.docs.isNotEmpty) {
        for (final snap in qs.docs) {
          favList.add(Favorite.fromMap(snap.data()));
        }
      }
    },
  );
  return favList;
}

Stream<QuerySnapshot<Map<String, dynamic>>> getUserFavoritesStream() {
  return favorites
      .where('email', isEqualTo: kAuth.currentUser!.email)
      .snapshots();
}

Future<void> toggleFavorite(Favorite favorite) async {
  var docRefForDeletion = '';
  await favorites.where('email', isEqualTo: favorite.email).get().then(
    (qs) {
      if (qs.docs.isNotEmpty) {
        // ignore: omit_local_variable_types
        final List<Favorite> favorites = [];

        for (final snap in qs.docs) {
          final fav = Favorite.fromMap(snap.data());
          if (fav.movieId == favorite.movieId && favorite.email == fav.email) {
            docRefForDeletion = snap.reference.id;
          } else {
            favorites.add(fav);
          }
        }
      }
    },
  );
  if (docRefForDeletion.isEmpty) {
    kLog.w('Adding favorite for ${favorite.email} movie ${favorite.movieId}');
    await favorites.add(
      {
        'email': favorite.email,
        'movieId': favorite.movieId,
      },
    );
  } else {
    kLog.w('Removing favorite with doc reference $docRefForDeletion');
    await favorites.doc(docRefForDeletion).delete();
  }
}
