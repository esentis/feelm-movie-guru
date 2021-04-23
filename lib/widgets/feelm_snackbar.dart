import 'package:feelm/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum status {
  SUCCESS,
  ERROR,
  INFO,
}

void feelmSnackbar(status status, String title, String body) {
  return Get.snackbar(
    title,
    body,
    backgroundColor: status.index == 0
        ? Colors.green
        : status.index == 1
            ? Colors.red
            : kColorMain,
    titleText: Text(
      title,
      style: kStyleLight.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    messageText: Text(
      body,
      style: kStyleLight.copyWith(
        color: Colors.white,
      ),
    ),
  );
}
