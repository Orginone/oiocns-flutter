import 'package:get/get.dart';
import 'package:orginone/api/market_api.dart';
import 'package:orginone/api_resp/merchandise_entity.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/controller/base_controller.dart';
import 'package:orginone/controller/market/staging_controller.dart';

class MerchandiseController extends BaseController<MerchandiseEntity> {
  final StagingController stagingController = Get.find();

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
  search(String value) async {
    clear();
    addAll(await _getData(value: value));
  }

  changeMarket(String marketId) {
    _marketId = marketId;
    onLoad();
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

class MerchandiseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MerchandiseController());
  }
}
