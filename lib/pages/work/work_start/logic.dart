import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/work/index.dart';
import 'package:orginone/main.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class WorkStartController extends BaseController<WorkStartState>
    with GetTickerProviderStateMixin {
  final WorkStartState state = WorkStartState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
  }

  void createWork(IWork work) async {
    WorkNodeModel? node = await work.loadWorkNode();
    if (node != null && node.forms != null && node.forms!.isNotEmpty) {
      Get.toNamed(Routers.createWork,
          arguments: {"work": work, "node": node, 'target': state.target});
    } else {
      ToastUtils.showMsg(msg: "流程未绑定表单");
    }
  }

  void operation(String key, IWork define) {
    if(key == 'set'){
      settingCtrl.work.setMostUsed(define);
    }else if(key == 'remove'){
      settingCtrl.work.removeMostUsed(define);
    }
  }
}
