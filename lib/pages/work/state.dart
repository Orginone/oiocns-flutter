

import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';
import 'package:orginone/dart/core/work/todo.dart';

class WorkState extends BaseGetListState<ITodo>{
  WorkEnum type = WorkEnum.todo;
}


enum WorkEnum{
  todo("待办"),
  done("已办"),
  copy("抄送"),
  completed("已完结");

  final String label;

  const WorkEnum(this.label);
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