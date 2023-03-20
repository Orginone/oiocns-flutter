import 'dart:convert';

import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/pages/other/work/network.dart';
import 'package:orginone/util/common_tree_management.dart';

import 'state.dart';

class ProcessDetailsController extends BaseController<ProcessDetailsState> {
  final ProcessDetailsState state = ProcessDetailsState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();

    state.flowInstacne =
        await WorkNetWork.getFlowInstance(id: state.task.instanceId ?? "");
    await loadDataInfo();

  }

  void showAllProcess() {
    state.hideProcess.value = false;
  }

  Future<void> loadDataInfo() async {
    Map<String, dynamic> data = jsonDecode(state.task.flowInstance?.data ?? "");
    if (data.isEmpty || state.flowInstacne == null) {
      return;
    }
    for (var element in state.flowInstacne!.flowTaskHistory!) {
      for (var bindOperation in element.flowNode!.bindOperations!) {
        Map<String, Map<XAttribute, dynamic>> bindOperationInfo = {bindOperation.name!: {}};
        for (var key in data.keys) {
          XAttribute? x = await CommonTreeManagement().findXAttribute(
              specieId: bindOperation.speciesId ?? "", attributeId: key);
          if (x != null) {
            bindOperationInfo[bindOperation.name!]!.addAll({x: data[key]});
          }
        }
        state.xAttribute.addAll(bindOperationInfo);
      }
    }
  }
}
