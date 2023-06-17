

import 'package:flutter/material.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_frequently_used_list_state.dart';
import 'package:orginone/dart/core/thing/base/flow.dart';

class WorkState extends BaseFrequentlyUsedListState<WorkFrequentlyUsed,XWorkTask>{

}


class WorkFrequentlyUsed extends FrequentlyUsed{
  late IWorkDefine define;
  WorkFrequentlyUsed({super.id,super.avatar,super.name,required this.define});
}

Map<int, Status> statusMap = {
  1: Status(Colors.blue, '待处理'),
  100: Status(Colors.green, '已同意'),
  200: Status(Colors.red, '已拒绝'),
  102: Status(Colors.green, '已发货'),
  220: Status(Colors.red, '买方取消订单'),
  221: Status(Colors.red, '买方取消订单'),
  222: Status(Colors.red, '已退货'),
};

class Status {
  late Color color;
  late String text;

  Status(this.color, this.text);
}