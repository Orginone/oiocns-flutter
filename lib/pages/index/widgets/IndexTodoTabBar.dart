import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/images.dart';
import 'package:orginone/pages/index/HorizontalScrollMenu/MyMenuItem.dart';
import 'package:orginone/pages/index/index_page.dart';
import 'package:orginone/pages/index/widgets/dataMonitoring.dart';
import 'package:orginone/widget/keep_alive_widget.dart';

import '../../../dart/core/getx/base_controller.dart';
import '../../../dart/core/getx/base_get_view.dart';
import '../../index/index_page.dart';

class IndexTodoTabBarWidget
    extends BaseGetPageView<FunctionController, FunctionState> {
  @override
  Widget buildView() {
    return ListView(children: <Widget>[
      Container(
        width: 110, // 设置宽度
        height: 110, // 设置高度
        child: Column(
          children: [
            tabBar(),
            Expanded(
              child: TabBarView(
                controller: state.tabController,
                children: [
                  Center(
                    child: CustomRow(
                        firstText: "11",
                        secondText: "22",
                        thirdText: "33",
                        fourthText: "44"),
                  ),
                  Container(),
                  Container(),
                  Container(),
                ],
              ),
            )
          ],
        ),
      ),
      Container(
          decoration: BoxDecoration(
              color: XColors.white, borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            height: 12.h,
          )),
      Container(
          decoration: BoxDecoration(
              color: XColors.white, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
          alignment: Alignment.topLeft,
          child: const Text("快捷入口")),
      Container(
          decoration: BoxDecoration(
              color: XColors.white, borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            height: 12.h,
          )),
      MyHorizontalMenu(),
    ]);
  }

  @override
  FunctionController getController() {
    return FunctionController();
  }

  Widget tabBar() {
    return Container(
        width: 320,
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: state.tabController,
                  tabs: tabTitle.map((e) {
                    return Tab(
                      text: e,
                      height: 50.h,
                    );
                  }).toList(),
                  indicatorColor: XColors.themeColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  unselectedLabelColor: Colors.grey,
                  unselectedLabelStyle: TextStyle(fontSize: 18.sp),
                  labelColor: XColors.themeColor,
                  labelStyle: TextStyle(fontSize: 21.sp),
                  isScrollable: true,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.more_vert,
                  )),
            ),
          ],
        ));
  }

  @override
  String tag() {
    // TODO: implement tag
    return this.toString();
  }
}

class FunctionController extends BaseController<FunctionState>
    with GetTickerProviderStateMixin {
  final FunctionState state = FunctionState();
  FunctionController() {
    state.tabController = TabController(length: tabTitle.length, vsync: this);
  }
}

class FunctionState extends BaseGetState {
  late TabController tabController;
}

// TODO 单位管理员显示控制台
const List<String> tabTitle = ["待办", "已办", "已完结", "我发起的"];

// CustomRow 组件
class CustomRow extends StatefulWidget {
  final String firstText;
  final String secondText;
  final String thirdText;
  final String fourthText;

  CustomRow({
    Key? key,
    required this.firstText,
    required this.secondText,
    required this.thirdText,
    required this.fourthText,
  }) : super(key: key);

  @override
  _CustomRowState createState() => _CustomRowState();
}

class _CustomRowState extends State<CustomRow> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 280,
      height: 50,
      child: Row(
        children: [
          _buildCell(widget.firstText),
          _buildCell(widget.secondText),
          _buildCell(widget.thirdText),
          _buildCell(widget.fourthText),
        ],
      ),
    ));
  }

  Widget _buildCell(String text) {
    return Container(
      width: 70,
      height: 40,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 40,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
