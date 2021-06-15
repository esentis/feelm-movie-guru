import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:feelm/constants.dart';
import 'package:feelm/models/keyword.dart';
import 'package:feelm/models/movie_reference.dart';
import 'package:feelm/models/user.dart';
import 'package:feelm/pages/movies_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:tcard/tcard.dart';

// ignore: must_be_immutable
class TestPage extends StatefulWidget {
  GuruUser? user;
  TestPage({this.user});
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  var random;
  TCardController cardController = TCardController();

  List<Keyword> includedKeys = [];
  List<Keyword> excludedKeys = [];

  var currentIndex = 1;

  @override
  void initState() {
    random = Random().nextInt(10);
    kLog.wtf('User email is ${widget.user!.email}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          MirrorAnimation<double>(
            tween: 0.0.tweenTo(-350.0),
            duration: 55.seconds,
            builder: (context, child, value) => Positioned.fill(
              bottom: 0,
              top: 0,
              left: value,
              child: Image.asset(
                'assets/collage$random.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // A smooth color layer at top of the background image
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Positioned(
            top: 35,
            left: -10,
            child: GestureDetector(
              onTap: () async {
                cardController.forward(direction: SwipDirection.Right);
              },
              child: Lottie.asset(
                'assets/dislike.json',
                height: 100,
                width: 100,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 70,
            right: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5,
                  sigmaY: 5,
                ),
                child: Container(
                  color: Colors.white.withOpacity(0.3),
                  child: Column(
                    children: [
                      Text(
                        'Παρακαλώ διαλλέξτε τις ταινίες που σας αρέσουν',
                        textAlign: TextAlign.center,
                        style: kStyleLight.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${currentIndex - 1}/15',
                        textAlign: TextAlign.center,
                        style: kStyleLight.copyWith(
                          color: kColorMain,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 25,
            right: -10,
            child: GestureDetector(
              onTap: () async {
                cardController.forward(direction: SwipDirection.Right);
              },
              child: Lottie.asset(
                'assets/like.json',
                height: 100,
                width: 100,
              ),
            ),
          ),
          Positioned(
            top: 120,
            bottom: 0,
            right: 10,
            left: 10,
            child: StreamBuilder<QuerySnapshot>(
                stream: getReferencesStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return kSpinkit;
                  }
                  // ignore: omit_local_variable_types
                  List<MovieReference> refs = [];
                  snapshot.data!.docs.forEach(
                    (qsDocument) {
                      refs.add(MovieReference.fromMap(qsDocument.data()!));
                    },
                  );
                  // ignore: omit_local_variable_types
                  List<Widget> cards = List.generate(
                    refs.length,
                    (int index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            const BoxShadow(
                              offset: Offset(0, 17),
                              blurRadius: 23.0,
                              spreadRadius: -13.0,
                              color: Colors.black54,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: ExtendedImage.network(
                            refs[index].image,
                            fit: BoxFit.cover,
                            loadStateChanged: (state) {
                              if (state.extendedImageLoadState ==
                                  LoadState.loading) {
                                return kSpinkit;
                              }
                            },
                          ),
                        ),
                      );
                    },
                  )..shuffle();

                  return TCard(
                    controller: cardController,
                    size: const Size(400, 600),
                    lockYAxis: true,
                    cards: cards.take(15).toList(),
                    slideSpeed: 15,
                    onForward: (index, info) {
                      if (info.direction == SwipDirection.Right) {
                        kLog.i('${refs[index - 1].name} liked !');
                        includedKeys.addAll(refs[index - 1].keywords);
                      } else {
                        kLog.w('${refs[index - 1].name} disliked !');
                        excludedKeys.addAll(refs[index - 1].keywords);
                      }
                      setState(() {
                        currentIndex = index + 1;
                      });
                    },
                    onBack: (index, info) {
                      kLog.i(index);
                    },
                    onEnd: () async {
                      kLog.w('Cards have ended');

                      // The included keys should be concluded after removing excluded keys

                      excludedKeys = excludedKeys
                          .where(
                            (exKey) =>
                                includedKeys
                                    .where((inKey) => exKey.name == inKey.name)
                                    .count() <=
                                excludedKeys
                                    .where((inKey) => exKey.name == inKey.name)
                                    .count(),
                          )
                          .toList();
                      includedKeys = includedKeys
                          .where(
                            (inKey) => !excludedKeys
                                .any((exKey) => inKey.name == exKey.name),
                          )
                          .toList();
                      var includedKeywordIds = List.generate(
                        includedKeys.length,
                        (index) => includedKeys[index].id.toString(),
                      ).toSet().toList();

                      var excludedKeywordIds = List.generate(
                        excludedKeys.length,
                        (index) => excludedKeys[index].id.toString(),
                      ).toSet().toList();

                      kLog.wtf(
                          'Included keyword length ${includedKeywordIds.length}');
                      kLog.wtf(
                          'Excluded keyword length ${excludedKeywordIds.length}');
                      widget.user!.includedKeywords =
                          "|${includedKeywordIds.join('|')}";
                      widget.user!.excludedKeywords =
                          excludedKeywordIds.join('|');
                      kLog.wtf(widget.user!.email);
                      await updateUser(widget.user!);
                      await Get.offAll(() => MoviesScreen());
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
