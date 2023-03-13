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
    _storeHub.onConnected(() {
      if (accessToken != "") {
        _storeHub.invoke("TokenAuth", args: [accessToken, 'user']).then(
          (value) {
            _subscribeCallbacks.forEach((fullKey, value) {
              var key = fullKey.split("|")[0];
              var domain = fullKey.split("|")[1];
              subscribed(key, domain, value);
            });
          },
        );
      }
    });
  }

  start() {
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
  /// @param {string} domain 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @param {(data:any)=>void} callback 变更回调，默认回调一次
  /// @returns {void} 无返回值
  subscribed(String key, String domain, Function(dynamic)? callback) async {
    if (callback != null) {
      final fullKey = "$key|$domain";
      _subscribeCallbacks[fullKey] = callback;
      if (_storeHub.isConnected) {
        dynamic raw = await _storeHub.invoke('Subscribed', args: [key, domain]);
        var res = ResultType.fromJson(raw);
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
  Future<ResultType<dynamic>> get(String key, String domain) async {
    var raw = await _storeHub.invoke('Get', args: [key, domain]);
    return ResultType.fromJson(raw);
  }

  /// 修改对象
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {any} setData 对象新的值
  /// @param {string} domain 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 变更异步结果
  Future<ResultType<dynamic>> set(
      String key, dynamic setData, String domain) async {
    var raw = await _storeHub.invoke('Set', args: [key, setData, domain]);
    return ResultType.fromJson(raw);
  }

  /// 删除对象
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {string} domain 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 删除异步结果
  Future<ResultType<dynamic>> delete(String key, String domain) async {
    var raw = await _storeHub.invoke('Delete', args: [key, domain]);
    return ResultType.fromJson(raw);
  }

  /// 添加数据到数据集
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} data 要添加的数据，对象/数组
  /// @param {string} domain 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 添加异步结果
  Future<ResultType<dynamic>> insert(
      String collName, dynamic data, String domain) async {
    var raw = await _storeHub.invoke('Insert', args: [collName, data, domain]);
    return ResultType.fromJson(raw);
  }

  /// 更新数据到数据集
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} update 更新操作（match匹配，update变更,options参数）
  /// @param {string} domain 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 更新异步结果
  Future<ResultType<dynamic>> update(
      String collName, dynamic update, String domain) async {
    var raw =
        await _storeHub.invoke('Update', args: [collName, update, domain]);
    return ResultType.fromJson(raw);
  }

  /// 从数据集移除数据
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} match 匹配信息
  /// @param {string} domain 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 移除异步结果
  Future<ResultType<dynamic>> remove(
      String collName, dynamic match, String domain) async {
    var raw = await _storeHub.invoke('Remove', args: [collName, match, domain]);
    return ResultType.fromJson(raw);
  }

  /// 从数据集查询数据
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} options 聚合管道(eg: {match:{a:1},skip:10,limit:10})
  /// @param {string} domain 对象所在域, 个人域(user),单位域(company),开放域(all)
  /// @returns {ResultType} 移除异步结果
  Future<ResultType<dynamic>> aggregate(
      String collName, dynamic options, String domain) async {
    var raw =
        await _storeHub.invoke('Aggregate', args: [collName, options, domain]);
    return ResultType.fromJson(raw);
  }

  /// 桶操作
  /// @param data 操作携带的数据
  /// @returns {ResultType<T>} 移除异步结果
  Future<ResultType<dynamic>> bucketOpreate(BucketOpreateModel data) async {
    if (_storeHub.isConnected) {
      var raw = await _storeHub.invoke('BucketOpreate', args: [data]);
      return ResultType.fromJson(raw);
    }
    var raw = await _restRequest('Bucket', 'Operate', data);
    return ResultType.fromJson(raw);
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
