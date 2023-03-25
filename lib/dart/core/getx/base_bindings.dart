import 'package:get/get.dart';

import 'base_controller.dart';

abstract class BaseBindings<T extends BaseController> extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<T>(() => getController(),tag: getTag());
  }

  T getController();

  String? getTag(){
    return null;
  }
}
