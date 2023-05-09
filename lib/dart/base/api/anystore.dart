import 'dart:async';

import 'package:logging/logging.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/api/storehub.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/util/http_util.dart';

class AnyStore {
  final Logger log = Logger("AnyStore");
  final HttpUtil _requester;
  final StoreHub _storeHub;
  String accessToken;
  final Map<String, Function(dynamic)> _subscribeCallbacks = {};

  static AnyStore? _instance;

  static AnyStore getInstance({String url = "/orginone/anydata/hub"}) {
    _instance ??= AnyStore(request: HttpUtil());
    return _instance!;
  }

  AnyStore({required HttpUtil request})
      : accessToken = "",
        _storeHub = StoreHub(Constant.anyStoreHub),
        _requester = request {
    _storeHub.on("updated", (args) => _updated(args![0], args[1], args[2]));
    _storeHub.onConnected(() {
      if (accessToken.isNotEmpty) {
        _storeHub.invoke("TokenAuth", args: [accessToken]).then(
            (value) => _subscribeCallbacks.forEach((fullKey, value) {
                  var key = fullKey.split("|")[0];
                  var belongId = fullKey.split("|")[1];
                  subscribed(key, belongId, value);
                }));
      }
    });
    _storeHub.start();
  }

  stop() async {
    _subscribeCallbacks.clear();
    await _storeHub.dispose();
  }

  /// 是否在线
  /// @returns {boolean} 在线状态
  bool get isOnline {
    return _storeHub.isConnected;
  }

  /// 更新token
  /// @param accessToken token
  updateToken(String accessToken) {
    if (this.accessToken != accessToken) {
      this.accessToken = accessToken;
      _storeHub.restart();
    }
  }

  /// 订阅对象变更
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @param {(data:any)=>void} callback 变更回调，默认回调一次
  /// @returns {void} 无返回值
  subscribed(String key, String belongId, Function(dynamic)? callback) async {
    if (callback != null) {
      final fullKey = "$key|$belongId";
      _subscribeCallbacks[fullKey] = callback;
      if (_storeHub.isConnected) {
        var raw = await _storeHub.invoke('Subscribed', args: [belongId, key]);
        var res = ResultType.fromJson(raw);
        if (res.success && res.data != null) {
          callback(res.data);
        }
      }
    }
  }

  /// 取消订阅对象变更
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {void} 无返回值
  unSubscribed(String key, String belongId) async {
    final fullKey = "$key|$belongId";
    if (_subscribeCallbacks.containsKey(fullKey) && _storeHub.isConnected) {
      await _storeHub.invoke('UnSubscribed', args: [key, belongId]);
      _subscribeCallbacks.remove(fullKey);
    }
  }

  /// 查询对象
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 对象异步结果
  Future<ResultType<dynamic>> get(String key, String belongId) async {
    if (_storeHub.isConnected) {
      var raw = await _storeHub.invoke('Get', args: [belongId, key]);
      return ResultType.fromJson(raw);
    }
    var raw = await _restRequest(
      'Object',
      'Get/$key',
      {
        "belongId": belongId,
      },
      {},
    );
    return ResultType.fromJson(raw);
  }

  /// 修改对象
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {any} setData 对象新的值
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 变更异步结果
  Future<ResultType<dynamic>> set(
      String key, dynamic setData, String belongId) async {
    if (_storeHub.isConnected) {
      var raw = await _storeHub.invoke('Set', args: [belongId, key, setData]);
      return ResultType.fromJson(raw);
    }
    var raw = await _restRequest(
      'Object',
      'Set/$key',
      {
        "belongId": belongId,
      },
      setData,
    );
    return ResultType.fromJson(raw);
  }

  /// 删除对象
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 删除异步结果
  Future<ResultType<dynamic>> delete(String key, String belongId) async {
    if (_storeHub.isConnected) {
      var raw = await _storeHub.invoke('Delete', args: [key, belongId]);
      return ResultType.fromJson(raw);
    }
    var raw = await _restRequest(
      'Object',
      'Delete/$key',
      {
        "belongId": belongId,
      },
      {},
    );
    return ResultType.fromJson(raw);
  }

  /// 添加数据到数据集
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} data 要添加的数据，对象/数组
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 添加异步结果
  Future<ResultType<dynamic>> insert(
      String collName, dynamic data, String belongId) async {
    if (_storeHub.isConnected) {
      var raw =
          await _storeHub.invoke('Insert', args: [belongId, collName, data]);
      return ResultType.fromJson(raw);
    }
    var raw = await _restRequest(
      'Object',
      'Update/$collName',
      {
        "belongId": belongId,
      },
      data,
    );
    return ResultType.fromJson(raw);
  }

  /// 更新数据到数据集
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} update 更新操作（match匹配，update变更,options参数）
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 更新异步结果
  Future<ResultType<dynamic>> update(
      String collName, dynamic update, String belongId) async {
    if (_storeHub.isConnected) {
      var raw =
          await _storeHub.invoke('Update', args: [belongId, collName, update]);
      return ResultType.fromJson(raw);
    }
    var raw = await _restRequest(
      'Collection',
      'Update/$collName',
      {
        "belongId": belongId,
      },
      update,
    );
    return ResultType.fromJson(raw);
  }

  /// 从数据集移除数据
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} match 匹配信息
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 移除异步结果
  Future<ResultType<dynamic>> remove(
      String collName, dynamic match, String belongId) async {
    if (_storeHub.isConnected) {
      var raw =
          await _storeHub.invoke('Remove', args: [belongId, collName, match]);
      return ResultType.fromJson(raw);
    }
    var raw = await _restRequest(
      'Collection',
      'Remove/$collName',
      {
        "belongId": belongId,
      },
      match,
    );
    return ResultType.fromJson(raw);
  }

  /// 从数据集查询数据
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} options 聚合管道(eg: {match:{a:1},skip:10,limit:10})
  /// @param {string} belongId 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 移除异步结果
  Future<ResultType<dynamic>> aggregate(
      String collName, dynamic options, String belongId) async {
    if (_storeHub.isConnected) {
      var raw = await _storeHub
          .invoke('Aggregate', args: [belongId, collName, options]);
      return ResultType.fromJson(raw);
    }
    var raw = await _restRequest(
      'Collection',
      'Aggregate/$collName',
      {
        "belongId": belongId,
      },
      options,
    );
    return ResultType.fromJson(raw);
  }

  /// 桶操作
  /// @param data 操作携带的数据
  /// @returns {ResultType<T>} 移除异步结果
  Future<ResultType<dynamic>> bucketOpreate(String belongId,BucketOpreateModel data) async {
    if (_storeHub.isConnected) {
      var raw = await _storeHub.invoke('BucketOpreate', args: [belongId,data.toJson()]);
      return ResultType.fromJson(raw);
    }
    var raw = await _restRequest('Bucket', 'Operate', {}, data.toJson());
    return ResultType.fromJson(raw);
  }

  /// 加载物
  /// @param  过滤参数
  /// @returns {ResultType<T>} 移除异步结果
  Future<ResultType<dynamic>> loadThing<T>(
      dynamic options, String belongId) async {
    if (_storeHub.isConnected) {
      var raw = await _storeHub.invoke('Load', args: [belongId, options]);
      return ResultType.fromJson(raw);
    }
    var raw = await _restRequest('Thing', 'Load', options, {});
    return ResultType.fromJson(raw);
  }

  ///
  /// 加载物的归档信息
  /// @param  过滤参数
  /// * @returns {ResultType<T>} 移除异步结果
  Future<ResultType<dynamic>> loadThingArchives<T>(
    Map<String, dynamic> options,
    String belongId,
  ) async {
    if (_storeHub.isConnected) {
      var raw =
          await _storeHub.invoke('LoadArchives', args: [belongId, options]);
      return ResultType.fromJson(raw);
    }
    options.addAll({"belongId": belongId});
    var raw = await _restRequest('Thing', 'LoadArchives', options, {});
    return ResultType.fromJson(raw);
  }

  /// 创建物
  /// @param  创建数量
  /// @returns {ResultType<T>} 移除异步结果
  Future<ResultType<T>> createThing<T>(
    int number,
    String belongId,
  ) async {
    if (_storeHub.isConnected) {
      var raw = await _storeHub.invoke('Create', args: [belongId, number]);
      return ResultType.fromJson(raw);
    }
    var raw = await _restRequest(
      'Thing',
      'Create',
      {
        "belongId": belongId,
      },
      number,
    );
    return ResultType.fromJson(raw);
  }

  /// 对象变更通知
  /// @param belongId 归属
  /// @param key 主键
  /// @param data 数据
  /// @returns {void} 无返回值
  _updated(String belongId, String key, dynamic data) {
    final fullKey = "$key|$belongId";
    if (_subscribeCallbacks.containsKey(fullKey)) {
      final Function(dynamic)? callback = _subscribeCallbacks[fullKey];
      if (callback != null) {
        callback(data);
      }
    }
  }

  /// 使用rest请求后端
  /// @param methodName 方法
  /// @param data 内容体数据
  /// @param params 查询参数
  /// @returns 返回结果
  Future<dynamic> _restRequest(
    String controller,
    String methodName,
    Map<String, dynamic> params,
    dynamic data,
  ) async {
    return await _requester.post(
      "/orginone/anydata/$controller/$methodName",
      queryParameters: params,
      data: data,
    );
  }
}
