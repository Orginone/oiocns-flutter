import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/dart/base/api/company_api.dart';
import 'package:orginone/dart/base/model/target.dart';
import 'package:orginone/pages/other/home/home_controller.dart';

class GroupsController extends GetxController {
  Logger logger = Logger("GroupsController");
  HomeController homeController = Get.find<HomeController>();

  int? limit;
  int? offset;
  String? filter;

  List<Target> groups = [];

  @override
  void onInit() {
    onLoadGroups("");
    super.onInit();
  }

  Future<void> onLoadGroups(String filter) async {
    limit = 20;
    offset = 0;
    var pageResp = await CompanyApi.groups(limit!, offset!, filter);
    groups = pageResp.result;
    update();
  }

  Future<void> moreFriends(int offset, int limit, String filter) async {
    var pageResp = await CompanyApi.groups(offset, limit, filter);
    groups.addAll(pageResp.result);
    update();
  }

  Future<void> searchingCallback(String filter) async {
    await onLoadGroups(filter);
  }
}
