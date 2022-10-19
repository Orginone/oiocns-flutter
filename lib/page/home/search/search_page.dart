import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/tabs/gf_tabbar.dart';
import 'package:getwidget/components/tabs/gf_tabbar_view.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/page/home/search/unit_result_page.dart';

import '../../../../util/widget_util.dart';
import '../../../component/text_search.dart';
import '../../../config/custom_colors.dart';
import 'search_controller.dart';

class SearchPage extends GetView<SearchController> {
  const SearchPage({Key? key}) : super(key: key);

  Widget _tabBar(BuildContext context) {
    List<Widget> tabs = controller.searchItems
        .map((item) => Text(item.name, style: text12))
        .toList();

    return GFTabBar(
        width: 1000,
        tabBarHeight: 40,
        indicatorColor: Colors.blueAccent,
        tabBarColor: CustomColors.easyGrey,
        length: controller.tabController.length,
        controller: controller.tabController,
        tabs: tabs);
  }

  Widget _tabView() {
    return GFTabBarView(
      height: 400,
      controller: controller.tabController,
      children: controller.searchItems
          .map((item) => Container(
                alignment: Alignment.center,
                child: Text(item.name),
              ))
          .toList(),
    );
  }

  Widget _friendsResultPage() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    bool isMultiple = controller.searchItems.length > 1;
    bool isSingle = controller.searchItems.length == 1;
    Widget? body;
    if (isMultiple) {
      body = Column(
        children: [_tabBar(context), _tabView()],
      );
    } else if (isSingle) {
      SearchItem searchItem = controller.searchItems[0];
      switch (searchItem) {
        case SearchItem.friends:
          body = _friendsResultPage();
          break;
        case SearchItem.applications:
          break;
        case SearchItem.comprehensive:
          break;
        case SearchItem.cohorts:
          break;
        case SearchItem.messages:
          break;
        case SearchItem.documents:
          break;
        case SearchItem.logs:
          break;
        case SearchItem.labels:
          break;
        case SearchItem.functions:
          break;
        case SearchItem.departments:
          break;
        case SearchItem.publicCohorts:
          break;
        case SearchItem.units:
          body = const UnitResultPage();
          break;
      }
    } else {
      body = Container();
    }

    return UnifiedScaffold(
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarTitle: TextSearch(
          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          controller.searchingCallback),
      body: body,
    );
  }
}
