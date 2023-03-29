import 'package:get/get.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ApproveDocumentsController extends BaseController<ApproveDocumentsState> {
 final ApproveDocumentsState state = ApproveDocumentsState();

  void showMore() {
   state.showMore.value = !state.showMore.value;
  }
}
