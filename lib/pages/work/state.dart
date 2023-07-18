

import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_state.dart';
import 'package:orginone/dart/core/work/index.dart';
import 'package:orginone/dart/core/work/task.dart';

class WorkState extends BaseSubmenuState<WorkFrequentlyUsed,IWorkTask>{
  @override
  // TODO: implement tag
  String get tag => "办事";
}


class WorkFrequentlyUsed extends FrequentlyUsed{
  late IWork define;
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