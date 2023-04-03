import 'package:get/get.dart';
import 'package:orginone/pages/setting/cofig.dart';
import 'package:orginone/routers.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class StandardController extends BaseController<StandardState> {
 final StandardState state = StandardState();

  void nextLvForEnum(StandardEnum standardEnum) {
   Get.toNamed(Routers.relationGroup,arguments: {"standardEnum":standardEnum,"head":"标准"});
  }
}
