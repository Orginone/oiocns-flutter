import 'package:get/get.dart';
import 'package:logging/logging.dart';

import '../../../../api/company_api.dart';
import '../../../../api_resp/target_resp.dart';
import '../../home_controller.dart';

class GroupsController extends GetxController {
  Logger logger = Logger("GroupsController");
  HomeController homeController = Get.find<HomeController>();

  int? limit;
  int? offset;
  String? filter;

  List<TargetResp> groups = [];

  @override
  void onInit() {
    onLoadGroups("");
    super.onInit();
  }

  Future<void> onLoadGroups(String filter) async {
    limit = 20;
    offset = 0;
    groups = await CompanyApi.groups(limit!, offset!, filter);
    update();
  }

  Future<void> moreFriends(int offset, int limit, String filter) async {
    var newGroups = await CompanyApi.groups(offset, limit, filter);
    groups.addAll(newGroups);
    update();
  }

  Future<void> searchingCallback(String filter) async {
    await onLoadGroups(filter);
  }
}
