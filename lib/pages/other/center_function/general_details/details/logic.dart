import 'package:get/get.dart';
import 'package:orginone/pages/other/center_function/assets_check/check/network.dart';
import 'package:orginone/pages/other/center_function/assets_check/check/state.dart';
import 'package:orginone/pages/other/center_function/general_details/logic.dart';

import '../../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class DetailsController extends BaseController<DetailsState> {
  final DetailsState state = DetailsState();

  GeneralDetailsController get detailsController =>
      Get.find<GeneralDetailsController>();

  void inventory(CheckType type) {
    CheckNetwork.performInventory(
      status: type == CheckType.saved ? 1 : 2,
      code: detailsController.state.assets!.assetCode ?? "",
    );
   Get.back();
  }
}
