import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  static showToasterSuccess(String msg,
      {Icon? icon = const Icon(
        Icons.check_circle,
        color: Colors.green,
      )}) {
    Get.showSnackbar(
      GetSnackBar(
        message: msg,
        icon: icon,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  static showToasterFailed(String msg,
      {Icon? icon = const Icon(
        Icons.error,
        color: Colors.red,
      )}) {
    Get.showSnackbar(
      GetSnackBar(
        message: msg,
        icon: icon,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

extension MySizedBox on num {
  SizedBox get ph => SizedBox(height: toDouble());
  SizedBox get pw => SizedBox(width: toDouble());
}
