import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/widgets/common_widget.dart';
import 'package:orginone/components/widgets/image_widget.dart';
import 'package:orginone/dart/base/common/format.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/dart/core/thing/standard/index.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/message_chats/message_chats_controller.dart';
import 'package:orginone/pages/home/home/logic.dart';
import 'package:orginone/pages/home/index/widget/widget.dart';
import 'package:orginone/pages/work/logic.dart';
import 'package:orginone/utils/load_image.dart';
import 'controller.dart';
import 'state.dart';

class WorkBenchPage
    extends BaseGetListPageView<WorkBenchController, WorkBenchState> {
  late String type;
  late String label;

  HomeController homeController = Get.find<HomeController>();
  WorkController workController = Get.find<WorkController>();
  MessageChatsController messageChatsController =
      Get.find<MessageChatsController>();

  WorkBenchPage(this.type, this.label, {super.key});

  @override
  Widget buildView() {
    return Container(
        color: const Color.fromARGB(255, 240, 240, 240),
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
        child: ListView(children: [
          RenderOperate(),
          RenderChat(),
          RenderWork(),
          RendeStore(),
          // RendeAppInfo()
        ]));
  }

  // 操作组件
  Widget RenderOperate() {
    // 发送快捷命令
    renderCmdBtn(String cmd, String title, String iconType, ShortcutData item) {
      return GestureDetector(
        onTap: () {
          settingCtrl.settingMenuController.hideMenu();
          settingCtrl.showAddFeatures(item);
        },
        child: Container(
          child: Column(
            children: [
              XImage.localImage(cmd, size: Size(56.w, 56.w)),
              Container(
                padding: const EdgeInsets.only(top: 16),
                margin: EdgeInsets.only(top: 10.h),
                child: SizedBox(
                  height: 16,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      // color: Colors.black.withOpacity(0.8999999761581421),
                      color: const Color(0xFF6F7686),
                      fontSize: 18.sp,
                      fontFamily: 'PingFang SC',
                      // fontWeight: FontWeight.w400,
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
                renderCmdBtn('joinFriend', '添加好友', 'joinFriend',
                    settingCtrl.menuItems[0]),
                renderCmdBtn(
                    'newCohort', '创建群组', '群组', settingCtrl.menuItems[4]),
                renderCmdBtn('joinCohort', '加入群聊', 'joinCohort',
                    settingCtrl.menuItems[1]),
                renderCmdBtn(
                    'newCompany', '新建单位', '单位', settingCtrl.menuItems[2]),
                renderCmdBtn('joinCompany', '加入单位', 'joinCompany',
                    settingCtrl.menuItems[3]),
              ],
            )));
  }

  //更多操作
  Widget modelWindow(String title,
      {Widget? moreWidget, Widget? contentWidget}) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        children: [
          CommonWidget.commonDoorHeadInfoWidget(title,
              action: moreWidget ??
                  GestureDetector(
                      onTap: () {
                        homeController.jumpTab(HomeEnum.relation);
                      },
                      child: const TextArrow(
                        title: '更多操作',
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
                int i = messageChatsController.getTabIndex('friend');
                messageChatsController.changeSubmenuIndex(i);
                messageChatsController.state.tabController.index = i;
              }),
              renderDataItem(
                  "同事(个)", 'company_friend', state.colleagueNum, HomeEnum.chat,
                  () {
                print('同事(个)');
                messageChatsController.setTabIndex('company_friend');
              }),
              renderDataItem(
                  '群聊(个)', 'group', state.groupChatNum, HomeEnum.chat, () {
                int i = messageChatsController.getTabIndex('group');
                messageChatsController.changeSubmenuIndex(i);
                messageChatsController.state.tabController.index = i;
              }),
              renderDataItem(
                  '单位(家)', 'company', state.companyNum, HomeEnum.chat, () {
                int i = messageChatsController.getTabIndex('company');
                messageChatsController.changeSubmenuIndex(i);
                messageChatsController.state.tabController.index = i;
              }),
            ],
          ),
        ),
        moreWidget: GestureDetector(
            onTap: () {
              homeController.jumpTab(HomeEnum.chat);
            },
            child: TextArrow(
                title: '未读消息 · ${settingCtrl.noReadMgsCount.value}')));
  }

  Widget renderDataItem(String title, String? code, RxString number,
      HomeEnum? home, Function()? fun,
      [int size = 0, String info = '']) {
    return Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          onTap: () {
            if (home != null) {
              homeController.jumpTab(home);
            }
            fun!();
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 5),
                child: number.value.length > 4
                    ? Text('9999+', style: TextStyle(fontSize: 22.sp))
                    : Text(number.value, style: TextStyle(fontSize: 22.sp)),
              ),
              Text(title,
                  style: TextStyle(
                      fontSize: 18.sp, color: const Color(0xFF6F7686))),
            ],
          ),
        ));
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
                    int i = workController.getTabIndex('todo');
                    workController.changeSubmenuIndex(i);
                    workController.state.tabController.index = i;
                  }),
                  renderDataItem(
                      '已办', 'done', state.completedCount, HomeEnum.work, () {
                    int i = workController.getTabIndex('done');
                    workController.changeSubmenuIndex(i);
                    workController.state.tabController.index = i;
                  }),
                  renderDataItem('抄送', 'alt', state.copysCount, HomeEnum.work,
                      () {
                    int i = workController.getTabIndex('alt');
                    workController.changeSubmenuIndex(i);
                    workController.state.tabController.index = i;
                  }),
                  renderDataItem(
                      '发起的', 'create', state.applyCount, HomeEnum.work, () {
                    int i = workController.getTabIndex('create');
                    workController.changeSubmenuIndex(i);
                    workController.state.tabController.index = i;
                  }),
                ])),
        moreWidget: GestureDetector(
            onTap: () {
              homeController.jumpTab(HomeEnum.work);
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
                            '共计:${settingCtrl.chats.length}个'),
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
              homeController.jumpTab(HomeEnum.store);
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
