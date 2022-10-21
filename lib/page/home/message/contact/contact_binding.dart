

import 'package:get/get.dart';
import 'package:orginone/page/home/message/contact/contact_controller.dart';


class ContactBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ContactController());
  }

}