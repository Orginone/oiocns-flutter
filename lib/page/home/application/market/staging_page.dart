import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/api_resp/staging_entity.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/market/staging_item_widget.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/controller/market/staging_controller.dart';
import 'package:orginone/page/home/message/message_controller.dart';
import 'package:orginone/util/widget_util.dart';

class StagingPage extends StatelessWidget {
  const StagingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("购物车", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: _body,
    );
  }

  get _body {
    var stagingCtrl = Get.find<StagingController>();
    return Container(
      color: UnifiedColors.navigatorBgColor,
      child: Obx(() => ListView.builder(
            shrinkWrap: true,
            itemCount: stagingCtrl.getSize(),
            itemBuilder: (BuildContext context, int index) {
              return stagingCtrl.mapping(index, _item);
            },
          )),
    );
  }

  Widget _item(StagingEntity staging) {
    var messageController = Get.find<MessageController>();
    var orgChatCache = messageController.orgChatCache;
    return StagingItemWidget(
      staging: staging,
      belongName: orgChatCache.nameMap[staging.belongId],
    );
  }
}
