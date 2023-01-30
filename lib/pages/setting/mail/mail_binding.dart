import 'package:get/get.dart';
import 'package:orginone/pages/setting/mail/mail_controller.dart';

class MailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MailController());
  }
}
