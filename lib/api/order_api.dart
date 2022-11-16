import 'package:orginone/config/constant.dart';
import 'package:orginone/util/http_util.dart';

class OrderApi {
  /// 取消订单
  static Future<Map<String, dynamic>> cancel(String orderId, int status) async {
    String url = "${Constant.order}/cancel";
    Map<String, dynamic> data = {"id": orderId, "status": status};
    return await HttpUtil().post(url, data: data);
  }

  /// 取消订单详情
  static Future<Map<String, dynamic>> cancelDetail({
    required String detailId,
    required int status,
  }) async {
    String url = "${Constant.order}/cancel/detail";
    Map<String, dynamic> data = {"id": detailId, "status": status};
    return await HttpUtil().post(url, data: data);
  }

  /// 创建订单
  static Future<Map<String, dynamic>> create({
    required String name,
    required String code,
    required String merchandiseId,
  }) async {
    String url = "${Constant.order}/create";
    Map<String, dynamic> data = {
      "name": name,
      "code": code,
      "merchandiseId": merchandiseId,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 创建订单支付
  static Future<Map<String, dynamic>> createPay({
    required String orderDetailId,
    required String price,
    required String paymentType,
  }) async {
    String url = "${Constant.order}/create/pay";
    Map<String, dynamic> data = {
      "orderDetailId": orderDetailId,
      "price": price,
      "paymentType": paymentType,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 交付订单详情中的商品
  static Future<Map<String, dynamic>> deliver(String id, int status) async {
    String url = "${Constant.order}/deliver";
    Map<String, dynamic> data = {"id": id, "status": status};
    return await HttpUtil().post(url, data: data);
  }

  /// 退还商品
  static Future<Map<String, dynamic>> reject(String id, int status) async {
    String url = "${Constant.order}/reject";
    Map<String, dynamic> data = {"id": id, "status": status};
    return await HttpUtil().post(url, data: data);
  }

  /// 买方: 查询订单列表
  static Future<Map<String, dynamic>> searchBuyList({
    required int status,
    required int offset,
    required int limit,
    required String filter,
  }) async {
    String url = "${Constant.order}/search/buy/list";
    Map<String, dynamic> data = {
      "status": status,
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 卖方: 查询指定商品订单列表
  static Future<Map<String, dynamic>> searchMerchandiseSellList({
    required String id,
    required int offset,
    required int limit,
    required String filter,
  }) async {
    String url = "${Constant.order}/search/merchandise/sell/list";
    Map<String, dynamic> data = {
      "id": id,
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 查询订单支付信息
  static Future<Map<String, dynamic>> searchPayList({
    required String id,
    required int offset,
    required int limit,
    required String filter,
  }) async {
    String url = "${Constant.order}/search/pay/list";
    Map<String, dynamic> data = {
      "id": id,
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 查询售卖订单列表
  static Future<Map<String, dynamic>> searchSellList({
    required int status,
    required int offset,
    required int limit,
    required String filter,
  }) async {
    String url = "${Constant.order}/search/sell/list";
    Map<String, dynamic> data = {
      "status": status,
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 更新订单
  static Future<Map<String, dynamic>> update({
    required int id,
    required int nftId,
    required String name,
    required String code,
  }) async {
    String url = "${Constant.order}/search/sell/list";
    Map<String, dynamic> data = {
      "id": id,
      "nftId": nftId,
      "name": name,
      "code": code,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 更新订单详情
  static Future<Map<String, dynamic>> updateDetail({
    required String id,
    required double price,
    required int days,
    required String caption,
    required int status,
  }) async {
    String url = "${Constant.order}/update/detail";
    Map<String, dynamic> data = {
      "id": id,
      "price": price,
      "days": days,
      "caption": caption,
      "status": status
    };
    return await HttpUtil().post(url, data: data);
  }
}
