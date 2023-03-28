import 'package:get/get.dart';
import 'package:orginone/pages/other/thing/network.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';


class ThingController extends BaseController<ThingState> {
 final ThingState state = ThingState();


  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);
    state.things.value = await ThingNetWork.getThing(state.id);
    LoadingDialog.dismiss(context);
  }
}
