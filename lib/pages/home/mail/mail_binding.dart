import 'package:get/get.dart';
import 'package:orginone/page/home/mail/mail_controller.dart';

class MailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MailController());
  }
}
