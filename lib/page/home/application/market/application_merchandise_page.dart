import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/api_resp/merchandise_entity.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/market/merchandise_item_widget.dart';
import 'package:orginone/component/text_search.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/controller/application_merchandise_controller.dart';
import 'package:orginone/util/widget_util.dart';

class ApplicationMerchandisePage
    extends GetView<ApplicationMerchandiseController> {
  const ApplicationMerchandisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("商城", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: _body(),
    );
  }

  Widget _body() {
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
            searchingCallback: controller.search,
            bgColor: Colors.white,
            hasSearchIcon: false,
            type: SearchType.dropdown,
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.getSize(),
                itemBuilder: (BuildContext context, int index) {
                  return controller.mapping(index, _item);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(MerchandiseEntity merchandise) {
    var messageController = controller.messageController;
    var orgChatCache = messageController.orgChatCache;
    return MerchandiseItemWidget(
      merchandise: merchandise,
      belongName: orgChatCache.nameMap[merchandise.product.belongId],
    );
  }
}

class ApplicationMerchandiseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApplicationMerchandiseController());
  }
}
