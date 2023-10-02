import 'dart:convert';
import 'package:get/get.dart';
import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/base/common/emitter.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/main.dart';
import 'package:orginone/util/local_store.dart';
import 'thing/standard/application.dart';
import 'work/provider.dart';

const sessionUserName = 'sessionUser';

class UserProvider {
  UserProvider(Emitter emiter) {
    _emiter = emiter;
    final userJson = Storage.getString(sessionUserName);
    if (userJson.isNotEmpty) {
      _loadUser(jsonDecode(userJson));
    }
  }

  late IPerson? _user;
  late IWorkProvider? _work;
  bool _inited = false;
  late Emitter _emiter;
  var myApps = <Map<IApplication, ITarget>>[].obs;

  /// 当前用户
  IPerson? get user {
    return _user;
  }

  IWorkProvider? get work {
    return _work;
  }

  /// 是否完成初始化
  bool get inited {
    return _inited;
  }

  List<ITarget> get targets {
    final List<ITarget> targets = [];
    if (_user != null) {
      targets.addAll(_user!.targets);
      for (final company in _user!.companys) {
        targets.addAll(company.targets);
      }
    }
    return targets;
  }

  /// 登录
  /// @param account 账户
  /// @param password 密码
  Future<dynamic> login(String account, String password) async {
    var res = await kernel.login(account, password);
    if (res.success) {
      await _loadUser(XTarget.fromJson(res.data["target"]));
    }
    return res;
  }

  /// 注册用户
  /// @param {RegisterType} params 参数
  register(RegisterType params) async {
    var res = await kernel.register(params);
    if (res.success) {
      await _loadUser(res.data.target);
    }
    return res;
  }

  /// 变更密码
  /// @param account 账号
  /// @param password 密码
  /// @param privateKey 私钥
  /// @returns
  Future<ResultType> resetPassword(
    String account,
    String password,
    String privateKey,
  ) async {
    return await kernel.resetPassword(account, password, privateKey);
  }

  /// 加载用户
  _loadUser(XTarget person) async {
    Storage.setJson(sessionUserName, jsonEncode(person.toJson()));
    kernel.userId = person.id;
    _user = Person(person);
    _work = WorkProvider(this);
    refresh();
  }

  /// 重载数据
  Future<void> refresh() async {
    _inited = false;
    await _user?.deepLoad(reload: true);
    await work?.loadTodos(reload: true);
    _inited = true;
    _emiter.changCallback();
    command.emitterFlag();
  }
}
