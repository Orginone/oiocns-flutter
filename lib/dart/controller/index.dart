import 'dart:async';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/thing/standard/index.dart';
import 'package:orginone/dart/core/user.dart';
import 'package:orginone/dart/core/work/provider.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/utils/bus/event_bus_helper.dart';
import 'package:orginone/utils/hive_utils.dart';
import 'package:orginone/utils/index.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:orginone/components/widgets/loading_dialog.dart';

const sessionUserName = 'sessionUser';
const sessionSpaceName = 'sessionSpace';

enum Shortcut {
  addPerson("添加朋友", Icons.group_add_outlined),
  addGroup("加入群组", Icons.speaker_group_outlined),
  createCompany("创建单位", Icons.compare_outlined),
  addCompany("加入单位", Icons.compare_outlined),
  addCohort("发起群聊", Icons.chat_bubble_outline_outlined),
  createDir("新建目录", Ionicons.folder_sharp),
  createApplication("新建应用", Ionicons.apps_sharp),
  createSpecies("新建分类", Ionicons.pricetag_sharp),
  createDict("新建字典", Ionicons.book_sharp),
  createAttr("新建属性", Ionicons.snow_sharp),
  createThing("新建实体配置", Ionicons.pricetag_sharp),
  createWork("新建事项配置", Ionicons.pricetag_sharp),
  uploadFile("上传文件", Ionicons.file_tray_sharp);

  final String label;
  final IconData icon;

  const Shortcut(this.label, this.icon);
}

enum SettingEnum {
  security("账号与安全", Ionicons.key_outline),
  cardbag("卡包设置", Ionicons.card_outline),
  gateway("门户设置", Ionicons.home_outline),
  theme("主题设置", Ionicons.color_palette_outline),
  exitLogin("退出登录", Ionicons.exit_outline);

  final String label;
  final IconData icon;

  const SettingEnum(this.label, this.icon);
}

class ShortcutData {
  Shortcut shortcut;
  TargetType? targetType;
  String title;
  String hint;

  ShortcutData(
    this.shortcut, [
    this.title = '',
    this.hint = '',
    this.targetType,
  ]);
}

/// 设置控制器
class IndexController extends GetxController {
  String currentKey = "";
  StreamSubscription<UserLoaded>? _userSub;
  late UserProvider _provider;

  var homeEnum = HomeEnum.door.obs;
  final _noReadMgsCount = 0.obs;

  late CustomPopupMenuController functionMenuController;

  late CustomPopupMenuController settingMenuController;

  /// 数据提供者
  UserProvider get provider => _provider;

  /// 当前用户
  IPerson get user => provider.user!;

  /// 办事提供者
  IWorkProvider get work => provider.work!;

  /// 所有相关的用户
  List<ITarget> get targets => provider.targets;

  /// 所有相关会话
  RxList<ISession> get chats {
    List<ISession> chats = [];
    if (provider.user != null) {
      chats.addAll(provider.user?.chats ?? []);
      for (var company in provider.user?.companys ?? []) {
        chats.addAll(company.chats ?? []);
      }

      /// 排序
      chats.sort((a, b) {
        var num = (b.chatdata.value.isToping ? 10 : 0) -
            (a.chatdata.value.isToping ? 10 : 0);
        if (num == 0) {
          if (b.chatdata.value.lastMsgTime == a.chatdata.value.lastMsgTime) {
            num = b.isBelongPerson ? 1 : -1;
          } else {
            num = b.chatdata.value.lastMsgTime > a.chatdata.value.lastMsgTime
                ? 5
                : -5;
          }
        }
        return num;
      });
    }
    return RxList<ISession>.from(chats);
  }

  int get noReadMgsCount {
    //处理所有未读消息
    refreshNoReadMgsCount();
    return _noReadMgsCount.value;
  }

  var menuItems = [
    ShortcutData(
      Shortcut.addPerson,
      "添加好友",
      "请输入用户的账号",
      TargetType.person,
    ),
    ShortcutData(Shortcut.addGroup, "加入群组", "请输入群组的编码", TargetType.cohort),
    ShortcutData(Shortcut.createCompany, "创建单位", "", TargetType.company),
    ShortcutData(
        Shortcut.addCompany, "加入单位", "请输入单位的社会统一代码", TargetType.company),
    ShortcutData(Shortcut.addCohort, "发起群聊", "请输入群聊信息", TargetType.cohort),
  ];

  @override
  void onInit() {
    super.onInit();
    functionMenuController = CustomPopupMenuController();
    settingMenuController = CustomPopupMenuController();
    _provider = UserProvider();
    _userSub = EventBusUtil.instance.on<UserLoaded>((event) async {
      EventBusHelper.fire(ShowLoading(true));
      // await _provider.loadData();
      // EventBusHelper.fire(ShowLoading(false));
      // await Future.wait([
      //   _provider.loadChatData(),
      //   _provider.loadWorkData(),
      //   _provider.loadStoreData(),
      //   _provider.loadContent(),
      // ]);
      // _provider.loadApps();
      EventBusHelper.fire(InitDataDone());
    });
    //初始化未读信息命令
    initNoReadCommand();
  }

  void initNoReadCommand() {
    //沟通未读消息提示处理
    command.subscribeByFlag(
        'session', ([List<dynamic>? args]) => {refreshNoReadMgsCount()});
  }

  void refreshNoReadMgsCount() {
    _noReadMgsCount.value = 0;
    for (var element in chats) {
      _noReadMgsCount.value += element.chatdata.value.noReadCount;
    }
    print('>>>=====refresh:${_noReadMgsCount.value}');
  }

  @override
  void onClose() {
    _userSub?.cancel();
    super.onClose();
  }

  Future<List<IApplication>> loadApplications() async {
    List<IApplication> apps = [];
    for (var directory in targets
        .where((i) => i.session.isMyChat)
        .toList()
        .map((a) => a.directory)
        .toList()) {
      apps.addAll((await directory.loadAllApplication()));
    }
    return apps;
  }

  void setHomeEnum(HomeEnum value) {
    homeEnum.value = value;
  }

  void jumpInitiate() {
    switch (homeEnum.value) {
      case HomeEnum.chat:
        Get.toNamed(Routers.initiateChat);
        break;
      case HomeEnum.work:
        Get.toNamed(Routers.initiateWork);
        break;
      case HomeEnum.store:
        Get.toNamed(Routers.storeTree);
        break;
      case HomeEnum.setting:
        Get.toNamed(Routers.settingCenter);
        break;
      case HomeEnum.door:
        // TODO: Handle this case.
        break;
    }
  }

  bool isUserSpace(space) {
    return space == user;
  }

  void showAddFeatures(ShortcutData item) {
    switch (item.shortcut) {
      case Shortcut.createCompany:
      case Shortcut.addCohort:
        showCreateOrganizationDialog(
          Get.context!,
          [item.targetType!],
          callBack: (String name, String code, String nickName, String identify,
              String remark, TargetType type) async {
            var target = TargetModel(
              name: nickName,
              code: code,
              typeName: type.label,
              teamName: name,
              teamCode: code,
              remark: remark,
            );
            var data = item.shortcut == Shortcut.createCompany
                ? await user.createCompany(target)
                : await user.createCohort(target);
            if (data != null) {
              ToastUtils.showMsg(msg: "创建成功");
            }
          },
        );
        break;
      case Shortcut.addPerson:
      case Shortcut.addGroup:
      case Shortcut.addCompany:
        showSearchDialog(Get.context!, item.targetType!,
            title: item.title, hint: item.hint, onSelected: (targets) async {
          if (targets.isNotEmpty) {
            bool success = await user.applyJoin(targets);
            if (success) {
              ToastUtils.showMsg(msg: "发送申请成功");
            }
          }
        });
        break;
    }
  }

  void exitLogin({bool cleanUserLoginInfo = true}) async {
    if (cleanUserLoginInfo) {
      Storage().clear();
    }
    LoadingDialog.dismiss(Get.context!);
    kernel.stop();
    await HiveUtils.clean();
    homeEnum.value = HomeEnum.door;
    Get.offAllNamed(Routers.login);
  }

  void qrScan() {
    Get.toNamed(Routers.qrScan)?.then((value) async {
      if (value != null) {
        String id = value.split('/').toList().last;
        XEntity? entity = await user.findEntityAsync(id);
        if (entity != null) {
          List<XTarget> target =
              await user.searchTargets(entity.code!, [entity.typeName!]);
          if (target.isNotEmpty) {
            var success = await user.applyJoin(target);
            if (success) {
              ToastUtils.showMsg(msg: "申请发送成功");
            } else {
              ToastUtils.showMsg(msg: "申请发送失败");
            }
          } else {
            ToastUtils.showMsg(msg: "获取用户失败");
          }
        } else if (null != value &&
            value.length == 24 &&
            value.indexOf('==') > 0) {
          print('$value>>>${value.length}');
          ResultType res = await provider.qrAuth(value);
          if (res.success) {
            ToastUtils.showMsg(msg: "登录成功");
          } else {
            ToastUtils.showMsg(msg: "登录失败：${res.msg}");
          }
        } else {
          ToastUtils.showMsg(msg: "获取用户失败");
        }
      }
    });
  }

  void jumpSetting(SettingEnum item) {
    switch (item) {
      case SettingEnum.security:
        Get.toNamed(Routers.forgotPassword);
        break;
      case SettingEnum.cardbag:
        RoutePages.jumpCardBag();
        break;
      case SettingEnum.gateway:
        Get.toNamed(
          Routers.security,
        );
        break;
      case SettingEnum.theme:
        Get.toNamed(
          Routers.security,
        );
        break;
      case SettingEnum.exitLogin:
        exitLogin();
        break;
    }
  }
}

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(IndexController(), permanent: true);
  }
}

enum HomeEnum {
  chat("沟通"),
  work("办事"),
  door("门户"),
  store("存储"),
  setting("设置");

  final String label;

  const HomeEnum(this.label);
}
