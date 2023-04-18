import 'package:get/get.dart';
import 'package:orginone/event/tap_navigator.dart';
import 'package:orginone/util/event_bus_helper.dart';

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

  void selectItem(NavigatorModel item) {
   EventBusHelper.fire(TapNavigator(item));
  }
}
