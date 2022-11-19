import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/market_api.dart';
import 'package:orginone/api_resp/market_entity.dart';
import 'package:orginone/api_resp/merchandise_entity.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/public/http/base_list_controller.dart';

enum ApplicationMarketFunc {
  create,
  update,
  applyMarket,
}

const int initOffset = 0;
const int initLimit = 20;

class ApplicationMarketController extends BaseListController {
  Logger log = Logger("ApplicationMarketController");

  int offset = initOffset;
  int limit = initLimit;
  RxList<MarketEntity> data = <MarketEntity>[].obs;
  late MarketEntity soft;

  @override
  void onInit() async {
    super.onInit();
    await onShare();
    await onLoad();
  }

  onShare() async {
    soft = await MarketApi.searchSoftShare();
  }

  onLoad() async {
    // await searchingCallback();
  }

  loadMore() async {
    List<MarketEntity> res = await _getData();
    data.addAll(res);
    offset += res.length;
    log.info("==> offset:$offset");
  }

  Future<List<MarketEntity>> _getData({String? value}) async {
    PageResp<MarketEntity> page = await MarketApi.searchOwn(
      offset: offset,
      limit: limit,
      filter: value ?? "",
    );
    return page.result;
  }

  delete(String marketId) async {
    await MarketApi.delete(marketId);
    data.removeWhere((item) => item.id == marketId);
  }

  @override
  void onLoadMore() {
    // TODO: implement onLoadMore
  }

  @override
  void onRefresh() {
    // TODO: implement onRefresh
  }

  @override
  void search(String value) {
    offset = initOffset;
    limit = initLimit;
    // await loadMore();
    // addData(true, pageResp);
  }
}
