import 'package:get/get.dart';
import 'package:orginone/dart/base/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/target/targetMap.dart';
import 'package:orginone/main.dart';
import 'package:orginone/util/event_bus.dart';

class UserProvider {
  final Rx<IPerson?> _user = Rxn();
  final RxBool _inited = false.obs;
  List<XImMsg> _preMessages = [];

  UserProvider() {
    kernelApi.on('ChatRefresh', () async {
      await reload();
    });
    kernelApi.on('RecvMsg', (data) {
      var item = XImMsg.fromJson(data);
      if (_inited.value) {
        _recvMessage(item);
      } else {
        _preMessages.add(item);
      }
    });
  }

  TargetShare findUserById(String id) {
    return findTargetShare(id);
  }

  String findNameById(String id) {
    return findTargetShare(id).name;
  }

  /// 当前用户
  IPerson? get user {
    return _user.value;
  }

  /// 是否完成初始化
  bool get inited {
    return _inited.value;
  }

  /// 登录
  /// @param account 账户
  /// @param password 密码
  Future<dynamic> login(String account, String password) async {
    var res = await kernelApi.login(account, password);
    if (res.success) {
      await _loadUser(XTarget.fromJson(res.data["person"]));
    }
    return res;
  }

  /// 注册用户
  /// @param {RegisterType} params 参数
  register(RegisterType params) async {
    var res = await kernelApi.register(params);
    if (res.success) {
      await _loadUser(XTarget.fromJson(res.data["person"]));
    }
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
    return await kernelApi.resetPassword(account, password, privateKey);
  }

  /// 加载用户
  _loadUser(XTarget person) async {
    _user.value = Person(person);
    XEventBus.instance.fire(UserLoaded());
  }

  /// 重载数据
  Future<void> reload() async {
    _inited.value = false;
    await _user.value?.getCohorts();
    await _user.value?.loadMembers(pageAll());
    await _user.value?.work.loadTodo();
    var companys = await _user.value?.getJoinedCompanys() ?? [];
    for (var company in companys) {
      await company.deepLoad();
      await company.loadMembers(pageAll());
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
    var sessionId = data.toId;
    if (data.toId == _user.value!.id) {
      sessionId = data.fromId;
    }
    for (var c in user!.allChats()) {
      var isMatch = sessionId == c.chatId;
      if (c.target.typeName == TargetType.person.label && isMatch) {
        isMatch = data.belongId == c.spaceId;
      }
      if (isMatch) {
        c.receiveMessage(data);
      }
    }
  }
}
