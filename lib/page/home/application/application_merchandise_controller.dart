import 'package:get/get.dart';
import 'package:orginone/api_resp/merchandise_entity.dart';
import 'package:orginone/public/http/base_list_controller.dart';

class ApplicationMerchandiseController
    extends BaseListController<MerchandiseEntity> {
  @override
  void onLoadMore() {
  }

  @override
  void onRefresh() {
  }

  @override
  void search(String value) {
    // TODO: implement search
    super.search(value);
  }
}
