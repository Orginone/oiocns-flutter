
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/template/originone_scaffold.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/pages/todo/work_page.dart';

class TodoTabPage extends StatefulWidget {
  const TodoTabPage({Key? key}) : super(key: key);

  @override
  State<TodoTabPage> createState() => _TodoTabPageState();
}

class _TodoTabPageState extends State<TodoTabPage> with AutomaticKeepAliveClientMixin  {

  late final int _index;
  _TodoTabPageState(){
    _index = Get.arguments["index"];
  }
  @override
  Widget build(BuildContext context) {
    return OrginoneScaffold(
        bgColor: Colors.white,
        body: AffairsTab(_index),
        resizeToAvoidBottomInset: false);
  }

  @override
  bool get wantKeepAlive => true;
}



class AffairsTab extends GetView<WorkController> {
  final int index;
  const AffairsTab(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _tabBar(),
        _line(),
        _content(),
      ],
    );
  }

  Widget _tabBar() {
    return GetBuilder<WorkController>(
        init: controller,
        builder: (controller) {
          return Container(
            color: XColors.white,
            child: SizedBox(
              height: 60.h,
              child: TabBar(
                controller: controller.tabController,
                tabs: controller.mTabs.map((item) => item.body!).toList(),
              ),
            ),
          );
        });
  }

  Widget _tabBarItem(String title, {bool showRightImage = true}) {
    return Tab(
        child: Container(
          color: Colors.yellow,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                color: Colors.red,
                child: Center(
                  child: Text(title),
                ),
              ),

              ///分割符自定义，可以放任何widget
              showRightImage
                  ? Container(
                width: 1.w,
                height: 30.h,
                color: XColors.lineLight2,
              )
                  : Container(
                  width: 1.w, height: 30.h, color: XColors.transparent)
            ],
          ),
        ));
  }

  _content() {
    return Expanded(
      flex: 1,
      child: TabBarView(
        controller: controller.tabController,
        children: controller.mTabs.map((item) => item.tabView).toList(),
      ),
    );
  }

  _line() {
    return Divider(
      height: 1.h,
      color: XColors.lineLight,
    );
  }
}
//
// class TodoListBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => WorkController());
//   }
// }