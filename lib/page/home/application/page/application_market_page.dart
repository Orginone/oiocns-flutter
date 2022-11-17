import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/text_search.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/page/home/application/applicatino_controller.dart';
import 'package:orginone/util/widget_util.dart';

class ApplicationMarketPage extends GetView<ApplicationController> {
  const ApplicationMarketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("市场", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      bgColor: UnifiedColors.navigatorBgColor,
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
    return Container();
  }
}
