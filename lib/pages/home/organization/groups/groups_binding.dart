import 'package:get/get.dart';

import 'groups_controller.dart';

class GroupsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupsController());
  }
}
