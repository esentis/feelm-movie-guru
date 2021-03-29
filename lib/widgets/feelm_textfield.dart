import 'package:feelm/constants.dart';
import 'package:feelm/theme_config.dart';
import 'package:flutter/material.dart';

class FeelmTextField extends StatelessWidget {
  final BuildContext context;
  final String label;
  const FeelmTextField({
    required this.context,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.center,
      style: kStyleLight.copyWith(
        color: pink,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(60),
          borderSide: BorderSide(
            color: purpleDark,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            60,
          ),
          borderSide: BorderSide(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: 3,
          ),
        ),
        labelText: label,
        labelStyle: kStyleLight.copyWith(
          color: whiteLight,
        ),
      ),
    );
  }
}
