import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/util/hive_util.dart';

class MineInfoController extends GetxController {
  final Logger log = Logger("MineInfoController");
  TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
  @override
  void onReady() async{
    super.onReady();
  }
}
