import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/chat/chat.dart';
import 'package:orginone/dart/core/chat/ichat.dart';
import 'package:orginone/dart/core/enum.dart';

Future<List<IChatGroup>> loadChats(String userId) async {
  List<IChatGroup> groups = [];
  var res = await KernelApi.getInstance().queryImChats(ChatsReqModel(
    spaceId: userId,
    cohortName: TargetType.cohort.label,
    spaceTypeName: TargetType.company.label,
  ));
  if (res.success) {
    res.data?.groups?.forEach((item) {
      int index = 0;
      var chats = (item.chats ?? [])
          .map((item) => createChat(item.id, item.name, item, userId))
          .toList();
      groups.add(BaseChatGroup(
        spaceId: item.id,
        spaceName: item.name,
        isOpened: index++ == 0,
        chats: chats,
      ));
    });
  }
  return groups;
}
