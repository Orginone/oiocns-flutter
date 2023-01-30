import 'package:get/get.dart';
import 'package:orginone/pages/chat/contact/contact_controller.dart';

class ContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ContactController());
  }
}
