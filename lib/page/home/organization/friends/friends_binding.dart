import 'package:get/get.dart';

import 'friends_controller.dart';

class FriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendsController());
  }
}
