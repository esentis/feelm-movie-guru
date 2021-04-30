import 'package:feelm/constants.dart';
import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String text;

  final String? subtitleText;
  final double subtitleTextSize;

  final double space;
  final Color iconColor;

  const InfoContainer({
    required this.icon,
    required this.text,
    required this.iconColor,
    this.subtitleText,
    this.iconSize = 25,
    this.space = 3,
    this.subtitleTextSize = 17,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
        SizedBox(
          width: space,
        ),
        Column(
          children: [
            Text(
              text,
              style: kStyleLight.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kColorMain,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitleText ?? '',
              style: kStyleLight.copyWith(
                fontSize: subtitleTextSize,
                color: kColorMain,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
