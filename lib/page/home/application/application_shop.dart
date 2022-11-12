import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/choose_item.dart';
import 'package:orginone/component/icon_avatar.dart';
import 'package:orginone/component/text_search.dart';
import 'package:orginone/component/text_tag.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/util/widget_util.dart';

class ApplicationShopPage extends GetView<ApplicationShopController> {
  const ApplicationShopPage({Key? key}) : super(key: key);

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
            searchingCallback: controller.searchingCallback,
            bgColor: Colors.white,
            hasSearchIcon: false,
            type: SearchType.dropdown,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                _item(),
                _item(),
                _item(),
                _item(),
                _item(),
                _item(),
                _item(),
                _item(),
                _item(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _item() {
    return ChooseItem(
      bgColor: Colors.white,
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
      header: Column(
        children: [
          IconAvatar(
            width: 64.w,
            radius: 20.w,
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.group, color: Colors.white),
          ),
          Padding(padding: EdgeInsets.only(top: 10.h)),
          Text("V.1.0.3", style: AFont.instance.size12Black9),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("资产监管", style: AFont.instance.size14Black3W500),
          Padding(padding: EdgeInsets.only(top: 10.h)),
          Text(
            "此处显示应用描述描应用描描此处显示应用描述描应用描描此处显示应"
            "此处显示应用描述描应用描描此处显示应用描述描应用描描此处显示应"
            "此处显示应用描述描应用描描此处显示应用描述描应用描描此处显示应"
            "此处显示应用描述描应用描描此处显示应用描述描应用描描此处显示应",
            overflow: TextOverflow.ellipsis,
            style: AFont.instance.size12Black9,
            maxLines: 3,
          ),
        ],
      ),
      operate: Wrap(
        children: [
          Padding(padding: EdgeInsets.only(left: 10.w)),
          TextTag(
            "加入购物车",
            borderColor: UnifiedColors.themeColor,
            bgColor: Colors.white,
            padding: EdgeInsets.all(5.w),
            textStyle: AFont.instance.size12themeColor,
          ),
          Padding(padding: EdgeInsets.only(left: 10.w)),
          TextTag(
            "获取",
            borderColor: UnifiedColors.themeColor,
            bgColor: Colors.white,
            padding: EdgeInsets.all(5.w),
            textStyle: AFont.instance.size12themeColor,
          ),
        ],
      ),
      func: () {},
    );
  }
}

class ApplicationShopController extends GetxController {
  searchingCallback() {}
}

class ApplicationShopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApplicationShopController());
  }
}
