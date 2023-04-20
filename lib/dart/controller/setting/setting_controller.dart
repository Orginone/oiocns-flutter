import 'dart:async';

import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/chat/chat_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/event/home_data.dart';
import 'package:orginone/pages/setting/home/logic.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/event_bus.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/local_store.dart';
import 'package:orginone/util/toast_utils.dart';

const sessionUserName = 'sessionUser';
const sessionSpaceName = 'sessionSpace';

/// 设置控制器
class SettingController extends GetxController {
  String currentKey = "";
  final Rx<IPerson?> _user = Rxn();
  final Rx<ICompany?> _curSpace = Rxn();

  var homeEnum = HomeEnum.chat.obs;

  StreamSubscription<User>? _userSub;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _userSub = XEventBus.instance.on<User>().listen((event) async {
      await _loadUser(XTarget.fromJson(event.person));
    });
  }

  @override
  void onClose() {
    _userSub?.cancel();
    clear();
    super.onClose();
  }

  clear() {
    currentKey = "";
    _user.value = null;
    _curSpace.value = null;
  }

  /// 是否已登录
  bool get signed {
    return _user.value?.target.id != null;
  }

  /// 是否为单位空间
  bool isCompanySpace() {
    return _curSpace.value != null;
  }

  bool isUserSpace({ISpace? space}) {
    if(space!=null){
      return space.id == user?.id;
    }
    return !isCompanySpace();
  }
  /// 当前用户
  IPerson? get user => _user.value;

  /// 当前单位空间
  ICompany? get company => _curSpace.value;

  /// 当前空间对象
  ISpace get space {
    if (_curSpace.value != null) {
      return _curSpace.value!;
    }
    return _user.value!;
  }

  String findTargetShare(String id){
    String targetName = "奥集能平台";
    if(_user.value?.joinedFriend.isNotEmpty??false){
       try{
         targetName = _user.value!.joinedFriend.firstWhere((element) => element.id==id).team?.name??"";
       }catch(e){
         return targetName;
       }
    }

    return targetName;
  }

  String spaceName(ISpace space) {
    return space.id == user?.id ? "个人空间" : space.target.team?.name ?? "";
  }

  /// 设置当前空间
  setCurSpace(String id) async {
    if (id == space.id) {
      return;
    }
    if (id == _user.value!.id) {
      _curSpace.value = null;
    } else {
      _curSpace.value = _findCompany(id);
    }
    if (currentKey == "") {
      currentKey = space.key;
    }
    await KernelApi.getInstance().genToken(id);
  }

  /// 组织树
  Future<List<ITarget>> getTeamTree(bool isShare) async {
    var result = <ITarget>[];
    if (_curSpace.value != null) {
      result.add(space);
      if (isShare) {
        var groups = await _curSpace.value!.getJoinedGroups(reload: false);
        result.addAll([...groups]);
      }
    } else {
      result.add(_user.value!);
      var cohorts = await _user.value!.getCohorts(reload: false);
      result.addAll([...cohorts]);
    }
    return result;
  }

  /// 组织树
  Future<List<ITarget>> getCompanyTeamTree(
      ICompany company, bool isShare) async {
    var result = <ITarget>[];
    result.add(company);
    if (isShare) {
      var groups = await company.getJoinedGroups(reload: false);
      result.addAll([...groups]);
    }
    return result;
  }

  /// 加载组织树
  buildTargetTree(List<ITarget> targets, Function(ITarget)? menus) {
    var result = <Map<String, dynamic>>[];
    for (var item in targets) {
      result.add({
        "id": item.id,
        "item": item,
        "isLeaf": item.subTeam.isEmpty,
        "menus": menus != null ? menus(item) : [],
        "name": item == user ? '我的好友' : item.name,
        "children": buildTargetTree(item.subTeam, menus),
      });
    }
    return result;
  }

  /// 登录
  /// @param account 账户
  /// @param password 密码
  Future<ResultType<dynamic>> login(String account, String password) async {
    var res = await KernelApi.getInstance().login(account, password);
    if (res.success) {
      await _loadUser(XTarget.fromJson(res.data["person"]));
      XEventBus.instance.fire(SignIn());
    }
    return res;
  }

  /// 注册用户
  /// @param {RegisterType} params 参数
  Future<XTarget?> register(RegisterType params) async {
    XTarget? xTarget;
    var res = await KernelApi.getInstance().register(params);
    if (res.success) {
      ToastUtils.showMsg(msg: "您的账号私有密钥是————${res.data['privateKey']}");
    }else{
      ToastUtils.showMsg(msg: res.msg);
    }
    return xTarget;
  }

  /// 变更密码
  /// @param account 账号
  /// @param password 密码
  /// @param privateKey 私钥
  /// @returns
  Future<ResultType<bool>> resetPassword(
    String account,
    String password,
    String privateKey,
  ) async {
    return await KernelApi.getInstance().resetPassword(ResetPwdModel(code: account, password: password, privateKey: privateKey));
  }

  _loadUser(XTarget person) async {
    _user.value = Person(person);
    _curSpace.value = null;
    homeEnum.value = HomeEnum.chat;
    await load(person);
  }

  Future<void> load(XTarget person) async{
    if(KernelApi.getInstance().isOnline){
      await _user.value?.getJoinedCompanys(reload: true);
      _user.value?.joinedFriend.add(person);
      await space.loadMembers(PageRequest(offset: 0, limit: 9999, filter: ''));
      print('获取用户关系成功');
      XEventBus.instance.fire(SignIn());
    }else{
      Future.delayed(const Duration(milliseconds: 100),() async{
        await load(person);
      });
    }

  }

  ICompany? _findCompany(String id) {
    if (_user.value != null) {
      for (var company in _user.value!.joinedCompany) {
        if (company.target.id == id) {
          return company;
        }
      }
    }
    return null;
  }

  void jumpSpaces() {
    Get.toNamed(Routers.spaces)?.then((value) {
      if (value != null && value) {
        EventBusHelper.fire(InitHomeData());
      }
    });
  }

  void setHomeEnum(HomeEnum value) {
    homeEnum.value = value;
  }

  void jumpInitiate() {
    switch(homeEnum.value){
      case HomeEnum.chat:
        // TODO: Handle this case.
        break;
      case HomeEnum.work:
        Get.toNamed(Routers.initiateWork);
        break;
      case HomeEnum.warehouse:
        Get.toNamed(Routers.warehouseManagement);
        break;
      case HomeEnum.shop:
        // TODO: Handle this case.
        break;
    }
  }
}

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingController(), permanent: true);
    Get.put(ChatController(), permanent: true);
  }
}


enum HomeEnum{
  chat("沟通"),
  work("办事"),
  door("门户"),
  warehouse("仓库"),
  shop("商店");
  final String label;
  const HomeEnum(this.label);
}