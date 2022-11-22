import 'package:get/get.dart';
import 'package:orginone/api/market_api.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/api_resp/staging_entity.dart';
import 'package:orginone/controller/base_controller.dart';
import 'package:orginone/logic/authority.dart';

class StagingController extends BaseController<StagingEntity> {
  /// 这个数值用来记录购物车里面的总数量
  final RxInt total = 0.obs;

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
    total.value = page.total;
    return page.result;
  }

  /// 往购物车里加入一个商品
  Future<void> staging(String merchandiseId) async {
    StagingEntity staging = await MarketApi.staging(merchandiseId);
    add(staging);
    total.value += 1;
  }
}

class StagingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StagingController());
  }
}
