import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/modules/general_bread_crumbs/index.dart';
import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/standard/application.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/main.dart';
import 'package:orginone/utils/icons.dart';

class ListAdapter {
  VoidCallback? callback;

  List<PopupMenuItem> popupMenuItems = [];

  late String title;

  late List<String> labels;

  dynamic image;

  late String content;

  late RxString noReadCount;

  String? dateTime;

  late bool circularAvatar;

  late bool isUserLabel;

  PopupMenuItemSelected? onSelected;

  String? typeName;

  ListAdapter({
    this.title = '',
    this.labels = const [],
    this.image,
    this.content = '',
    this.dateTime,
    this.isUserLabel = false,
    noReadCount,
    this.circularAvatar = false,
    this.callback,
    this.popupMenuItems = const [],
  }) {
    this.noReadCount = noReadCount ?? ''.obs;
  }

  ListAdapter.chat(ISession chat) {
    noReadCount = ''.obs;
    labels = chat.groupTags;
    bool isTop = labels.contains("置顶");
    isUserLabel = false;
    typeName = chat.share.typeName;
    popupMenuItems = [
      PopupMenuItem(
        value: isTop ? PopupMenuKey.cancelTopping : PopupMenuKey.topping,
        child: Text(isTop ? "取消常用" : "设为常用"),
      ),
      const PopupMenuItem(
        value: PopupMenuKey.delete,
        child: Text("删除"),
      ),
    ];
    onSelected = (key) async {
      switch (key) {
        case PopupMenuKey.cancelTopping:
          chat.groupTags.remove('常用');
          chat.chatdata.value.isToping = false;
          await chat.cacheChatData();
          settingCtrl.loadChats();
          break;
        case PopupMenuKey.topping:
          chat.groupTags.add('常用');
          chat.chatdata.value.isToping = true;
          await chat.cacheChatData();
          settingCtrl.loadChats();
          break;
        case PopupMenuKey.delete:
          chat.chatdata.value.recently = false;
          await chat.cacheChatData();
          settingCtrl.chats.remove(chat);
          settingCtrl.loadChats();
          break;
      }
    };
    circularAvatar = chat.share.typeName == TargetType.person.label;
    initNoReadCommand(chat.chatdata.value.fullId, chat);
    title = chat.chatdata.value.chatName ?? "";
    dateTime = chat.updateTime;
    content = chat.remark;
    // var lastMessage = chat.chatdata.value.lastMessage;
    // if (lastMessage != null) {
    //   if (lastMessage.fromId != settingCtrl.user.metadata.id) {
    //     if (chat.share.typeName != TargetType.person.label) {
    //     } else {
    //       content = "对方:";
    //     }
    //   }
    //   content = content + chat.remark;
    //   // StringUtil.msgConversion(lastMessage, settingCtrl.user.userId);
    // }

    image = chat.share.avatar?.thumbnailUint8List ??
        chat.share.avatar?.defaultAvatar;

    callback = () {
      // chat.onMessage((messages) => null);
      Get.toNamed(
        Routers.messageChat,
        arguments: chat,
      );
    };
  }
  ListAdapter.work(IWorkTask work) {
    noReadCount = ''.obs;
    labels = [
      work.creater.name,
      work.taskdata.taskType!,
      work.taskdata.approveType!
    ];
    isUserLabel = false;
    circularAvatar = false;
    title = work.taskdata.title ?? '';
    dateTime = work.metadata.createTime ?? "";
    content = work.taskdata.content ?? "";

    // LogUtil.d('ShareIdSet');
    // LogUtil.d(ShareIdSet[work.metadata.id]?.avatar);
    // image = ShareIdSet[work.metadata.id]?.avatar?.thumbnailUint8List ??
    //     AssetsImages.iconWorkitem;
    image = IconsUtils.workDefaultAvatar(work.taskdata.taskType ?? '');
    if (work.targets.length == 2) {
      content =
          "${work.targets[0].name}[${work.targets[0].typeName}]申请加入${work.targets[1].name}[${work.targets[1].typeName}]";
    }

    content = content.isEmpty ? '暂无信息' : "内容:$content";

    ///点击回调
    callback = () async {
      if (work.targets.isEmpty) {
        //加载流程实例数据
        await work.loadInstance();
      }
      //跳转办事详情
      Get.toNamed(Routers.processDetails, arguments: {"todo": work});
    };
  }

  ListAdapter.application(IApplication application, ITarget target) {
    noReadCount = ''.obs;
    labels = [target.name ?? ""];
    isUserLabel = false;
    circularAvatar = false;
    title = application.name ?? "";
    dateTime = application.metadata.createTime ?? "";
    content = "应用说明:${application.metadata.remark ?? ""}";
    image = application.metadata.avatarThumbnail() ?? Ionicons.apps;

    callback = () async {
      var works = await application.loadWorks();
      var nav = GeneralBreadcrumbNav(
          id: application.metadata.id ?? "",
          name: application.metadata.name ?? "",
          source: application,
          spaceEnum: SpaceEnum.applications,
          space: target,
          children: [
            ...works.map((e) {
              return GeneralBreadcrumbNav(
                id: e.metadata.id ?? "",
                name: e.metadata.name ?? "",
                spaceEnum: SpaceEnum.work,
                space: target,
                source: e,
                children: [],
              );
            }).toList(),
            ..._loadModuleNav(application.children, target),
          ]);
      Get.toNamed(Routers.generalBreadCrumbs, arguments: {"data": nav});
    };
  }

  ListAdapter.store(RecentlyUseModel recent) {
    noReadCount = ''.obs;
    image = recent.avatar ?? Ionicons.clipboard_sharp;
    labels = [recent.thing == null ? "文件" : "物"];
    callback = () {
      if (recent.file != null) {
        RoutePages.jumpFile(file: recent.file!, type: "store");
      }
    };
    title = recent.thing?.id ?? recent.file?.name ?? "";
    isUserLabel = false;
    circularAvatar = false;
    content = '';
    dateTime = recent.createTime;
  }

  List<GeneralBreadcrumbNav> _loadModuleNav(
      List<IApplication> app, ITarget target) {
    List<GeneralBreadcrumbNav> navs = [];
    for (var value in app) {
      navs.add(GeneralBreadcrumbNav(
          id: value.metadata.id ?? "",
          name: value.metadata.name ?? "",
          source: value,
          spaceEnum: SpaceEnum.module,
          space: target,
          onNext: (item) async {
            var works = await value.loadWorks();
            List<GeneralBreadcrumbNav> data = [
              ...works.map((e) {
                return GeneralBreadcrumbNav(
                  id: e.metadata.id ?? "",
                  name: e.metadata.name ?? "",
                  spaceEnum: SpaceEnum.work,
                  source: e,
                  space: target,
                  children: [],
                );
              }),
              ..._loadModuleNav(value.children, target),
            ];
            item.children = data;
          },
          children: []));
    }
    return navs;
  }

  void initNoReadCommand(String key, ISession chat) {
    if (chat.chatdata.value.noReadCount > 0) {
      noReadCount.value = chat.chatdata.value.noReadCount > 99
          ? "99+"
          : chat.chatdata.value.noReadCount.toString();
    } else {
      noReadCount.value = '';
    }
    //沟通未读消息提示处理
    command.subscribeByFlag('session-$key',
        ([List<dynamic>? args]) => {refreshNoReadMgsCount(args)});
  }

  void refreshNoReadMgsCount([List<dynamic>? args]) {
    if (null != args && args.isNotEmpty) {
      noReadCount.value = args[0] > 0 ? args[0].toString() : '';
    }
  }
}
