import 'package:get/get.dart';
import 'package:orginone/controller/target/target_controller.dart';
import 'package:orginone/page/home/affairs/affairs_page_controller.dart';
import 'package:orginone/page/home/application/applicatino_controller.dart';
import 'package:orginone/page/home/mine/set_home/set_home_controller.dart';
import 'package:orginone/page/home/organization/organization_controller.dart';

import 'home_controller.dart';
import '../../controller/message/message_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => AffairsPageController());
    Get.lazyPut(() => MessageController());
    Get.lazyPut(() => ApplicationController());
    Get.lazyPut(() => OrganizationController());
    Get.lazyPut(() => SetHomeController());
    Get.lazyPut(() => TargetController());
  }
}
