import 'package:orginone/public/http/base_list_controller.dart';

/// 办事模块通用的controller
abstract class AffairsBaseListController<T> extends BaseListController<T> {
  /// 不分页，直接一次性加载完成
  int limit = 1000;
  int offset = 0;

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }
}
