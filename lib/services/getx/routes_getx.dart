import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoutesGetx {
  GetPage GetPageCustom(
      {required String routeName,
      required Widget Function() page,
      Transition transition = Transition.fadeIn}) {
    return GetPage(name: routeName, page: page, transition: transition);
  }
}
