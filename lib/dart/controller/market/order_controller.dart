import 'package:get/get.dart';
import 'package:orginone/dart/base/api/market_api.dart';
import 'package:orginone/dart/base/model/page_resp.dart';
import 'package:orginone/dart/base/model/staging_entity.dart';
import 'package:orginone/dart/controller/list_controller.dart';
import 'package:orginone/dart/core/authority.dart';

class OrderController extends BaseController<StagingEntity> {
  @override
  void onInit() {
    super.onInit();
    onLoad();
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

  /// 获取数据
  Future<List<StagingEntity>> _getData({String? value}) async {
    PageResp<StagingEntity> page = await MarketApi.searchStaging(
      targetId: auth.spaceId,
      offset: getSize(),
      limit: defaultLimit,
      filter: value ?? "",
    );
    return page.result;
  }

  /// 将选中的购物车内容提交为一个订单
  Future<void> createOrderByStaging(String name, List<String> ids) async {
    String code = "${DateTime.now().millisecondsSinceEpoch}";
    await MarketApi.createOrderByStaging(
      name: "$name${ids.length > 1 ? "...等${ids.length}件商品" : ""} ",
      code: code,
      stageIds: ids,
    );
    onLoad();
  }
}

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderController());
  }
}
