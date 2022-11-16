import 'package:orginone/config/constant.dart';
import 'package:orginone/util/http_util.dart';

class ProductApi {
  /// 创建单个产品资源
  static Future<Map<String, dynamic>> createResource({
    required String productId,
    required String code,
    required String name,
    required String link,
    required String flows,
    required String components,
  }) async {
    String url = "${Constant.product}/create/resource";
    Map<String, dynamic> data = {
      "productId": productId,
      "code": code,
      "name": name,
      "link": link,
      "flows": flows,
      "components": components,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 创建多个产品资源
  static Future<Map<String, dynamic>> createResources({
    required String productId,
    required List<dynamic> resources,
  }) async {
    String url = "${Constant.product}/create/resource";
    Map<String, dynamic> data = {
      "productId": productId,
      "resources": resources
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 删除产品
  static Future<Map<String, dynamic>> delete(String productId) async {
    String url = "${Constant.product}/delete";
    Map<String, dynamic> data = {"id": productId};
    return await HttpUtil().post(url, data: data);
  }

  /// 删除产品资源
  static Future<Map<String, dynamic>> deleteResource(String resourceId) async {
    String url = "${Constant.product}/delete/resource";
    Map<String, dynamic> data = {"id": resourceId};
    return await HttpUtil().post(url, data: data);
  }

  /// 创建产品, 资源的拓展
  static Future<Map<String, dynamic>> extendCreate({
    required String teamId,
    required String sourceId,
    required String sourceType,
    required List<String> destIds,
    required String destType,
  }) async {
    String url = "${Constant.product}/extend/create";
    Map<String, dynamic> data = {
      "teamId": teamId,
      "sourceId": sourceId,
      "sourceType": sourceType,
      "destIds": destIds,
      "destType": destType,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 取消产品, 资源的拓展
  static Future<Map<String, dynamic>> extendDelete({
    required String teamId,
    required String sourceId,
    required String sourceType,
    required List<String> destIds,
    required String destType,
  }) async {
    String url = "${Constant.product}/extend/delete";
    Map<String, dynamic> data = {
      "teamId": teamId,
      "sourceId": sourceId,
      "sourceType": sourceType,
      "destIds": destIds,
      "destType": destType,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 查询产品, 资源的拓展
  static Future<Map<String, dynamic>> extendQuery({
    required String teamId,
    required String sourceId,
    required String sourceType,
    required String destType,
  }) async {
    String url = "${Constant.product}/extend/query";
    Map<String, dynamic> data = {
      "teamId": teamId,
      "sourceId": sourceId,
      "sourceType": sourceType,
      "destType": destType,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 查询产品, 资源的拓展
  static Future<Map<String, dynamic>> publish({
    required String caption,
    required String productId,
    required double price,
    required String sellAuth,
    required String marketId,
    required String information,
    required int days,
  }) async {
    String url = "${Constant.product}/publish";
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

  /// 查询指定产品元数据
  static Future<Map<String, dynamic>> queryInfo(String id) async {
    String url = "${Constant.product}/query/info";
    Map<String, dynamic> data = {"id": id};
    return await HttpUtil().post(url, data: data);
  }

  /// 查询组织/个人拥有的资源列表
  static Future<Map<String, dynamic>> queryOwnResource({
    required String id,
    required int offset,
    required int limit,
    required String filter,
  }) async {
    String url = "${Constant.product}/query/own/resource";
    Map<String, dynamic> data = {
      "id": id,
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 产品登记/注册
  static Future<Map<String, dynamic>> register({
    required String name,
    required String code,
    required String thingId,
    required String remark,
    required List<dynamic> resources,
  }) async {
    String url = "${Constant.product}/query/own/resource";
    Map<String, dynamic> data = {
      "name": name,
      "code": code,
      "thingId": thingId,
      "remark": remark,
      "resources": resources,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 查询组织/个人所属产品
  static Future<Map<String, dynamic>> searchOwnProduct({
    required int offset,
    required int limit,
    required String filter,
  }) async {
    String url = "${Constant.product}/query/own/resource";
    Map<String, dynamic> data = {
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 查询指定产品的上架信息
  static Future<Map<String, dynamic>> searchPublicList({
    required String id,
    required int offset,
    required int limit,
    required String filter,
  }) async {
    String url = "${Constant.product}/query/own/resource";
    Map<String, dynamic> data = {
      "id": id,
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 查询指定产品资源列表
  static Future<Map<String, dynamic>> searchResource({
    required String id,
    required int offset,
    required int limit,
    required String filter,
  }) async {
    String url = "${Constant.product}/search/resource";
    Map<String, dynamic> data = {
      "id": id,
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 查询组织/个人可用产品(资源分配至组织/个人的产品)
  static Future<Map<String, dynamic>> searchUsefulProduct({
    required String id,
    required int offset,
    required int limit,
    required String filter,
  }) async {
    String url = "${Constant.product}/search/resource";
    Map<String, dynamic> data = {
      "offset": offset,
      "limit": limit,
      "filter": filter,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 下架商品:商品所有者
  static Future<Map<String, dynamic>> unPublish(String productId) async {
    String url = "${Constant.product}/unpublish";
    Map<String, dynamic> data = {"id": productId};
    return await HttpUtil().post(url, data: data);
  }

  /// 更新产品
  static Future<Map<String, dynamic>> update({
    required String id,
    required String name,
    required String code,
    required String remark,
    required List<dynamic> resources,
  }) async {
    String url = "${Constant.product}/udpate";
    Map<String, dynamic> data = {
      "id": id,
      "name": name,
      "code": code,
      "remark": remark,
      "resources": resources,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 更新商品信息
  static Future<Map<String, dynamic>> updateMerchandise({
    required String id,
    required String caption,
    required double price,
    required String sellAuth,
    required String information,
    required int days,
  }) async {
    String url = "${Constant.product}/update/merchandise";
    Map<String, dynamic> data = {
      "id": id,
      "caption": caption,
      "price": price,
      "sellAuth": sellAuth,
      "information": information,
      "days": days,
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 更新资源信息
  static Future<Map<String, dynamic>> updateResource({
    required String id,
    required String code,
    required double name,
    required String link,
    required String flows,
    required String components,
  }) async {
    String url = "${Constant.product}/update/resource";
    Map<String, dynamic> data = {
      "id": id,
      "code": code,
      "name": name,
      "link": link,
      "flows": flows,
      "components": components,
    };
    return await HttpUtil().post(url, data: data);
  }
}
