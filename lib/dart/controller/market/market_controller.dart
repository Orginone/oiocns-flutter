import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/dart/base/api/market_api.dart';
import 'package:orginone/dart/base/model/market_entity.dart';
import 'package:orginone/dart/base/model/page_resp.dart';

import '../list_controller.dart';

enum ApplicationMarketFunc {
  create,
  update,
  applyMarket,
}

class MarketController extends BaseController<MarketEntity> {
  Logger log = Logger("ApplicationMarketController");

  late MarketEntity soft;

  @override
  void onInit() async {
    super.onInit();
    await onShare();
    await loadMore();
  }

  onShare() async {
    soft = await MarketApi.searchSoftShare();
  }

  @override
  loadMore() async {
    addAll(await _getData());
  }

  @override
  search(String value) {
    clear();
    onLoad();
  }

  @override
  remove(MarketEntity entity) async {
    await MarketApi.delete(entity.id);
    super.remove(entity);
    Fluttertoast.showToast(msg: "删除成功!");
  }

  Future<List<MarketEntity>> _getData({String? value}) async {
    PageResp<MarketEntity> page = await MarketApi.searchOwn(
      offset: getSize(),
      limit: defaultLimit,
      filter: value ?? "",
    );
    return page.result;
  }

  /// 是否是软市场
  bool isSoft(MarketEntity target) {
    return target.id == soft.id;
  }
}

class MarketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MarketController());
  }
}
