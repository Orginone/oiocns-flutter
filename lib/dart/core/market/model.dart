import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/core/enum.dart';


/// 内核请求模型
abstract class IMerchandise {
  /// 商品实例
  late XMerchandise merchandise;

  /// 更新商品信息
  /// @param merchandise 商品信息
  /// @returns 是否成功
  Future<bool> update(
    String caption,
    double price,
    String sellAuth,
    String information,
    String days,
  );

  /// 查询商品交易情况
  /// @param page 分页参数
  /// @returns 交易情况
  Future<XOrderDetailArray?> getSellOrder(PageRequest page);

  /// 交付订单中的商品
  /// @param detailId 订单ID
  /// @param status 交付状态
  /// @returns 交付结果
  Future<bool> deliver(String detailId, int status);

  /// 卖方取消订单
  /// @param detailId 订单Id
  /// @param status 取消状态
  /// @returns
  Future<bool> cancel(String detailId, int status);
}

// enum SellAuth {
//   sell0,
//   sell1
// }
// List<String> sellAuthValues =['使用权','所属权'];

/// 事件接收模型
abstract class APrams {
  final String caption;
  final String marketId;
  final String sellAuth;
  final String information;
  final double price;
  final String days;
  APrams({
    required this.caption,
    this.marketId = '',
    required this.sellAuth,
    required this.information,
    required this.price,
    required this.days,
  });
}

abstract class IProduct {
  late String id;

  /// 应用实体
  late XProduct prod;

  /// 商品列表
  late List<IMerchandise> merchandises;

  /// 应用资源
  late List<IResource> resource;

  /// 获取商品列表
  Future<List<IMerchandise>> getMerchandises(bool reload);

  /// 拓展操作 应用分享
  /// @param teamId 组织Id
  /// @param destIds 目标Id
  /// @param destType 目标类型
  /// @returns
  Future<bool> createExtend(
      String teamId, List<String> destIds, String destType);

  /// 取消应用分享
  /// @param teamId 组织Id
  /// @param destIds 目标Id
  /// @param destType 目标类型
  /// @returns
  Future<bool> deleteExtend(
      String teamId, List<String> destIds, String destType);

  /// 查询拓展 (应用分享)
  /// @param destType 目标类型
  /// @param teamId 组织Id
  /// @returns
  Future<IdNameArray?> queryExtend(String destType, String? teamId);

  /// 上架商品
  /// @param params.Caption 标题
  /// @param params.MarketId 市场ID
  /// @param params.SellAuth 售卖权限
  /// @param params.Information 详情信息
  /// @param {number} params.Price 价格
  /// @param {string} params.Days 期限
  /// @returns 是否上架成功
  Future<bool> publish(APrams params);

  /// 下架商品
  /// @param merchandiseId 下架商品ID
  /// @returns 下架是否成功
  Future<bool> unPublish(String merchandiseId);

  /// 更新应用
  /// @param name 应用名称
  /// @param code 应用编号
  /// @param typeName 应用类型
  /// @param remark 应用信息
  /// @param resources 应用资源
  Future<bool> update(
    String name,
    String code,
    String typeName,
    String remark,
    String photo,
    List<ResourceModel> resources,
  );
}

abstract class IResource {
  /* 资源实体 */
  late XResource resource;
  /*
   * 资源分发拓展操作
   * @param teamId 组织Id
   * @param destIds 目标Id
   * @param destType 目标类型
   * @returns
   */
  Future<bool> createExtend(
      String teamId, List<String> destIds, String destType);
  /*
   * 取消资源分发
   * @param teamId 组织Id
   * @param destIds 目标Id
   * @param destType 目标类型
   * @returns
   */
  Future<bool> deleteExtend(
      String teamId, List<String> destIds, String destType);
  /*
   * 查询资源分发
   * @param sourceId 资源Id
   * @param destType 目标类型
   * @param teamId 组织Id
   * @returns
   */
  Future<IdNameArray?> queryExtend(String destType, String teamId);
}
