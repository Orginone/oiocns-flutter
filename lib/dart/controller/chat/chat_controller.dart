import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/controller/store/index.dart';
import 'package:orginone/dart/core/chat/chat.dart';
import 'package:orginone/dart/core/chat/ichat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/store/ifilesys.dart';
import 'package:orginone/main.dart';
import 'package:orginone/util/event_bus.dart';

const chatsObjectName = "chatscache";

class ChatController extends GetxController {
  final Logger log = Logger("ChatController");

  final settingCtrl = Get.find<SettingController>();

  String _userId = "";
  String _userName = "";

  final RxList<IChatGroup> _groups = <IChatGroup>[].obs;
  final RxList<IChat> _chats = <IChat>[].obs;
  final Rx<IChat?> _curChat = Rxn();

  StreamSubscription<SignIn>? _signInSub;
  StreamSubscription<SignOut>? _signOutSub;

  List<IChatGroup> get groups => _groups;

  List<IChat> get chats => _chats;

  IChat? get chat => _curChat.value;

  String get userId => _userId;

  String get userName => _userName;

  var sctr = StoreController();

  @override
  void onInit() async {
    kernelApi.on('RecvMsg', onReceiveMessage);
    _signInSub = XEventBus.instance.on<SignIn>().listen((event) async {
      var settingCtrl = Get.find<SettingController>();
      _userId = settingCtrl.user?.id ?? "";
      _userName = settingCtrl.user?.name ?? "";
      if (_userId != "") {
        _initialization();
      }
    });
    _signOutSub = XEventBus.instance.on<SignOut>().listen((event) {
      clear();
    });
    super.onInit();
  }

  @override
  onClose() {
    _signInSub?.cancel();
    _signOutSub?.cancel();
    clear();
    super.onClose();
  }

  clear() {
    _userId = "";
    _groups.clear();
    _chats.clear();
    _curChat.value = null;
  }

  /// 获取名称
  String getName(String id) {
    for (var chatGroup in _groups) {
      for (var chat in chatGroup.chats) {
        if (chat.target.id == id) {
          return chat.target.name;
        }
      }
    }
    return "未知";
  }

  /// 查询组织信息
  TargetShare? findTeamInfoById(String id) {
    // return findTargetShare(id);
    return null;
  }

  /// 获取未读数量
  int getNoReadCount() {
    int sum = 0;
    for (var group in _groups) {
      for (var chat in group.chats) {
        sum += chat.noReadCount.value;
      }
    }
    return sum;
  }

  int getChatSize() {
    return _chats.length;
  }

  /// 移除近期会话
  removeChat(IChat chat) async {
    _chats.remove(chat);
    await _cacheChats();
  }

  /// 通过空间 ID，会话 ID设置
  Future<void> setCurrent(IChat? chat) async {
    if (chat != null && isCurrent(chat.fullId)) return;
    if (chat != null) {
      chat.noReadCount.value = 0;
      await chat.moreMessage();
      if (chat.persons.isEmpty) {
        await chat.morePersons();
      }
      _appendChats(chat);
      await _cacheChats();
    }
    _curChat.value = chat;
  }

  /// 是否为当前会话
  bool isCurrent(String fullId) {
    return _curChat.value?.fullId == fullId;
  }

  /// 缓存当前会话
  _cacheChats() async {
    mapping(c) => c.getCache().toJson();
    await KernelApi.getInstance().anystore.set(
          chatsObjectName,
          {
            "operation": "replaceAll",
            "data": {"chats": _chats.map(mapping).toList().reversed.toList()}
          },
          settingCtrl.space.id,
        );
  }

  /// 初始化监听器
  _initialization() async {
    kernelApi.anystore
        .subscribed(chatsObjectName, settingCtrl.space.id, _updateMails);
  }

  Future<List<IChatGroup>> loadChats(String userId) async {
    List<IChatGroup> groups = [];
    var res = await KernelApi.getInstance().queryImChats(ChatsReqModel(
      spaceId: userId,
      cohortName: TargetType.cohort.label,
      spaceTypeName: TargetType.company.label,
    ));
    if (res.success) {
      res.data?.groups?.forEach((group) {
        int index = 0;
        var chats = (group.chats ?? [])
            .map((item) => createChat(group.id, group.name, item, userId))
            .toList();
        var base = BaseChatGroup(group.id, group.name, index++ == 0, chats.obs);
        groups.add(base);
      });
    }
    return groups;
  }

  targetChat(
    XTarget target,
    String userId,
    String spaceId,
    String spaceName,
    String label,
  ) {
    var chatModel = ChatModel(
      id: target.id,
      name: target.team?.name ?? "",
      typeName: target.typeName,
      photo: target.avatar,
      label: label,
    );
    return createChat(spaceId, spaceName, chatModel, userId);
  }

  /// 更新视图
  _updateMails(dynamic data) {
    log.info("data:$data");
    List<dynamic> chats = data["chats"] ?? [];
    List<IChat> newChats = [];
    for (Map<String, dynamic>? chat in chats) {
      if (chat == null) {
        continue;
      }
      var chatModel = createChat(
        chat["spaceId"],
        chat["spaceName"],
        ChatModel.fromJson(chat["target"]),
        userId,
      );
      var spaceId = chat["spaceId"];
      var chatId = chat["chatId"];
      var fullId = "$spaceId-$chatId";
      var matchedChat = findChat(fullId);
      if (matchedChat != null) {
        chatModel = matchedChat;
      }
      chatModel.loadCache(ChatCache.fromMap(chat));
      newChats.add(chatModel);
    }
    _chats.value = newChats;
  }

  /// 获取会话的位置
  _getPositioned(String spaceId, String chatId) {
    return _chats.indexWhere((item) {
      return item.spaceId == spaceId && item.chatId == chatId;
    });
  }

  /// 不存在会话就加入
  _appendChats(IChat targetChat) {
    var position = _getPositioned(targetChat.spaceId, targetChat.chatId);
    if (position == -1) {
      _chats.insert(0, targetChat);
    } else {
      _chats[position] = targetChat;
    }
  }

  /// 获取存在的会话
  IChat? findChat(String fullId) {
    return _chats.firstWhereOrNull((item) => item.fullId == fullId);
  }

  /// 设置置顶
  setTopping(IChat targetChat) {
    var position = _getPositioned(targetChat.spaceId, targetChat.chatId);
    if (position != -1) {
      var chat = _chats.removeAt(position);
      _chats.insert(0, chat);
    }
  }

  bool hasNoRead() {
    var has = _chats.firstWhereOrNull((item) => item.noReadCount.value != 0);
    return has != null;
  }

  /// 接受消息
  Future<void> onReceiveMessage(dynamic item) async {
    var message = XImMsg.fromJson(item);
    var sessionId = message.toId;
    if (message.toId == _userId) {
      sessionId = message.fromId;
    }
    for (var one in _chats) {
      bool isMatched = one.target.id == sessionId;
      if (isMatched && one.target.typeName == TargetType.person.label) {
        isMatched = message.spaceId == one.spaceId;
      }
      if (isMatched) {
        one.receiveMessage(message, _curChat.value != one);
        _appendChats(one);
        _cacheChats();
      }
    }
    _createRevMsgChat(message, sessionId);
  }

  IChat findTargetChat(
    XTarget target,
    String spaceId,
    String spaceName,
    String label,
  ) {
    var chat = findChat('$spaceId-${target.id}');
    if (chat != null) return chat;
    return targetChat(target, _userId, spaceId, spaceName, label);
  }

  void _createRevMsgChat(XImMsg data, String sessionId) async {
    var id = IdArrayReq(ids: [data.spaceId, sessionId]);
    var result = await KernelApi.getInstance().queryTargetById(id);
    if (result.data?.result?.isNotEmpty ?? false) {
      var target = result.data!.result!
          .where((item) => item.id == sessionId)
          .toList()[0];
      var spaceTarget = result.data!.result!
          .where((item) => item.id == data.spaceId)
          .toList()[0];
      var label = '好友';
      if (target.typeName == TargetType.cohort.label) {
        label = "群组";
      } else if (target.typeName == TargetType.person.label) {
        if (spaceTarget.typeName != TargetType.person.label) {
          label = '同事';
        }
      } else {
        label = '${target.typeName}群';
      }
      var chat = findTargetChat(
        target,
        spaceTarget.typeName == TargetType.person.label
            ? _userId
            : data.spaceId,
        spaceTarget.typeName == TargetType.person.label
            ? '我的'
            : (spaceTarget.team?.name ?? spaceTarget.name),
        label,
      );
      chat.receiveMessage(data, true);
      _appendChats(chat);
      _cacheChats();
    }
  }

  void imagePicked(XFile pickedImage) async {
    await sctr.constructor();
    sctr.home?.create("沟通").then((docDir) async {
      IObjectItem item = await docDir.upload(
          pickedImage.name, File(pickedImage.path), (progress) {});
      if (item.target != null) {
        _curChat.value?.sendMessage(
            MessageType.image, jsonEncode(item.target!.shareInfo()));
      }
    });

    // getFileSysItemRoot.create("主目录").then((value){
    //
    // });
  }

  void voice(String path, int time) async {
    _curChat.value?.sendMessage(
        MessageType.voice,
        jsonEncode({
          "milliseconds": time,
          "bytes": File(path).readAsBytesSync(),
        }));

    // getFileSysItemRoot.create("主目录").then((value){
    //
    // });
  }
}

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatController(), permanent: true);
  }
}
