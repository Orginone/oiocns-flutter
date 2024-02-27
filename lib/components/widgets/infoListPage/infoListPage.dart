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

  // int getDefaultTabIndex() {
  //   int index = infoListPageController.getTabItems().indexWhere(
  //       (element) => element.title == widget.infoListPageModel.activeTabTitle);
  //   if (index < 0) {
  //     index = 0;
  //   }
  //   return index;
  // }

  // ///页签
  // Widget _tabPage() {
  //   return Expanded(
  //       child: DefaultTabController(
  //     initialIndex: getDefaultTabIndex(),
  //     length: infoListPageController.getTabItems().length,
  //     child: Scaffold(
  //       backgroundColor: Colors.white,
  //       appBar: _tabBar(infoListPageController.getTabItems()),
  //       // TabBar(
  //       //   isScrollable: true,
  //       //   tabs: infoListPageController.getTabItems().map((TabItemsModel tab) {
  //       //     return Tab(text: tab.title);
  //       //   }).toList(),
  //       // ),
  //       body: ExtendedTabBarView(
  //           children: infoListPageController
  //               .getTabItems()
  //               .map((tab) => _content(tab))
  //               .toList()),
  //     ),
  //   ));
  //   // return Column(
  //   //   children: [
  //   //     _tabHeader(),
  //   //     _tabContent(),
  //   //   ],
  //   // );
  //   // ExtendedTabBarView(
  //   //     shouldIgnorePointerWhenScrolling: false,
  //   //     // controller: state.tabController,
  //   //     children: [])
  // }

  // PreferredSizeWidget _tabBar(List<TabItemsModel> tabItems) {
  //   return infoListPageController.hasSubTabPage()
  //       ? _tabItems(tabItems)
  //       : _subTabItems(tabItems);
  // }

  // _tabItems(List<TabItemsModel> tabItems) {
  //   return ExtendedTabBar(
  //     isScrollable: false,
  //     labelColor: XColors.black,
  //     unselectedLabelColor: XColors.black666,
  //     tabs: infoListPageController.getTabItems().map((TabItemsModel tab) {
  //       return Tab(text: tab.title);
  //     }).toList(),
  //   );
  // }

  // _subTabItems(List<TabItemsModel> tabItems) {}

  // ///页签内容
  // Widget _content(TabItemsModel item) {
  //   LogUtil.d(
  //       '>>>>>>======aaa${item.title} ${item.tabItems.length} ${item.content == null}');
  //   return item.content ??
  //       _tabListContent(item) ??
  //       Container(
  //         child: Text(item.title),
  //       );
  // }

  // Widget _tabListContent(TabItemsModel item) {
  //   return Container();
  // }

  // // ///页签项
  // // ExtendedTabBar _tabItems() {
  // //   tabController!.index = infoListPageController.getTabItems().length;
  // //   return ExtendedTabBar(
  // //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  // //       controller: tabController,
  // //       onTap: infoListPageController.changeTab,
  // //       tabs: infoListPageController.getTabItems().map((e) {
  // //         return ExtendedTab(
  // //           scrollDirection: Axis.horizontal,
  // //           height: 30.h,
  // //           child: Container(
  // //             alignment: Alignment.center,
  // //             child: Column(
  // //               children: [
  // //                 Text(
  // //                   e.title,
  // //                   style: TextStyle(
  // //                       color: !infoListPageController.isActiveTab(e)
  // //                           ? XColors.black666
  // //                           : XColors.themeColor,
  // //                       fontSize: 18.sp,
  // //                       fontWeight: !infoListPageController.isActiveTab(e)
  // //                           ? FontWeight.normal
  // //                           : FontWeight.bold),
  // //                 ),
  // //               ],
  // //             ),
  // //           ),
  // //         );
  // //       }).toList(),
  // //       // indicatorColor: XColors.themeColor,
  // //       // unselectedLabelColor: Colors.grey,
  // //       // labelColor: XColors.themeColor,
  // //       // isScrollable: true,
  // //       labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
  // //       indicator: const UnderlineTabIndicator(
  // //           borderSide: BorderSide(width: 2.0, color: XColors.themeColor)));
  // // }

  // // ///页签头部
  // // Widget _tabHeader() {
  // //   return Container(
  // //     decoration: infoListPageController.hasSubTabPage()
  // //         ? null
  // //         : BoxDecoration(
  // //             border: Border(
  // //             bottom: BorderSide(color: Colors.grey.shade400, width: 0.4),
  // //           )),
  // //     child: Container(
  // //       color: Colors.white,
  // //       child: Row(
  // //         children: [
  // //           Expanded(
  // //               child: infoListPageController.hasSubTabPage()
  // //                   ? _tabItems()
  // //                   : _subTabHeader()),
  // //           // IconButton(
  // //           //   onPressed: () {
  // //           //     _showSubTabSettings(infoListPageController.getActiveSubTab());
  // //           //   },
  // //           //   alignment: Alignment.center,
  // //           //   icon: const Icon(
  // //           //     Icons.menu,
  // //           //     color: Colors.black,
  // //           //   ),
  // //           //   iconSize: 24.w,
  // //           //   padding: EdgeInsets.zero,
  // //           // )
  // //         ],
  // //       ),
  // //     ),
  // //   );
  // // }

  // // ///页签内容
  // // Widget _tabContent() {
  // //   // return TabBarView(
  // //   //   key: PageStorageKey<dynamic>(context), // 使用PageStorageKey来保存滚动位置
  // //   //   children: [
  // //   //     Container(color: Colors.red), // 第一个页签，只是一个占位符
  // //   //     Container(color: Colors.green), // 第二个页签，只是一个占位符
  // //   //     Container(color: Colors.blue), // 第三个页签，只是一个占位符
  // //   //   ],
  // //   // );
  // //   return infoListPageController.isShowSubTabPage()
  // //       ? _subTabPage()
  // //       : _content();
  // // }

  // // ///详细内容
  // // Widget _content() {
  // //   return infoListPageController.getActiveTab().content ??
  // //       Container(
  // //         child: Text(infoListPageController.getActiveTab().title),
  // //       );
  // //   // return Container(
  // //   //   color: Colors.yellow,
  // //   //   child: Navigator(
  // //   //       key: Get.nestedKey(1), // create a key by index
  // //   //       initialRoute: '/',
  // //   //       onGenerateRoute: (settings) {
  // //   //         LogUtil.d('>>>>>>======${settings.name}');
  // //   //         if (settings.name == '/second') {
  // //   //           return GetPageRoute(
  // //   //             page: () => const Text("跳转下一页"),
  // //   //             // Scaffold(
  // //   //             //   appBar: AppBar(
  // //   //             //       title: const Text("首页"), backgroundColor: Colors.blue),
  // //   //             //   body: Center(
  // //   //             //     child: ElevatedButton(
  // //   //             //       onPressed: () {
  // //   //             //         Get.toNamed('/second',
  // //   //             //             id: 1); // navigate by your nested route by index
  // //   //             //       },
  // //   //             //       child: const Text("跳转下一页"),
  // //   //             //     ),
  // //   //             //   ),
  // //   //             // ),
  // //   //           );
  // //   //         } else if (settings.name == '/') {
  // //   //           return GetPageRoute(
  // //   //               barrierColor: Colors.black,
  // //   //               page: () => Container(
  // //   //                     color: Colors.red,
  // //   //                     child: const Text("第二页"),
  // //   //                   )
  // //   //               // Center(
  // //   //               //   child: Scaffold(
  // //   //               //     appBar: AppBar(
  // //   //               //         title: const Text("第二页"), backgroundColor: Colors.blue),
  // //   //               //     body: const Center(child: Text("第二页")),
  // //   //               //   ),
  // //   //               // ),
  // //   //               );
  // //   //         }
  // //   //         return null;
  // //   //       }),
  // //   // );
  // // }

  // /// 子页签
  // Widget _subTabPage() {
  //   InfoListPageModel infoListPageModel = InfoListPageModel(
  //       title: infoListPageController.getActiveTab().title,
  //       tabItems: infoListPageController.getActiveTab().tabItems);
  //   return InfoListPage(infoListPageModel);
  //   // return Column(
  //   //   children: [
  //   //     _subTabHeader(),
  //   //     Obx(
  //   //       () => Offstage(
  //   //         offstage: relationCtrl.isConnected.value,
  //   //         child: Container(
  //   //           alignment: Alignment.center,
  //   //           color: XColors.bgErrorColor,
  //   //           padding: EdgeInsets.all(8.w),
  //   //           child: const Row(
  //   //             children: [
  //   //               Icon(Icons.error, size: 18, color: XColors.fontErrorColor),
  //   //               SizedBox(width: 18),
  //   //               Text("当前无法连接网络，可检查网络设置是否正常。",
  //   //                   style: TextStyle(color: XColors.black666))
  //   //             ],
  //   //           ),
  //   //         ),
  //   //       ),
  //   //     ),
  //   //     _subTabContent(),
  //   //   ],
  //   // );
  // }

  // // /// 子页签头部
  // // Widget _subTabHeader() {
  // //   return Container(
  // //     decoration: BoxDecoration(
  // //         border: Border(
  // //       bottom: BorderSide(color: Colors.grey.shade400, width: 0.4),
  // //     )),
  // //     child: Container(
  // //       color: Colors.white,
  // //       child: Row(
  // //         children: [
  // //           Expanded(child: _subTabItems()),
  // //           IconButton(
  // //             onPressed: () {
  // //               // _showSubTabSettings(infoListPageController.getActiveSubTab());
  // //             },
  // //             alignment: Alignment.center,
  // //             icon: const Icon(
  // //               Icons.menu,
  // //               color: Colors.black,
  // //             ),
  // //             iconSize: 24.w,
  // //             padding: EdgeInsets.zero,
  // //           )
  // //         ],
  // //       ),
  // //     ),
  // //   );
  // // }

  // // // /// 子页签内容
  // // // Widget _subTabContent() {
  // // //   return Container();
  // // // }

  // // ///子页签项
  // // ExtendedTabBar _subTabItems() {
  // //   return ExtendedTabBar(
  // //     controller: tabController,
  // //     onTap: infoListPageController.changeTab,
  // //     tabs: infoListPageController.getTabItems().map((e) {
  // //       return ExtendedTab(
  // //         scrollDirection: Axis.horizontal,
  // //         height: 30.h,
  // //         child: Container(
  // //           alignment: Alignment.center,
  // //           padding: EdgeInsets.symmetric(horizontal: 15.w),
  // //           decoration: BoxDecoration(
  // //             borderRadius: BorderRadius.circular(10.w),
  // //             color: infoListPageController.isActiveTab(e)
  // //                 ? Colors.grey[200]
  // //                 : Colors.white,
  // //             border: Border.all(
  // //               width: 1,
  // //               color: infoListPageController.isActiveTab(e)
  // //                   ? Colors.white
  // //                   : Colors.grey[200]!,
  // //             ),
  // //           ),
  // //           child: Text(
  // //             e.title,
  // //             style: TextStyle(
  // //                 color: !infoListPageController.isActiveTab(e)
  // //                     ? XColors.black666
  // //                     : XColors.themeColor,
  // //                 fontSize: 18.sp),
  // //           ),
  // //         ),
  // //       );
  // //     }).toList(),
  // //     indicatorColor: XColors.themeColor,
  // //     unselectedLabelColor: Colors.grey,
  // //     labelColor: XColors.themeColor,
  // //     isScrollable: true,
  // //     labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
  // //     indicator: const UnderlineTabIndicator(),
  // //   );
  // // }

  // ///显示页签设置
  // Future<int?> _showSubTabSettings(ITabModel tabItemsModel) {
  //   return showModalBottomSheet<int?>(
  //       context: context,
  //       backgroundColor: Colors.grey,
  //       constraints: BoxConstraints(maxHeight: 800.h, minHeight: 800.h),
  //       isScrollControlled: true,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(15.w),
  //               topRight: Radius.circular(15.w))),
  //       builder: (context) {
  //         return GyScaffold(
  //           backgroundColor: Colors.grey.shade200,
  //           titleName: "${tabItemsModel.title}分组",
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 // Get.toNamed(Routers.editSubGroup, arguments: {
  //                 //   "subGroup": SubGroup.fromJson(state.subGroup.value.toJson())
  //                 // })?.then((value) {
  //                 //   if (value != null) {
  //                 //     state.subGroup.value = value;
  //                 //     state.subGroup.refresh();
  //                 //     resetTab();
  //                 //   }
  //                 // });
  //               },
  //               child: Text(
  //                 "分组",
  //                 style: TextStyle(fontSize: 24.sp, color: Colors.black),
  //               ),
  //             )
  //           ],
  //           body: Container(
  //               margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
  //               decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(15.w)),
  //               child: ListView.builder(
  //                 shrinkWrap: true,
  //                 itemBuilder: (context, index) {
  //                   var item = tabItemsModel.tabItems[index];
  //                   return Container(
  //                     decoration: BoxDecoration(
  //                         border: Border(
  //                             bottom: BorderSide(
  //                                 color: Colors.grey.shade200, width: 0.5))),
  //                     child: ListTile(
  //                       onTap: () {
  //                         Navigator.pop(context, index);
  //                       },
  //                       title: Text(item.title),
  //                     ),
  //                   );
  //                 },
  //                 itemCount: tabItemsModel.tabItems.length,
  //               )),
  //         );
  //       }).then((value) {
  //     if (value != null) {
  //       // infoListPageController.changeSubTab(value);
  //     }
  //     return null;
  //   });
  // }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'index.dart';

// class InfoListPage extends StatelessWidget {
//   InfoListPageModel infoListPageModel;
//   InfoListPage(this.infoListPageModel, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('嵌套导航'),
//       ),
//       body: Navigator(
//           key: Get.nestedKey(1), // create a key by index
//           initialRoute: '/',
//           onGenerateRoute: (settings) {
//             if (settings.name == '/') {
//               return GetPageRoute(
//                 page: () => Scaffold(
//                   appBar: AppBar(
//                       title: const Text("首页"), backgroundColor: Colors.blue),
//                   body: Center(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Get.toNamed('/second',
//                             id: 1); // navigate by your nested route by index
//                       },
//                       child: const Text("跳转下一页"),
//                     ),
//                   ),
//                 ),
//               );
//             } else if (settings.name == '/second') {
//               return GetPageRoute(
//                 page: () => Center(
//                   child: Scaffold(
//                     appBar: AppBar(
//                         title: const Text("第二页"), backgroundColor: Colors.blue),
//                     body: const Center(child: Text("第二页")),
//                   ),
//                 ),
//               );
//             }
//             return null;
//           }),
//     );
//   }
// }
