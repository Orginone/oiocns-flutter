import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
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

const sessionUserName = 'sessionUser';
const sessionSpaceName = 'sessionSpace';

class ItemModel {
  String name;
  IconData icon;
  TargetType targetType;
  String title;
  String hint;
  ItemModel(this.name,this.icon,this.targetType,this.title,this.hint);
}


/// 设置控制器
class SettingController extends GetxController {
  String currentKey = "";
  StreamSubscription<UserLoaded>? _userSub;
  late UserProvider _provider;

  var homeEnum = HomeEnum.door.obs;

  var menuItems = [
    ItemModel('添加朋友', Icons.group_add,TargetType.person,"添加好友","请输入用户的账号"),
    ItemModel('加入群组', Icons.speaker_group,TargetType.cohort,"添加群组","请输入群组的编码"),
    ItemModel('加入单位组织', Icons.compare,TargetType.company,"添加单位","请输入单位的社会统一代码"),
    ItemModel('发起群聊', Icons.chat_bubble,TargetType.cohort,"发起群聊","请输入群聊信息"),
  ];

  @override
  void onInit() {
    super.onInit();
    _provider = UserProvider();
    _userSub = XEventBus.instance.on<UserLoaded>().listen((event) async {
      EventBusHelper.fire(ShowLoading(true));
      await _provider.loadData();
      EventBusHelper.fire(ShowLoading(false));
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
  Future<List<ITarget>> getTeamTree(
      IBelong space,
    [bool isShare = true]
  ) async {
    var result = <ITarget>[];
    result.add(space);
    if (space == user) {
      result.addAll([...(await user.loadCohorts(reload: false))??[]]);
    } else if (isShare) {
      result.addAll(
          [...(await (space as ICompany).loadGroups(reload: false))]);
    }
    return result;
  }

  /// 组织树
  Future<List<ITarget>> getCompanyTeamTree(
    ICompany company,
    bool isShare,
  ) async {
    var result = <ITarget>[];
    result.add(company);
    if (isShare) {
      var groups = await company.loadGroups(reload: false);
      result.addAll([...groups]);
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

  void showAddFeatures(int index, TargetType targetType, String title, String hint) {
     if(index == menuItems.length - 1){
       showCreateOrganizationDialog(
           Get.context!, [targetType],
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
             var data =  await user.createCohort(target);
             if(data!=null){
               ToastUtils.showMsg(msg: "创建成功");
             }
           },
       );
     }else{
       showSearchDialog(Get.context!,targetType,title: title,hint: hint,onSelected: (targets) async{
           if(targets.isNotEmpty){
             bool success = await user.applyJoin(targets);
             if(success){
               ToastUtils.showMsg(msg: "发送申请成功");
             }
           }
       });
     }
  }

  void exitLogin() async{
    kernel.stop();
    LocalStore.clear();
    await HiveUtils.clean();
    homeEnum.value = HomeEnum.door;
    Get.offAllNamed(Routers.login);
  }
}

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingController(), permanent: true);
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
