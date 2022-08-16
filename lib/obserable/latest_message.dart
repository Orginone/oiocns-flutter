import 'package:get/get.dart';

class LatestDetail {
  var notReadCount = 0.obs;
  var msgBody = "".obs;
  var createTime = DateTime.now().obs;

  LatestDetail(this.notReadCount, this.msgBody, this.createTime);
}
