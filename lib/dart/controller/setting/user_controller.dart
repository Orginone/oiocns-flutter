import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/provider.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/store/provider.dart';
import 'package:orginone/dart/core/user.dart';
import 'package:orginone/dart/core/work/provider.dart';
import 'package:orginone/event/home_data.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/event_bus.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/local_store.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';

const sessionUserName = 'sessionUser';
const sessionSpaceName = 'sessionSpace';

enum Shortcut {
  addPerson("添加朋友", Icons.group_add),
  addGroup("加入群组", Icons.speaker_group),
  addCompany("加入单位组织", Icons.compare),
  addCohort("发起群聊", Icons.chat_bubble),
  createCompany("创建单位", Icons.compare);

  final String label;
  final IconData icon;
  const Shortcut(this.label, this.icon);
}

class ItemModel {
  Shortcut shortcut;
  TargetType? targetType;
  String title;
  String hint;
  ItemModel(
    this.shortcut, [
    this.title = '',
    this.hint = '',
    this.targetType,
  ]);
}

/// 设置控制器
class UserController extends GetxController {
  String currentKey = "";
  StreamSubscription<UserLoaded>? _userSub;
  late UserProvider _provider;

  var homeEnum = HomeEnum.door.obs;

  var menuItems = [
    ItemModel(
      Shortcut.addPerson,
      "添加好友",
      "请输入用户的账号",
      TargetType.person,
    ),
    ItemModel(Shortcut.addGroup, "添加群组", "请输入群组的编码", TargetType.cohort),
    ItemModel(Shortcut.addCompany, "添加单位", "请输入单位的社会统一代码", TargetType.company),
    ItemModel(Shortcut.addCohort, "发起群聊", "请输入群聊信息", TargetType.cohort),
    ItemModel(Shortcut.createCompany, "创建单位", "", TargetType.company),
  ];

  @override
  void onInit() {
    super.onInit();
    _provider = UserProvider();
    _userSub = XEventBus.instance.on<UserLoaded>().listen((event) async {
      EventBusHelper.fire(ShowLoading(true));
      await _provider.loadData();
      EventBusHelper.fire(ShowLoading(false));
      await Future.wait([
        _provider.loadChatData(),
        _provider.loadWorkData(),
        _provider.loadStoreData(),
        _provider.loadContent(),
      _provider.loadApps(),
      ]);
      EventBusHelper.fire(InitHomeData());
    });
  }

  @override
  void onClose() {
    _userSub?.cancel();
    super.onClose();
  }

  UserProvider get provider {
    return _provider;
  }

  IPerson get user {
    return _provider.user!;
  }

  IChatProvider get chat {
    return _provider.chat!;
  }

  IWorkProvider get work {
    return _provider.work!;
  }

  IStoreProvider get store {
    return _provider.store!;
  }

  /// 组织树
  Future<List<ITarget>> getTeamTree(IBelong space,
      [bool isShare = true]) async {
    var result = <ITarget>[];
    result.add(space);
    if (space == user) {
      result.addAll([...(await user.loadCohorts(reload: false)) ?? []]);
    } else if (isShare) {
      result.addAll([...(await (space as ICompany).loadGroups(reload: false))]);
    }
    return result;
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

  void showAddFeatures(ItemModel item) {
    if (item.shortcut == Shortcut.addCohort || item.shortcut == Shortcut.createCompany) {
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
          var data = item.shortcut == Shortcut.createCompany?await user.createCompany(target):await user.createCohort(target);
          if (data != null) {
            ToastUtils.showMsg(msg: "创建成功");
          }
        },
      );
    } else {
      showSearchDialog(Get.context!, item.targetType!,
          title: item.title, hint: item.hint, onSelected: (targets) async {
        if (targets.isNotEmpty) {
          bool success = await user.applyJoin(targets);
          if (success) {
            ToastUtils.showMsg(msg: "发送申请成功");
          }
        }
      });
    }
  }

  void exitLogin({bool cleanUserLoginInfo = true}) async {
    if (cleanUserLoginInfo) {
      LocalStore.clear();
    }
    LoadingDialog.dismiss(Get.context!);
    kernel.stop();
    await HiveUtils.clean();
    homeEnum.value = HomeEnum.chat;
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
            if(success){
              ToastUtils.showMsg(msg: "申请发送成功");
            }else{
              ToastUtils.showMsg(msg: "申请发送失败");
            }
          }else{
            ToastUtils.showMsg(msg: "获取用户失败");
          }
        }else{
          ToastUtils.showMsg(msg: "获取用户失败");
        }
      }
    });
  }
}

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserController(), permanent: true);
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
