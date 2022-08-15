import 'package:get/get.dart';

class LatestMessage {
  var notReadCount = 0.obs;
  var msgBody = "".obs;
  var createTime = DateTime.now().obs;

  LatestMessage(this.notReadCount, this.msgBody, this.createTime);
}
