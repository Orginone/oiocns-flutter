import 'package:get/get.dart';
import 'person_detail_controller.dart';

class PersonDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonDetailController());
  }
}
