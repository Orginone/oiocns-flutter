import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/template/originone_scaffold.dart';
import 'package:orginone/components/template/tabs.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/pages/chat/message_page.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/pages/other/home/components/user_bar.dart';
import 'package:orginone/pages/setting/set_home_page.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/load_image.dart';
import 'package:orginone/util/sys_util.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SysUtil.setStatusBarBright();
    return OrginoneScaffold(
      resizeToAvoidBottomInset: false,
      appBarElevation: 0,
      appBarHeight: 0,
      body: Tabs(
        tabCtrl: controller.tabController,
        top: const UserBar(),
        views: controller.tabs.map((e) => e.toTabView()).toList(),
        bottom: TabBar(
          controller: controller.tabController,
          tabs: controller.tabs.map((item) => item.toTab()).toList(),
        ),
      ),
    );
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}

class HomeController extends TabsController {
  @override
  initTabs() {
    var size = Size(32.w, 32.w);
    registerTab(
      XTab(
        customTab: SizedBox(
          width: 200.w,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Tab(
                  iconMargin: const EdgeInsets.all(4),
                  icon: XImage.localImage("chat", size: Size(38.w, 32.w)),
                  child: Text("沟通", style: XFonts.size14Black3),
                ),
              ),
            ],
          ),
        ),
        view: const MessagePage(),
      ),
    );
    registerTab(XTab(
      body: Text('办事', style: XFonts.size14Black3),
      view: Container(),
      icon: XImage.localImage("work", size: size),
    ));
    var center = XTab(
      body: XImage.localImage("logo_not_bg", size: Size(36.w, 36.w)),
      view:  GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        crossAxisCount: 5,
        childAspectRatio: 80 / 100,
        children: items.map((item){
          Color iconColor = Colors.black;

          return GestureDetector(
            onTap: (){
              Get.toNamed(Routers.centerFunction,arguments: {"info":item});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40.w)),
                    color: Colors.white,
                  ),
                  child:Icon(Icons.transform, color: iconColor),
                ),
                Container(
                  margin: EdgeInsets.only(top: 6.5.w),
                  child: Text(item.name, style:XFonts.size12Black3),
                ),
              ],
            ),
          );
        }).toList(),
      ),
      iconMargin: EdgeInsets.zero,
    );
    registerTab(center);
    registerTab(XTab(
      body: Text('仓库', style: XFonts.size14Black3),
      view: Container(),
      icon: XImage.localImage("warehouse", size: size),
    ));
    registerTab(XTab(
      body: Text('设置', style: XFonts.size14Black3),
      view: SetHomePage(),
      icon: XImage.localImage("setting", size: size),
    ));
    setIndex(tabs.indexOf(center));
  }
}


class CenterItem {
  final String name;
  final String iconUrl;
  final AssetsType type;

  CenterItem(this.name, this.iconUrl, this.type);
}


final List<CenterItem> items = [
  CenterItem("我的资产", "", AssetsType.myAssets),
  CenterItem("资产申领", "", AssetsType.claim),
  CenterItem("资产盘点", "", AssetsType.check),
  CenterItem("资产处置", "", AssetsType.dispose),
  CenterItem("资产移交", "", AssetsType.transfer),
  CenterItem("资产交回", "", AssetsType.handOver),
];