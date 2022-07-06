import 'package:get/get.dart';

class NavigateGetx {
  void navigateGetx({required String routeName, dynamic? arguments}) {
    Get.toNamed(routeName, arguments: arguments);
  }

  void goBack({Object? result}) {
    Get.back(result: result);
  }

  /* ====== delete previous route and routes*/
  void navigateGetxOff({required String routeName, dynamic? arguments}) {
    Get.offNamed(routeName, arguments: arguments);
  }

  void navigateGetxOffAll({required String routeName, dynamic? arguments}) {
    Get.offAllNamed(routeName, arguments: arguments);
  }

  dynamic getArguments() {
    return Get.arguments;
  }
}
