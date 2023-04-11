import 'package:get/get.dart';
import 'package:orginone/config/enum.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'base_get_state.dart';

abstract class BaseGetListState<T> extends BaseGetState{
  var dataList = <T>[].obs;

  var loadStatus = LoadStatusX.loading.obs;

  RefreshController refreshController = RefreshController();

  var isSuccess = false.obs;

  var isLoading = true.obs;
}
