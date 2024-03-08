import 'package:flutter/material.dart';
import 'package:orginone/common/routers/pages.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/components/modules/chat/chat_session_page.dart';
import 'package:orginone/components/modules/common/entity_info_page.dart';
import 'package:orginone/components/modules/common/file_list_page.dart';
import 'package:orginone/components/modules/common/member_list_page.dart';
import 'package:orginone/components/widgets/infoListPage/index.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/utils/load_image.dart';

import '../../widgets/target_activity/activity_list.dart';

/// 群组关系
class RelationCohortPage extends OrginoneStatelessWidget {
  late InfoListPageModel? relationModel;
  RelationCohortPage({super.key, super.data}) {
    relationModel = null;
  }

  @override
  Widget buildWidget(BuildContext context, dynamic data) {
    if (null == relationModel) {
      load();
    }

    return InfoListPage(
      relationModel!,
    );
  }

  void load() {
    relationModel = InfoListPageModel(
        title: RoutePages.getRouteTitle() ??
            data.name ??
            data.typeName ??
            TargetType.cohort.label,
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
              title: "文件", icon: XImage.fileOutline, content: buildFiles()),
          TabItemsModel(
              title: "成员", icon: XImage.memberOutline, content: buildPersons()),
          TabItemsModel(
              title: "设置",
              icon: XImage.settingOutline,
              content: buildSetting()),
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
    } else if (data is ITarget) {
      chat = data.session;
    } else {
      //TODO新建会话
    }

    return ActivityListWidget(activity: chat?.activity);
  }

  Widget? buildChats() {
    return ChatSessionPage(data: data);
  }

  Widget buildFiles() {
    return FileListPage(data: data);
  }

  Widget buildPersons() {
    return MemberListPage(data: data);
  }

  Widget buildSetting() {
    return EntityInfoPage(data: data);
  }
}
