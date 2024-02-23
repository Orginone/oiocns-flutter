import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:orginone/common/routers/pages.dart';
import 'package:orginone/components/widgets/infoListPage/index.dart';
import 'package:orginone/components/widgets/list_widget/index.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/date_util.dart';
import 'package:orginone/utils/log/log_util.dart';

/// 沟通页面
class ChatPage extends StatefulWidget {
  InfoListPageModel? relationModel;
  List<ISession>? datas;

  ChatPage({super.key, List<ISession>? datas}) {
    relationModel = null;
    dynamic params = RoutePages.getParentRouteParam();
    this.datas = datas ?? (params is List<ISession> ? params : null);
  }

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  InfoListPageModel? get relationModel => widget.relationModel;
  set relationModel(InfoListPageModel? value) {
    widget.relationModel = value;
  }

  List<ISession>? get datas => widget.datas;

  RxList<ISession> get chats => relationCtrl.chats;

  @override
  void initState() {
    super.initState();
    // relationCtrl.loadChats().then((value) => setState(() {}));
    // command.subscribeByFlag('session', ([List<dynamic>? args]) {
    //   setState(() {});
    // });
    chats.listen((values) {
      setState(() {
        widget.datas = values;
        widget.relationModel = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (null == relationModel) {
      load();
    }

    return InfoListPage(
      relationModel!,
    );
  }

  void load() {
    relationModel = InfoListPageModel(
        title: "沟通",
        activeTabTitle: getActiveTabTitle(),
        tabItems: [
          createTabItemsModel(title: "最近"),
          createTabItemsModel(title: "常用"),
          createTabItemsModel(title: "好友"),
          createTabItemsModel(title: "同事"),
          createTabItemsModel(title: "群组"),
          createTabItemsModel(title: "单位"),
        ]);
  }

  /// 获得激活页签
  getActiveTabTitle() {
    return RoutePages.getRouteDefaultActiveTab()?.firstOrNull;
  }

  TabItemsModel createTabItemsModel({
    required String title,
  }) {
    RxList<ISession> initDatas = RxList();
    if (null == datas) {
      initDatas.value = getSessionsByLabel(title);
    } else {
      initDatas.value = datas ?? [];
    }

    return TabItemsModel(
        title: title,
        content: ListWidget<ISession>(
          // initDatas: null == datas ? getSessionsByLabel(title) : datas ?? [],
          initDatas: initDatas,
          getDatas: ([dynamic data]) {
            if (null == data) {
              return datas ?? [];
            }
            return [];
          },
          getBadge: (dynamic data) {
            if (data.noReadCount.isNotEmpty) {
              return int.parse(data.noReadCount);
            }
            return 0;
          },
          getAction: (dynamic data) {
            return GestureDetector(
              onTap: () {
                LogUtil.d('>>>>>>======点击了感叹号');
                RoutePages.jumpMemberList(data: data);
              },
              child: Text(
                CustomDateUtil.getSessionTime(data.updateTime),
                style: XFonts.chatSMTimeTip,
                textAlign: TextAlign.right,
              ),
            );
          },
          onTap: (dynamic data, List children) {
            LogUtil.d('>>>>>>======点击了列表项 ${data.name}');
            if (data is ISession) {
              RoutePages.jumpChatSession(data: data);
            }
          },
        ));
  }

  // 根据标签获得沟通会话列表
  List<ISession> getSessionsByLabel(String label) {
    return chats
        .where((element) => label == '最近' || element.groupTags.contains(label))
        .toList();
  }
}
