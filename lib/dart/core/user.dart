import 'dart:convert';

import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/chat/provider.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/event/home_data.dart';
import 'package:orginone/main.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/notification_util.dart';

import 'enum.dart';
import 'target/base/team.dart';
import 'target/identity/identity.dart';
import 'target/innerTeam/station.dart';
import 'thing/standard/application.dart';
import 'thing/store/provider.dart';
import 'work/provider.dart';

class UserProvider {
  final Rxn<IPerson> _user = Rxn();
  final Rxn<IWorkProvider> _work = Rxn();
  final Rxn<IChatProvider> _chat = Rxn();

  final Rxn<IStoreProvider> _store = Rxn();

  var myApps = <Map<IApplication, ITarget>>[].obs;
  bool _inited = false;

  UserProvider() {
    kernel.on('ChatRefresh', () async {
      await reloadChats();
    });
    kernel.on('RecvTarget', (data) async {
      if (_inited) {
        _recvTarget(data);
      }
    });
    kernel.on('RecvIdentity', (data) async {
      if (_inited) {
        _recvIdentity(data);
      }
    });
    kernel.on('RecvTags', (data) async {
      try {
        TagsMsgType tagsMsgType = TagsMsgType.fromJson(data);
        var currentChat = chat?.allChats.firstWhere((element) =>
            element.chatId == tagsMsgType.id &&
            element.belong.id == tagsMsgType.belongId);
        currentChat?.overwriteMessagesTags(tagsMsgType);
      } catch (e) {}
    });
  }

  List<ITarget> get targets {
    final List<ITarget> targets = [];
    if (_user.value != null) {
      targets.addAll(_user.value!.targets);
      for (final company in _user.value!.companys) {
        targets.addAll(company.targets);
      }
    }
    return targets;
  }

  /// 当前用户
  IPerson? get user {
    return _user.value;
  }

  IWorkProvider? get work {
    return _work.value;
  }

  IChatProvider? get chat {
    return _chat.value;
  }

  IStoreProvider? get store {
    return _store.value;
  }

  /// 是否完成初始化
  bool get inited {
    return _inited;
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
  Future<ResultType> resetPassword(
    String account,
    String password,
    String privateKey,
  ) async {
    return await kernel.resetPassword(account, password, privateKey);
  }

  /// 加载用户
  _loadUser(XTarget person) async {
    _user.value = Person(person);
    _chat.value = ChatProvider(_user.value!);
    _work.value = WorkProvider(this);
    _store.value = StoreProvider(_user.value!);
    EventBusHelper.fire(StartLoad());
  }

  ///加载消息数据
  Future<void> loadChatData() async {
    if (_inited) {
      print('开始加载沟通数据-------${DateTime.now()}');
      _chat.value?.preMessage();
      _chat.value?.loadAllChats();
      await Future.wait([
        _chat.value!.loadPreMessage(),
        _chat.value!.loadMostUsed(),
      ]);
      print('加载沟通数据完成-------${DateTime.now()}');
      _chat.refresh();
    } else {
      await loadChatData();
    }
  }

  ///加载办事数据
  Future<void> loadWorkData() async {
    if (_inited) {
      print('开始加载办事数据-------${DateTime.now()}');
      await Future.wait([
        _work.value!.loadTodos(reload: true),
        _work.value!.loadMostUsed(),
      ]);
      _work.refresh();
      print('加载办事数据完成-------${DateTime.now()}');
    } else {
      await loadWorkData();
    }
  }

  ///加载存储数据
  Future<void> loadStoreData() async {
    if (_inited) {
      print('开始加载存储数据-------${DateTime.now()}');
      await Future.wait([
        _store.value!.loadMostUsed(),
        _store.value!.loadRecentList(),
      ]);
      _store.refresh();
      print('加载存储数据完成-------${DateTime.now()}');
    } else {
      await loadStoreData();
    }
  }

  ITarget? findTarget(String belongId) {
    for (var element in user?.targets ?? []) {
      if (element.id == belongId) {
        return element;
      }
    }
    return null;
  }

  void refreshWork() {
    _work.refresh();
  }

  void refreshChat() {
    _chat.refresh();
  }

  /// 重载数据
  Future<void> loadData() async {
    if (kernel.isOnline && kernel.anystore.isOnline) {
      print('开始加载数据-------${DateTime.now()}');
      _inited = false;
      await _user.value!.deepLoad(reload: true, reloadContent: false);
      _inited = true;
      _user.refresh();
      print('加载数据完成-------${DateTime.now()}');
      EventBusHelper.fire(LoadUserDone());
    } else {
      await Future.delayed(const Duration(milliseconds: 100), () async {
        await loadData();
      });
    }
  }

  Future<void> loadContent() async {
    await _user.value!.deepLoad(reload: false, reloadContent: true);
  }

  Future<void> reloadChats() async {
    await _user.value?.deepLoad(reload: true);
    _chat.value?.loadAllChats();
    await _chat.value?.loadPreMessage();
    _chat.refresh();
  }

  Future<void> loadApps([bool reload = false]) async {
    List<Map<IApplication, ITarget>> apps = [];
    print('开始加载应用-------${DateTime.now()}');
    for (var target in _user.value!.targets) {
      var applications =
          await target.directory.loadAllApplications(reload: reload);
      for (var element in applications) {
        apps.add({element: target.space});
      }
    }
    myApps.value = apps.where((a) {
      return apps.indexWhere((x) => x.keys.first.id == a.keys.first.id) ==
          apps.indexOf(a);
    }).toList();
    print('加载应用完成-------${DateTime.now()}');
    myApps.refresh();
    EventBusHelper.fire(LoadApplicationDone());
  }

  Future<void> _recvTarget(String recvData) async {
    final data = TargetOperateModel.fromJson(json.decode(recvData));
    if (user == null) return;

    final allTarget = List<ITeam>.from(user!.targets);
    for (var a in user!.companys) {
      allTarget.addAll(a.stations);
    }

    String message = '';
    switch (OperateType.getType(data.operate!)) {
      case OperateType.delete:
        message = '${data.operater?.name}将${data.target!.name}删除.';
        allTarget
            .where((i) => i.id == data.target!.id)
            .forEach((i) => i.delete());
        break;
      case OperateType.update:
        message = '${data.operater?.name}将${data.target!.name}信息更新.';
        break;
      case OperateType.remove:
        if (data.subTarget != null) {
          var operated = false;
          for (final item in [user, ...user!.companys]) {
            if (item!.id == data.subTarget!.id) {
              message =
                  '${item.id == user!.id ? '您' : item.metadata.name}已被${data.operater?.name}从${data.target!.name}移除.';
              item.parentTarget
                  .where((i) => i.id == data.target!.id)
                  .forEach((i) {
                i.delete();
                operated = true;
              });
            }
          }
          if (!operated) {
            message =
                '${data.operater?.name}把${data.subTarget!.name}从${data.target!.name}移除.';
            allTarget
                .where((i) =>
                    i.id == data.target!.id ||
                    data.target!.id == data.subTarget!.id)
                .forEach((i) {
              i.removeMembers([data.subTarget!]);
            });
          }
        }
        break;
      case OperateType.add:
        if (data.subTarget != null) {
          var operated = false;
          message =
              '${data.operater?.name}把${data.subTarget!.name}与${data.target!.name}建立关系.';
          for (final item in [user, ...user!.companys]) {
            if (item!.id == data.subTarget!.id &&
                await item.teamChangedNotity(data.target!)) {
              operated = true;
            }
          }
          if (!operated) {
            for (final item in allTarget) {
              if (item.id == data.target!.id) {
                await item.teamChangedNotity(data.subTarget!);
              }
            }
          }
        }
        break;
    }

    if (message.isNotEmpty) {
      if (data.operater?.id != user!.id) {
        NotificationUtil.showMsgNotification("信息变更", message);
      }
    }
  }

  void _recvIdentity(String recvData) {
    final data = IdentityOperateModel.fromJson(json.decode(recvData));
    if (user == null) return;
    final targets = user!.targets;
    for (var a in user!.companys) {
      targets.addAll(a.cohorts);
    }
    final identitys = <IIdentity>[];
    final stations = <IStation>[];
    for (var i in targets) {
      if (i.id == data.identity!.shareId) {
        identitys.addAll(i.identitys.where((s) => s.id == data.identity!.id));
      }
    }
    for (var a in user!.companys) {
      stations.addAll(a.stations);
    }
    var message = '';
    switch (OperateType.getType(data.operate!)) {
      case OperateType.create:
        message = '${data.operater?.name}新增身份【${data.identity!.name}】.';
        for (var a in targets) {
          if (a.identitys.every((q) => q.id != data.identity!.id)) {
            a.identitys.add(Identity(a, data.identity!));
          }
        }
        break;
      case OperateType.delete:
        message = '${data.operater?.name}将身份【${data.identity!.name}】删除.';
        for (var a in identitys) {
          a.delete();
        }
        for (var i in stations) {
          i.removeIdentitys([data.identity!]);
        }
        break;
      case OperateType.update:
        // user.updateMetadata(data.identity);
        break;
      case OperateType.remove:
        if (data.station != null) {
          message =
              '${data.operater?.name}移除岗位【${data.station!.name}】中的身份【${data.identity!.name}】.';
          stations
              .firstWhereOrNull((s) => s.id == data.station!.id)
              ?.removeIdentitys([data.identity!]);
        } else {
          message =
              '${data.operater?.name}移除赋予【${data.subTarget!.name}】的身份【${data.identity!.name}】.';
          for (var i in identitys) {
            i.removeMembers([data.subTarget!]);
          }
        }
        break;
      case OperateType.add:
        if (data.station != null) {
          message =
              '${data.operater?.name}向岗位【${data.station!.name}】添加身份【${data.identity!.name}】.';
          stations
              .firstWhereOrNull((s) => s.id == data.station!.id)
              ?.pullIdentitys([data.identity!]);
        } else {
          message =
              '${data.operater?.name}赋予{${data.subTarget!.name}身份【${data.identity!.name}】.';
          for (var i in identitys) {
            i.pullMembers([data.subTarget!]);
          }
        }
        break;
    }
    if (message.isNotEmpty) {
      if (data.operater?.id != user!.id) {
        NotificationUtil.showMsgNotification("身份变更", message);
      }
    }
  }
}
