import 'package:orginone/dart/base/model.dart';
import '../../base/common/uint.dart';
import '../../base/schema.dart';
import '../enum.dart';
import '../market/market.dart';
import '../market/model.dart';
import '../market/webapp.dart';
import 'flow.dart';
import 'itarget.dart';

abstract class MarketTarget extends FlowTarget implements IMTarget {
  late List<TargetType> extendTargetType;

  MarketTarget(XTarget target, ISpace? space, String userId) : super(target, space, userId) {
    ownProducts = [];
    joinedMarkets = [];
    joinMarketApplys = [];
    usefulProduct = [];
    publicMarkets = [];
    usefulResource = {};
    extendTargetType = [];
  }
  @override
  Future<XMarketArray?> getMarketByCode(name) async {
    return (await kernel.queryMarketByCode(IDBelongReq(
            id: id,
            page: PageRequest(
              offset: 0,
              limit: Constants.maxUint16,
              filter: name,
            ))))
        .data;
  }

  @override
  Future<List<IProduct>> getOwnProducts({reload = false}) async {
    if (!reload && ownProducts.isNotEmpty) {
      return ownProducts;
    }
    final res = await kernel.querySelfProduct(IDBelongReq(
      id: target.id,
      page: PageRequest(
        offset: 0,
        filter: '',
        limit: Constants.maxUint16,
      ),
    ));
    if (res.success && res.data?.result != null) {
      ownProducts = res.data!.result?.map((e) => WebApp(e)).toList() ?? [];
    }
    return ownProducts;
  }

  @override
  Future<List<IMarket>> getJoinMarkets({reload = false}) async {
    if (!reload && joinedMarkets.isNotEmpty) {
      return joinedMarkets;
    }
    final res = await kernel.queryOwnMarket(IDBelongReq(
      id: id,
      page: PageRequest(offset: 0, limit: Constants.maxUint16, filter: ''),
    ));
    if (res.success && res.data?.result != null) {
      joinedMarkets = res.data!.result?.map((e) => Market(e)).toList() ?? [];
    }
    return joinedMarkets;
  }

  @override
  Future<List<IMarket>> getPublicMarket({reload = false}) async {
    if (!reload && publicMarkets.isNotEmpty) {
      return publicMarkets;
    }
    final res = await kernel.getPublicMarket();
    publicMarkets = res.data!.result?.map((e) => Market(e)).toList() ?? [];
    return publicMarkets;
  }

  @override
  Future<XOrderArray?> getBuyOrders(
    int status,
    PageRequest page,
  ) async {
    return (await kernel.queryBuyOrderList(IDStatusPageReq(
      id: target.id,
      status: status,
      page: page,
    )))
        .data;
  }

  @override
  Future<XOrderDetailArray?> getSellOrders(
    int status,
    PageRequest page,
  ) async {
    return (await kernel.querySellOrderList(IDStatusPageReq(
      id: target.id,
      status: status,
      page: page,
    )))
        .data;
  }

  @override
  Future<XMarketRelationArray?> queryJoinMarketApproval() async {
    return (await kernel.queryJoinApproval(IDBelongReq(
      id: target.id,
      page: PageRequest(
        offset: 0,
        limit: Constants.maxUint16,
        filter: '',
      ),
    )))
        .data;
  }

  @override
  Future<List<XMarketRelation>> getJoinMarketApplys() async {
    if (joinMarketApplys.isNotEmpty) {
      return joinMarketApplys;
    }
    final res = await kernel.queryJoinMarketApply(IDBelongReq(
      id: target.id,
      page: PageRequest(
        offset: 0,
        limit: Constants.maxUint16,
        filter: '',
      ),
    ));
    if (res.success && res.data?.result != null) {
      joinMarketApplys = res.data!.result!;
    }
    return joinMarketApplys;
  }

  @override
  Future<bool> applyJoinMarket(String id) async {
    return (await kernel
            .applyJoinMarket(IDWithBelongReq(id: id, belongId: target.id)))
        .success;
  }

  @override
  Future<bool> cancelJoinMarketApply(String id) async {
    final res = await kernel.cancelJoinMarket(IdReqModel(
      id: id,
      typeName: target.typeName,
      belongId: target.id,
    ));
    if (res.success) {
      joinMarketApplys =
          joinMarketApplys.where((apply) => apply.id != id).toList();
    }
    return res.success;
  }

  @override
  Future<XMerchandiseArray?> queryPublicApproval() async {
    return (await kernel.queryPublicApproval(IDBelongReq(
      id: target.typeName == TargetType.person.name ? '0' : target.id,
      page: PageRequest(
        offset: 0,
        limit: Constants.maxUint16,
        filter: '',
      ),
    )))
        .data;
  }

  @override
  Future<bool> approvalJoinMarketApply(id, int status) async {
    return (await kernel
            .approvalJoinApply(ApprovalModel(id: id, status: status)))
        .success;
  }

  @override
  Future<bool> approvalPublishApply(id, int status) async {
    return (await kernel
            .approvalMerchandise(ApprovalModel(id: id, status: status)))
        .success;
  }

  @override
  Future<IMarket?> createMarket(MarketModel data) async {
    final res = await kernel.createMarket(data);
    if (res.success && res.data != null) {
      final market = Market(res.data!);
      joinedMarkets.add(market);
      return market;
    }
    return null;
  }

  @override
  Future<IProduct?> createProduct(ProductModel data) async {
    data.belongId = target.id;
    final res = await kernel.createProduct(data);
    if (res.success && res.data != null) {
      var prod = WebApp(res.data!);
      ownProducts.add(prod);
      return prod;
    }
    return null;
  }

  @override
  Future<bool> deleteMarket(id) async {
    final res = await kernel.deleteMarket(IDWithBelongReq(
      id: id,
      belongId: target.id,
    ));
    if (res.success) {
      joinedMarkets =
          joinedMarkets.where((market) => market.market.id != id).toList();
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteProduct(id) async {
    final res = await kernel.deleteProduct(IDWithBelongReq(
      id: id,
      belongId: target.id,
    ));
    if (res.success) {
      ownProducts = ownProducts.where((prod) => prod.prod.id != id).toList();
    }
    return res.success;
  }

  @override
  Future<bool> quitMarket(id) async {
    final res = await kernel.quitMarket(IDWithBelongReq(
      id: id,
      belongId: target.id,
    ));
    if (res.success) {
      joinedMarkets =
          joinedMarkets.where((market) => market.market.id != id).toList();
    }
    return res.success;
  }

  @override
  Future<List<XProduct>> getUsefulProduct({bool reload = false}) async {
    if (!reload && usefulProduct.isNotEmpty) {
      return usefulProduct;
    }
    final res = await kernel.queryUsefulProduct(UsefulProductReq(
      spaceId: target.id,
      typeNames: List<String>.from(extendTargetType),
    ));
    if (res.success && res.data?.result != null) {
      usefulProduct = res.data!.result!;
    }
    return usefulProduct;
  }

  @override
  Future<List<XResource>?> getUsefulResource(String id,
      {bool reload = false}) async {
    if (!reload && usefulResource[id] != null) {
      return usefulResource[id]!;
    }
    final res = await kernel.queryUsefulResource(UsefulResourceReq(
      productId: id,
      spaceId: target.id,
      typeNames: List<String>.from(extendTargetType),
    ));
    if (res.success && res.data?.result != null) {
      usefulResource[id] = res.data!.result!;
    }
    return usefulResource[id];
  }

  @override
  Future<XOrder?> createOrder(
    String nftId,
    String name,
    String code,
    String spaceId,
    List<String> merchandiseIds,
  ) async {
    return (await kernel.createOrder(OrderModel(
      nftId: nftId,
      name: name,
      code: code,
      belongId: spaceId,
      merchandiseIds: merchandiseIds,
    )))
        .data;
  }

  @override
  late List<XMarketRelation> joinMarketApplys;

  @override
  late List<XProduct> usefulProduct;

  @override
  late Map<String, List<XResource>> usefulResource;
}
