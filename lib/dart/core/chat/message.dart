import 'dart:convert';

import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/util/encryption_util.dart';

import '../../../../main.dart';

const hisMsgCollName = 'chat-message';
var nullTime = DateTime(2022, 7, 1).millisecondsSinceEpoch;


abstract class IChatMessage{
  late IBelong belong;
  late RxList<XImMsg> messages;

  void onMessage();

  void unMessage();

  Future<int> moreMessage({bool before = true});
}

class ChatMessage implements IChatMessage {

  ChatMessage(this.belong){
    messages = <XImMsg>[].obs;
  }

  @override
  late IBelong belong;

  @override
  late RxList<XImMsg> messages;

  @override
  Future<int> moreMessage({bool before = true}) async{
    var minTime = '2023-05-03 09:00:00.000';
    var maxTime = 'sysdate()';
    if (messages.isNotEmpty) {
      if (before) {
        maxTime = messages[0].createTime??"";
      } else {
        minTime = messages[messages.length].createTime??"";
      }
    }
    var res = await kernel.anystore.aggregate(hisMsgCollName, {
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
      "limit": 30,
    },belong.metadata.id);
    if (res.success && res.data!=null) {
      _loadMessages(res.data, before);
      return res.data.length;
    }
    return 0;
  }

  void _loadMessages(List<dynamic> msgs,bool before) {
    for (var item in msgs) {
      item["id"] = item["chatId"];
      var detail = XImMsg.fromJson(item);
      detail.showTxt = EncryptionUtil.inflate(detail.msgBody);
      if(before){
        messages.insert(0, detail);
      }else{
        messages.add(detail);
      }
    }
    messages.refresh();
  }

  @override
  void onMessage() {
    if (messages.length < 10) {
      moreMessage();
    }
  }

  @override
  void unMessage() {
    // TODO: implement unMessage
  }

}
