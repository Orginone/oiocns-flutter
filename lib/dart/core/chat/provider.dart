import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/main.dart';

abstract class IChatProvider {
  /// 当前用户
  IPerson get user;

  /// 所有会话
  List<IMsgChat> get chats;

  /// 挂起消息
  void preMessage();

  /// 加载消息
  void loadPreMessage();
}

class ChatProvider implements IChatProvider {
  bool _preMessage = true;
  final RxList<MsgSaveModel> _preMessages;

  List<MsgTagModel> _preTags = [];
  @override
  final IPerson user;

  ChatProvider(this.user) : _preMessages = <MsgSaveModel>[].obs {
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
        _chatReceive(tag.id!,tag.belongId!,(chat){
          chat.receiveTags(tag.ids!, tag.tags!);
        });
      } else {
        _preTags.add(tag);
      }
    });
  }

  @override
  void preMessage() {
    _preMessage = true;
  }

  @override
  void loadPreMessage() {
    kernel.anystore.get(StoreCollName.chatMessage,user.id).then((res) {
      if (res.success) {
        if (res.data is Map<String, dynamic>) {
          res.data.keys.forEach((key) {
            if (key!.startsWith('T') &&
                res.data[key]['fullId'] != null) {
              var fullId = key.substring(1);
              var find =
                  chats.firstWhereOrNull((i) => i.chatdata.value.fullId == fullId);
              find?.loadCache(MsgChatData.fromMap(res.data[key]));
            }
          });
        }
        _preMessages.sort((a, b){
          return DateTime.parse(a.createTime).compareTo(DateTime.parse(b.createTime));
        });
        for (var element in _preMessages) {
          _recvMessage(element);
        }
        _preMessage = false;
      }
    });
  }

  @override
  List<IMsgChat> get chats {
    final chats = [...user.chats];
    for (final company in user.companys) {
      chats.addAll(company.chats);
    }
    return chats;
  }

  void _recvMessage(MsgSaveModel data) {
    for (var c in chats) {
      var isMatch = data.sessionId == c.chatId;
      if ((c.share.typeName == TargetType.person.label ||
              c.share.typeName == '权限') &&
          isMatch) {
        isMatch = data.belongId == c.belongId;
      }
      if (isMatch) {
        c.receiveMessage(data);
      }
    }
  }

  void _chatReceive(String chatId, String belongId, void Function(IMsgChat) action) {
    for (var c in chats) {
      bool isMatch = chatId == c.chatId;
      if ((c.share.typeName == TargetType.person.label || c.share.typeName == '权限') && isMatch) {
        isMatch = belongId == c.belongId;
      }
      if (isMatch) {
        action(c);
      }
    }
  }
}
