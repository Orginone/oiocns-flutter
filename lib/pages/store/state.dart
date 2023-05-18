

import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class StoreState extends BaseGetState{

  var recentlyList = [];
}


class Recent {
  final String id;
  final String name;
  final String url;

  Recent(this.id, this.name, this.url);
}