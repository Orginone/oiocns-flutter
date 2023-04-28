import 'dart:async';

import 'package:get/get.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/dart/core/user.dart';
import 'package:orginone/event/home_data.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/event_bus.dart';
import 'package:orginone/util/event_bus_helper.dart';

const sessionUserName = 'sessionUser';
const sessionSpaceName = 'sessionSpace';

/// 设置控制器
class SettingController extends GetxController {
  String currentKey = "";
  StreamSubscription<UserLoaded>? _userSub;
  late UserProvider _provider;

  var homeEnum = HomeEnum.chat.obs;

  @override
  void onInit() {
    super.onInit();
    _provider = UserProvider();
    _userSub = XEventBus.instance.on<UserLoaded>().listen((event) async {
      EventBusHelper.fire(ShowLoading(true));
      await _provider.reload();
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

  /// 组织树
  Future<List<ITarget>> getTeamTree(
    ISpace space,
    bool isShare,
  ) async {
    var result = <ITarget>[];
    result.add(space);
    if (space == user) {
      result.addAll([...(await user.getCohorts(reload: false))??[]]);
    } else if (isShare) {
      result.addAll(
          [...(await (space as ICompany).getJoinedGroups(reload: false))]);
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

  void jumpSpaces() {
    // Get.toNamed(Routers.spaces)?.then((value) {
    //   if (value != null && value) {
    //     EventBusHelper.fire(InitHomeData());
    //   }
    // });
  }

  void setHomeEnum(HomeEnum value) {
    homeEnum.value = value;
  }

  void jumpInitiate() {
    switch (homeEnum.value) {
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
      case HomeEnum.door:
        // TODO: Handle this case.
        break;
    }
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
  warehouse("仓库"),
  shop("商店");

  final String label;

  const HomeEnum(this.label);
}
