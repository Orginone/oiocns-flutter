import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/message_chats/message_chats_state.dart';
import 'package:orginone/pages/home/index/index_page.dart';

abstract class IChatProvider {
  /// 当前用户
  IPerson get user;

  /// 所有会话
  late RxList<IMsgChat> allChats;

  late RxList<MessageFrequentlyUsed> messageFrequentlyUsed;

  /// 指定会话
  List<IMsgChat> get topChats;

  List<IMsgChat> get chats;

  IMsgChat? currentChat;

  /// 挂起消息
  void preMessage();

  /// 加载消息
  Future<void> loadPreMessage();

  //设为常用
  Future<void> setMostUsed(IMsgChat msg);

  //设为常用
  Future<void> removeMostUsed(IMsgChat msg);

  //获取常用
  Future<void> loadMostUsed();

  void loadAllChats();

  bool isMostUsed(IMsgChat msg);
}

class ChatProvider implements IChatProvider {
  bool _preMessage = true;
  var _preMessages = <MsgSaveModel>[].obs;

  List<MsgTagModel> _preTags = [];

  @override
  IMsgChat? currentChat;
  @override
  final IPerson user;

  @override
  late RxList<MessageFrequentlyUsed> messageFrequentlyUsed;

  ChatProvider(this.user) {
    kernel.on('RecvMsg', (data) {
      if (!_preMessage) {
        _recvMessage(MsgSaveModel.fromJson(data));
      } else {
        _preMessages.add(MsgSaveModel.fromJson(data));
      }
    });
    kernel.on('RecvTags', (data) {
      var tag = MsgTagModel.fromJson(data);
      if (!_preMessage) {
        _chatReceive(tag);
      } else {
        _preTags.add(tag);
      }
    });
    allChats = RxList();
    messageFrequentlyUsed = RxList();
  }

  @override
  void preMessage() {
    _preMessage = true;
  }

  @override
  Future<void> loadPreMessage() async {
    var res = await kernel.anystore.get(StoreCollName.chatMessage, user.id);
    if (res.success) {
      if (res.data is Map<String, dynamic>) {
        for (var key in (res.data as Map).keys) {
          if (key!.startsWith('T') && res.data[key]['fullId'] != null) {
            var fullId = key.substring(1);
            var find = allChats
                .firstWhereOrNull((i) => i.chatdata.value.fullId == fullId);
            find?.loadCache(MsgChatData.fromMap(res.data[key]));
          }
        }
      }
      _preMessages.sort((a, b) {
        return DateTime.parse(a.createTime)
            .compareTo(DateTime.parse(b.createTime));
      });
      for (var element in _preMessages) {
        _recvMessage(element);
      }
      _preMessage = false;
    }
  }

  @override
  late RxList<IMsgChat> allChats;

  @override
  void loadAllChats() {
    allChats.clear();
    allChats.value = [...user.chats];
    for (final company in user.companys) {
      allChats.addAll(company.chats);
    }
    allChats.removeWhere((element) => !element.isMyChat);
  }

  void _recvMessage(MsgSaveModel data) {
    for (var c in allChats) {
      var isMatch = data.sessionId == c.chatId;
      if ((c.share.typeName == TargetType.person.label ||
              c.share.typeName == '权限') &&
          isMatch) {
        isMatch = data.belongId == c.belong.id;
      }
      if (isMatch) {
        c.receiveMessage(data, currentChat?.chatId == c.chatId);
      }
    }
  }

  void _chatReceive(MsgTagModel tagModel) {
    for (var c in allChats) {
      bool isMatch = tagModel.id == c.chatId;
      if ((c.share.typeName == TargetType.person.label ||
              c.share.typeName == '权限') &&
          isMatch) {
        isMatch = tagModel.belongId == c.belong.id;
      }
      if (isMatch) {
        c.receiveTags(tagModel.ids!, tagModel.tags!);
      }
    }
  }

  @override
// TODO: implement topChats
  List<IMsgChat> get topChats{
    var list = allChats.where((element) => element.labels.contains("置顶")).toList();
    list.sort((f, s) {
      return (s.chatdata.value.lastMsgTime) - (f.chatdata.value.lastMsgTime);
    });
    return list;
  }

  @override
// TODO: implement chats
  List<IMsgChat> get chats {
    var list =
        allChats.where((element) => !element.labels.contains("置顶")).toList();
    list.removeWhere((element) => element.chatdata.value.lastMessage == null);
    list.sort((f, s) {
      return (s.chatdata.value.lastMsgTime) - (f.chatdata.value.lastMsgTime);
    });
    return list;
  }


  @override
  Future<void> setMostUsed(IMsgChat msg) async {
    var res = await kernel.anystore.set(
      "${StoreCollName.mostUsed}.chats.T${msg.chatdata.value.fullId}",
      {},
      user.id,
    );
    if (res.success) {
      MessageFrequentlyUsed recent =  MessageFrequentlyUsed(
          chat: msg,
          name: msg.chatdata.value.chatName,
          id: msg.chatdata.value.fullId,
          avatar: msg.share.avatar?.thumbnailUint8List ??
              msg.share.avatar?.defaultAvatar);
      messageFrequentlyUsed.add(recent);
    }
  }

  @override
  Future<void> loadMostUsed() async{
    var res = await kernel.anystore.get(
      "${StoreCollName.mostUsed}.chats",
      user.id,
    );
    if(res.success && res.data!=null){
      messageFrequentlyUsed.clear();
      var chats = res.data;
      if (chats is Map<String, dynamic>) {
        for (var key in chats.keys) {
          var fullId = key.substring(1);
          var find = allChats
              .firstWhereOrNull((i) => i.chatdata.value.fullId == fullId);
          if(find!=null){
            messageFrequentlyUsed.add(MessageFrequentlyUsed(
                chat: find,
                name: find.chatdata.value.chatName,
                id: find.chatdata.value.fullId,
                avatar: find.share.avatar?.thumbnailUint8List ??
                    find.share.avatar?.defaultAvatar));
          }
        }
      }
    }
  }

  @override
  bool isMostUsed(IMsgChat msg) {
    return messageFrequentlyUsed.where((p0) => p0.id == msg.chatdata.value.fullId).isNotEmpty;
  }

  @override
  Future<void> removeMostUsed(IMsgChat msg) async{
    var res = await kernel.anystore.delete(
      "${StoreCollName.mostUsed}.chats.T${msg.chatdata.value.fullId}",
      user.id,
    );
    if(res.success){
      messageFrequentlyUsed.removeWhere((element) => element.id == msg.chatdata.value.fullId);
      messageFrequentlyUsed.refresh();
    }
  }

}
