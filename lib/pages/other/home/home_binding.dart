import 'package:get/get.dart';
import 'package:orginone/dart/controller/file_controller.dart';
import 'package:orginone/dart/controller/message/message_controller.dart';
import 'package:orginone/dart/controller/target/target_controller.dart';
import 'package:orginone/pages/market/application/applicatino_controller.dart';
import 'package:orginone/pages/other/home/home_controller.dart';
import 'package:orginone/pages/setting/mine/set_home/set_home_controller.dart';
import 'package:orginone/pages/setting/organization/organization_controller.dart';
import 'package:orginone/pages/work/affairs/affairs_page_controller.dart';

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
    Get.lazyPut(() => FileController());
  }
}
