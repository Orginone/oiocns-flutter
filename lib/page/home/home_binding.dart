import 'package:get/get.dart';
import 'package:orginone/page/home/affairs/affairs_page_controller.dart';
import 'package:orginone/page/home/mine/set_home/set_home_controller.dart';
import 'package:orginone/page/home/organization/organization_controller.dart';
import 'package:orginone/page/home/work/work_controller.dart';

import 'home_controller.dart';
import 'message/message_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => AffairsPageController());
    Get.lazyPut(() => MessageController());
    Get.lazyPut(() => WorkController());
    Get.lazyPut(() => OrganizationController());
    Get.lazyPut(() => SetHomeController());
  }
}
