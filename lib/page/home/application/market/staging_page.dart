import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/api_resp/staging_entity.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/market/staging_item_widget.dart';
import 'package:orginone/component/refresh_body.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/controller/market/staging_controller.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/public/dialog/dialog_confirm.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/widget_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StagingPage extends StatelessWidget {
  const StagingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("购物车", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: _refreshBody,
      appBarActions: _actions(context),
    );
  }

  List<Widget> _actions(BuildContext context) {
    var stagingCtrl = Get.find<StagingController>();
    return [
      IconButton(
        onPressed: () {
          stagingCtrl.deleteStagings();
        },
        icon: const Icon(Icons.delete_outline, color: Colors.black),
      ),
      IconButton(
        onPressed: () {
          if (stagingCtrl.selectedSize() == 0) {
            Fluttertoast.showToast(msg: "");
            return;
          }
          showAnimatedDialog(
            context: context,
            barrierDismissible: false,
            animationType: DialogTransitionType.fadeScale,
            builder: (BuildContext context) {
              return DialogConfirm(
                title: "提示",
                content: "此操作将生成操作订单, 是否确认？",
                confirmFun: () async {
                  Navigator.of(context).pop();
                  Get.toNamed(Routers.order);
                  stagingCtrl.buy().then((value) {
                    Fluttertoast.showToast(msg: "创建成功!");
                    Get.toNamed(Routers.order);
                  });
                },
              );
            },
          );
        },
        icon: const Icon(Icons.add, color: Colors.black),
      )
    ];
  }

  get _refreshBody {
    var stagingCtrl = Get.find<StagingController>();
    var refreshCtrl = RefreshController();
    return Container(
        color: UnifiedColors.navigatorBgColor,
        child: Obx(() => RefreshBody(
              refreshCtrl: refreshCtrl,
              onRefresh: () async => stagingCtrl.onLoad(),
              onLoading: () async => stagingCtrl.loadMore(),
              body: ListView.builder(
                  itemCount: stagingCtrl.getSize(),
                  itemBuilder: (BuildContext context, int index) {
                    return stagingCtrl.mapping(index, _item);
                  }),
            )));
  }

  Widget _item(StagingEntity staging) {
    var messageCtrl = Get.find<MessageController>();
    var orgChatCache = messageCtrl.orgChatCache;
    var stagingCtrl = Get.find<StagingController>();

    return StagingItemWidget(
      staging: staging,
      belongName: orgChatCache.nameMap[staging.belongId],
      onSelected: stagingCtrl.onSelected,
      selected: stagingCtrl.has(staging.id) ? true.obs : false.obs,
    );
  }
}
