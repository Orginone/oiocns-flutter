import 'package:orginone/dart/controller/base_list_controller.dart';

class ApplicationController extends BaseListController {
  late int limit;
  late int offset;

  @override
  void onLoadMore() {}

  @override
  void onRefresh() {}

  searchingCallback(String value) {}
}
