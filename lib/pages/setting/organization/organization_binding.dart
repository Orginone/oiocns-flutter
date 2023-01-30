import 'package:get/get.dart';

import 'organization_controller.dart';

class OrganizationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrganizationController());
  }
}
