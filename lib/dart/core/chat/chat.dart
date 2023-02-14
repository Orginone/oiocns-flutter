import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/ichat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/util/encryption_util.dart';

const hisMsgCollName = 'chat-message';

class BaseChat extends IChat {
  BaseChat(String id, String name, ChatModel m, String userId) {
    spaceId = id;
    spaceName = name;
    target = m;
    messages = <XImMsg>[].obs;
    persons = <XTarget>[].obs;
    personCount = 0.obs;
    chatId = target.id;
    noReadCount = 0.obs;
    isTopping = false.obs;
    fullId = '$id-${target.id}';
    // appendShare(target.id, shareInfo());
  }

  TargetShare shareInfo() {
    return TargetShare(
      name: target.name,
      typeName: target.typeName,
      avatar: "", //parseAvatar(target.photo),
    );
  }

  @override
  ChatCache getCache() {
    return ChatCache(
      chatId: chatId,
      spaceId: spaceId,
      noReadCount: noReadCount.value,
      lastMessage: lastMessage.value,
      isTopping: isTopping.value,
    );
  }

  @override
  loadCache(ChatCache chatCache) {
    if (chatCache.lastMessage?.id != lastMessage.value?.id) {
      if (chatCache.lastMessage != null) {
        messages.insert(0, chatCache.lastMessage!);
      }
    }
    isTopping.value = chatCache.isTopping;
    noReadCount.value = chatCache.noReadCount;
    lastMessage.value = chatCache.lastMessage;
  }

  @override
  clearMessage() async {
    if (spaceId == userId) {
      var res = await KernelApi.getInstance().anystore.remove(
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
      var res = await KernelApi.getInstance()
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
        await KernelApi.getInstance().recallImMsg(message);
      }
    }
  }

  @override
  Future<void> morePersons({String? filter}) async {
    return;
  }

  @override
  Future<int> moreMessage({String? filter}) async {
    return 0;
  }

  @override
  Future<bool> sendMessage(MessageType type, String msgBody) async {
    var res = await KernelApi.getInstance().createImMsg(ImMsgModel(
      msgType: type.label,
      msgBody: EncryptionUtil.deflate(msgBody),
      spaceId: spaceId,
      fromId: userId,
      toId: chatId,
    ));
    return res.success;
  }

  @override
  receiveMessage(XImMsg msg, bool noRead) async {
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
    noReadCount.value += noRead ? 1 : 0;
    lastMessage.value = msg;
  }

  loadMessages(List<dynamic> messages) {
    for (var message in messages) {
      message["id"] = message["chatId"];
      var detail = XImMsg.fromJson(message);
      detail.showTxt = EncryptionUtil.inflate(detail.msgBody);
      messages.add(detail);
    }
  }

  Future<int> loadCacheMessages() async {
    var res = await KernelApi.getInstance().anystore.aggregate(
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

class BaseChatGroup extends IChatGroup {
  BaseChatGroup(
    String spaceId,
    String spaceName,
    bool isOpened,
    RxList<IChat> chats,
  ) {
    this.spaceId = spaceId;
    this.spaceName = spaceName;
    this.isOpened = isOpened.obs;
    this.chats = chats;
  }
}

class PersonChat extends BaseChat {
  PersonChat(super.id, super.name, super.m, super.userId);

  @override
  Future<int> moreMessage({String? filter}) async {
    if (spaceId == userId) {
      return await loadCacheMessages();
    } else {
      var res = await KernelApi.getInstance().queryFriendImMsgs(IdSpaceReq(
        id: target.id,
        spaceId: spaceId,
        page: PageRequest(
          limit: 30,
          offset: messages.length,
          filter: filter ?? "",
        ),
      ));
      if (res.success && res.data != null && res.data?.result != null) {
        for (var detail in res.data!.result!) {
          detail.showTxt = EncryptionUtil.inflate(detail.msgBody);
          messages.add(detail);
        }
        return res.data!.result!.length;
      }
    }
    return 0;
  }
}

class CohortChat extends BaseChat {
  CohortChat(super.id, super.name, super.m, super.userId);

  @override
  moreMessage({String? filter}) async {
    if (spaceId == userId) {
      return await loadCacheMessages();
    } else {
      var params = IDBelongReq(
        id: target.id,
        page: PageRequest(
          limit: 30,
          offset: messages.length,
          filter: filter ?? "",
        ),
      );
      var res = await KernelApi.getInstance().queryCohortImMsgs(params);
      if (res.success && res.data != null && res.data?.result != null) {
        for (var detail in res.data!.result!) {
          detail.showTxt = EncryptionUtil.inflate(detail.msgBody);
          messages.add(detail);
        }
        return res.data!.result!.length;
      }
    }
    return 0;
  }

  @override
  morePersons({String? filter}) async {
    var res = await KernelApi.getInstance().querySubTargetById(IDReqSubModel(
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

IChat createChat(
  String spaceId,
  String spaceName,
  ChatModel target,
  String userId,
) {
  if (target.typeName == TargetType.person.label) {
    return PersonChat(spaceId, spaceName, target, userId);
  } else {
    return CohortChat(spaceId, spaceName, target, userId);
  }
}
