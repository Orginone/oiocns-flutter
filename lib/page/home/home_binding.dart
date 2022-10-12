import 'package:get/get.dart';
import 'package:orginone/page/home/organization/organization_controller.dart';

import 'home_controller.dart';
import 'message/message_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => MessageController());
    Get.lazyPut(() => OrganizationController());
  }
}
