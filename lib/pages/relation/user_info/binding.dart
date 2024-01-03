import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';

import 'logic.dart';


class UserInfoBinding extends BaseBindings<UserInfoController> {
  @override
  UserInfoController getController() {
   return UserInfoController();
  }

}