import 'package:get/get.dart';
import 'package:orginone/config/enum.dart';

import 'base_get_state.dart';

abstract class BaseGetListState<T> extends BaseGetState{
  var dataList = RxList<T>([]);

  var loadStatus = LoadStatusX.loading.obs;
}
