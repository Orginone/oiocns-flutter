import 'package:orginone/public/http/base_list_controller.dart';

enum ApplicationFunction {
  create,
  update,
  applyMarket,
}

class ApplicationController extends BaseListController {

  late int limit;
  late int offset;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onLoadMore() {

  }

  @override
  void onRefresh() {}

  searchingCallback(String value) {}
}
