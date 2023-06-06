import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/chat/provider.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/event/home_data.dart';
import 'package:orginone/main.dart';
import 'package:orginone/util/event_bus_helper.dart';

import 'work/provider.dart';

class UserProvider {
  final Rxn<IPerson> _user = Rxn();
  final Rxn<IWorkProvider> _work = Rxn();
  final Rxn<IChatProvider> _chat = Rxn();
  bool _inited = false;

  UserProvider() {
    kernel.on('ChatRefresh', () async {
      await reload();
    });
    kernel.on('RecvTarget', (data) async {
      if (_inited) {
        _recvTarget(data);
      }
    });
    kernel.on('RecvTags', (data) async {
       try{
         TagsMsgType tagsMsgType = TagsMsgType.fromJson(data);
         var currentChat = chat?.allChats.firstWhere((element) => element.chatId==tagsMsgType.id && element.belongId == tagsMsgType.belongId);
         currentChat?.overwriteMessagesTags(tagsMsgType);
       }catch(e){}
    });
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
    if (_user.value != null) {
      _work.value = WorkProvider(_user.value!);
      _chat.value = ChatProvider(_user.value!);
      EventBusHelper.fire(StartLoad());
    }
  }

  void refreshWork(){
    _work.refresh();
  }

  void refreshChat(){
    _chat.refresh();
  }


  /// 重载数据
  Future<void> reload() async {
       _inited = false;
       _chat.value?.preMessage();
       await _user.value?.deepLoad(reload: true);
       await _work.value?.loadTodos(reload: true);
       _inited = true;
       _chat.value?.loadPreMessage();
       _chat.value?.loadAllChats();
       _chat.refresh();
       _user.refresh();
  }




  void _recvTarget(data) {
    switch(data['TypeName']){
      case "Relation":
        XTarget xTarget = XTarget.fromJson(data['Target']);
        XTarget subTarget = XTarget.fromJson(data['SubTarget']);
        var target = [_user.value, ...user!.targets].firstWhere((element) => element!.id == xTarget.id,orElse: ()=>null);
        if(target!=null){
          target.recvTarget(data['Operate'], true, subTarget);
        }else if (_user.value!.id == subTarget.id) {
          _user.value!.recvTarget(data['Operate'], false, xTarget);
        }
        break;
    }
  }
}
