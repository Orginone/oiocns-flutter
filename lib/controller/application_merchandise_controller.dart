import 'package:get/get.dart';
import 'package:orginone/api/market_api.dart';
import 'package:orginone/api_resp/merchandise_entity.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/controller/base_controller.dart';
import 'package:orginone/page/home/message/message_controller.dart';

class ApplicationMerchandiseController
    extends BaseController<MerchandiseEntity> {
  final MessageController messageController = Get.find<MessageController>();
  late String _marketId;

  @override
  void onInit() {
    super.onInit();
    _marketId = Get.arguments;
    loadMore();
  }

  @override
  loadMore() async {
    addAll(await _getData());
  }

  @override
  search(String value) {
    clear();
    loadMore();
  }

  changeMarket(String marketId) {
    _marketId = marketId;
    clear();
    loadMore();
  }

  Future<List<MerchandiseEntity>> _getData({String? value}) async {
    PageResp<MerchandiseEntity> page = await MarketApi.searchMerchandise(
      marketId: _marketId,
      offset: getSize(),
      limit: defaultLimit,
      filter: value ?? "",
    );
    return page.result;
  }
}
