

import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class WorkState extends BaseGetListState{
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
