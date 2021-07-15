import 'package:feelm/constants.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:get/get.dart';

enum status {
  success,
  error,
  info,
}

void feelmSnackbar(status status, String title, String body) {
  return Get.snackbar(
    title,
    body,
    backgroundColor: status.index == 0
        ? 'ffc93c'.toColor().withOpacity(0.2)
        : status.index == 1
            ? Colors.red.withOpacity(0.2)
            : kColorMain.withOpacity(0.2),
    titleText: Text(
      title,
      style: kStyleLight.copyWith(
        fontWeight: FontWeight.bold,
        color: kColorMain,
      ),
    ),
    messageText: Text(
      body,
      style: kStyleLight.copyWith(
        color: kColorGrey,
      ),
    ),
  );
}
