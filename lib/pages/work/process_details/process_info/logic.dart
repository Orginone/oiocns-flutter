import 'package:get/get.dart';
import 'package:orginone/pages/work/network.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ProcessInfoController extends BaseController<ProcessInfoState> {
  final ProcessInfoState state = ProcessInfoState();

  void approval(int status) async {
    await WorkNetWork.approvalTask(
        status: status,
        comment: state.comment.text, todo: state.todo,
        onSuccess: () {
          Get.back();
        }
      );
  }
}
