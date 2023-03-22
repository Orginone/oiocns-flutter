

import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class WorkState extends BaseGetState{
  late TabController tabController;

}

const List<String> tabTitle = [
  '待办',
  '已办',
  '抄送',
  '发起业务',
];

enum WorkEnum{
  todo("审批"),
  done("已办"),
  copy("抄送");

  final String label;

  const WorkEnum(this.label);
}
