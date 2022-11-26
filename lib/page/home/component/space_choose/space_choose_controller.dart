import 'package:get/get.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/page/home/home_controller.dart';

import '../../../../api/company_api.dart';
import '../../../../api_resp/target.dart';

class SpaceChooseController extends GetxController {
  HomeController homeController = Get.find<HomeController>();

  late int offset;
  late int limit;
  late List<Target> spaces;

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
    var currentUserInfo = auth.userInfo;
    Target userInfo = Target.copyWith(currentUserInfo);
    userInfo.name = "个人空间";
    spaces.add(userInfo);
  }

  Future<void> loadMoreSpaces(int offset, int limit) async {
    // 获取加入的空间
    PageResp<Target> pageResp = await CompanyApi.getJoinedCompanys(offset, limit);
    spaces.addAll(pageResp.result);

    // 更新试图
    update();
  }
}
