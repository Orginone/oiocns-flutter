import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:orginone/components/widgets/common_widget.dart';
import 'package:orginone/components/widgets/image_widget.dart';
import 'package:orginone/dart/base/common/format.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/dart/core/thing/standard/index.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/home/index/widget/widget.dart';
import 'package:orginone/utils/load_image.dart';
import 'controller.dart';
import 'state.dart';

class WorkBenchPage
    extends BaseGetListPageView<WorkBenchController, WorkBenchState> {
  late String type;
  late String label;

  WorkBenchPage(this.type, this.label, {super.key});

  @override
  Widget buildView() {
    return ListView(children: [
      RenderOperate(),
      RenderChat(),
      RenderWork(),
      RendeStore(),
      RendeAppInfo()
    ]);
  }

  // 操作组件
  Widget RenderOperate() {
    // 发送快捷命令
    renderCmdBtn(String cmd, String title, String iconType) {
      return Container(
        padding:
            EdgeInsets.only(left: 12.w, right: 12.w, top: 10.h, bottom: 10.h),
        child: Column(
          children: [
            XImage.localImage(cmd, size: Size(56.w, 56.w)),
            Container(
              margin: EdgeInsets.only(top: 10.h),
              child: Text(title),
            ),
          ],
        ),
      );
    }

    return modelWindow("快捷操作",
        contentWidget: Container(
            padding: EdgeInsets.only(
                left: 12.w, right: 12.w, top: 10.h, bottom: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    renderCmdBtn('joinFriend', '添加好友', 'joinFriend'),
                    renderCmdBtn('newCohort', '创建群组', '群组'),
                    renderCmdBtn('joinCohort', '加入群聊', 'joinCohort'),
                    renderCmdBtn('newCompany', '新建单位', '单位'),
                    renderCmdBtn('joinCompany', '加入单位', 'joinCompany'),
                  ],
                ),
              ],
            )));
  }

  //更多操作
  Widget modelWindow(String title,
      {Widget? moreWidget, Widget? contentWidget}) {
    return Container(
      decoration: const BoxDecoration(
        //设置背景颜色
        color: Colors.white,
        //设置Container圆角
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        //设置Container边框
        // border: Border.all(width: 0,),
      ),
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      // color: Colors.white,
      child: Column(
        children: [
          CommonWidget.commonHeadInfoWidget(title,
              action: moreWidget ??
                  const TextArrow(
                    title: '更多操作',
                  )),
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
              renderDataItem("好友(人)", state.friendNum.value),
              renderDataItem("同事(个)", state.colleagueNum.value),
              renderDataItem('群聊(个)', state.groupChatNum.value),
              renderDataItem('单位(家)', state.companyNum.value),
            ],
          ),
        ),
        moreWidget:
            TextArrow(title: '未读消息 · ${settingCtrl.noReadMgsCount.value}'));
  }

  Widget renderDataItem(String title, String number,
      [int size = 0, String info = '']) {
    return Container(
      child: Column(
        children: [
          Text(title),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Text(number, style: TextStyle(fontSize: 36.sp)),
          ),
          if (size > 0) Text("大小:${formatSize(size)}"),
          if (info.isNotEmpty) Text(info),
        ],
      ),
    );
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
                  renderDataItem('待办', state.todoCount.value),
                  renderDataItem('已办', state.completedCount.value),
                  renderDataItem('抄送', state.copysCount.value),
                  renderDataItem('发起的', state.applyCount.value),
                ])),
        moreWidget: TextArrow(title: '待办${state.todoCount.value}件'));
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
                        const Text(
                            "您还未申请存储资源，您将无法使用本系统，请申请加入您的存储资源群（用来存储您的数据），个人用户试用存储群为（orginone_data），申请通过后请在关系中激活使用哦！")
                      ]
                    : [
                        renderDataItem('关系(个)', state.relationNum.value ?? "0",
                            -1, '共计:${settingCtrl.chats.length}个'),
                        renderDataItem(
                            '数据集(个)',
                            state.diskInfo.value.collections.toString() ?? "0",
                            state.diskInfo.value.dataSize ?? 0),
                        renderDataItem(
                            '对象数(个)',
                            state.diskInfo.value.objects.toString() ?? "0",
                            state.diskInfo.value.totalSize ?? 0),
                        renderDataItem(
                            '文件(个)',
                            state.diskInfo.value.files.toString() ?? "0",
                            state.diskInfo.value.fileSize ?? 0),
                        renderDataItem(
                            '硬件',
                            formatSize(state.diskInfo.value.fsUsedSize)
                                    .toString() ??
                                "0",
                            state.diskInfo.value.fsTotalSize ?? 0),
                      ])),
        moreWidget: const TextArrow(title: '管理数据'));
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
