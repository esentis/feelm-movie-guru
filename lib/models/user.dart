import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelm/constants.dart';
import 'package:feelm/models/keyword.dart';
import 'package:firebase_auth/firebase_auth.dart';

var users = kFirestore.collection('users');

extension UserExtensions on User? {
  Future<GuruUser> toGuruUser() async {
    var user = GuruUser();
    if (this != null) {
      await users.where('email', isEqualTo: this!.email).get().then(
        (qs) {
          if (qs.docs.isNotEmpty) {
            user = GuruUser.fromMap(qs.docs.first.data()!);
            kLog.wtf('${user.email} is logged in.');

            // return GuruUser.fromMap(qs.docs.first.data()!);
          }
        },
      );
    }
    return user;
  }
}

class GuruUser {
  String? email;
  DateTime? joinDate;
  String? zodiacSign;
  bool? tested;
  String? includedKeywords;
  String? excludedKeywords;

  String? get getIncludedKeywords => includedKeywords;

  set setIncludedKeywords(includedKeywords) =>
      this.includedKeywords = includedKeywords;

  String? get getExcludedKeywords => excludedKeywords;

  set setExcludedKeywords(excludedKeywords) =>
      this.excludedKeywords = excludedKeywords;

  bool? get getTested => tested;

  set setTested(tested) => this.tested = tested;

  String? get getEmail => email;

  set setEmail(email) => this.email = email;

  DateTime? get getJoinDate => joinDate;

  set setJoinDate(joinDate) => this.joinDate = joinDate;

  String? get getZodiacSign => zodiacSign;

  set setZodiacSign(zodiacSign) => this.zodiacSign = zodiacSign;
  GuruUser({
    this.zodiacSign,
    this.email,
    this.joinDate,
    this.tested,
    this.excludedKeywords,
    this.includedKeywords,
  });

  factory GuruUser.fromMap(Map<String, dynamic> map) => GuruUser(
        zodiacSign: map['zodiacSign']!,
        email: map['email'] ?? kAuth.currentUser!.email,
        joinDate: (map['joinDate']! as Timestamp).toDate(),
        tested: map['tested'] ?? false,
        includedKeywords: map['includedKeywords'] ?? '',
        excludedKeywords: map['excludedKeywords'] ?? '',
      );
}

// class UserProvider extends ChangeNotifier {
//   UserProvider({
//     required this.currentUser,
//   });
//   GuruUser? currentUser;
// }

Future<bool> checkMail(String? email) async {
  var exists = false;
  await users.where('email', isEqualTo: email).get().then((qs) {
    exists = qs.docs.isEmpty;
  });

  return exists;
}

Future<GuruUser?> getGuruUser(String email) async {
  GuruUser? user;
  await users.where('email', isEqualTo: email).get().then((qs) {
    user = GuruUser.fromMap(qs.docs.first.data()!);
  });

  return user;
}

void createUser(GuruUser user) {
  users
      .add(
        {
          'email': user.email,
          'zodiacSign': user.zodiacSign,
          'joinDate': DateTime.now()
        },
      )
      .then((value) => kLog.i('User ${value.id} added !'))
      .catchError((error) => kLog.e(error));
}

Future<void> updateUser(GuruUser user) async {
  await users.where('email', isEqualTo: user.email).get().then(
    (qs) {
      if (qs.docs.isNotEmpty) {
        // ignore: omit_local_variable_types

        qs.docs.forEach(
          (snap) {
            users
                .doc(snap.reference.id)
                .update({
                  'includedKeywords': user.includedKeywords,
                  'excludedKeywords': user.excludedKeywords,
                  'tested': true,
                })
                .then((value) => kLog.i('User Updated'))
                .catchError((error) => kLog.e('Failed to update user: $error'));
          },
        );
      }
    },
    // ignore: return_of_invalid_type_from_catch_error
  ).catchError((error) => kLog.e(error));
}
