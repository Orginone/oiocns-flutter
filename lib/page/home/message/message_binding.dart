import 'package:get/get.dart';
import 'package:orginone/page/home/message/message_controller.dart';

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageController());
  }
}
