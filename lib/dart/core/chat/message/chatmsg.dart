import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/util/encryption_util.dart';

import '../../../../../main.dart';

const hisMsgCollName = 'chat-message';

abstract class IChatMessage {
  /// 归属用户
  abstract final IBelong belong;

  /// 会话的历史消息
  abstract final List<MsgSaveModel> messages;

  /// 消息变更通知
  void onMessage(void Function(List<MsgSaveModel>) callback);

  /// 禁用通知
  void unMessage();

  /// 加载更多历史消息
  Future<int> moreMessage({bool before = true});
}

class ChatMessage implements IChatMessage {
  ChatMessage(this.belong) : messages = <MsgSaveModel>[];

  @override
  final IBelong belong;

  @override
  final List<MsgSaveModel> messages;

  void Function(List<MsgSaveModel>)? messageNotify;

  @override
  void unMessage() {
    messageNotify = null;
  }

  @override
  void onMessage(void Function(List<MsgSaveModel>) callback) {
    messageNotify = callback;
    if (messages.length < 10) {
      moreMessage();
    }
  }

  @override
  Future<int> moreMessage({bool before = true}) async {
    var minTime = '2023-05-03 09:00:00.000';
    var maxTime = 'sysdate()';
    if (messages.isNotEmpty) {
      if (before) {
        maxTime = messages[0].createTime;
      } else {
        minTime = messages[messages.length].createTime;
      }
    }
    var res = await kernel.anystore.aggregate(
      hisMsgCollName,
      {
        "match": {
          "belongId": belong.metadata.id,
          "createTime": {
            "_gt_": minTime,
            "_lt_": maxTime,
          },
        },
        "sort": {
          "createTime": -1,
        },
        "limit": 100000,
      },
      belong.metadata.id!,
    );
    if (res.success && res.data != null) {
      _loadMessages(res.data, before);
      return res.data.length;
    }
    return 0;
  }

  void _loadMessages(List<dynamic> msgs, bool before) {
    for (var item in msgs) {
      if (item.chatId != null) {
        item["id"] = item["chatId"];
      }
      item = MsgSaveModel.fromJson(item);
      item.showTxt = EncryptionUtil.inflate(item.msgBody);
      if (before) {
        messages.insert(0, item);
      } else {
        messages.add(item);
      }
    }
    if (messageNotify != null) {
      messageNotify!(messages);
    }
  }
}
