import 'dart:convert';

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/pages/chat/widgets/info_item.dart';
import 'package:orginone/util/encryption_util.dart';

import 'msgchat.dart';

abstract class IMessageLabel {
  String get label;

  Future<ShareIcon> get labeler;

  String get time;

  String get userId;
}

class MessageLabel implements IMessageLabel {
  final IPerson user;
  final Tag metadata;

  MessageLabel(this.user, this.metadata);

  @override
  String get label => metadata.label;

  @override
  String get userId => metadata.userId;

  @override
  Future<ShareIcon> get labeler => user.findShareById(metadata.userId);

  @override
  String get time => metadata.time;
}

abstract class IMessage {
  String get id;
  late MsgSaveModel metadata;
  Future<ShareIcon> get from;
  Future<ShareIcon> get to;
  bool get isMySend;
  bool get isReaded;
  List<IMessageLabel> get labels;
  String get msgType;
  String get msgTitle;
  String get msgBody;
  String get msgSource;
  String get createTime;
  bool get allowRecall;
  bool get allowEdit;
  String get readedinfo;
  int get comments;

  MsgBodyModel? get body;
  void recall();
  void receiveTags(List<String> tags);
}

class Message implements IMessage {
  late IPerson user;
  late IMsgChat _chat;
  late String _msgBody;
  @override
  List<IMessageLabel> labels = [];
  @override
  late MsgSaveModel metadata;

  Message(this._chat, this.metadata) {
    _chat = _chat;
    user = _chat.space.user;
    if (metadata.msgType == 'recall') {
      metadata.msgType = MessageType.recall.label;
    }
    _msgBody = EncryptionUtil.inflate(metadata.msgBody);
    metadata.tags?.forEach((tag) {
      labels.add(MessageLabel(user,tag));
    });
  }

  @override
  String get id => metadata.id;

  @override
  String get msgType => metadata.msgType;

  @override
  String get createTime => metadata.createTime;

  @override
  Future<ShareIcon> get from => user.findShareById(metadata.fromId);

  @override
  Future<ShareIcon> get to => user.findShareById(metadata.toId);

  @override
  bool get isMySend => metadata.fromId == user.id;

  @override
  bool get isReaded {
    return _chat.isBelongPerson ||
        isMySend ||
        labels.any((i) => i.userId == user.id);
  }

  @override
  String get readedinfo {
    final ids = labels.map((v) => v.userId).toList();
    final readedCount = ids.toSet().length;
    if (_chat.share.typeName == TargetType.person.label) {
      return readedCount == 1 ? '已读' : '未读';
    }
    final mCount = (_chat.members.length - 1) ?? 1;
    if (readedCount == mCount) {
      return '全部已读';
    }
    if (readedCount == 0) {
      return '全部未读';
    }
    return '${mCount - readedCount}人未读';
  }

  @override
  int get comments {
    return labels.where((v) => v.label != '已读').length;
  }

  @override
  bool get allowRecall {
    return msgType != MessageType.recall.label &&
        metadata.fromId == user.id &&
        DateTime.now().millisecondsSinceEpoch -
            DateTime.parse(createTime).millisecondsSinceEpoch <
            2 * 60 * 1000;
  }

  @override
  bool get allowEdit {
    return isMySend && msgType == MessageType.recall.label;
  }

  @override
  String get msgTitle {
    var header = '';
    if (_chat.share.typeName != TargetType.person.label &&
        metadata.fromId != user.id) {
      from.then((value){
        header += value.name;
      });
    }
    switch (msgType) {
      case "文本":
      case "撤回":
        return '$header[消息]:${msgBody.substring(0, 50)}';
      default:
        var file = FileItemShare.parseAvatar(msgBody);
        if (file != null) {
          return '$header[$msgType]:${file.name}(${getFileSizeString(bytes: file.size??0)})';
        }
        return '$header[$msgType]:解析异常';
    }
  }

  @override
  String get msgBody {
    if (msgType == MessageType.recall.label) {
      from.then((value){
        return '${isMySend ? '我' :value.name}撤回了一条消息';
      });
    }
    return _msgBody;
  }

  @override
  String get msgSource {
    return _msgBody;
  }

  @override
  void recall() {
    metadata.msgType = MessageType.recall.label;
  }

  @override
  void receiveTags(List<String> tags) {
    for (var tag in tags) {
      var t = Tag.fromJson(jsonDecode(tag));
      labels.add(MessageLabel(user,t));
    }
  }

  @override
  // TODO: implement body
  MsgBodyModel? get body => metadata.body;
}
