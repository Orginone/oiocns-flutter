import 'package:get/get.dart';
import 'package:orginone/page/home/work/work_controller.dart';

class WorkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WorkController());
  }
}
