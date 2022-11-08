import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/logic/authority.dart';
import 'package:orginone/page/home/message/message_controller.dart';
import 'package:orginone/routers.dart';

import '../../../../api/cohort_api.dart';
import '../../../../api_resp/target_resp.dart';

enum CohortFunction {
  create("创建群组"),
  update("修改群组"),
  role("角色管理"),
  identity("身份管理"),
  transfer("转移权限"),
  dissolution("解散群组"),
  exit("退出群组");

  final String funcName;

  const CohortFunction(this.funcName);
}

class CohortsController extends GetxController {
  Logger logger = Logger("CohortsController");

  MessageController messageController = Get.find();

  int? limit;
  int? offset;
  String? filter;

  List<TargetResp> cohorts = [];

  @override
  void onInit() {
    onLoad();
    super.onInit();
  }

  Future<void> onLoad() async {
    await onLoadCohorts("");
  }

  Future<void> onLoadCohorts(String filter) async {
    limit = 20;
    offset = 0;
    var pageResp = await CohortApi.cohorts(limit!, offset!, filter);
    cohorts = pageResp.result;
    update();
  }

  Future<void> moreCohorts(int offset, int limit, String filter) async {
    var pageResp = await CohortApi.cohorts(offset, limit, filter);
    cohorts.addAll(pageResp.result);
    update();
  }

  Future<void> searchingCallback(String filter) async {
    await onLoadCohorts(filter);
  }

  Future<dynamic> createCohort(Map<String, dynamic> value) async {
    await CohortApi.create(value);
    await onLoad();
    await loadAuth();
    Fluttertoast.showToast(msg: "创建成功！");
  }

  Future<dynamic> updateCohort(Map<String, dynamic> value) async {
    await CohortApi.update(value);
    await onLoad();
    Fluttertoast.showToast(msg: "修改成功！");
  }

  cohortFunc(CohortFunction func, TargetResp cohort) async {
    switch (func) {
      case CohortFunction.update:
        Map<String, dynamic> args = {
          "func": func,
          "cohort": {
            "id": cohort.id,
            "name": cohort.name,
            "code": cohort.code,
            "remark": cohort.team?.remark,
            "thingId": cohort.thingId,
            "belongId": cohort.belongId
          },
        };
        Get.toNamed(Routers.cohortMaintain, arguments: args);
        break;
      case CohortFunction.role:
        break;
      case CohortFunction.identity:
        break;
      case CohortFunction.transfer:
        break;
      case CohortFunction.dissolution:
        await CohortApi.delete(cohort.id);
        await onLoad();
        break;
      case CohortFunction.exit:
        await CohortApi.exit(cohort.id);
        await onLoad();
        break;
      case CohortFunction.create:
        break;
    }
  }
}
