import "package:get/get.dart";
import "package:orginone/dart/base/api/kernelapi.dart";
import "package:orginone/dart/base/model.dart";
import "package:orginone/dart/base/schema.dart";
import "package:orginone/dart/core/target/itarget.dart";
import "package:orginone/dart/core/target/person.dart";

var kernel = KernelApi.getInstance();

/// 设置控制器
class SettingController extends GetxController {
  final RxString currentKey = RxString("");
  final Rx<IPerson?> _user = Rxn();
  final Rx<ICompany?> _curSpace = Rxn();

  /// 是否已登录
  bool get signedIn {
    return _user.value != null;
  }

  /// 是否为单位空间
  bool isCompanySpace() {
    return _curSpace.value != null;
  }

  /// 当前用户
  IPerson? get user {
    return _user.value;
  }

  /// 当前单位空间
  ICompany? get company {
    return _curSpace.value;
  }

  /// 当前空间对象
  ISpace get space {
    if (_curSpace.value != null) {
      return _curSpace.value!;
    }
    return _user.value!;
  }

  /// 设置当前空间
  setCurSpace(String id) {
    if (id == _user.value?.id) {
      _curSpace.value = null;
    } else {
      _curSpace.value = _findCompany(id);
    }
    if (currentKey.isEmpty) {
      currentKey.value = space.key;
    }
    kernel.genToken(id);
  }

  /// 组织树
  Future<List<ITarget>> getTeamTree({bool isShare = true}) async {
    var result = <ITarget>[];
    if (company != null) {
      result.add(space);
      if (isShare) {
        var groups = await company!.getJoinedGroups(reload: false);
        result.addAll(groups);
      }
    } else {
      result.add(user!);
      var cohorts = await user!.getCohorts(reload: false);
      result.addAll(cohorts);
    }
    return result;
  }

  /// 加载组织树
  buildTargetTree(List<ITarget> targets, Function(ITarget)? menus) {
    var result = <dynamic>[];
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

  /// 查询组织信息
  /// @param id 组织id
  TargetShare? findTeamInfoById(String id) {
    // return findTargetShare(id);
    return null;
  }

  /// 登录
  /// @param account 账户
  /// @param password 密码
  Future<ResultType<dynamic>> login(String account, String password) async {
    var res = await kernel.login(account, password);
    if (res.success) {
      await _loadUser(res.data.person);
    }
    return res;
  }

  /// 注册用户
  /// @param {RegisterType} params 参数
  Future<ResultType<dynamic>> register(RegisterType params) async {
    var res = await kernel.register(params);
    if (res.success) {
      await _loadUser(res.data.person);
    }
    return res;
  }

  /// 变更密码
  /// @param account 账号
  /// @param password 密码
  /// @param
  /// privateKey 私钥
  /// @returns
  Future<ResultType<dynamic>> resetPassword(
    String account,
    String password,
    String privateKey,
  ) async {
    var model = ResetPwdModel(
      code: account,
      password: password,
      privateKey: privateKey,
    );
    return await kernel.resetPassword(model);
  }

  _loadUser(XTarget person) async {
    _user.value = Person(person);
    _curSpace.value = null;
    await _user.value?.getJoinedCompanys();
  }

  ICompany? _findCompany(String id) {
    if (_user.value != null && id.isNotEmpty) {
      for (var item in _user.value!.joinedCompany) {
        if (item.target.id == id) {
          return item;
        }
      }
    }
    return null;
  }
}

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController());
  }
}
