import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/widgets/index.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/base/common/format.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/dart/core/thing/standard/index.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/pages/home/index/widget/widget.dart';
import 'package:orginone/utils/load_image.dart';
import 'controller.dart';
import 'state.dart';

class WorkBenchPage
    extends BaseGetListPageView<WorkBenchController, WorkBenchState> {
  late String type;
  late String label;

  // HomeController homeController = Get.find<HomeController>();
  // WorkController workController = Get.find<WorkController>();
  // MessageChatsController messageChatsController =
  //     Get.find<MessageChatsController>();

  WorkBenchPage(this.type, this.label, {super.key});

  @override
  Widget buildView() {
    return Obx(() {
      return Container(
          color: XColors.bgListBody,
          // padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
          child: ListView(children: [
            _renderWorkV1(),
            RenderOperate(),
            _renderRecentApp(),
            _renderGroupActivity(),
            _renderFieldCircle(),
            // RenderChat(),
            // RenderWork(),
            // RendeStore(),
            // RendeAppInfo()
          ]));
    });
  }

  // 发送快捷命令
  renderCmdBtn(IFileInfo<XEntity> file) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: 120.w,
        child: Column(
          children: [
            XImage.entityIcon(file, width: 60.w),
            Container(
              // padding: const EdgeInsets.only(top: 16),
              margin: EdgeInsets.only(top: 10.h),
              child: SizedBox(
                height: 16,
                child: Text(
                  file.name,
                  // softWrap: true,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: XColors.doorDesGrey,
                    fontSize: 18.sp,
                    fontFamily: 'PingFang SC',
                    // height: 0.16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 渲染最近应用
  Widget _renderRecentApp() {
    // var datas = (await relationCtrl.loadCommons())
    //       .where((element) => element.typeName == WorkType.thing.label)
    //       .toList();
    return modelWindow("最近应用",
        contentWidget: FutureBuilder<List<IFileInfo<XEntity>>>(
          builder: (BuildContext context,
              AsyncSnapshot<List<IFileInfo<XEntity>>> datas) {
            return Container(
                padding:
                    EdgeInsets.only(left: 0, right: 0, top: 0.h, bottom: 30.h),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 18.0,
                  children: datas.data
                          ?.sublist(0, min(8, datas.data!.length))
                          .map<Widget>((e) => renderCmdBtn(e))
                          .toList() ??
                      [],
                ));
          },
          future: relationCtrl.loadCommons(),
        ));
  }

  // 渲染群动态
  Widget _renderGroupActivity() {
    return modelWindow("动态",
        contentWidget: null != relationCtrl.cohortActivity.value
            ? Container(
                child: Column(
                children: relationCtrl.cohortActivity.value!.activityList
                    .sublist(
                        0,
                        min(
                            2,
                            relationCtrl
                                .cohortActivity.value!.activityList.length))
                    .map((item) {
                  return ActivityMessageWidget(
                    item: item,
                    activity: item.activity,
                    hideResource: true,
                  );
                }).toList(),
              ))
            : Container(), onMoreTap: () {
      RoutePages.jumpHome(
          home: relationCtrl.homeEnum.value, defaultActiveTabs: ["群动态"]);
    });
  }

  // 渲染好友圈
  Widget _renderFieldCircle() {
    return modelWindow("好友圈",
        contentWidget: null != relationCtrl.friendsActivity.value
            ? Container(
                child: Column(
                children: relationCtrl.friendsActivity.value!.activityList
                    .sublist(
                        0,
                        min(
                            2,
                            relationCtrl
                                .friendsActivity.value!.activityList.length))
                    .map((item) {
                  return ActivityMessageWidget(
                    item: item,
                    activity: item.activity,
                    hideResource: true,
                  );
                }).toList(),
              ))
            : Container(), onMoreTap: () {
      RoutePages.jumpHome(
          home: relationCtrl.homeEnum.value, defaultActiveTabs: ["好友圈"]);
    });
  }

  // 操作组件
  Widget RenderOperate() {
    // 发送快捷命令
    renderCmdBtn(String cmd, String title, String iconType, ShortcutData item,
        Color btnColor) {
      return GestureDetector(
        onTap: () {
          relationCtrl.settingMenuController.hideMenu();
          relationCtrl.showAddFeatures(item);
        },
        child: Container(
          child: Column(
            children: [
              XImage.localImage(cmd,
                  width: 30.w,
                  color: Colors.white,
                  bgColor: btnColor,
                  radius: 5),
              Container(
                padding: const EdgeInsets.only(top: 16),
                margin: EdgeInsets.only(top: 10.h),
                child: SizedBox(
                  height: 16,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: XColors.doorDesGrey,
                      fontSize: 18.sp,
                      fontFamily: 'PingFang SC',
                      height: 0.16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return modelWindow("快捷操作",
        contentWidget: Container(
            padding: EdgeInsets.only(
                left: 12.w, right: 12.w, top: 10.h, bottom: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                renderCmdBtn('addFriend', '添加好友', 'joinFriend',
                    relationCtrl.menuItems[0], const Color(0xFFFF9A5C)),
                renderCmdBtn('createGroup', '创建群组', '群组',
                    relationCtrl.menuItems[4], const Color(0xFF228DEF)),
                renderCmdBtn('joinGroup', '加入群聊', 'joinCohort',
                    relationCtrl.menuItems[1], const Color(0xFFFFCE39)),
                renderCmdBtn('establishmentUnit', '新建单位', '单位',
                    relationCtrl.menuItems[2], const Color(0xFFFFCE39)),
                renderCmdBtn('joinUnit', '加入单位', 'joinCompany',
                    relationCtrl.menuItems[3], const Color(0xFF59D8A5)),
              ],
            )));
  }

  //更多操作
  Widget modelWindow(String title,
      {Function()? onMoreTap, Widget? moreWidget, Widget? contentWidget}) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
      child: Column(
        children: [
          CommonWidget.commonDoorHeadInfoWidget(title,
              action: moreWidget ??
                  GestureDetector(
                      onTap: () {
                        // homeController.jumpTab(HomeEnum.relation);
                        null != onMoreTap
                            ? onMoreTap.call()
                            : RoutePages.jumpRelation();
                      },
                      child: const TextArrow(
                        title: '更多',
                      ))),
          SizedBox(
            height: 10.h,
          ),
          contentWidget ?? const Column()
        ],
      ),
    );
  }

  // 渲染沟通信息
  Widget RenderChat() {
    return modelWindow("沟通",
        contentWidget: Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              renderDataItem("好友(人)", 'friend', state.friendNum, HomeEnum.chat,
                  () {
                // int i = messageChatsController.getTabIndex('friend');
                // messageChatsController.changeSubmenuIndex(i);
                // messageChatsController.state.tabController.index = i;
                RoutePages.jumpChat(defaultActiveTabs: ["好友"]);
              }),
              renderDataItem(
                  "同事(个)", 'company_friend', state.colleagueNum, HomeEnum.chat,
                  () {
                RoutePages.jumpChat(defaultActiveTabs: ["同事"]);
                // messageChatsController.setTabIndex('company_friend');
              }),
              renderDataItem(
                  '群聊(个)', 'group', state.groupChatNum, HomeEnum.chat, () {
                RoutePages.jumpChat(defaultActiveTabs: ["群组"]);
                // int i = messageChatsController.getTabIndex('group');
                // messageChatsController.changeSubmenuIndex(i);
                // messageChatsController.state.tabController.index = i;
              }),
              renderDataItem(
                  '单位(家)', 'company', state.companyNum, HomeEnum.chat, () {
                RoutePages.jumpChat(defaultActiveTabs: ["单位"]);
                // int i = messageChatsController.getTabIndex('company');
                // messageChatsController.changeSubmenuIndex(i);
                // messageChatsController.state.tabController.index = i;
              }),
            ],
          ),
        ),
        moreWidget: GestureDetector(
            onTap: () {
              // homeController.jumpTab(HomeEnum.chat);
              RoutePages.jumpChat();
            },
            child: TextArrow(
                title: '未读消息 · ${relationCtrl.noReadMgsCount.value}')));
  }

  Widget renderDataItem(String title, String? code, RxString number,
      HomeEnum? home, Function()? fun,
      [int size = 0, String info = '']) {
    return Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          onTap: () {
            if (home != null) {
              // homeController.jumpTab(home);
            }
            fun!();
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(ExString.unitConverter(number.value),
                    style: TextStyle(fontSize: 22.sp)),
              ),
              Text(title,
                  style:
                      TextStyle(fontSize: 18.sp, color: XColors.doorDesGrey)),
            ],
          ),
        ));
  }

  // 渲染办事信息v1
  Widget _renderWorkV1() {
    return modelWindow("事项提醒",
        contentWidget: Container(
            // color: Colors.red,
            padding: EdgeInsets.only(left: 10.w, bottom: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 子元素之间的对齐方式
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildWorkItemV1("未读", relationCtrl.noReadMgsCount.toString(),
                    XImage.homeChat, const Color(0x205B66FF), onTab: () {
                  RoutePages.jumpChat();
                }),
                _buildWorkItemV1("待办", state.todoCount.value, XImage.homeWork,
                    const Color(0x20FF9A5C), onTab: () {
                  RoutePages.jumpWork();
                }),
                _buildWorkItemV1(
                    "任务", "0", XImage.homeTask, const Color(0x2059D8A5)),
                _buildWorkItemV1(
                    "提醒", "0", XImage.homeRemind, const Color(0x20E1516B))
              ],
            )),
        moreWidget: Container());
  }

  Widget _buildWorkItemV1(
      String title, String count, String icon, Color bgColor,
      {void Function()? onTab}) {
    return Expanded(
        child: GestureDetector(
            onTap: onTab,
            child: Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: bgColor,
                ),
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.only(right: 10.w),
                child: Column(
                  children: [
                    XImage.localImage(icon, color: bgColor.withOpacity(1)),
                    Text(title, style: const TextStyle(fontSize: 12)),
                    Text(count,
                        style: const TextStyle(
                          fontSize: 22,
                          height: 1.5,
                        )),
                  ],
                ))));
  }

  // 渲染办事信息
  Widget RenderWork() {
    return modelWindow("办事",
        contentWidget: Container(
            padding: EdgeInsets.only(
                left: 12.w, right: 12.w, top: 10.h, bottom: 10.h),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  renderDataItem('待办', 'todo', state.todoCount, HomeEnum.work,
                      () {
                    // int i = workController.getTabIndex('todo');
                    // workController.changeSubmenuIndex(i);
                    // workController.state.tabController.index = i;
                    RoutePages.jumpWork(defaultActiveTabs: ["待办"]);
                  }),
                  renderDataItem(
                      '已办', 'done', state.completedCount, HomeEnum.work, () {
                    // int i = workController.getTabIndex('done');
                    // workController.changeSubmenuIndex(i);
                    // workController.state.tabController.index = i;
                    RoutePages.jumpWork(defaultActiveTabs: ["已办"]);
                  }),
                  renderDataItem('抄送', 'alt', state.copysCount, HomeEnum.work,
                      () {
                    // int i = workController.getTabIndex('alt');
                    // workController.changeSubmenuIndex(i);
                    // workController.state.tabController.index = i;
                    RoutePages.jumpWork(defaultActiveTabs: ["抄送"]);
                  }),
                  renderDataItem(
                      '发起的', 'create', state.applyCount, HomeEnum.work, () {
                    // int i = workController.getTabIndex('create');
                    // workController.changeSubmenuIndex(i);
                    // workController.state.tabController.index = i;
                    RoutePages.jumpWork(defaultActiveTabs: ["已发起"]);
                  }),
                ])),
        moreWidget: GestureDetector(
            onTap: () {
              // homeController.jumpTab(HomeEnum.work);
              RoutePages.jumpWork();
            },
            child: const TextArrow(title: '前往审批')));
  }

  // 渲染存储数据信息
  Widget RendeStore() {
    return modelWindow("数据",
        contentWidget: Container(
            padding: EdgeInsets.only(
                left: 12.w, right: 12.w, top: 10.h, bottom: 10.h),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: state.noStore.value
                    ? [
                        const SizedBox(
                          width: 300,
                          child: Text(
                            "您还未申请存储资源，您将无法使用本系统，请申请加入您的存储资源群（用来存储您的数据），个人用户试用存储群为（orginone_data），申请通过后请在关系中激活使用哦！",
                            maxLines: 5,
                            overflow: TextOverflow.fade,
                          ),
                        )
                      ]
                    : [
                        renderDataItem(
                            '关系(个)',
                            null,
                            state.relationNum,
                            HomeEnum.store,
                            () {},
                            -1,
                            '共计:${relationCtrl.chats.length}个'),
                        renderDataItem(
                            '数据集(个)',
                            null,
                            state.diskInfo.value.collections.toString().obs,
                            HomeEnum.store,
                            () {},
                            state.diskInfo.value.dataSize ?? 0),
                        renderDataItem(
                            '对象数(个)',
                            null,
                            state.diskInfo.value.objects.toString().obs,
                            HomeEnum.store,
                            () {},
                            state.diskInfo.value.totalSize ?? 0),
                        renderDataItem(
                            '文件(个)',
                            null,
                            state.diskInfo.value.files.toString().obs,
                            HomeEnum.store,
                            () {},
                            state.diskInfo.value.fileSize ?? 0),
                        renderDataItem(
                            '硬件',
                            null,
                            formatSize(state.diskInfo.value.fsUsedSize)
                                .toString()
                                .obs,
                            HomeEnum.store,
                            () {},
                            state.diskInfo.value.fsTotalSize ?? 0),
                      ])),
        moreWidget: GestureDetector(
            onTap: () {
              // homeController.jumpTab(HomeEnum.store);
              RoutePages.jumpStore();
            },
            child: const TextArrow(title: '管理数据')));
  }

  // 渲染应用信息
  Widget RendeAppInfo() {
    return modelWindow("常用应用",
        contentWidget: Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: state.applications
                    .where((i) => i.cache.tags?.contains("常用") ?? false)
                    .map((element) => loadAppCard(element))
                    .toList())),
        moreWidget: const TextArrow(title: '全部应用'));
  }

  //渲染应用数据
  Widget loadAppCard(IApplication item) {
    var useAlays = item.cache.tags?.contains('常用');
    return GestureDetector(
      onTap: () {
        // TODO全部应用
      },
      child: Slidable(
        enabled: state.enabledSlidable,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.vertical_align_top,
              label: useAlays! ? "取消常用" : "设为常用",
              onPressed: (BuildContext context) async {
                if (useAlays) {
                  item.cache.tags =
                      item.cache.tags?.where((i) => i != '常用').toList();
                  item.cacheUserData();
                } else {
                  item.cache.tags = item.cache.tags ?? [];
                  item.cache.tags?.add('常用');
                  item.cacheUserData();
                }
              },
            ),
          ],
        ),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 7.h),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Colors.grey.shade300, width: 0.4))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageWidget(
                  item.metadata.icon,
                  size: 50.w,
                  iconColor: const Color(0xFF9498df),
                ),
                Text(item.name),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  WorkBenchController getController() {
    // showErr();
    return WorkBenchController(type);
  }

  @override
  String tag() {
    return "portal_$type";
  }

  @override
  bool displayNoDataWidget() => false;
}
