import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingApp {
  static show() {
    Get.dialog(
      WillPopScope(child: const Center(
        child: CircularProgressIndicator(),
      ), onWillPop: () {
        return Future.value(true);
      })
    );
  }
  static hide() {
    Get.back();
  }
}