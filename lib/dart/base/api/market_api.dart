import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/model/market_entity.dart';
import 'package:orginone/dart/base/model/merchandise_entity.dart';
import 'package:orginone/dart/base/model/page_resp.dart';
import 'package:orginone/dart/base/model/staging_entity.dart';
import 'package:orginone/util/http_util.dart';

class MarketApi {
  /// 申请加入
  static Future<Map<String, dynamic>> applyJoin(String targetId) async {
    String url = "${Constant.market}/apply/join";
    Map<String, dynamic> data = {"id": targetId};
    return await HttpUtil().post(url, data: data);
  }

  /// 审核加入
  static Future<Map<String, dynamic>> approvalJoin({
    required String targetId,
    required int status,
  }) async {
    String url = "${Constant.market}/approval/join";
    Map<String, dynamic> data = {"id": targetId, "status": status};
    return await HttpUtil().post(url, data: data);
  }

  /// 审批商品上架申请
  static Future<Map<String, dynamic>> approvalPublish({
    required String productId,
    required int status,
  }) async {
    String url = "${Constant.market}/approval/publish";
    Map<String, dynamic> data = {"id": productId, "status": status};
    return await HttpUtil().post(url, data: data);
  }

  /// 审批商品上架申请
  static Future<Map<String, dynamic>> cancelJoin(String targetId) async {
    String url = "${Constant.market}/cancel/join";
    Map<String, dynamic> data = {"id": targetId};
    return await HttpUtil().post(url, data: data);
  }

  /// 创建市场
  static Future<Map<String, dynamic>> create(Map<String, dynamic> map) async {
    String url = "${Constant.market}/create";
    Map<String, dynamic> data = {
      "name": map['name'],
      "code": map['code'],
      "sarmId": map['sarmId'],
      "remark": map['remark'],
      "public": map['public'],
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 又暂存提交为订单
  static Future<Map<String, dynamic>> createOrderByStaging({
    required String name,
    required String code,
    required List<String> stageIds,
  }) async {
    String url = "${Constant.market}/create/order/by/staging";
    Map<String, dynamic> data = {
      "name": name,
      "code": code,
      "stagIds": stageIds,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 删除市场
  static Future<Map<String, dynamic>> delete(String marketId) async {
    String url = "${Constant.market}/delete";
    Map<String, dynamic> data = {"id": marketId};
    return await HttpUtil().post(url, data: data);
  }

  /// 删除购物车内容
  static Future<Map<String, dynamic>> deleteStaging(String stagingId) async {
    String url = "${Constant.market}/delete/staging";
    Map<String, dynamic> data = {"id": stagingId};
    return await HttpUtil().post(url, data: data);
  }

  /// 产品上架
  static Future<Map<String, dynamic>> publish({
    required String caption,
    required String productId,
    required String price,
    required String sellAuth,
    required String marketId,
    required String information,
    required int days,
  }) async {
    String url = "${Constant.market}/publish";
    Map<String, dynamic> data = {
      "caption": caption,
      "productid": productId,
      "price": price,
      "sellAuth": sellAuth,
      "marketId": marketId,
      "information": information,
      "days": days,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 拉取组织/个人加入市场
  static Future<Map<String, dynamic>> pullTarget({
    required List<String> targetIds,
    required String marketId,
  }) async {
    String url = "${Constant.market}/pull/target";
    Map<String, dynamic> data = {
      "targetIds": targetIds,
      "marketId": marketId,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 退出市场
  static Future<Map<String, dynamic>> quit(String targetId) async {
    String url = "${Constant.market}/quit";
    Map<String, dynamic> data = {"id": targetId};
    return await HttpUtil().post(url, data: data);
  }

  /// 移除市场成员
  static Future<Map<String, dynamic>> removeMember(String targetId) async {
    String url = "${Constant.market}/remove/member";
    Map<String, dynamic> data = {"id": targetId};
    return await HttpUtil().post(url, data: data);
  }

  /// 查询所有市场
  static Future<Map<String, dynamic>> searchAll({
    required int offset,
    required int limit,
    required String filter,
  }) async {
    String url = "${Constant.market}/search/all";
    Map<String, dynamic> data = {
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 发起者: 查询加入的市场申请
  static Future<Map<String, dynamic>> searchJoinApply({
    required int offset,
    required int limit,
    required String filter,
  }) async {
    String url = "${Constant.market}/search/join/apply";
    Map<String, dynamic> data = {
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 管理者: 查询加入的市场申请
  static Future<Map<String, dynamic>> searchJoinApplyManager({
    required int offset,
    required int limit,
    required String filter,
  }) async {
    String url = "${Constant.market}/search/join/apply/manager";
    Map<String, dynamic> data = {
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 管理者: 查询产品上架申请
  static Future<Map<String, dynamic>> searchManagerPublishApply({
    required int offset,
    required int limit,
    required String filter,
  }) async {
    String url = "${Constant.market}/search/manager/publish/apply";
    Map<String, dynamic> data = {
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 查询市场成员
  static Future<Map<String, dynamic>> searchMember({
    required String marketId,
    required int offset,
    required int limit,
    required String filter,
  }) async {
    String url = "${Constant.market}/search/member";
    Map<String, dynamic> data = {
      "id": marketId,
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 查询指定市场所有商品
  static Future<PageResp<MerchandiseEntity>> searchMerchandise({
    required String marketId,
    required int offset,
    required int limit,
    required String filter,
  }) async {
    String url = "${Constant.market}/search/merchandise";
    Map<String, dynamic> data = {
      "id": marketId,
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    Map<String, dynamic> ansMap = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(ansMap, MerchandiseEntity.fromJson);
  }

  /// 查询管理以及加入的市场
  static Future<PageResp<MarketEntity>> searchOwn({
    required int offset,
    required int limit,
    required String? filter,
  }) async {
    String url = "${Constant.market}/search/own";
    Map<String, dynamic> data = {
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    Map<String, dynamic> ans = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(ans, MarketEntity.fromJson);
  }

  /// 查询产品上架申请
  static Future<Map<String, dynamic>> searchPublishApply({
    required int offset,
    required int limit,
    required String filter,
  }) async {
    String url = "${Constant.market}/search/public/apply";
    Map<String, dynamic> data = {
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 查询软件共享仓库
  static Future<MarketEntity> searchSoftShare() async {
    String url = "${Constant.market}/search/softshare";
    Map<String, dynamic> ans = await HttpUtil().post(url, data: {});
    return MarketEntity.fromJson(ans);
  }

  /// 查询暂存区
  static Future<PageResp<StagingEntity>> searchStaging({
    required String targetId,
    required int offset,
    required int limit,
    required String filter,
  }) async {
    String url = "${Constant.market}/search/staging";
    Map<String, dynamic> data = {
      "id": targetId,
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    Map<String, dynamic> map = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(map, StagingEntity.fromJson);
  }

  /// 加入暂存区
  static Future<StagingEntity> staging(String merchandiseId) async {
    String url = "${Constant.market}/staging";
    Map<String, dynamic> data = {"id": merchandiseId};
    Map<String, dynamic> map = await HttpUtil().post(url, data: data);
    return StagingEntity.fromJson(map);
  }

  /// 下架
  static Future<Map<String, dynamic>> unPublish(String productId) async {
    String url = "${Constant.market}/unpublish";
    Map<String, dynamic> data = {"id": productId};
    return await HttpUtil().post(url, data: data);
  }

  /// 更新市场信息
  static Future<Map<String, dynamic>> update(Map<String, dynamic> map) async {
    String url = "${Constant.market}/unpublish";
    Map<String, dynamic> data = {
      "id": map["marketId"],
      "name": map["name"],
      "code": map["code"],
      "sarmId": map["sarmId"],
      "remark": map["remark"],
      "public": map["public"],
    };
    return await HttpUtil().post(url, data: data);
  }
}
