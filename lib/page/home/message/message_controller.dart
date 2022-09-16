import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/message_space_resp.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/model/message_detail_util.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/util/hive_util.dart';

import '../../../api_resp/api_resp.dart';
import '../../../api_resp/message_item_resp.dart';
import '../../../model/db_model.dart';
import '../../../util/hub_util.dart';
import 'chat/chat_controller.dart';

/// 所有与后端消息交互的逻辑都先保存至数据库中再读取出来
class MessageController extends GetxController {
  // 日志对象
  Logger log = Logger("MessageController");

  // 空间
  List<SpaceMessagesResp> spaces = [];

  // 会话索引
  Map<int, SpaceMessagesResp> spaceMap = {};
  Map<int, Map<int, MessageItemResp>> spaceMessageItemMap = {};

  // 参数
  int currentSpaceId = -1;
  int currentMessageItemId = -1;

  @override
  void onInit() async {
    // 连接成功后初始化聊天面板信息，
    await getCharts();
    super.onInit();
  }

  void sortingGroup(TargetResp highestPriority) {
    // 匹配会话空间
    SpaceMessagesResp? matchSpace;
    for (SpaceMessagesResp space in spaces) {
      var isCurrentSpace = space.id == highestPriority.id;
      space.isExpand = isCurrentSpace;
      if (isCurrentSpace) {
        matchSpace = space;
        break;
      }
    }
    if (matchSpace != null) {
      // 重新排序
      spaces.remove(matchSpace);
      spaces.insert(0, matchSpace);
    }
    update();
  }

  Future<dynamic> getCharts() async {
    // 清空数组
    spaces.clear();
    spaceMap.clear();

    // 读取聊天群
    Map<String, dynamic> chats = await HubUtil().getChats();
    ApiResp apiResp = ApiResp.fromMap(chats);

    List<dynamic> messageGroups = apiResp.data["groups"];
    HomeController homeController = Get.find<HomeController>();
    for (var messageGroup in messageGroups) {
      SpaceMessagesResp space = SpaceMessagesResp.fromMap(messageGroup);
      spaces.add(space);
      spaceMap[space.id] = space;
    }
    sortingGroup(homeController.currentSpace);

    // 更新视图
    update();
  }

  // 更新聊天记录
  void updateChatItem(MessageItemResp target, MessageDetail messageDetail) {
    // 校验
    if (messageDetail.spaceId == null || target.id == null) {
      return;
    }

    // 搜索空間
    int spaceId = messageDetail.spaceId!;
    if (!spaceMessageItemMap.containsKey(spaceId)) {
      return;
    }
    Map<int, MessageItemResp> messageItemMap = spaceMessageItemMap[spaceId]!;

    // 搜索会话
    int targetId = target.id!;
    if (!messageItemMap.containsKey(targetId)) {
      return;
    }
    MessageItemResp messageItem = messageItemMap[targetId]!;

    // 如果是我自己发的或者我当前正在群中，那就不更新视图条数了
    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
    if (messageDetail.fromId != userInfo.id &&
        currentMessageItemId != targetId) {
      messageItem.noRead += 1;
    }

    update();
  }

  // 打开一个群组就阅读所有消息
  Future<void> messageItemRead() async {
    if (spaceMessageItemMap.containsKey(currentSpaceId)) {
      Map<int, MessageItemResp> messageItemMap =
          spaceMessageItemMap[currentSpaceId]!;
      if (messageItemMap.containsKey(currentMessageItemId)) {
        MessageItemResp messageItem = messageItemMap[currentMessageItemId]!;
        messageItem.noRead = 0;
      }
    }
  }

  // 接受消息
  Future<void> onReceiveMessage(List<dynamic> messageList) async {
    if (messageList.isEmpty) {
      return;
    }
    try {
      TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
      for (var message in messageList) {
        var messageDetail = MessageDetail.fromMap(message);

        var spaceId = messageDetail.spaceId;
        var fromId = messageDetail.fromId;
        var toId = messageDetail.toId;

        try {
          // 确定空间
          if (!spaceMessageItemMap.containsKey(spaceId) ||
              !spaceMap.containsKey(spaceId)) {
            var itemMap = spaceMessageItemMap[userInfo.id]!;
            if (itemMap.containsKey(spaceId)) {
              spaceId = userInfo.id;
            } else {
              // 如果还是找不到，就丢了
              continue;
            }
          }

          // 匹配群
          Map<int, MessageItemResp> messageItemMap =
              spaceMessageItemMap[spaceId]!;
          MessageItemResp? currentMessageItem = messageItemMap[toId];
          messageItemMap.forEach((itemId, messageItem) {
            if (messageItem.typeName == "人员" &&
                fromId == messageItem.id &&
                fromId != userInfo.id &&
                toId == userInfo.id) {
              currentMessageItem = messageItem;
            }
          });
          if (currentMessageItem == null) {
            continue;
          }

          // 更换位置, 更新优先级
          SpaceMessagesResp spaceMessageItems = spaceMap[spaceId]!;
          List<MessageItemResp> messageItems = spaceMessageItems.chats;
          messageItems.remove(currentMessageItem);
          messageItems.insert(0, currentMessageItem!);
          update();

          // 保存消息
          if (messageDetail.msgType == "recall") {
            var oldDetail = await MessageDetailUtil.getById(messageDetail.id!);
            if (oldDetail == null) continue;
            var msgBody =
                oldDetail.fromId == userInfo.id ? "您撤回了一条信息" : "xxx 撤回了一条信息";
            oldDetail.isWithdraw = true;
            oldDetail.msgBody = msgBody;
            await MessageDetailManager().update(oldDetail);

            messageDetail.msgBody = msgBody;
            messageDetail.isWithdraw = true;
            messageDetail.isRead = false;
          } else {
            messageDetail.isWithdraw = false;
            messageDetail.isRead = false;
            messageDetail.spaceId = spaceId;
            messageDetail.typeName = currentMessageItem!.typeName;
            await messageDetail.save();
          }

          if (currentMessageItemId == currentMessageItem!.id) {
            // 如果当前在聊天页面当中就接受消息
            ChatController chatController = Get.find();
            await chatController.onReceiveMessage(messageDetail);
          }

          // 更新聊天列表的视图
          updateChatItem(currentMessageItem!, messageDetail);
        } catch (error) {
          error.printError();
        }
      }
    } catch (error) {
      error.printError();
    }
  }
}
