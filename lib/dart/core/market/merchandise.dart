import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/base/model.dart';
import './model.dart';

class Merchandise implements IMerchandise {
  late XMerchandise merchandise;

  Merchandise(XMerchandise? merchandise);

  get id => merchandise.id;
  get marketId => merchandise.id;
  get productId => merchandise.productId;

  constructor(XMerchandise merchandise) {
    this.merchandise = merchandise;
  }

  /// 更新商品信息
  /// @param merchandise 商品信息
  /// @returns 是否成功
  @override
  Future<bool> update(
    String caption,
    double price,
    String sellAuth,
    String information,
    String days,
  ) async {
    var res = await kernel.updateMerchandise({
      caption: caption,
      price: price,
      sellAuth: sellAuth,
      information: information,
      days: days,
      id: merchandise.id,
      marketId: merchandise.marketId,
      productId: merchandise.productId,
    } as MerchandiseModel);
    if (res.success) {
      XMerchandise xMerchandise = XMerchandise(
          id: id,
          caption: caption,
          productId: productId,
          price: price,
          sellAuth: sellAuth,
          days: days,
          marketId: marketId,
          information: information,
          status: 0,
          createUser: "",
          updateUser: "",
          version: "",
          createTime: "",
          updateTime: "",
          stags: [],
          orders: [],
          product: null,
          market: null);
      merchandise = xMerchandise;
    }
    return res.success;
  }

  /// 查询商品交易情况
  /// @param page 分页参数
  /// @returns 交易情况
  @override
  Future<XOrderDetailArray?> getSellOrder(PageRequest page) async {
    return (await kernel.querySellOrderListByMerchandise({
      id: merchandise.id,
      page: page,
    } as IDBelongReq))
        .data;
  }

  @override
  Future<bool> deliver(String detailId, int status) async {
    return (await kernel.deliverMerchandise(
            {id: detailId, status: status} as ApprovalModel))
        .success;
  }

  @override
  Future<bool> cancel(String detailId, int status) async {
    return (await kernel
            .cancelOrderDetail({id: detailId, status: status} as ApprovalModel))
        .success;
  }
}
