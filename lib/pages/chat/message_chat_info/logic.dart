import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/toast_utils.dart';

import 'state.dart';

class MessageChatInfoController extends BaseController<MessageChatInfoState> {
  @override
  final MessageChatInfoState state = MessageChatInfoState();

  void jumpQr() {
    Get.toNamed(
      Routers.shareQrCode,
      arguments: {"entity": (state.chat as ITarget).metadata},
    );
  }

  void jumpMessage() {
    state.chat.onMessage((messages) {});
    Get.offAndToNamed(Routers.messageChat, arguments: state.chat);
  }

  void addPerson() async {
    if (null != relationCtrl.user) {
      var id = state.chat.chatdata.value.fullId.split('-').last;
      XEntity? entity = await relationCtrl.user!.findEntityAsync(id);
      if (entity != null) {
        List<XTarget> target = await relationCtrl.user!
            .searchTargets(entity.code!, [entity.typeName!]);
        if (target.isNotEmpty) {
          var success = await relationCtrl.user!.applyJoin(target);
          if (success) {
            ToastUtils.showMsg(msg: "申请发送成功");
          } else {
            ToastUtils.showMsg(msg: "申请发送失败");
          }
        } else {
          ToastUtils.showMsg(msg: "获取用户失败");
        }
      } else {
        ToastUtils.showMsg(msg: "获取用户失败");
      }
    } else {
      ToastUtils.showMsg(msg: "用户信息异常，请重新登陆");
    }
  }
}
