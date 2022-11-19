import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/api_resp/market_entity.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/choose_item.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/component/text_search.dart';
import 'package:orginone/component/text_tag.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/logic/authority.dart';
import 'package:orginone/page/home/application/application_market_controller.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/string_util.dart';
import 'package:orginone/util/widget_util.dart';

class ApplicationMarketPage extends GetView<ApplicationMarketController> {
  const ApplicationMarketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("市场", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      bgColor: UnifiedColors.navigatorBgColor,
      body: _body(),
      appBarActions: _actions,
    );
  }

  /// 按钮
  get _actions => <Widget>[
        IconButton(
          onPressed: () {
            Map<String, dynamic> args = {"func": ApplicationMarketFunc.create};
            Get.toNamed(Routers.applicationMarketMaintain, arguments: args);
          },
          icon: const Icon(Icons.create_outlined, color: Colors.black),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add, color: Colors.black),
        ),
      ];

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
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.data.length,
                itemBuilder: (context, index) {
                  return _item(controller.data[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(MarketEntity market) {
    List<Widget> list = [];
    if (market.id != controller.soft.id) {
      if (market.public ?? false) {
        var tag = TextTag(
          "私有",
          padding: EdgeInsets.only(
            top: 6.w,
            bottom: 6.w,
            left: 10.w,
            right: 10.w,
          ),
        );
        list.add(tag);
        list.add(Padding(padding: EdgeInsets.only(bottom: 10.h)));
      }
      String name;
      if (auth.isUserSpace()) {
        name = auth.userId == market.belongId ? "创建的" : "加入的";
      } else {
        name = auth.spaceId == market.belongId ? "创建的" : "加入的";
      }
      var tag = TextTag(
        name,
        padding: EdgeInsets.only(
          top: 6.w,
          bottom: 6.w,
          left: 10.w,
          right: 10.w,
        ),
      );
      list.add(tag);
      list.add(Padding(padding: EdgeInsets.only(bottom: 10.h)));
    }
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) async {
              await controller.delete(market.id);
              Fluttertoast.showToast(msg: "删除市场成功");
            },
            backgroundColor: UnifiedColors.backColor,
            icon: Icons.delete,
            label: '刪除',
          ),
        ],
      ),
      child: ChooseItem(
        bgColor: Colors.white,
        padding: EdgeInsets.all(20.w),
        header: TextAvatar(
          avatarName: StringUtil.getPrefixChars(market.name, count: 1),
          width: 64.w,
          radius: 20.w,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(market.name, style: AFont.instance.size16Black0W500),
                Padding(padding: EdgeInsets.only(left: 10.w)),
                Text("归属:-", style: AFont.instance.size14Black6),
                Padding(padding: EdgeInsets.only(left: 10.w)),
                Text("编码:${market.code}", style: AFont.instance.size14Black6),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.h)),
            Text(
              market.remark,
              overflow: TextOverflow.ellipsis,
              style: AFont.instance.size12Black9,
              maxLines: 3,
            ),
          ],
        ),
        operate: Wrap(
          children: [
            Padding(padding: EdgeInsets.only(left: 10.w)),
            Column(children: list)
          ],
        ),
        func: () {
          Get.toNamed(Routers.applicationShop);
        },
      ),
    );
  }
}

class ApplicationMarketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApplicationMarketController());
  }
}
