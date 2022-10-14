import 'package:get/get.dart';
import 'package:orginone/page/home/home_controller.dart';

import '../../../../api/company_api.dart';
import '../../../../api_resp/target_resp.dart';

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
    addUserInfoSpace();
    await loadMoreSpaces(offset, limit);
  }

  void addUserInfoSpace() {
    TargetResp userInfo = TargetResp.copyWith(homeController.userInfo);
    userInfo.name = "个人空间";
    spaces.add(userInfo);
  }

  Future<void> loadMoreSpaces(int offset, int limit) async {
    // 获取加入的空间
    var pageResp = await CompanyApi.getJoinedCompanys(offset, limit);
    spaces.addAll(pageResp.result);

    // 更新试图
    update();
  }
}
