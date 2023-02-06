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
    _storeHub.on("updated", _updated);
  }

  start() {
    _storeHub.start();
  }

  stop() async {
    _subscribeCallbacks.clear();
    await _storeHub.dispose();
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
  /// @param {string} domain 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @param {(data:any)=>void} callback 变更回调，默认回调一次
  /// @returns {void} 无返回值
  subscribed<T>(String key, String domain, Function(dynamic)? callback) async {
    if (callback != null) {
      final fullKey = "$key|$domain";
      _subscribeCallbacks[fullKey] = callback;
      if (_storeHub.isConnected) {
        final ResultType<T> res =
            await _storeHub.invoke<T>('Subscribed', args: [key, domain]);
        if (res.success && res.data != null) {
          callback(res.data);
        }
      }
    }
  }

  /// 取消订阅对象变更
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {string} domain 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {void} 无返回值
  unSubscribed(String key, String domain) async {
    final fullKey = "$key|$domain";
    if (_subscribeCallbacks.containsKey(fullKey) && _storeHub.isConnected) {
      await _storeHub.invoke('UnSubscribed', args: [key, domain]);
      _subscribeCallbacks.remove(fullKey);
    }
  }

  /// 查询对象
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {string} domain 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 对象异步结果
  Future<ResultType<T>> get<T>(String key, String domain) async {
    return await _storeHub.invoke<T>('Get', args: [key, domain]);
  }

  /// 修改对象
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {any} setData 对象新的值
  /// @param {string} domain 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 变更异步结果
  Future<ResultType<dynamic>> set(
      String key, dynamic setData, String domain) async {
    return await _storeHub.invoke<dynamic>('Set', args: [key, setData, domain]);
  }

  /// 删除对象
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {string} domain 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 删除异步结果
  Future<ResultType<dynamic>> delete(String key, String domain) async {
    return await _storeHub.invoke<dynamic>('Delete', args: [key, domain]);
  }

  /// 添加数据到数据集
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} data 要添加的数据，对象/数组
  /// @param {string} domain 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 添加异步结果
  Future<ResultType<dynamic>> insert(
      String collName, dynamic data, String domain) async {
    return await _storeHub
        .invoke<dynamic>('Insert', args: [collName, data, domain]);
  }

  /// 更新数据到数据集
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} update 更新操作（match匹配，update变更,options参数）
  /// @param {string} domain 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 更新异步结果
  Future<ResultType<dynamic>> update(
      String collName, dynamic update, String domain) async {
    return await _storeHub
        .invoke<dynamic>('Update', args: [collName, update, domain]);
  }

  /// 从数据集移除数据
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} match 匹配信息
  /// @param {string} domain 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 移除异步结果
  Future<ResultType<dynamic>> remove(
      String collName, dynamic match, String domain) async {
    return await _storeHub
        .invoke<dynamic>('Remove', args: [collName, match, domain]);
  }

  /// 从数据集查询数据
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} options 聚合管道(eg: {match:{a:1},skip:10,limit:10})
  /// @param {string} domain 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 移除异步结果
  Future<ResultType<dynamic>> aggregate(
      String collName, dynamic options, String domain) async {
    return await _storeHub
        .invoke<dynamic>('Aggregate', args: [collName, options, domain]);
  }

  /// 桶操作
  /// @param data 操作携带的数据
  /// @returns {ResultType<T>} 移除异步结果
  Future<ResultType<T>> bucketOpreate<T>(BucketOpreateModel data) async {
    if (_storeHub.isConnected) {
      return await _storeHub.invoke<T>('BucketOpreate', args: [data]);
    }
    return await _restRequest('Bucket', 'Operate', data);
  }

  /// 对象变更通知
  /// @param key 主键
  /// @param data 数据
  /// @returns {void} 无返回值
  _updated(List<dynamic>? args) {
    if (args == null || args.length < 3) return;
    final String key = args[0];
    final String domain = args[1];
    final dynamic data = args[2];
    final fullKey = "$key|$domain";
    if (_subscribeCallbacks.containsKey(fullKey)) {
      final Function(dynamic)? callback = _subscribeCallbacks[fullKey];
      if (callback != null) {
        callback(data);
      }
    }
  }

  /// 使用rest请求后端
  /// @param methodName 方法
  /// @param data 参数
  /// @returns 返回结果
  Future<dynamic> _restRequest(
    String controller,
    String methodName,
    dynamic data,
  ) async {
    return await _requester.post(
      "/orginone/anydata/$controller/$methodName",
      data: data,
    );
  }
}
