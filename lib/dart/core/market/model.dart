import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/core/enum.dart';

KernelApi kernel = KernelApi.getInstance();

abstract class IMarket {
  /// 市场实体
  late XMarket market;

  /// 可以拉取的成员类型

  late List<TargetType> pullTypes;

  /// 更新商店信息
  /// @param name 商店名称
  /// @param code 商店编号
  /// @param samrId 监管组织/个人
  /// @param remark 备注
  /// @param ispublic 是否公开
  /// @param photo 照片
  /// @returns
  Future<bool> update(
    String name,
    String code,
    String samrId,
    String remark,
    bool ispublic,
    String photo,
  );

  /// 分页获取商店成员
  /// @param page 分页参数
  /// @returns 加入的商店成员
  Future<XMarketRelationArray?> getMember(PageRequest page);

  /// 分页获取商品列表
  /// @param page 分页参数
  /// @returns 返回商店商品列表
  Future<XMerchandiseArray?> getMerchandise(PageRequest page);

  /// 分页获取加入商店申请
  /// @param page 分页参数
  Future<XMarketRelationArray?> getJoinApply(PageRequest page);

  /// 获取商品上架申请列表
  /// @param page 分页参数
  /// @returns 返回商品上架申请列表
  Future<XMerchandiseArray?> getMerchandiseApply(PageRequest page);

  /// 审批商店成员加入申请
  /// @param id 申请ID
  /// @param status 审批结果
  /// @returns 是否成功
  Future<bool> approvalJoinApply(String id, int status);

  /// 审批商品上架申请
  /// @param id 申请ID
  /// @param status 审批结果
  /// @returns 是否成功
  Future<bool> approvalPublishApply(String id, int status);

  /// 拉对象加入商店
  /// @param targetIds 对象ID集合
  /// @param typenames 对象类型
  /// @returns 是否成功
  Future<bool> pullMember(List<String> targetIds, List<String> typenames);

  /// 移除商店成员
  /// @param id 关系成员ID
  /// @param typename 成员类型
  /// @return 移除人员结果
  Future<bool> removeMember(List<String> targetIds);

  /// 下架商品
  /// @param merchandiseId 下架商品ID
  /// @returns 下架是否成功
  Future<bool> unPublish(String merchandiseId);
}

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
  Future<IdNameArray> queryExtend(String destType, String? teamId);

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
  /** 资源实体 */
  late XResource resource;
  /**
   * 资源分发拓展操作
   * @param teamId 组织Id
   * @param destIds 目标Id
   * @param destType 目标类型
   * @returns
   */
  Future<bool> createExtend(
      String teamId, List<String> destIds, String destType);
  /**
   * 取消资源分发
   * @param teamId 组织Id
   * @param destIds 目标Id
   * @param destType 目标类型
   * @returns
   */
  Future<bool> deleteExtend(
      String teamId, List<String> destIds, String destType);
  /**
   * 查询资源分发
   * @param sourceId 资源Id
   * @param destType 目标类型
   * @param teamId 组织Id
   * @returns
   */
  Future<IdNameArray> queryExtend(String destType, String teamId);
}
