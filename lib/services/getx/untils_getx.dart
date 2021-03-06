import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UntilsGetx {
  void snackbar(
      {required String title,
      required String message,
      Color? colorText = Colors.white,
      Widget? icon,
      bool isDismissible = true,
      Duration duration = const Duration(seconds: 2),
      Duration animationDuration = const Duration(seconds: 1),
      Color? backgroundColor = Colors.black,
      SnackPosition? direction = SnackPosition.TOP,
      Curve? animation}) {
    Get.snackbar(
      title,
      message,
      colorText: colorText,
      duration: duration,
      animationDuration: animationDuration,
      icon: icon,
      backgroundColor: backgroundColor!.withOpacity(0.3),
      snackPosition: direction,
      forwardAnimationCurve: animation,
    );
  }

  void dialog(
      {required String title,
      TextStyle? titleStyle,
      Widget? content,
      String? textCancel,
      String? textConfirm,
      Color? backgroundColor,
      Color? cancelTextColor,
      Color? confirmTextColor,
      Color? buttonColor,
      Widget? customCancel,
      Widget? customConfirm,
      VoidCallback? onCancel,
      VoidCallback? onConfirm,
      double radius = 10.0}) {
    Get.defaultDialog(
        title: title,
        titleStyle: titleStyle,
        content: content,
        textCancel: textCancel,
        textConfirm: textConfirm,
        backgroundColor: backgroundColor,
        cancel: customCancel,
        confirm: customConfirm,
        onCancel: onCancel,
        onConfirm: onConfirm,
        cancelTextColor: cancelTextColor,
        confirmTextColor: confirmTextColor,
        buttonColor: buttonColor,
        radius: radius);
  }
}
