import 'dart:math';
import 'dart:ui';

import 'package:feelm/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:tcard/tcard.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  var random;
  TCardController cardController = TCardController();
  List<String> images = [
    'https://i.imgur.com/Bp7O5SV.jpg',
    'https://i.imgur.com/My2bzCs.jpg',
    'https://i.imgur.com/xGZ302v.jpg',
    'https://i.imgur.com/JW5gR8T.jpg',
  ];

  @override
  void initState() {
    random = Random().nextInt(10);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = List.generate(
      images.length,
      (int index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 17),
                blurRadius: 23.0,
                spreadRadius: -13.0,
                color: Colors.black54,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
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
            top: 40,
            left: 25,
            child: GestureDetector(
              onTap: () async {
                cardController.forward(direction: SwipDirection.Left);
              },
              child: const Icon(
                MfgLabs.cancel_circled,
                color: Colors.red,
                size: 35,
              ),
            ),
          ),
          Positioned(
            top: 30,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 5,
                    ),
                    child: Text(
                      'Παρακαλώ διαλλέξτε τις ταινίες που σας αρέσουν',
                      textAlign: TextAlign.center,
                      style: kStyleLight.copyWith(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 25,
            child: GestureDetector(
              onTap: () async {
                cardController.forward(direction: SwipDirection.Right);
              },
              child: const Icon(
                MfgLabs.ok_circled,
                color: Colors.green,
                size: 35,
              ),
            ),
          ),
          Positioned(
            top: 75,
            bottom: 0,
            right: 10,
            left: 10,
            child: TCard(
              controller: cardController,
              size: const Size(400, 600),
              lockYAxis: true,
              cards: cards,
              slideSpeed: 15,
              onForward: (index, info) {
                kLog.i('Current index is $index');
                kLog.i(info.direction);
                if (info.direction == SwipDirection.Right) {
                  kLog.i('like');
                } else {
                  kLog.i('dislike');
                }
              },
              onBack: (index, info) {
                kLog.i(index);
              },
              onEnd: () {
                kLog.w('Cards have ended');
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 25,
            child: GestureDetector(
              onTap: () async {
                cardController.back();
              },
              child: const Icon(
                MfgLabs.reply,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
