import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';

import 'state.dart';

class ProcessDetailsController extends BaseController<ProcessDetailsState> {
 final ProcessDetailsState state = ProcessDetailsState();

  void showAllProcess() {
   state.hideProcess.value = false;
  }
}
