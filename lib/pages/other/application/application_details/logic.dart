import 'package:get/get.dart';
import 'package:orginone/pages/other/home/ware_house/recently_opened_controller.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ApplicationDetailsController extends BaseController<ApplicationDetailsState> {
 final ApplicationDetailsState state = ApplicationDetailsState();


 RecentlyOpenedController get roController => Get.find<RecentlyOpenedController>(tag: "RecentlyOpenedPage");
  void addCommon() {
   roController.addRecentlyApp(state.product);
  }
}
