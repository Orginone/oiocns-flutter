// import 'dart:convert';
// import 'dart:typed_data';
//
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:orginone/api_resp/message_detail_resp.dart';
// import 'package:orginone/api_resp/message_item_resp.dart';
// import 'package:orginone/api_resp/org_chat_cache.dart';
// import 'package:orginone/api_resp/space_messages_resp.dart';
// import 'package:orginone/enumeration/enum_map.dart';
// import 'package:orginone/enumeration/message_type.dart';
// import 'package:orginone/logic/authority.dart';
// import 'package:orginone/logic/server/chat_server.dart';
// import 'package:orginone/logic/server/store_server.dart';
// import 'package:orginone/page/home/message/chat/chat_controller.dart';
// import 'package:orginone/util/api_exception.dart';
//
// class Detail {
//   final MessageDetailResp resp;
//
//   const Detail.fromResp(this.resp);
//
//   /// 构造工厂
//   factory Detail(MessageDetailResp resp) {
//     MsgType msgType = EnumMap.messageTypeMap[resp.msgType] ?? MsgType.unknown;
//     Map<String, dynamic> msgMap = jsonDecode(resp.msgBody ?? "{}");
//     switch (msgType) {
//       case MsgType.file:
//         // 文件
//         String fileName = msgMap["fileName"] ?? "";
//         String path = msgMap["path"] ?? "";
//         String size = msgMap["size"] ?? "";
//         return FileDetail(
//           fileName: fileName,
//           resp: resp,
//           status: FileStatus.local.obs,
//           progress: 0.0.obs,
//           path: path,
//           size: size,
//         );
//       case MsgType.voice:
//         // 语音
//         int milliseconds = msgMap["milliseconds"] ?? 0;
//         List<dynamic> rowBytes = msgMap["bytes"] ?? [];
//         List<int> tempBytes = rowBytes.map((byte) => byte as int).toList();
//         return VoiceDetail(
//           resp: resp,
//           status: VoiceStatus.stop.obs,
//           initProgress: milliseconds,
//           progress: milliseconds.obs,
//           bytes: Uint8List.fromList(tempBytes),
//         );
//       default:
//         return Detail.fromResp(resp);
//     }
//   }
// }
//
// /// 播放状态
// enum VoiceStatus { stop, playing }
//
// /// 语音播放类
// class VoiceDetail extends Detail {
//   final Rx<VoiceStatus> status;
//   final int initProgress;
//   final RxInt progress;
//   final Uint8List bytes;
//
//   const VoiceDetail({
//     required MessageDetailResp resp,
//     required this.status,
//     required this.initProgress,
//     required this.progress,
//     required this.bytes,
//   }) : super.fromResp(resp);
// }
//
// /// 文件状态
// enum FileStatus { local, uploading, pausing, stopping, uploaded, synced }
//
// /// 文件上传状态类
// class FileDetail extends Detail {
//   final String fileName;
//   final Rx<FileStatus> status;
//   final RxDouble progress;
//   final String path;
//   final String size;
//
//   const FileDetail({
//     required MessageDetailResp resp,
//     required this.fileName,
//     required this.status,
//     required this.progress,
//     required this.path,
//     required this.size,
//   }) : super.fromResp(resp);
// }
//
// class Chat {
//   late OrgChatCache _cache;
//   Current? _current;
//
//   Chat.fromChat(Map<String, dynamic> data) {
//     _cache = OrgChatCache(data);
//     _cache.chats = _spaceHandling(_cache.chats);
//     sortingGroups();
//     _latestMsgHandling(_cache.messageDetail);
//   }
//
//   setCurrent(String spaceId, String sessionId) {
//     _current = getSession(spaceId, sessionId);
//
//     // 打开的会话不存在就加入
//     _cache.openChats = _cache.openChats
//         .where((item) => item.id != _current!.sessionId || item.spaceId != _current!.spaceId)
//         .toList();
//     _cache.openChats.add(_current!._currentItem);
//
//     // 加入近期会话
//     _cache.recentChats ??= [];
//     bool has = false;
//     for (var item in _cache.recentChats!) {
//       if (item.spaceId == spaceId && item.id == sessionId) {
//         has = true;
//       }
//     }
//     if (!has) {
//       _cache.recentChats!.add(messageItem);
//       messageController.sortingItems(_cache.recentChats!);
//     }
//
//     // 加入自己
//     messageItem.noRead = 0;
//     messageController.update();
//
//     storeServer.cacheChats(_cache);
//   }
//
//   /// 最新的消息处理
//   _latestMsgHandling(MessageDetailResp? detail) {
//     if (detail == null) {
//       return;
//     }
//     if (Get.isRegistered<ChatController>()) {
//       // 消息预处理
//       var sessionId = detail.toId;
//       if (detail.toId == auth.userId) {
//         sessionId = detail.fromId;
//       }
//       ChatController chatController = Get.find<ChatController>();
//       chatController.onReceiveMsg(detail.spaceId!, sessionId, detail);
//     }
//   }
//
//   /// 空间处理
//   List<SpaceMessagesResp> _spaceHandling(List<SpaceMessagesResp> groups) {
//     // 新的数组
//     List<SpaceMessagesResp> spaces = [];
//     Map<String, SpaceMessagesResp> newSpaceMap = {};
//     Map<String, Map<String, MessageItemResp>> newSpaceMessageItemMap = {};
//
//     // 置顶会话
//     groups = groups.where((item) => item.id != "topping").toList();
//     SpaceMessagesResp topGroup = SpaceMessagesResp("topping", "置顶会话", []);
//
//     bool hasTop = false;
//     for (var group in groups) {
//       // 初始数据
//       String spaceId = group.id;
//       List<MessageItemResp> chats = group.chats;
//
//       // 建立索引
//       newSpaceMap[spaceId] = group;
//       newSpaceMessageItemMap[spaceId] = {};
//
//       // 数据映射
//       for (MessageItemResp messageItem in chats) {
//         var id = messageItem.id;
//         if (spaceMessageItemMap.containsKey(spaceId)) {
//           var messageItemMap = spaceMessageItemMap[spaceId]!;
//           if (messageItemMap.containsKey(id)) {
//             var oldItem = messageItemMap[id]!;
//             messageItem.msgTime = oldItem.msgTime;
//             messageItem.msgType ??= oldItem.msgType;
//             messageItem.msgBody ??= oldItem.msgBody;
//             messageItem.personNum ??= oldItem.personNum;
//             messageItem.noRead ??= oldItem.noRead;
//             messageItem.showTxt ??= oldItem.showTxt;
//             messageItem.isTop ??= oldItem.isTop;
//           }
//         }
//         newSpaceMessageItemMap[spaceId]![id] = messageItem;
//         if (messageItem.isTop == true) {
//           hasTop = true;
//         }
//       }
//
//       // 组内排序
//       sortingItems(group.chats);
//       spaces.add(group);
//     }
//     if (hasTop) {
//       spaces.insert(0, topGroup);
//     }
//     return spaces;
//   }
//
//   /// 分组排序
//   sortingGroups() {
//     List<SpaceMessagesResp> groups = _cache.chats;
//     List<SpaceMessagesResp> spaces = [];
//     SpaceMessagesResp? topping;
//     for (SpaceMessagesResp space in groups) {
//       var isCurrent = space.id == auth.spaceId;
//       if (space.id == "topping") {
//         topping = space;
//         space.isExpand = true;
//       } else if (isCurrent) {
//         space.isExpand = isCurrent;
//         spaces.insert(0, space);
//       } else {
//         space.isExpand = false;
//         spaces.add(space);
//       }
//     }
//     if (topping != null) {
//       spaces.insert(0, topping);
//     }
//     _cache.chats = spaces;
//   }
//
//   /// 排序数组
//   sortingItems(List<MessageItemResp> chats) {
//     chats.sort((first, second) {
//       if (first.msgTime == null || second.msgTime == null) {
//         return 0;
//       } else {
//         return -first.msgTime!.compareTo(second.msgTime!);
//       }
//     });
//     // 置顶排序
//     chats.sort((first, second) {
//       first.isTop ??= false;
//       second.isTop ??= false;
//       if (first.isTop == second.isTop) {
//         return first.isTop! ? -1 : 0;
//       } else {
//         return first.isTop! ? -1 : 1;
//       }
//     });
//   }
//
//   Current getSession(String spaceId, String sessionId) {
//     List<SpaceMessagesResp> spaces = _cache.chats;
//     for (SpaceMessagesResp space in spaces) {
//       if (space.id == spaceId) {
//         var sessions = space.chats;
//         for (var session in sessions) {
//           if (session.id == sessionId) {
//             return Current(spaceId, sessionId, session, []);
//           }
//         }
//       }
//     }
//     String error = "未获取到会话";
//     Fluttertoast.showToast(msg: error);
//     throw Exception(error);
//   }
// }
//
// class Current {
//   final String _spaceId;
//   final String _sessionId;
//   final MessageItemResp _currentItem;
//   final List<Detail> _currentDetails;
//
//   String get spaceId => _spaceId;
//
//   Current(this._spaceId, this._sessionId, this._currentItem, this._currentDetails);
//
//   String get sessionId => _sessionId;
//
//   MessageItemResp get current => _currentItem;
//
//   List<Detail> get currentDetails => _currentDetails;
//
//   /// 下拉时刷新旧的聊天记录
//   Future<void> getHistoryMsg({bool isCacheNameMap = false}) async {
//     var typeMap = EnumMap.targetTypeMap;
//     var typeName = _currentItem.typeName;
//     if (!typeMap.containsKey(_currentItem.typeName)) {
//       throw ApiException("未知的会话类型！");
//     }
//
//     var insertPointer = _currentDetails.length;
//     late List<MessageDetailResp> newDetails;
//     if (auth.userId == _spaceId) {
//       newDetails = await storeServer.getUserSpaceHistoryMsg(
//         typeName: typeMap[typeName]!,
//         sessionId: _sessionId,
//         offset: insertPointer,
//         limit: 15,
//       );
//     } else {
//       newDetails = await chatServer.getHistoryMsg(
//         spaceId: _spaceId,
//         sessionId: _sessionId,
//         typeName: typeMap[typeName]!,
//         offset: insertPointer,
//         limit: 15,
//       );
//     }
//
//     for (MessageDetailResp detail in newDetails) {
//       _currentDetails.insert(insertPointer, Detail.fromResp(detail));
//     }
//   }
// }
//
// late Chat _instance;
//
// Chat get chat => _instance;
//
// Future<void> loadChat() async {
//   /// 主动订阅接口
//   await storeServer.subscribing(
//     SubscriptionKey.orgChat,
//     Domain.user.name,
//     (data) => _instance = Chat.fromChat(data),
//   );
// }
