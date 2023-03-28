import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/model/thing_model.dart';
import 'package:orginone/pages/other/thing/thing_details/logic.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'network.dart';
import 'state.dart';

class UseTracesController extends BaseController<UseTracesState> {
 final UseTracesState state = UseTracesState();

 var detailsController = Get.find<ThingDetailsController>();

 ThingModel get thing => detailsController.state.thing;

 @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);
    state.archives.value = await UseTracesNetWork.getThingArchives(thing.id??"");
    if(state.archives.value == null){
      ToastUtils.showMsg(msg: '未查到相关数据');
    }
    if(state.archives.value?.archives?.isEmpty??false){
      ToastUtils.showMsg(msg: '历史数据为空');
    }
    LoadingDialog.dismiss(context);
  }

}
