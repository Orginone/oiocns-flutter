import 'package:get/get.dart';

import 'new_friends_controller.dart';

class NewFriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewFriendsController());
  }
}
