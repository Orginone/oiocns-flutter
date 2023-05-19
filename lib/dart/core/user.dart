import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/thing/base/work.dart';
import 'package:orginone/main.dart';
import 'package:orginone/util/event_bus.dart';
import 'package:orginone/util/toast_utils.dart';

import 'work/provider.dart';


class UserProvider {
  final Rxn<IPerson> _user = Rxn();
  final Rxn<IWorkProvider> _work = Rxn();
  final RxBool _inited = false.obs;
  List<XImMsg> _preMessages = [];

  UserProvider() {
    kernel.on('ChatRefresh', () async {
      await reload();
    });
    kernel.on('RecvMsg', (data) {
      var item = XImMsg.fromJson(data);
      if (_inited.value) {
        _recvMessage(item);
      } else {
        _preMessages.add(item);
      }
    });
    kernel.on('RecvTask', (data) {
      var work = XWorkTask.fromJson(data);
      if (_inited.value) {
        _work.value?.updateTask(data);
      }
    });
  }

  /// 当前用户
  IPerson? get user {
    return _user.value;
  }

  IWorkProvider? get work{
    return _work.value;
  }

  /// 是否完成初始化
  bool get inited {
    return _inited.value;
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
    return res;
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
    return await kernel.resetPassword(account, password, privateKey);
  }

  /// 加载用户
  _loadUser(XTarget person) async {
    _user.value = Person(person);
    if(_user.value!=null){
      _work.value = WorkProvider(_user.value!);
    }
    XEventBus.instance.fire(UserLoaded());
  }

  /// 重载数据
  Future<void> reload() async {
    _inited.value = false;
    await _user.value?.loadCohorts(reload: true);
    await _user.value?.loadMembers(reload: true);
    await _work.value?.loadTodos(reload: true);
    var companys = await _user.value?.loadCompanys(reload: true) ?? [];
    for (var company in companys) {
      await company.deepLoad();
      await company.loadMembers(reload: true);
    }
    _inited.value = true;
    _preMessages = _preMessages.where((item) {
      _recvMessage(item);
      return false;
    }).toList();
    refresh();
  }

  void refresh(){
    _user.refresh();
  }

  /// 接收到新信息
  /// @param data 新消息
  /// @param cache 是否缓存
  Future<void> _recvMessage(XImMsg data) async {
    for (final c in user?.chats ?? []) {
      bool isMatch = data.sessionId == c.chatId;
      if ((c.share.typeName == TargetType.person || c.share.typeName == '权限') &&
          isMatch) {
        isMatch = data.belongId == c.belongId;
      }
      if (isMatch) {
        c.receiveMessage(data);
      }
    }
  }
}
