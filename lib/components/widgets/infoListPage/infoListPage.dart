/*
 * @Descripttion: 
 * @version: 
 * @Author: 
 * @Date: 
 */
import 'package:flutter/material.dart';
import 'package:orginone/common/routers/pages.dart';
import 'package:orginone/components/widgets/infoListPage/tabPage.dart';
import 'package:orginone/components/widgets/system/gy_scaffold.dart';

import 'index.dart';
import 'infoTabsController.dart';

/// 移动端列表信息页面
class InfoListPage extends StatefulWidget {
  ///信息列表页签模型
  InfoListPageModel infoListPageModel;
  final List<Widget> Function()? getActions;

  InfoListPage(this.infoListPageModel, {super.key, this.getActions});

  @override
  InfoListPageState createState() => InfoListPageState();
}

class InfoListPageState extends State<InfoListPage> {
  late InfoListPageController infoListPageController;

  ///活跃页签
  TabItemsModel? activeTab;

  ///页签控制器
  TabController? tabController;
  late bool showHeader = false;
  dynamic datas;

  @override
  void initState() {
    super.initState();
    infoListPageController = InfoListPageController(this);
    datas = RoutePages.getRouteTitle();
    showHeader = null != datas;
  }

  @override
  Widget build(BuildContext context) {
    // final ancestorState = context.findAncestorStateOfType<InfoListPageState>();
    // LogUtil.d('>>>>>>======$ancestorState');

    return GyScaffold(
      toolbarHeight: showHeader ? null : 0,
      titleWidget: showHeader ? _header() : null,
      centerTitle: false,
      operations: widget.getActions?.call(),
      body: Container(
        color: Colors.white,
        child: TabPage(widget.infoListPageModel),
      ),
    );
  }

  ///页面顶部标题栏
  Widget _header() {
    return Text(
      datas ?? widget.infoListPageModel.title,
      style: const TextStyle(color: Colors.black),
    ); //const UserBar();
  }
}
