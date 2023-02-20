import './model.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';

class Market implements IMarket {
  @override
  late XMarket market;

  @override
  late List<TargetType> pullTypes;

  get typeNames => null;
  get marketId => null;
  get id => market.id;
  get belongId => market.belongId;

  Market(XMarket store) {
    market = store;
    pullTypes = [TargetType.person, ...companyTypes];
  }

  @override
  Future<bool> update(
    String name,
    String code,
    String samrId,
    String remark,
    bool ispublic,
    String photo,
  ) async {
    ResultType res = await kernel.updateMarket(MarketModel(
        id: market.id,
        name: name,
        code: code,
        samrId: samrId,
        remark: remark,
        photo: photo,
        public: ispublic,
        belongId: market.belongId));
    if (res.success) {
      XMarket xMarket = XMarket(
        name: name,
        code: code,
        samrId: samrId,
        remark: remark,
        public: ispublic,
        id: market.id,
        photo: photo,
        belongId: market.belongId,
        createTime: '',
        createUser: '',
        status: 0,
        updateTime: '',
        updateUser: '',
        version: '',
        belong: null,
        merchandises: [],
        samr: null,
        stags: [],
        targetRelations: [],
      );
      market = xMarket;
      return true;
    }
    return false;
  }

  @override
  Future<XMarketRelationArray?> getMember(PageRequest page) async {
    return (await kernel.queryMarketMember({
      id: market.id,
      page: page,
    } as IDBelongReq))
        .data;
  }

  @override
  Future<XMarketRelationArray?> getJoinApply(
    PageRequest page,
  ) async {
    return (await kernel.queryJoinMarketApply({
      id: market.id,
      page: page,
    } as IDBelongReq))
        .data;
  }

  @override
  Future<bool> approvalJoinApply(String id, int status) async {
    return (await kernel.approvalJoinApply({id, status} as ApprovalModel))
        .success;
  }

  @override
  Future<bool> pullMember(
      List<String> targetIds, List<String> typenames) async {
    return (await kernel.pullAnyToMarket({
      targetIds: targetIds,
      marketId: market.id,
      typeNames: pullTypes,
    } as MarketPullModel))
        .success;
  }

  @override
  Future<bool> removeMember(List<String> targetIds) async {
    return (await kernel.removeMarketMember({
      targetIds: targetIds,
      marketId: market.id,
      typeNames: pullTypes,
    } as MarketPullModel))
        .success;
  }

  @override
  Future<XMerchandiseArray?> getMerchandise(PageRequest page) async {
    return (await kernel.searchMerchandise({
      id: market.id,
      page: page,
    } as IDBelongReq))
        .data;
  }

  @override
  Future<XMerchandiseArray?> getMerchandiseApply(PageRequest page) async {
    return (await kernel.queryMerchandiesApplyByManager({
      id: market.id,
      page: page,
    } as IDBelongReq))
        .data;
  }

  @override
  Future<bool> approvalPublishApply(String id, int status) async {
    return (await kernel.approvalMerchandise({id, status} as ApprovalModel))
        .success;
  }

  @override
  Future<bool> unPublish(String merchandiseId) async {
    return (await kernel.deleteMerchandiseByManager({
      id: merchandiseId,
      belongId: market.belongId,
    } as IDWithBelongReq))
        .success;
  }
}
