import 'package:get/get.dart';
import 'package:orginone/model/db_model.dart';
import 'package:orginone/page/home/home_controller.dart';

import '../../../../api/company_api.dart';
import '../../../../api_resp/target_resp.dart';
import '../../../../util/hive_util.dart';

class SpaceChooseController extends GetxController {
  HomeController homeController = Get.find<HomeController>();

  late int offset;
  late int limit;
  late List<TargetResp> spaces;

  @override
  void onInit() {
    onLoadSpaces();
    super.onInit();
  }

  Future<void> onLoadSpaces() async {
    offset = 0;
    limit = 20;
    spaces = [];
    if (homeController.currentSpace.id != homeController.userInfo.id) {
      TargetResp userInfo = TargetResp.copyWith(homeController.userInfo);
      userInfo.name = "个人空间";
      spaces.add(userInfo);
    }
    await loadMoreSpaces(offset, limit);
  }

  Future<void> loadMoreSpaces(int offset, int limit) async {
    var currentSpace = homeController.currentSpace;
    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);

    // 获取加入的空间
    List<dynamic> joined = await CompanyApi.getJoinedCompanys(offset, limit);
    for (var joinedSpace in joined) {
      TargetResp space = TargetResp.fromMap(joinedSpace);
      if (currentSpace.id != space.id) {
        spaces.add(space);
      }
      await space.toTarget().upsert();

      TargetRelation relation = TargetRelation();
      relation.activeTargetId = userInfo.id;
      relation.passiveTargetId = space.id;
      relation.name = space.name;
      await relation.upsert();
    }
    update();
  }
}
