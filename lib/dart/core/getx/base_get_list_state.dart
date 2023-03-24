import 'package:get/get.dart';
import 'package:orginone/config/enum.dart';

import 'base_get_state.dart';

abstract class BaseGetListState<T> extends BaseGetState{
  var dataList = <T>[].obs;

  var loadStatus = LoadStatusX.loading.obs;

  var isSuccess = false.obs;

  var isLoading = true.obs;
}
