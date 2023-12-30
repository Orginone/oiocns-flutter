import 'dart:async';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/common/values/constants.dart';
import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/base/common/emitter.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/auth.dart';
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
  // vsrsion("版本记录", Ionicons.rocket_outline),
  about("关于奥集能", Ionicons.information_circle_outline),
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
  RxInt noReadMgsCount = 0.obs;
  //内核是否在线
  RxBool isConnected = false.obs;

  /// 所有相关会话
  late RxList<ISession> chats = <ISession>[].obs;

  late CustomPopupMenuController functionMenuController;

  late CustomPopupMenuController settingMenuController;

  /// 数据提供者
  UserProvider get provider => _provider;

  /// 授权方法
  AuthProvider get auth {
    return provider.auth;
  }

  /// 当前用户
  IPerson get user => provider.user!;

  /// 办事提供者
  IWorkProvider get work => provider.work!;

  /// 所有相关的用户
  List<ITarget> get targets => provider.targets;
  late Emitter emitter;
  // /// 所有相关会话
  // RxList<ISession> get chats {
  //   List<ISession> _chats = [];
  //   if (provider.user != null) {
  //     chats.addAll(provider.user?.chats ?? []);
  //     for (var company in provider.user?.companys ?? []) {
  //       chats.addAll(company.chats ?? []);
  //     }

  //     /// 排序
  //     chats.sort((a, b) {
  //       var num = (b.chatdata.value.isToping ? 10 : 0) -
  //           (a.chatdata.value.isToping ? 10 : 0);
  //       if (num == 0) {
  //         if (b.chatdata.value.lastMsgTime == a.chatdata.value.lastMsgTime) {
  //           num = b.isBelongPerson ? 1 : -1;
  //         } else {
  //           num = b.chatdata.value.lastMsgTime > a.chatdata.value.lastMsgTime
  //               ? 5
  //               : -5;
  //         }
  //       }
  //       return num;
  //     });
  //   }
  //   return chats;
  // }

  // int get noReadMgsCount {
  //   //处理所有未读消息
  //   refreshNoReadMgsCount();
  //   return _noReadMgsCount.value;
  // }

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
    emitter = Emitter();
    // // 监听消息加载
    // emitter.subscribe((key, args) {
    //   loadChats();
    // }, false);
    _provider = UserProvider(emitter);
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
    //监听内核是否在线
    kernel.onConnectedChanged((isConnected) {
      this.isConnected.value = isConnected;
      print('>>>===链接状态变更$isConnected');
    });
  }

  Future<void> loadChats([bool reload = false]) async {
    try {
      if (provider.user != null) {
        // this.chats.value = [];
        if (reload) {
          // TODO 后期晚上刷新列表
          await provider.user?.deepLoad(reload: reload);
        }
        List<ISession> chats = <ISession>[];
        chats.addAll(provider.user?.chats ?? []);
        for (var company in provider.user?.companys ?? []) {
          chats.addAll(company.chats ?? []);
        }
        chats = chats
            .where((element) =>
                element.chatdata.value.lastMessage != null ||
                element.chatdata.value.recently)
            .toList();

        /// 排序
        chats.sort((a, b) {
          var num = 0;
          if (b.chatdata.value.lastMsgTime == a.chatdata.value.lastMsgTime) {
            num = b.isBelongPerson ? 1 : -1;
          } else {
            num = b.chatdata.value.lastMsgTime > a.chatdata.value.lastMsgTime
                ? 5
                : -5;
          }
          return num;
        });
        for (var e in chats) {
          print('<<<===${e.chatdata.value.lastMsgTime} ${e.name}');
        }
        this.chats.value = chats;
      }
    } catch (e, s) {
      var msg = '\r\n$e === $s';
      provider.errInfo += msg;
    }
  }

  /// 订阅变更
  /// [callback] 变更回调
  /// 返回订阅ID
  String subscribe(void Function(String, List<dynamic>?) callback,
      [bool? target = true]) {
    return emitter.subscribe(callback, _provider.inited && target!);
  }

  /// 取消订阅 支持取消多个
  /// [key] 订阅ID
  void unsubscribe(dynamic key) {
    emitter.unsubscribe(key);
  }

  void initNoReadCommand() {
    //沟通未读消息提示处理
    command.subscribeByFlag('session', ([List<dynamic>? args]) {
      loadChats();
      refreshNoReadMgsCount();
    });
  }

  void refreshNoReadMgsCount() {
    if (chats.isNotEmpty) {
      if (noReadMgsCount.value != 0) {
        noReadMgsCount.value = 0;
      }
      for (var element in chats) {
        noReadMgsCount.value += element.chatdata.value.noReadCount;
      }
    }
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
        .map((a) => a.directory)
        .toList()) {
      apps.addAll((await directory.loadAllApplication()));
    }
    return apps;
  }

  void setHomeEnum(HomeEnum value) {
    homeEnum.value = value;
  }

  // void jumpInitiate() {
  //   switch (homeEnum.value) {
  //     case HomeEnum.chat:
  //       Get.toNamed(Routers.initiateChat);
  //       break;
  //     case HomeEnum.work:
  //       Get.toNamed(Routers.initiateWork);
  //       break;
  //     case HomeEnum.store:
  //       Get.toNamed(Routers.storeTree);
  //       break;
  //     case HomeEnum.relation:
  //       Get.toNamed(Routers.settingCenter);
  //       break;
  //     case HomeEnum.door:
  //       // TODO: Handle this case.
  //       break;
  //   }
  // }

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

  bool canAutoLogin([List<String>? account]) {
    account ??= Storage.getList(Constants.account);
    if (account.isNotEmpty && account.last != "") {
      return true;
    }
    return false;
  }

  void cancelAutoLogin() {
    Storage.setListValue(Constants.account, 1, "");
  }

  Future<void> autoLogin([List<String>? account]) async {
    print('>>>=====开始自动登录');
    account ??= Storage.getList(Constants.account);
    if (!canAutoLogin(account)) {
      return exitLogin(false);
    }

    String accountName = account.first;
    String passWord = account.last;
    var login = await provider.login(accountName, passWord);
    if (!login.success) {
      print('>>>=======自动登录异常');
      // exitLogin(false);

      if (kernel.isOnline) {
        Future.delayed(const Duration(milliseconds: 100), () async {
          await autoLogin();
        });
      } else {
        kernel.onConnectedChanged((isConnected) {
          if (isConnected && null == kernel.user) {
            autoLogin();
          }
        });
      }
    }
  }

  void exitLogin([bool cleanUserLoginInfo = true]) async {
    // if (cleanUserLoginInfo && canAutoLogin()) {
    //   cancelAutoLogin();
    // }
    if (null != Get.context) {
      LoadingDialog.dismiss(Get.context!);
    }
    kernel.stop();
    await HiveUtils.clean();
    homeEnum.value = HomeEnum.door;
    Storage.remove(Constants.sessionUser);
    // Storage.remove(Constants.account);
    Get.offAllNamed(Routers.login);
  }

  void qrScan() {
    Get.toNamed(Routers.qrScan)?.then((value) async {
      if (value != null) {
        if (null != value && value.length == 24 && value.indexOf('==') > 0) {
          print('$value>>>${value.length}');
          Get.toNamed(Routers.scanLogin, arguments: value);
        } else {
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
          } else {
            ToastUtils.showMsg(msg: "获取用户失败");
          }
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
          Routers.errorPage,
        );
        break;
      // case SettingEnum.vsrsion:
      //   Get.toNamed(
      //     Routers.version,
      //   );
      //   break;
      case SettingEnum.about:
        Get.toNamed(
          Routers.about,
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
  store("数据"),
  relation("关系"),
  setting("设置");

  final String label;

  const HomeEnum(this.label);
}
