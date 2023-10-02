import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/base/common/format.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'dart:convert';

// import { common, model, parseAvatar } from '../../base';
// import { MessageType, TargetType } from '../public';
// import { IPerson } from '../target/person';
// import { ISession } from './session';
abstract class IMessageLabel {
  /// 标签名称
  late String label;

  /// 贴标签的人
  late ShareIcon labeler;

  /// 贴标签的时间
  late String time;

  /// 用户Id
  late String userId;
}

class MessageLabel implements IMessageLabel {
  MessageLabel(CommentType matedata, IPerson user) {
    user = user;
    metadata = matedata;
  }
  late IPerson user;
  late CommentType metadata;
  @override
  String get label {
    return metadata.label;
  }

  @override
  String get userId {
    return metadata.userId;
  }

  @override
  ShareIcon get labeler {
    return user.findShareById(metadata.userId);
  }

  @override
  String get time {
    return metadata.time;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

abstract class IMessage {
  /// 消息id
  late String id;

  /// 元数据
  late ChatMessageType metadata;

  /// 发送方
  late ShareIcon from;

  /// 接收方
  late ShareIcon to;

  /// 是否是我发的
  late bool isMySend;

  /// 是否已读
  late bool isReaded;

  /// 提及
  late List<String> mentions;

  /// 引用
  late IMessage? cite;

  /// 标签信息
  late List<IMessageLabel> labels;

  /// 消息类型
  late String msgType;

  /// 消息标题
  late String msgTitle;

  /// 消息内容
  late String msgBody;

  /// 源消息
  late String msgSource;

  /// 创建时间
  late String createTime;

  /// 允许撤回
  late bool allowRecall;

  /// 允许编辑
  late bool allowEdit;

  /// 已读信息
  late String readedinfo;

  /// 已读人员
  late List<String> readedIds;

  /// 未读人员信息
  late List<IMessageLabel> unreadInfo;

  /// 评论数
  late int comments;
}

class Message implements IMessage {
  Message(ChatMessageType metadata, ISession chat) {
    _chat = chat;
    user = chat.target.user;
    metadata.comments = metadata.comments ?? [];
    var txt = StringPako.inflate(metadata.content);
    if (txt.startsWith('[obj]')) {
      var content = json.decode(txt.substring(5));
      _msgBody = content.body;
      mentions = content.mentions;
      if (content.cite) {
        cite = Message(content.cite, chat);
      }
    } else {
      _msgBody = txt;
    }
    metadata = metadata;
    metadata.comments.map((tag) => labels.add(MessageLabel(tag, user)));
  }

  @override
  IMessage? cite;
  @override
  List<String> mentions = [];
  late IPerson user;
  late ISession _chat;
  late String _msgBody;
  @override
  List<IMessageLabel> labels = [];
  @override
  late ChatMessageType metadata;
  @override
  String get id {
    return metadata.id;
  }

  @override
  String get msgType {
    return metadata.typeName;
  }

  @override
  String get createTime {
    return metadata.createTime!;
  }

  @override
  ShareIcon get from {
    return user.findShareById(metadata.fromId);
  }

  @override
  ShareIcon get to {
    return user.findShareById(metadata.toId);
  }

  @override
  bool get isMySend {
    return metadata.fromId == user.id;
  }

  @override
  bool get isReaded {
    return (_chat.isBelongPerson ||
        isMySend ||
        labels.any((i) => i.userId == user.id));
  }

  @override
  String get readedinfo {
    var ids = readedIds;
    if (_chat.metadata.typeName == TargetType.person) {
      return ids.length == 1 ? '已读' : '未读';
    }
    var mCount = _chat.members.where((i) => i.id != metadata.fromId).length;
    mCount = mCount > 0 ? mCount : 1;
    if (ids.length == mCount) {
      return '全部已读';
    }
    if (ids.isEmpty) {
      return '全部未读';
    }
    return '${mCount - ids.length}人未读';
  }

  @override
  List<String> get readedIds {
    var ids = labels.map((v) => v.userId).toList();
    var i = 0;
    return ids.where((id) => ids.indexOf(id) == i++).toList();
  }

  @override
  List<IMessageLabel> get unreadInfo {
    var ids = readedIds;
    return _chat.members
        .where((m) => !ids.contains(m.id) && m.id != user.id)
        .map(
          (m) => MessageLabel(
            {
              "label": m.remark,
              "userId": m.id,
              "time": '',
            } as CommentType,
            user,
          ),
        )
        .toList();
  }

  @override
  int get comments {
    return labels.where((v) => v.label != '已读').length;
  }

  @override
  bool get allowRecall {
    return (msgType != MessageType.recall &&
        metadata.fromId == user.id &&
        DateTime.now().millisecondsSinceEpoch -
                DateTime.parse(createTime).millisecondsSinceEpoch <
            2 * 60 * 1000);
  }

  @override
  bool get allowEdit {
    return isMySend && msgType == MessageType.recall;
  }

  @override
  String get msgTitle {
    var header = '';
    if (_chat.metadata.typeName != TargetType.person) {
      header += '${from.name}: ';
    }
    switch (MessageType.getType(msgType)) {
      case MessageType.text:
      case MessageType.notify:
      case MessageType.recall:
        return '$header${msgBody.substring(0, 50)}';
      case MessageType.voice:
        return '$header[${MessageType.voice}]';
    }
    FileItemShare file = parseAvatar(msgBody);
    if (file) {
      return '$header[$msgType]:${file.name}(${formatSize(file.size)})';
    }
    return '$header[$msgType]:解析异常';
  }

  @override
  String get msgBody {
    if (msgType == MessageType.recall) {
      return '${isMySend ? '我' : from.name}撤回了一条消息';
    }
    return _msgBody;
  }

  @override
  String get msgSource {
    return _msgBody;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}