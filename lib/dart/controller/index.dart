import 'dart:async';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/widgets/list_widget/index.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/base/common/emitter.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/auth.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/standard/index.dart';
import 'package:orginone/dart/core/user.dart';
import 'package:orginone/dart/core/work/provider.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/pages/relation/widgets/dialog.dart';
import 'package:orginone/utils/bus/event_bus_helper.dart';
import 'package:orginone/utils/hive_utils.dart';
import 'package:orginone/utils/index.dart';
import 'package:orginone/utils/string_util.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:orginone/components/widgets/dialog/loading_dialog.dart';

import '../../components/widgets/infoListPage/index.dart';
import 'app_data_controller.dart';

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
  ///未使用
  String currentKey = "";

  /// 用户加载事件订阅
  StreamSubscription<UserLoaded>? _userSub;

  /// 事件发射器
  late Emitter emitter;

  /// 数据提供者
  late UserProvider _provider;

  /// 数据提供者
  UserProvider get provider => _provider;

  /// 当前用户
  IPerson get user => provider.user;

  /// 办事提供者
  IWorkProvider get work => provider.work!;

  /// 所有相关的用户
  List<ITarget> get targets => provider.targets;

  /// 首页当前模块枚举
  var homeEnum = HomeEnum.door.obs;

  /// 沟通未读消息数
  RxInt noReadMgsCount = 0.obs;

  /// 所有沟通会话
  late RxList<ISession> chats = <ISession>[].obs;

  ///内核是否在线
  RxBool isConnected = false.obs;
  late AppDataController appDataController;

  ///用户头像菜单控制器
  late CustomPopupMenuController functionMenuController;

  ///模块顶部三点菜单控制器
  late CustomPopupMenuController settingMenuController;

  late InfoListPageModel dataStoreModel;
  late InfoListPageModel relationModel;

  /// 授权方法
  AuthProvider get auth {
    return provider.auth;
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
    // relationModel = InfoListPageModel(title: "关系", tabItems: [
    //   TabItemsModel(title: "全部"),
    //   TabItemsModel(title: "个人"),
    //   TabItemsModel(title: "单位")
    // ]);
    dataStoreModel = InfoListPageModel(
        title: "奥集能数据核",
        // avatar: IconWidget.icon(Icons.photo_camera,
        //     color: Colors.red //AppColors.onPrimary,
        //     ),
        tabItems: [
          TabItemsModel(title: "文件", tabItems: [
            TabItemsModel(title: "全部"),
            TabItemsModel(title: "当前目录"),
            TabItemsModel(title: "下级目录"),
            TabItemsModel(title: "字典"),
            TabItemsModel(title: "属性")
          ]),
          TabItemsModel(title: "权限", tabItems: [
            TabItemsModel(title: "全部"),
            TabItemsModel(title: "内设机构"),
            TabItemsModel(title: "群组"),
            TabItemsModel(title: "集群"),
          ]),
          TabItemsModel(title: "设置", content: const Text("设置页面")),
        ]);

    appDataController = AppDataController();
    functionMenuController = CustomPopupMenuController();
    settingMenuController = CustomPopupMenuController();
    emitter = Emitter();
    // // 监听消息加载
    emitter.subscribe((key, args) {
      // loadChats();
      loadRelation();
    }, false);
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
    kernel.onConnectedChanged((isConnected) async {
      if (!isConnected) {
        // 用于排除正常重链情况
        Future.delayed(const Duration(milliseconds: 6000), () {
          if (!kernel.isOnline) {
            this.isConnected.value = isConnected;
          }
        });
      } else {
        this.isConnected.value = isConnected;
      }
    });
  }

  void loadRelation() {
    // RelationSubPage relationSubPage = RelationSubPage("_all");
    relationModel = InfoListPageModel(title: "关系", tabItems: [
      TabItemsModel(
          title: "全部",
          content: ListWidget<IEntity>(
            getDatas: ([dynamic data]) {
              if (null == data) {
                return <IEntity>[
                  user,
                  ...user.companys.map((item) => item).toList()
                ];
              } else if (data.typeName == "人员") {
                List<Directory> personData = [];
                XDirectory friendDir =
                    XDirectory(id: "1", directoryId: "1", isDeleted: false);
                friendDir.name = "好友";
                personData.add(Directory(friendDir, user));
                return personData;
              }
              return [
                {
                  "name": "好友",
                  "share": ShareIcon(
                    name: "好友",
                    typeName: "好友",
                  ),
                } as IEntity,
                {
                  "name": "群组",
                  "share": ShareIcon(
                    name: "群组",
                    typeName: "群组",
                  ),
                } as IEntity,
                {
                  "name": "资源",
                  "share": ShareIcon(
                    name: "资源",
                    typeName: "资源",
                  ),
                } as IEntity
              ];
            },
            // getTitle: (dynamic data) => Text(data.name),
            // getAvatar: (dynamic data) =>
            //     TeamAvatar(size: 35, info: TeamTypeInfo(share: data.share)),
            // getLabels: (dynamic data) => data.groupTags,
            // getDesc: (dynamic data) => Text(data.remark ?? ""),
            getAction: (dynamic data) {
              return GestureDetector(
                onTap: () {
                  print('>>>>>>======点击了感叹号');
                },
                child: const IconWidget(
                  color: XColors.black666,
                  iconData: Icons.info_outlined,
                ),
              );
            },
            onTap: (dynamic data, List children) {
              print('>>>>>>======点击了列表项 ${data.name}');
            },
          )),
      TabItemsModel(
          title: "个人",
          content: ListWidget<IEntity>(
            getDatas: ([dynamic data]) {
              return [
                user,
              ];
            },
            // getTitle: (dynamic data) {
            //   return Text(data.name);
            // },
            // getAvatar: (dynamic data) {
            //   return TeamAvatar(
            //       size: 35, info: TeamTypeInfo(share: data.share));
            // },
            // getDesc: (dynamic data) {
            //   return Text(data.remark ?? "");
            // },
          )),
      TabItemsModel(
          title: "单位",
          content: ListWidget<IEntity>(
            getDatas: ([dynamic data]) {
              return [...user.companys.map((item) => item).toList()];
            },
            // getTitle: (dynamic data) {
            //   return Text(data.name);
            // },
            // getAvatar: (dynamic data) {
            //   return TeamAvatar(
            //       size: 35, info: TeamTypeInfo(share: data.share));
            // },
            // getDesc: (dynamic data) {
            //   return Text(data.remark ?? "");
            // },
          )),
      // TabItemsModel(title: "好友", content: const Text("好友页面")),
      // TabItemsModel(title: "动态", content: const Text("动态页面")),
      // TabItemsModel(title: "文件", tabItems: [
      //   TabItemsModel(title: "全部"),
      //   TabItemsModel(title: "当前目录"),
      //   TabItemsModel(title: "下级目录"),
      //   TabItemsModel(title: "字典"),
      //   TabItemsModel(title: "属性")
      // ]),
    ]);
  }

  /// 加载消息
  Future<void> loadChats([bool reload = false]) async {
    try {
      if (reload) {
        await provider.user.cacheObj.all(true);
        // TODO 后期刷新列表
        await Future.wait(chats.map((element) => element.refreshMessage()));
        chats.value = filterAndSortChats(chats);
      } else {
        List<ISession> tmpChats = <ISession>[];
        tmpChats.addAll(provider.user.chats ?? []);
        for (var company in provider.user.companys ?? []) {
          tmpChats.addAll(company.chats ?? []);
        }
        chats.value = filterAndSortChats(tmpChats);
      }
      refreshNoReadMgsCount();
    } catch (e, s) {
      var msg = '\r\n$e === $s';
      provider.errInfo += msg;
    }
  }

  /// 过滤和排序消息
  List<ISession> filterAndSortChats(List<ISession> chats) {
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

    return chats;
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
      if (provider.inited) {
        loadChats();
      }
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

  /// 唤醒
  void wakeUp() {
    kernel.restart().then((value) async {
      await relationCtrl.loadChats(true);
      relationCtrl.chats.refresh();
    });
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

  /// 自动登录
  Future<void> autoLogin([List<String>? account]) async {
    account ??= Storage.getList(Constants.account);
    if (!canAutoLogin(account)) {
      return exitLogin(false);
    }

    String accountName = account.first;
    String passWord = account.last;
    var login = await provider.login(accountName, passWord);
    if (login.success) {
      Get.offAndToNamed(Routers.logintrans, arguments: true);
    } else {
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
          Get.toNamed(Routers.scanLogin, arguments: value);
        } else if (StringUtil.isJson(value)) {
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
