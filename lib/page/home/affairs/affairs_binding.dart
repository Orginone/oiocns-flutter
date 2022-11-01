import 'package:get/get.dart';
import 'package:orginone/page/home/affairs/copy/copy_controller.dart';
import 'package:orginone/page/home/affairs/instance/instance_controller.dart';

import 'affairs_page_controller.dart';
import 'record/record_controller.dart';
import 'task/task_controller.dart';

class AffairsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AffairsPageController());
    Get.lazyPut(() => TaskController());
    Get.lazyPut(() => RecordController());
    Get.lazyPut(() => InstanceController());
    Get.lazyPut(() => CopyController());
  }
}
