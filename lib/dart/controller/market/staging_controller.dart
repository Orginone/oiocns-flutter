import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/api/market_api.dart';
import 'package:orginone/dart/base/model/page_resp.dart';
import 'package:orginone/dart/base/model/staging_entity.dart';
import 'package:orginone/dart/controller/list_controller.dart';
import 'package:orginone/dart/controller/market/order_controller.dart';
import 'package:orginone/dart/core/authority.dart';

class StagingController extends BaseController<StagingEntity> {
  /// 这个数值用来记录购物车里面的总数量
  final RxInt total = 0.obs;

  /// 这个用来记录选中的产品, 存储购物车的 ID
  final RxSet<String> _selected = <String>{}.obs;

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
    onLoad();
  }

  /// 获取选中的数量的大小
  int selectedSize() {
    return _selected.length;
  }

  /// 是否已经是选中了
  bool has(String id) {
    return _selected.contains(id);
  }

  /// 加入一个选中的
  select(String id) {
    _selected.add(id);
  }

  /// 去除一个选中的
  unselected(String id) {
    _selected.remove(id);
  }

  /// 选择购物车的回调
  onSelected(bool selected, String id) {
    if (selected) {
      select(id);
    } else {
      unselected(id);
    }
  }

  /// 删除购物车内容
  deleteStagings() async {
    for (var stagingId in _selected) {
      await MarketApi.deleteStaging(stagingId);
      removeWhere((item) => item.id == stagingId);
      total.value -= 1;
    }
    _selected.clear();
    Fluttertoast.showToast(msg: "删除成功!");
  }

  // 购买选中的订单
  Future<void> buy() async {
    if (_selected.isEmpty) {
      return;
    }

    /// 获取第一个购物车
    var staging = findOne((item) => item.id == _selected.first);
    var productName = staging.merchandise.caption;

    /// 订单提交
    var orderCtrl = Get.find<OrderController>();
    await orderCtrl.createOrderByStaging(productName, _selected.toList());

    /// 提交成功刷新购物车
    total.value -= _selected.length;
    _selected.clear();
    onLoad();
  }
}

class StagingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StagingController());
  }
}
