import 'package:get/get.dart';
import 'package:orginone/page/home/home_controller.dart';

import '../../../api_resp/target_resp.dart';
import '../../../util/hive_util.dart';

class OrganizationController extends GetxController {
  TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
}
