import 'package:get/get.dart';

import '../../dart/core/getx/base_controller.dart';
import 'state.dart';

class UniversalNavigatorController extends BaseController<UniversalNavigatorState> {
 final UniversalNavigatorState state = UniversalNavigatorState();

  void back() {
   Get.back();
  }

 void selectGroup(NavigatorModel item) {
  state.selectedData.add(item);
 }

  void removeGroup(index) {

  }

  void selectItem(NavigatorModel item) {}
}
