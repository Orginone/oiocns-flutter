import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/api_resp/merchandise_entity.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/refresh_body.dart';
import 'package:orginone/component/text_search.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/controller/market/merchandise_controller.dart';
import 'package:orginone/controller/market/staging_controller.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/core/ui/market/merchandise_item_widget.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/widget_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MerchandisePage extends StatelessWidget {
  const MerchandisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("商城", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: _body,
      appBarActions: _actions,
    );
  }

  get _actions => <Widget>[_shoppingCart];

  get _shoppingCart {
    var stagingController = Get.find<StagingController>();
    return GestureDetector(
      onTap: () => Get.toNamed(Routers.staging),
      child: SizedBox(
        width: 64.w,
        height: 64.w,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Obx(() {
                var total = stagingController.total;
                var value = total.value;
                return value == 0
                    ? Container()
                    : GFBadge(
                        color: UnifiedColors.backColor,
                        child: Text("${value > 99 ? "99+" : value}"),
                      );
              }),
            ),
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.shopping_cart,
                color: UnifiedColors.black3,
                size: 32.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  get _body {
    var merchandiseController = Get.find<MerchandiseController>();
    return Container(
      color: UnifiedColors.navigatorBgColor,
      child: Column(
        children: [
          TextSearch(
            margin: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 20.h,
              bottom: 20.h,
            ),
            searchingCallback: merchandiseController.search,
            bgColor: Colors.white,
            hasSearchIcon: false,
            type: SearchType.dropdown,
          ),
          Expanded(child: _refreshBody),
        ],
      ),
    );
  }

  get _refreshBody {
    var merchandiseCtrl = Get.find<MerchandiseController>();
    var refreshCtrl = RefreshController();
    return Obx(() => RefreshBody(
        refreshCtrl: refreshCtrl,
        onRefresh: () async => await merchandiseCtrl.onLoad(),
        onLoading: () async => await merchandiseCtrl.loadMore(),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: merchandiseCtrl.getSize(),
          itemBuilder: (BuildContext context, int index) {
            return merchandiseCtrl.mapping(index, _item);
          },
        )));
  }

  Widget _item(MerchandiseEntity merchandise) {
    /// 获取归属名称
    var messageCtrl = Get.find<MessageController>();
    var orgChatCache = messageCtrl.orgChatCache;
    var nameMap = orgChatCache.nameMap;
    var belongId = merchandise.product.belongId;

    var stagingController = Get.find<StagingController>();
    return MerchandiseItemWidget(
      merchandise: merchandise,
      belongName: nameMap[belongId] ?? "",
      addStagingCall: (MerchandiseEntity m) => stagingController
          .staging(m.id)
          .then((value) => Fluttertoast.showToast(msg: "添加成功!")),
    );
  }
}
