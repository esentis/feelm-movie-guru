import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelm/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

var users = kFirestore.collection('users');

extension UserExtensions on User? {
  Future<GuruUser> toGuruUser() async {
    if (this != null) {
      return users.where('email', isEqualTo: this!.email).get().then(
        (qs) {
          var user = GuruUser.fromMap(qs.docs.first.data()!);
          kLog.wtf('${user.email} is logged in.');
          return GuruUser.fromMap(qs.docs.first.data()!);
        },
      );
    }
    return GuruUser();
  }
}

class GuruUser {
  String? email;
  DateTime? joinDate;
  String? zodiacSign;
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
  });

  factory GuruUser.fromMap(Map<String, dynamic> map) => GuruUser(
        zodiacSign: map['zodiacSign']!,
        email: map['email']!,
        joinDate: (map['joinDate']! as Timestamp).toDate(),
      );
}

class UserProvider extends ChangeNotifier {
  UserProvider({
    required this.currentUser,
  });
  GuruUser? currentUser;
}

Future<bool> checkMail(String? email) async {
  var exists = false;
  await users.where('email', isEqualTo: email).get().then((qs) {
    exists = qs.docs.isEmpty;
  });

  return exists;
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
