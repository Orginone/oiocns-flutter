import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/widget/a_font.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/pages/todo/work_page.dart';

/// 办事-工作台
class WorkbenchPage extends GetView<WorkController>{
  const WorkbenchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: XColors.white,
      child: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: _getItems(),
          ),
          Positioned(
            bottom: 30.h,
            right: 30.h,
            child: SizedBox(
              width: 50.h,
              height: 50.h,
              child: GFButton(
                text: "+",
                textStyle: TextStyle(
                  color: XColors.white,
                  fontSize: 40.sp,
                ),
                onPressed: () {
                  controller.createInstance();
                },
                borderShape: const CircleBorder(),
              ),
            ),
          )
        ],
      ),
    );
  }


  List<Widget> _getItems() {
    List<Widget> children = [];
    controller.mData.forEach((key, value) {
      children.add(CardChildWidget(key, value));
    });
    return children;
  }

}

class CardChildWidget extends StatelessWidget {
  final String itemName;
  final List value;

  const CardChildWidget(this.itemName, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _cardTitle(itemName),
        SizedBox(
          height: 12.h,
        ),
        GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 20.h, bottom: 0.h),
            shrinkWrap: true,
            itemCount: value.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if(value[index]["func"] != null){
                    value[index]["func"]();
                  }
                },
                child: Column(
                  children: [
                    Container(
                        width: 64.w,
                        height: 64.w,
                        color: XColors.navigatorBgColor),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      value[index]['name'],
                      style: AFont.instance.size18Black6,
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }

  Widget _cardTitle(String title) {
    if (title.startsWith('_')) {
      return Divider(
        height: 2.h,
        color: XColors.lineLight,
      );
    }
    return Padding(
      padding: EdgeInsets.only(left: 12.w, top: 15.h),
      child: Text(
        itemName,
        style: AFont.instance.size24Black3W500,
      ),
    );
  }
}
/*

class WorkbenchController extends BaseController with GetSingleTickerProviderStateMixin{

  Map<String, dynamic> mData = {};
  late List<TabCombine> mTabs;
  late TabController mTabController;

  @override
  void onInit() {
    super.onInit();
    mData = getCards();
    mTabController = TabController(length: 3, vsync: this);
    mTabs = getTabs(mTabController);
  }

  @override
  void dispose() {
    super.dispose();
    mTabController.dispose();
  }
}

class WorkbenchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WorkbenchController());
  }
}*/
