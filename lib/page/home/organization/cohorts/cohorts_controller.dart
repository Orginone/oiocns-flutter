import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/api/hub/chat_server.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/routers.dart';

import '../../../../api/cohort_api.dart';
import '../../../../api_resp/target.dart';

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

  var messageController = Get.find<MessageController>();

  int? limit;
  int? offset;
  String? filter;

  List<Target> cohorts = [];

  @override
  void onInit() {
    super.onInit();
    onLoad();
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

  cohortFunc(CohortFunction func, Target cohort) async {
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

        String msgBody = "${auth.userInfo.name}退出了群聊";
        await chatServer.send(
          spaceId: cohort.belongId!,
          itemId: cohort.id,
          msgBody: msgBody,
          msgType: MsgType.exitCohort,
        );
        break;
      case CohortFunction.create:
        break;
    }
  }
}
