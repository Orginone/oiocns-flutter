import 'package:flutter/material.dart';
import 'package:orginone/common/routers/pages.dart';
import 'package:orginone/common/widgets/icon.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/components/modules/chat/chat_session_page.dart';
import 'package:orginone/components/modules/common/entity_info_page.dart';
import 'package:orginone/components/widgets/common/empty/empty_activity.dart';
import 'package:orginone/components/widgets/infoListPage/index.dart';
import 'package:orginone/components/widgets/list_widget/index.dart';
import 'package:orginone/components/widgets/target_activity/activity_message.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/load_image.dart';
import 'package:orginone/utils/log/log_util.dart';

class RelationFriendPage extends OrginoneStatelessWidget {
  late InfoListPageModel? relationModel;
  RelationFriendPage({super.key, super.data}) {
    relationModel = null;
  }

  @override
  Widget buildWidget(BuildContext context, dynamic data) {
    if (null == relationModel) {
      load();
    }

    return InfoListPage(relationModel!);
  }

  void load() {
    relationModel = InfoListPageModel(
        title: RoutePages.getRouteTitle() ?? data.name ?? "好友",
        activeTabTitle: getActiveTabTitle(),
        tabItems: [
          // createTabItemsModel(title: "好友"),
          TabItemsModel(
              title: "沟通", icon: XImage.chatOutline, content: buildChats()),
          TabItemsModel(
              title: "动态",
              icon: XImage.dynamicOutline,
              content: buildActivity()),
          TabItemsModel(
              title: "设置",
              icon: XImage.settingOutline,
              content: buildSetting()),
          // TabItemsModel(title: "成员", content: const Text("文件")),
          // TabItemsModel(title: "文件", content: const Text("文件")),
        ]);
  }

  /// 获得激活页签
  getActiveTabTitle() {
    return RoutePages.getRouteDefaultActiveTab()?.first;
  }

  Widget buildActivity() {
    ISession? chat;
    if (data is ISession) {
      chat = data;
    } else {
      chat = relationCtrl.user?.findMemberChat(data.id);
    }
    if (null != chat && chat.activity.activityList.isNotEmpty) {
      return Container(
          color: XColors.bgListBody,
          child: ListView(
              children: chat.activity.activityList.map((item) {
            return ActivityMessageWidget(
              item: item,
              activity: item.activity,
              hideResource: true,
            );
          }).toList()));
    }
    return const EmptyActivity();
  }

  TabItemsModel createTabItemsModel({
    required String title,
  }) {
    return TabItemsModel(
        title: title,
        content: ListWidget<XTarget>(
          getDatas: ([dynamic data]) {
            return getFriends();
          },
          getAction: (dynamic data) {
            return GestureDetector(
              onTap: () {
                LogUtil.d('>>>>>>======点击了感叹号');
              },
              child: const IconWidget(
                color: XColors.black666,
                iconData: Icons.info_outlined,
              ),
            );
          },
          onTap: (dynamic data, List children) {
            LogUtil.d('>>>>>>======点击了列表项 ${data.name}');
          },
        ));
  }

  Widget? buildChats() {
    return ChatSessionPage(data: data);
  }

  List<XTarget> getFriends() {
    return relationCtrl.user?.members ?? [];
  }

  Widget buildSetting() {
    return EntityInfoPage(data: data);
  }
}
