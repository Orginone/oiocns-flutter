import 'dart:convert';

import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/chat/ichat.dart';
import 'package:orginone/dart/core/target/targetMap.dart';
import 'package:orginone/main.dart';
import 'package:orginone/util/encryption_util.dart';
import 'package:orginone/util/logger.dart';

const hisMsgCollName = 'chat-message';
var nullTime = DateTime(2022, 7, 1).millisecondsSinceEpoch;

class BaseChat implements IChat {
  @override
  String chatId;

  @override
  String fullId;

  @override
  RxBool isTopping;

  @override
  RxList<XImMsg> messages;

  @override
  RxInt noReadCount;

  @override
  RxInt personCount;

  @override
  RxList<XTarget> persons;

  @override
  String spaceId;

  @override
  ChatModel target;

  @override
  String userId;

  @override
  int lastMsgTime;

  @override
  Rx<XImMsg?> lastMessage;

  BaseChat(this.spaceId, ChatModel model, this.userId)
      : target = model,
        messages = <XImMsg>[].obs,
        persons = <XTarget>[].obs,
        personCount = 0.obs,
        chatId = model.id,
        noReadCount = 0.obs,
        isTopping = false.obs,
        fullId = '$spaceId-${model.id}',
        lastMsgTime = nullTime,
        lastMessage = Rxn() {
    appendShare(target.id, shareInfo);
    kernel.anystore.subscribed("$hisMsgCollName.T$fullId", userId, (data) {
      if (data.length == 0) {
        return;
      }
      loadCache(ChatCache.fromMap(data));
    });
  }

  @override
  cache() {
    kernel.anystore.set(
      "$hisMsgCollName.T$fullId",
      {
        "operation": "replaceAll",
        "data": {
          "fullId": fullId,
          "isToping": isTopping,
          "noReadCount": noReadCount,
          "lastMsgTime": lastMsgTime,
          "lastMessage": lastMessage.value,
        },
      },
      userId,
    );
  }

  @override
  destroy() {
    kernel.anystore.unSubscribed("$hisMsgCollName.T$fullId", userId);
  }

  @override
  TargetShare get shareInfo {
    var share = TargetShare(
      name: target.name,
      typeName: target.typeName,
    );
    if (target.photo.isNotEmpty && "{}" != target.photo) {
      try {
        var map = jsonDecode(target.photo);
        share.avatar = FileItemShare.fromJson(map);
      } catch (e) {
        Log.info("photo converting error:$e");
      }
    }
    return share;
  }

  @override
  onMessage() {
    if (noReadCount.value > 0) {
      noReadCount.value = 0;
    }
    cache();
    if (messages.length < 10) {
      moreMessage();
    }
    morePersons();
  }

  @override
  ChatCache getCache() {
    return ChatCache(
      fullId: fullId,
      noReadCount: noReadCount.value,
      isTopping: isTopping.value,
      lastMsgTime: lastMsgTime,
      lastMessage: lastMessage.value,
    );
  }

  @override
  loadCache(ChatCache cache) {
    isTopping.value = cache.isTopping;
    if (cache.noReadCount != noReadCount.value) {
      noReadCount.value = cache.noReadCount;
    }
    lastMsgTime = cache.lastMsgTime ?? nullTime;
    if (cache.lastMessage != null &&
        cache.lastMessage?.id != lastMessage.value?.id) {
      lastMessage.value = cache.lastMessage;
      var index = messages.indexWhere((i) => i.id == cache.lastMessage?.id);
      if (index > -1) {
        messages[index] = cache.lastMessage!;
      } else {
        messages.insert(0, cache.lastMessage!);
      }
    }
  }

  @override
  clearMessage() async {
    if (spaceId == userId) {
      var res = await kernel.anystore.remove(
          hisMsgCollName, {"sessionId": target.id, "spaceId": spaceId}, 'user');
      if (res.success) {
        messages.clear();
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> deleteMessage(String id) async {
    if (userId == spaceId) {
      var res = await kernel
          .anystore
          .remove(hisMsgCollName, {"chatId": id}, 'user');
      if (res.success && res.data > 0) {
        messages.removeWhere((item) => item.id == id);
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> recallMessage(String id) async {
    for (var message in messages) {
      if (message.id == id) {
        await kernel.recallImMsg(message);
      }
    }
  }

  @override
  Future<void> morePersons({String? filter}) async {
    return;
  }

  @override
  Future<int> moreMessage({String? filter}) async {
    var res = await kernel.anystore.aggregate(
        hisMsgCollName,
        {
          "match": {
            "sessionId": target.id,
            "belongId": spaceId,
          },
          "sort": {
            "createTime": -1,
          },
          "skip": messages.length,
          "limit": 30,
        },
        userId);
    if (res.success) {
      loadMessages(res.data);
      return res.data.length;
    }
    return 0;
  }

  @override
  Future<bool> sendMessage(MessageType type, String msgBody) async {
    var res = await kernel.createImMsg(ImMsgModel(
      msgType: type.label,
      msgBody: EncryptionUtil.deflate(msgBody),
      spaceId: spaceId,
      fromId: userId,
      toId: chatId,
    ));
    return res.success;
  }

  @override
  receiveMessage(XImMsg msg) async {
    if (msg.msgType == "recall") {
      msg.showTxt = '撤回一条消息';
      msg.allowEdit = true;
      msg.msgBody = EncryptionUtil.inflate(msg.msgBody);
      int index = messages.indexWhere((item) => item.id == msg.id);
      if (index > -1) {
        messages[index] = msg;
      }
    } else {
      msg.showTxt = EncryptionUtil.inflate(msg.msgBody);
      messages.insert(0, msg);
    }
    noReadCount.value += 1;
    lastMessage.value = msg;
    cache();
  }

  loadMessages(List<dynamic> messages) {
    for (var message in messages) {
      message["id"] = message["chatId"];
      var detail = XImMsg.fromJson(message);
      detail.showTxt = EncryptionUtil.inflate(detail.msgBody);
      this.messages.add(detail);
    }
  }

  Future<int> loadCacheMessages() async {
    var res = await kernel.anystore.aggregate(
          hisMsgCollName,
          {
            "match": {
              "sessionId": target.id,
              "spaceId": spaceId,
            },
            "sort": {"createTime": -1},
            "skip": messages.length,
            "limit": 30
          },
          'user',
        );
    if (res.success) {
      loadMessages(res.data);
      return res.data.length;
    }
    return 0;
  }
}

class PersonChat extends BaseChat {
  PersonChat(super.spaceId, super.m, super.userId);
}

class CohortChat extends BaseChat {
  CohortChat(super.id, super.m, super.userId);

  @override
  morePersons({String? filter}) async {
    var res = await kernel.querySubTargetById(IDReqSubModel(
      id: target.id,
      typeNames: [target.typeName],
      subTypeNames: [TargetType.person.label],
      page: PageRequest(
        limit: 14,
        offset: persons.length,
        filter: filter ?? "",
      ),
    ));
    if (res.success && res.data != null && res.data?.result != null) {
      for (var target in res.data!.result!) {
        target.name = target.team?.name ?? target.name;
        persons.add(target);
      }
      personCount.value = res.data?.total ?? 0;
    }
  }
}

/// 创建用户会话
IChat createChat(
  String userId,
  String spaceId,
  XTarget target,
  List<String> labels,
) {
  if (userId == target.id) {
    labels = ["本人"];
  }
  var data = ChatModel(
    id: target.id,
    name: target.team?.name ?? target.name,
    photo: target.avatar.isNotEmpty ? target.avatar : "{}",
    labels: labels,
    remark: target.team?.remark ?? "",
    typeName: target.typeName,
  );
  if (target.typeName == TargetType.person.label) {
    return PersonChat(spaceId, data, userId);
  } else {
    return CohortChat(spaceId, data, userId);
  }
}

/// 创建权限会话
IChat createAuthChat(
  String userId,
  String spaceId,
  String spaceName,
  XAuthority target,
) {
  var data = ChatModel(
    id: target.id!,
    labels: [spaceName, '权限群'],
    typeName: '权限',
    photo: '{}',
    remark: target.remark ?? "",
    name: target.name!,
  );
  return CohortChat(spaceId, data, userId);
}
