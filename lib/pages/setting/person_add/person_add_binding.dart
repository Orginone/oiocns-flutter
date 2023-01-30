import 'package:get/get.dart';
import 'package:orginone/pages/setting/person_add/person_add_controller.dart';

class PersonAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonAddController());
  }
}
