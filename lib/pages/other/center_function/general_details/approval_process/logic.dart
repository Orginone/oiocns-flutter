import 'package:get/get.dart';

import '../../../../../../dart/core/getx/base_controller.dart';
import 'bottom_dialog.dart';
import 'state.dart';


class ApprovalProcessController extends BaseController<ApprovalProcessState> {
 final ApprovalProcessState state = ApprovalProcessState();

  void showDetails() {
   ApprovalBottomDialog.showDialog(context);
  }
}
