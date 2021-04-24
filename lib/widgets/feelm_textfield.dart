import 'package:feelm/constants.dart';
import 'package:flutter/material.dart';

class FeelmTextField extends StatelessWidget {
  final BuildContext context;
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  const FeelmTextField({
    required this.context,
    required this.label,
    required this.controller,
    this.isPassword = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      controller: controller,
      textAlign: TextAlign.center,
      style: kStyleLight.copyWith(
        color: kColorGrey,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(60),
          borderSide: BorderSide(
            color: kColorMain,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            60,
          ),
          borderSide: BorderSide(
            color: kColorMain,
            width: 3,
          ),
        ),
        labelText: label,
        labelStyle: kStyleLight.copyWith(
          color: kColorGrey,
        ),
      ),
    );
  }
}
